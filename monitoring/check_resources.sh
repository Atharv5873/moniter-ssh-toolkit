#!/bin/bash

# Author:        Atharv Sharma
# Date Created:  15/09/2025
# Date Modified: 15/09/2025

#Description:
# Capture top snapshot + system info -> /var/log/health/YYYY-MM-DD_HHMMSS.log

set -euo pipefail

LOG_DIR="/var/log/health"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date '+%F_%H%M%S')
LOG_FILE="$LOG_DIR/$TIMESTAMP.log"
SERVICES=("sshd" "nginx" "docker" "mysql" "mongod")

{
	echo "=== HEALTH CHECK: $TIMESTAMP ==="
	echo
	echo "Hostname: $(hostname)"
	echo "Uptime: $(uptime -p)"
	echo "Date: $(date -R)"
	echo
	echo "Memory (free -m):"
	free -m
	echo
	echo "Disk (df -h):"
	df -h
	echo
	echo "Top Processes (top -bn1 | head -n20):"
	top -bn1 | head -n20
	echo
	echo "Important service statuses:"
	for svc in "${SERVICES[@]}"; do
		echo "--- $svc ---"
		if systemctl cat "$svc" &> /dev/null; then
			systemctl status "$svc" --no-pager --full
			echo
		else
			echo "Service $svc not installed"
			echo
		fi
	done
} > "$LOG_FILE" 2>&1

# Keeping only the 30 newest health logs
if ls -1t "$LOG_DIR"/*.log > /dev/null 2>&1; then
	ls -1t "$LOG_DIR"/*.log | sed -n '31,$p' | xargs -r rm -f --
fi
