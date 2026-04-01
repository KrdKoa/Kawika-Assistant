# HEARTBEAT.md

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

## Cron: Daily Backup
When you receive the message "Run backup script", execute:
```
GITHUB_TOKEN="your_token_here" /root/.openclaw/workspace/backup-workspace.sh
```
Then confirm the backup completed.
