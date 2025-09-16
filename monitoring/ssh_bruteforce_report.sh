#!/bin/bash

# Author:         Atharv Sharma
# Date Created:   15/09/2025
# Date Modified:  15/09/2025

# Description:
# This script is brute-forcs report from auth logs -> ~/monitoring/ssh_bruteforce_report_YYYY-MM-DD.yxy

set -euo pipefail

OUT_DIR="$HOME/monitoring"
mkdir -p "$OUT_DIR"
REPORT="$OUT_DIR/ssh_bruteforce_report_$(date '+%F').txt"

AUTH="/var/log/auth.log"

{
  echo "SSH Bruteforce Report for $(hostname) - $(date)"
  echo "Source: ${AUTH:-(no auth log found)}"
  echo

  if [[ -n "$AUTH" ]]; then
    echo "Top 20 source IPs for 'Failed password' attempts:"
   	grep -i "Failed password" "$AUTH" 2>/dev/null | grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}' \
      | sort | uniq -c | sort -rn | head -n20
    echo
    echo "Top 20 usernames targeted in 'Failed password' attempts:"
    grep -i "Failed password" "$AUTH" 2>/dev/null | sed -n 's/.*for //p' | awk '{print $1}' \
      | sort | uniq -c | sort -rn | head -n20
    echo
    echo "Recent sample failed attempts (last 200 lines):"
    grep -i "Failed password" "$AUTH" 2>/dev/null | tail -n200
  else
    echo "No auth log file detected on this system. Ensure SSH logs are enabled."
  fi
} > "$REPORT"

# gzip old reports older than 30 days
find "$OUT_DIR" -name 'ssh_bruteforce_report_*.txt' -mtime +30 -exec gzip -f {} \; || true

echo "Report written to $REPORT"
