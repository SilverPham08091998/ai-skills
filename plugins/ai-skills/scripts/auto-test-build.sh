#!/bin/bash

# Only run if sentinel file exists (code was written)
[ ! -f /tmp/claude-project-dir.txt ] && exit 0

PROJECT_DIR=$(cat /tmp/claude-project-dir.txt)
rm -f /tmp/claude-project-dir.txt

[ ! -d "$PROJECT_DIR" ] && exit 0
cd "$PROJECT_DIR" || exit 0

RESULT=""
FAILED=0
COVERAGE_FAILED=0

run_cmd() {
  local label=$1
  local cmd=$2
  local output
  if output=$(eval "$cmd" 2>&1); then
    RESULT="${RESULT}✅ ${label} passed\n"
    return 0
  else
    RESULT="${RESULT}❌ ${label} FAILED:\n$(echo "$output" | tail -15)\n"
    FAILED=1
    return 1
  fi
}

check_coverage_pct() {
  local pct=$1
  local label=$2
  if (( $(echo "$pct >= 90" | bc -l 2>/dev/null || echo 0) )); then
    RESULT="${RESULT}✅ Coverage ${label}: ${pct}% (≥90%)\n"
  else
    RESULT="${RESULT}❌ Coverage ${label}: ${pct}% — chưa đạt 90%\n"
    COVERAGE_FAILED=1
    FAILED=1
  fi
}

# Maven
if [ -f "pom.xml" ]; then
  run_cmd "Maven Test" "mvn test -q" || true
  if [ $FAILED -eq 0 ]; then
    # JaCoCo coverage
    if mvn jacoco:report -q 2>/dev/null && [ -f "target/site/jacoco/jacoco.csv" ]; then
      PCT=$(awk -F',' 'NR>1{ covered += $4; missed += $3 } END { printf "%.1f", covered/(covered+missed)*100 }' target/site/jacoco/jacoco.csv 2>/dev/null || echo "0")
      check_coverage_pct "$PCT" "JaCoCo"
    else
      RESULT="${RESULT}⚠️  JaCoCo report not generated — add jacoco-maven-plugin to pom.xml\n"
    fi
    [ $FAILED -eq 0 ] && run_cmd "Maven Build" "mvn package -DskipTests -q"
  fi

# Gradle
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  GRADLE="./gradlew"
  [ ! -f "$GRADLE" ] && GRADLE="gradle"
  run_cmd "Gradle Test" "$GRADLE test" || true
  if [ $FAILED -eq 0 ]; then
    # JaCoCo or Kover
    if $GRADLE tasks --all 2>/dev/null | grep -q "jacocoTestReport"; then
      $GRADLE jacocoTestReport 2>/dev/null || true
      # Try to read CSV report
      JACOCO_CSV=$(find . -name "jacoco.csv" -path "*/jacoco/*" 2>/dev/null | head -1)
      if [ -n "$JACOCO_CSV" ]; then
        PCT=$(awk -F',' 'NR>1{ covered += $4; missed += $3 } END { printf "%.1f", covered/(covered+missed)*100 }' "$JACOCO_CSV" 2>/dev/null || echo "0")
        check_coverage_pct "$PCT" "JaCoCo"
      fi
    elif $GRADLE tasks --all 2>/dev/null | grep -q "koverReport"; then
      $GRADLE koverReport 2>/dev/null || true
      RESULT="${RESULT}⚠️  Kover report generated — verify ≥90% manually\n"
    fi
    [ $FAILED -eq 0 ] && run_cmd "Gradle Build" "$GRADLE build -x test"
  fi

