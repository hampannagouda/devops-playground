# Server Health Monitoring Scripts

## Files

- **server-health-check.sh** — Full monitoring script with configurable thresholds.
  Checks CPU, memory, disk, load average, key services, network reachability,
  and disk I/O errors. Logs everything and can email alerts. Designed to run
  on a schedule (cron).

- **quick-status.sh** — Lightweight snapshot for manual, on-demand checks.
  No thresholds or alerts, just a readable dump of current server state.

## Setup

1. Copy both scripts to your server, e.g. `/opt/health-monitor/`.
2. Make them executable:
   ```bash
   chmod +x server-health-check.sh quick-status.sh
   ```
3. Edit the configuration block at the top of `server-health-check.sh`:
   - `CPU_THRESHOLD`, `MEM_THRESHOLD`, `DISK_THRESHOLD`, `LOAD_THRESHOLD`
   - `SERVICES_TO_CHECK` — list the systemd services relevant to your server
   - `ALERT_EMAIL` — set an address to enable email alerts (requires `mail`/`mailx` installed and configured)
   - `LOG_FILE` — default is `/var/log/server-health-check.log`

## Running manually

```bash
./server-health-check.sh --verbose   # prints all checks to screen, not just alerts
./quick-status.sh                    # instant snapshot
```

## Scheduling with cron

Run the full check every 5 minutes:

```bash
crontab -e
```

Add:
```
*/5 * * * * /opt/health-monitor/server-health-check.sh >> /var/log/health-check-cron.log 2>&1
```

## Notes

- The script uses only standard Linux tools (`/proc`, `df`, `systemctl`, `ping`, `dmesg`),
  so it should work on most modern distributions without extra dependencies.
- If your server doesn't use `systemd`, replace the `systemctl` checks in
  `check_services()` with `service <name> status` or your init system's equivalent.
- For email alerts, ensure a mail transfer agent (e.g. `postfix`, `msmtp`) is configured,
  since the script relies on the `mail` command.
- Run as root (or with sudo) for full access to logs like `/var/log/auth.log` and `dmesg`.