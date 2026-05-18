#!/bin/bash
APPROVAL_FILE="$HOME/.claude/todo-approved"
MAX_AGE_SECONDS=7200  # 2 hours

if [ ! -f "$APPROVAL_FILE" ]; then
    echo '{"decision": "block", "reason": "Chưa có TODO approval. Claude phải present TODO list, chờ user approve, rồi chạy: touch ~/.claude/todo-approved"}'
    exit 0
fi

FILE_MTIME=$(stat -f%m "$APPROVAL_FILE" 2>/dev/null)
if [ -z "$FILE_MTIME" ]; then
    echo '{"decision": "block", "reason": "Không đọc được approval file."}'
    exit 0
fi

NOW=$(date +%s)
AGE=$(( NOW - FILE_MTIME ))

if [ "$AGE" -gt "$MAX_AGE_SECONDS" ]; then
    echo '{"decision": "block", "reason": "TODO approval đã hết hạn (> 2 giờ). Present TODO list và chờ user approve lại."}'
    exit 0
fi

echo '{"decision": "allow"}'