# Node / React Native
elif [ -f "package.json" ]; then
  PKG_MGR="npm"
  [ -f "yarn.lock" ] && PKG_MGR="yarn"
  [ -f "pnpm-lock.yaml" ] && PKG_MGR="pnpm"
  [ -f "bun.lockb" ] && PKG_MGR="bun"
  HAS_TEST=$(node -e "const p=require('./package.json'); console.log(p.scripts&&p.scripts.test?'yes':'no')" 2>/dev/null || echo "no")
  HAS_BUILD=$(node -e "const p=require('./package.json'); console.log(p.scripts&&p.scripts.build?'yes':'no')" 2>/dev/null || echo "no")
  if [ "$HAS_TEST" = "yes" ]; then
    # Run with coverage
    COV_OUTPUT=$($PKG_MGR test -- --coverage --coverageThreshold='{"global":{"lines":90,"branches":90,"functions":90,"statements":90}}' --passWithNoTests 2>&1 || true)
    if echo "$COV_OUTPUT" | grep -q "Tests:.*passed\|test suites passed\|passed"; then
      RESULT="${RESULT}✅ ${PKG_MGR} test passed\n"
      # Extract coverage pct
      PCT=$(echo "$COV_OUTPUT" | grep -oE 'All files[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*' | awk -F'|' '{gsub(/ /,"",$2); print $2}' | head -1)
      if [ -n "$PCT" ]; then
        check_coverage_pct "$PCT" "Statements"
      fi
      if echo "$COV_OUTPUT" | grep -q "coverage threshold"; then
        RESULT="${RESULT}❌ Coverage below 90% threshold\n"
        COVERAGE_FAILED=1
        FAILED=1
      fi
    else
      RESULT="${RESULT}❌ ${PKG_MGR} test FAILED:\n$(echo "$COV_OUTPUT" | tail -15)\n"
      FAILED=1
    fi
    [ $FAILED -eq 0 ] && [ "$HAS_BUILD" = "yes" ] && run_cmd "${PKG_MGR} build" "$PKG_MGR run build"
  fi

# Go
elif [ -f "go.mod" ]; then
  if run_cmd "Go Test" "go test ./... -coverprofile=/tmp/go-coverage.out"; then
    PCT=$(go tool cover -func=/tmp/go-coverage.out 2>/dev/null | grep "^total:" | awk '{gsub(/%/,"",$3); print $3}' || echo "0")
    check_coverage_pct "$PCT" "Go"
    rm -f /tmp/go-coverage.out
    [ $FAILED -eq 0 ] && run_cmd "Go Build" "go build ./..."
  fi

# Rust
elif [ -f "Cargo.toml" ]; then
  if run_cmd "Cargo Test" "cargo test"; then
    # Try tarpaulin if available
    if command -v cargo-tarpaulin &>/dev/null || cargo tarpaulin --version &>/dev/null 2>&1; then
      COV_OUT=$(cargo tarpaulin --out Stdout --fail-under 90 2>&1 || true)
      if echo "$COV_OUT" | grep -q "Coverage below threshold"; then
        PCT=$(echo "$COV_OUT" | grep -oE '[0-9]+\.[0-9]+%' | tail -1 | tr -d '%')
        check_coverage_pct "${PCT:-0}" "Tarpaulin"
      else
        PCT=$(echo "$COV_OUT" | grep -oE '[0-9]+\.[0-9]+%' | tail -1 | tr -d '%')
        check_coverage_pct "${PCT:-0}" "Tarpaulin"
      fi
    else
      RESULT="${RESULT}⚠️  cargo-tarpaulin not installed — coverage not checked\n"
      RESULT="${RESULT}   Install: cargo install cargo-tarpaulin\n"
    fi
    [ $FAILED -eq 0 ] && run_cmd "Cargo Build" "cargo build"
  fi

# Makefile
elif [ -f "Makefile" ]; then
  grep -q "^test:" Makefile && run_cmd "Make Test" "make test"
  [ $FAILED -eq 0 ] && grep -q "^build:" Makefile && run_cmd "Make Build" "make build"

else
  exit 0
fi

[ -z "$RESULT" ] && exit 0

MSG=$(printf "$RESULT")
python3 -c "import json,sys; print(json.dumps({'systemMessage': sys.argv[1]}))" "$MSG"
