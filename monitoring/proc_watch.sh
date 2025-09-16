#!/bin/bash

# Author:        Atharv Sharma
# Date Created:  15/09/2025
# Date Modified: 15/09/2025

# Description:
# Ensure critical services are active, restart via systemctl if not.

CRITICAL_SERVICES=(sshd nginx mongod docker mysql) # edit as per your need
LOG_DIR="/var/log/health"
mkdir -p "$LOG_DIR"
TS=$(date '+%F_%H%M%S')
OUT="$LOG_DIR/proc_watch_$TS.log"

for svc in "${CRITICAL_SERVICES[@]}"; do
	echo "[$(date -Iseconds)] Checking ${svc}..." | tee -a "$OUT"
		if systemctl is-enabled --quiet "$svc"|| system list-unit-files | grep -q "^${svc}.service"; then
			if systemctl is-active --quiet "$svc"; then
				echo "${svc} is active" | tee -a "$OUT"
			else
				echo "${svc} is NOT ctive. Attempting restart..." | tee -a "$OUT"
				if sudo systemctl restart "$svc"; then
					echo "Restarted $svc successfully" | tee -a "$OUT"
				else
					echo "Failed to restart $svc" | tee -a "$OUT"
				fi
			fi
		else
			echo "Service ${svc} is not present on this host" | tee -a "$OUT"
		fi
	done

exit 0
