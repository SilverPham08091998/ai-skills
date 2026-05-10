#!/bin/bash
# PostToolUse Write|Edit — ghi project dir vào sentinel file
FILE=$(cat /dev/stdin | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)
[ -z "$FILE" ] && exit 0

DIR=$(dirname "$FILE")
while [ "$DIR" != "/" ] && [ "$DIR" != "." ]; do
  for marker in pom.xml build.gradle build.gradle.kts package.json go.mod Cargo.toml Makefile; do
    if [ -f "$DIR/$marker" ]; then
      echo "$DIR" > /tmp/claude-project-dir.txt
      exit 0
    fi
  done
  DIR=$(dirname "$DIR")
done

echo "$(dirname "$FILE")" > /tmp/claude-project-dir.txt
