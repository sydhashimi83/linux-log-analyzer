#!/bin/bash

LOG_FILE=${1:-/var/log/auth.log}
THRESHOLD=5

echo "----------------------------------------"
echo " Log Analyzer Report"
echo "----------------------------------------"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found!"
    exit 1
fi

echo ""
echo "[1] Failed login attempts:"
grep -c "Failed password" "$LOG_FILE"

echo ""
echo "[2] Top attacking IPs:"
grep "Failed password" "$LOG_FILE" | awk '{print $NF}' | sort | uniq -c | sort -nr | head

echo ""
echo "[3] Suspicious IPs (more than $THRESHOLD attempts):"
grep "Failed password" "$LOG_FILE" | awk '{print $NF}' | sort | uniq -c | awk -v t="$THRESHOLD" '$1 > t {print}'

echo ""
echo "Report completed."
