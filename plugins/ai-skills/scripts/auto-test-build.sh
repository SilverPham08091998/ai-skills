#!/bin/bash

# Chỉ chạy nếu có sentinel file (code đã được viết)
[ ! -f /tmp/claude-project-dir.txt ] && exit 0

PROJECT_DIR=$(cat /tmp/claude-project-dir.txt)
rm -f /tmp/claude-project-dir.txt

[ ! -d "$PROJECT_DIR" ] && exit 0
cd "$PROJECT_DIR" || exit 0

RESULT=""
FAILED=0

run_cmd() {
  local label=$1
  local cmd=$2
  local output
  if output=$(eval "$cmd" 2>&1); then
    RESULT="${RESULT}✅ ${label} passed\n"
  else
    RESULT="${RESULT}❌ ${label} FAILED:\n$(echo "$output" | tail -15)\n"
    FAILED=1
  fi
}

# Maven
if [ -f "pom.xml" ]; then
  run_cmd "Maven Test" "mvn test -q"
  [ $FAILED -eq 0 ] && run_cmd "Maven Build" "mvn package -DskipTests -q"

# Gradle
elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  GRADLE="./gradlew"
  [ ! -f "$GRADLE" ] && GRADLE="gradle"
  run_cmd "Gradle Test" "$GRADLE test"
  [ $FAILED -eq 0 ] && run_cmd "Gradle Build" "$GRADLE build -x test"

# Node / React Native
elif [ -f "package.json" ]; then
  PKG_MGR="npm"
  [ -f "yarn.lock" ] && PKG_MGR="yarn"
  [ -f "pnpm-lock.yaml" ] && PKG_MGR="pnpm"
  [ -f "bun.lockb" ] && PKG_MGR="bun"
  HAS_TEST=$(node -e "const p=require('./package.json'); console.log(p.scripts&&p.scripts.test?'yes':'no')" 2>/dev/null || echo "no")
  HAS_BUILD=$(node -e "const p=require('./package.json'); console.log(p.scripts&&p.scripts.build?'yes':'no')" 2>/dev/null || echo "no")
  [ "$HAS_TEST" = "yes" ] && run_cmd "$PKG_MGR test" "$PKG_MGR test --passWithNoTests 2>/dev/null || $PKG_MGR test"
  [ $FAILED -eq 0 ] && [ "$HAS_BUILD" = "yes" ] && run_cmd "$PKG_MGR build" "$PKG_MGR run build"

# Go
elif [ -f "go.mod" ]; then
  run_cmd "Go Test" "go test ./..."
  [ $FAILED -eq 0 ] && run_cmd "Go Build" "go build ./..."

# Rust
elif [ -f "Cargo.toml" ]; then
  run_cmd "Cargo Test" "cargo test"
  [ $FAILED -eq 0 ] && run_cmd "Cargo Build" "cargo build"

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
