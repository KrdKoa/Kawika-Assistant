#!/bin/bash
# Workspace Backup Script to GitHub
# Usage: ./backup-workspace.sh

set -e

WORKSPACE_DIR="/root/.openclaw/workspace"
BRANCH="main"
BACKUP_MSG="Workspace backup $(date '+%Y-%m-%d %H:%M:%S')"

# GitHub credentials
GITHUB_USER="KrdKoa"
GITHUB_REPO_NAME="Kawika-Assistant"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Workspace Backup to GitHub${NC}"
echo "================================"

# Check for GitHub token in environment or prompt
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
if [ -z "$GITHUB_TOKEN" ]; then
    echo ""
    read -s -p "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
    echo ""
fi

GITHUB_REPO="https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$GITHUB_REPO_NAME.git"

cd "$WORKSPACE_DIR"

# Check if this is a git repo
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Initializing Git repository...${NC}"
    git init
    git config user.email "backup@local"
    git config user.name "Workspace Backup"
    git branch -M main
    
    # Add remote
    git remote add origin "$GITHUB_REPO"
    
    # Add files (exclude sensitive data)
    cat > .gitignore << 'EOF'
.github_config
*.bak
EOF
    
    git add -A
    git commit -m "Initial workspace backup"
    
    # Push to GitHub
    echo -e "${YELLOW}Pushing to GitHub...${NC}"
    git push -u origin main
    
    echo -e "${GREEN}✅ First backup complete!${NC}"
else
    # Check for changes
    if git diff --quiet && git diff --cached --quiet; then
        echo -e "${YELLOW}No changes to backup.${NC}"
        exit 0
    fi
    
    # Add all files
    git add -A
    
    # Commit changes
    git commit -m "$BACKUP_MSG"
    
    # Push to GitHub
    echo -e "${YELLOW}Pushing to GitHub...${NC}"
    git push origin main
    
    echo -e "${GREEN}✅ Backup complete!${NC}"
fi

echo ""
echo "Last backup: $(date '+%Y-%m-%d %H:%M:%S')"