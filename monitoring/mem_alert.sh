#!/bin/bash

# Author:         Atharv Sharma
# Date Created:   15/09/2025
# Date Modified:  15/09/2025

# Description:
# Log Memory alerts to /var/log/health/mem_alerts.log

set -euo pipefail

THRESH_MB=${THRESH_MB:-500}
LOG_DIR="/var/log/health"
ALERT_FILE="$LOG_DIR/mem_alerts.log" 
mkdir -p "$LOG_DIR"

AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

if [[ -z "${AVAILABLE:-}" ]]; then
    AVAILABLE=$(free -m | awk '/^Mem:/ {print $4}')
fi

TS=$(date '+%F %T')
if (( AVAILABLE < THRESH_MB )); then
    echo "$TS - LOW MEMORY: ${AVAILABLE}MB available (< ${THRESH_MB}MB)" >> "$ALERT_FILE"
fi
