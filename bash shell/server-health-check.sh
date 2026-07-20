#!/bin/bash
#
# server-health-check.sh
# ------------------------------------------------------------
# General-purpose server health monitoring script.
# Checks CPU, memory, disk, network, and key services.
# Logs results and optionally sends alerts when thresholds are breached.
#
# Usage:
#   ./server-health-check.sh
#   ./server-health-check.sh --verbose
#
# Recommended: run via cron every 5 minutes
#   */5 * * * * /path/to/server-health-check.sh >> /var/log/health-check.log 2>&1
# ------------------------------------------------------------

set -uo pipefail

# ---------- Configuration ----------
CPU_THRESHOLD=85          # percent
MEM_THRESHOLD=85           # percent
DISK_THRESHOLD=90          # percent
LOAD_THRESHOLD=4.0         # 1-min load average (adjust for core count)
SERVICES_TO_CHECK=("sshd" "cron" "nginx" "docker")   # edit as needed
LOG_FILE="/var/log/server-health-check.log"
ALERT_EMAIL="hampannagouda18@gmail.com"             # set an email to enable mail alerts, e.g. "admin@example.com"
VERBOSE=false

[[ "${1:-}" == "--verbose" ]] && VERBOSE=true

# ---------- Helpers ----------
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
ALERTS=()

log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE" >/dev/null 2>&1 || echo "[$TIMESTAMP] $1"
}

verbose_log() {
    $VERBOSE && echo "[$TIMESTAMP] $1"
}

add_alert() {
    ALERTS+=("$1")
    log "ALERT: $1"
}

send_alerts_if_any() {
    if [ ${#ALERTS[@]} -gt 0 ] && [ -n "$ALERT_EMAIL" ]; then
        {
            echo "Health check alerts on $(hostname) at $TIMESTAMP"
            echo ""
            printf '%s\n' "${ALERTS[@]}"
        } | mail -s "[ALERT] $(hostname) health check" "$ALERT_EMAIL" 2>/dev/null
    fi
}

# ---------- Checks ----------

check_cpu() {
    # Average CPU usage over 1 second sample using /proc/stat
    read -r cpu user nice system idle iowait irq softirq steal _ < /proc/stat
    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle1=$idle
    sleep 1
    read -r cpu user nice system idle iowait irq softirq steal _ < /proc/stat
    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle2=$idle

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))
    cpu_usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))

    verbose_log "CPU usage: ${cpu_usage}%"
    if [ "$cpu_usage" -ge "$CPU_THRESHOLD" ]; then
        add_alert "High CPU usage: ${cpu_usage}% (threshold: ${CPU_THRESHOLD}%)"
    fi
    echo "$cpu_usage"
}

check_memory() {
    mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    mem_available=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
    mem_used=$((mem_total - mem_available))
    mem_usage=$(( (100 * mem_used) / mem_total ))

    verbose_log "Memory usage: ${mem_usage}%"
    if [ "$mem_usage" -ge "$MEM_THRESHOLD" ]; then
        add_alert "High memory usage: ${mem_usage}% (threshold: ${MEM_THRESHOLD}%)"
    fi
    echo "$mem_usage"
}

check_disk() {
    # Check every mounted real filesystem (skip tmpfs, devtmpfs, overlay, etc.)
    while read -r line; do
        usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
        mount_point=$(echo "$line" | awk '{print $6}')
        verbose_log "Disk usage on $mount_point: ${usage}%"
        if [ "$usage" -ge "$DISK_THRESHOLD" ]; then
            add_alert "High disk usage on $mount_point: ${usage}% (threshold: ${DISK_THRESHOLD}%)"
        fi
    done < <(df -h -x tmpfs -x devtmpfs -x overlay | tail -n +2)
}

check_load_average() {
    load1=$(awk '{print $1}' /proc/loadavg)
    verbose_log "1-min load average: $load1"
    # Compare floats using awk (bash doesn't do float comparison natively)
    over=$(awk -v l="$load1" -v t="$LOAD_THRESHOLD" 'BEGIN { print (l > t) ? 1 : 0 }')
    if [ "$over" -eq 1 ]; then
        add_alert "High load average: $load1 (threshold: $LOAD_THRESHOLD)"
    fi
}

check_services() {
    for service in "${SERVICES_TO_CHECK[@]}"; do
        if systemctl list-unit-files 2>/dev/null | grep -q "^${service}\.service"; then
            if systemctl is-active --quiet "$service"; then
                verbose_log "Service '$service' is running"
            else
                add_alert "Service '$service' is NOT running"
            fi
        else
            verbose_log "Service '$service' not found on this system (skipped)"
        fi
    done
}

check_network() {
    # Simple reachability check to a reliable host
    if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
        add_alert "Network check failed: cannot reach 8.8.8.8"
    else
        verbose_log "Network check passed"
    fi
}

check_disk_io_errors() {
    # Look for recent disk I/O errors in kernel log (best-effort, needs root usually)
    if command -v dmesg >/dev/null 2>&1; then
        errors=$(dmesg 2>/dev/null | grep -iE "I/O error|ata.*error" | tail -n 5)
        if [ -n "$errors" ]; then
            add_alert "Disk I/O errors detected in kernel log (see dmesg)"
        fi
    fi
}

# ---------- Run all checks ----------
log "----- Starting health check on $(hostname) -----"

cpu_usage=$(check_cpu)
mem_usage=$(check_memory)
check_disk
check_load_average
check_services
check_network
check_disk_io_errors

log "Summary: CPU=${cpu_usage}% MEM=${mem_usage}% ALERTS=${#ALERTS[@]}"

if [ ${#ALERTS[@]} -eq 0 ]; then
    log "Status: OK - all checks passed"
else
    log "Status: WARNING - ${#ALERTS[@]} issue(s) found"
    send_alerts_if_any
fi

log "----- Health check complete -----"

exit 0
