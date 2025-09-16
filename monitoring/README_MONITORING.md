# Monitoring: quick guide

Paths:
- Health Logs: `/var/log/health/*.log`
- User Reports: `~/monitoring/ssh_bruteforce_report_YYYY-MM-DD.txt`

Scripts:
-`check_resources.sh` - snapshot top/uptime/free/disk -> `/var/log/health/$(date).log`
- `proc_watch.sh` - restart critical services defined in the script
- `mem_alert.sh` - threshold-based memory alerts -> `/var/log/health/mem_alerts.log`
- `ssh_bruteforce_report.sh` - parses auth logs -> `~/monitoring/ssh_bruteforce_report_YYYY-MM-DD.`

Install (local test):
```bash
# from repo root
sudo cp monitoring/*.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/*.sh
sudo mkdir -p /var/log/health
sudo chown root:root /var/log/health
```

Run on-demand:
```bash
sudo /usr/local/bin/check_resources.sh
sudo /usr/local/bin/proc_watch.sh
/usr/local/bin/ssh_bruteforce_report.sh
```

