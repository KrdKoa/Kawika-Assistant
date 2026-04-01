#!/bin/bash
# Daily Backup Scheduler
# Runs backup-workspace.sh every day at 2am UTC

GITHUB_TOKEN="${GITHUB_TOKEN:-}"
BACKUP_SCRIPT="/root/.openclaw/workspace/backup-workspace.sh"
LOG_FILE="/root/.openclaw/workspace/backup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S UTC')] $1" >> "$LOG_FILE"
}

while true; do
    # Calculate seconds until 2am UTC
    CURRENT_SECONDS=$(date -u +%s)
    TARGET_HOUR=2
    TARGET_SECONDS=$(( $(date -u -d "today $TARGET_HOUR:00:00" +%s) ))
    
    # If 2am has passed today, target tomorrow
    if [ "$CURRENT_SECONDS" -ge "$TARGET_SECONDS" ]; then
        TARGET_SECONDS=$((TARGET_SECONDS + 86400))
    fi
    
    SLEEP_SECONDS=$((TARGET_SECONDS - CURRENT_SECONDS))
    
    log "Next backup in $SLEEP_SECONDS seconds"
    sleep $SLEEP_SECONDS
    
    # Run backup
    log "Starting daily backup..."
    cd /root/.openclaw/workspace
    if GITHUB_TOKEN="$GITHUB_TOKEN" ./backup-workspace.sh >> "$LOG_FILE" 2>&1; then
        log "Backup completed successfully"
    else
        log "Backup failed"
    fi
done