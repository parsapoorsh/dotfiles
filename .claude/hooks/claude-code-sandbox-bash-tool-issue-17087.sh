#!/bin/bash
# Claude Code hook to clean up spurious dotfiles created by Bash tool sandbox bug
# https://github.com/anthropics/claude-code/issues/17087
#
# [Created with AI: Claude Code with Opus 4.5]
#
# INSTALL:
#   1. Save this script to ~/.claude/hooks/claude-code-sandbox-bash-tool-issue-17087.sh
#   2. Make executable: chmod +x ~/.claude/hooks/claude-code-sandbox-bash-tool-issue-17087.sh
#   3. Add to ~/.claude/settings.json under "hooks":
#      "PostToolUse": [
#        {
#          "matcher": "Bash",
#          "hooks": [
#            {
#              "type": "command",
#              "command": "~/.claude/hooks/claude-code-sandbox-bash-tool-issue-17087.sh"
#            }
#          ]
#        }
#      ]
#   4. Restart Claude Code session, if necessary.
#
# UNINSTALL (when issue #17087 is fixed):
#   1. Remove the PostToolUse entry from ~/.claude/settings.json
#   2. Delete this script: rm ~/.claude/hooks/claude-code-sandbox-bash-tool-issue-17087.sh
#   3. Optionally delete the log: rm ~/claude-code-sandbox-bash-tool-issue-17087.log

set -euo pipefail

LOG_FILE="$HOME/claude-code-sandbox-bash-tool-issue-17087.log"

# Files that the sandbox bug may create (from issue #17087)
# Note: .claude and .git are normally directories, but the bug creates them as
# empty read-only files. The script only removes regular files, not directories.
SPURIOUS_FILES=(
    .bash_profile
    .bashrc
    .claude/agents
    .claude/settings.json
    .claude
    .git
    .gitconfig
    .gitmodules
    .idea
    .mcp.json
    .profile
    .ripgreprc
    .vscode
    .zprofile
    .zshrc
    HEAD
    objects
    refs
    hooks
)

# Read JSON input from stdin and parse cwd
INPUT=$(cat)
CWD=$(echo "$INPUT" | grep -o '"cwd"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*:.*"\([^"]*\)"/\1/')
# OR, if jq is installed:
# CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

# Build list of directories to clean
DIRS_TO_CLEAN=()

# Add CLAUDE_PROJECT_DIR if set
if [[ -n "${CLAUDE_PROJECT_DIR:-}" ]]; then
    DIRS_TO_CLEAN+=("$CLAUDE_PROJECT_DIR")
fi

# Add cwd from stdin if available and different from PROJECT_DIR
if [[ -n "$CWD" && "$CWD" != "${CLAUDE_PROJECT_DIR:-}" ]]; then
    DIRS_TO_CLEAN+=("$CWD")
fi

# Fallback to current directory if nothing else
if [[ ${#DIRS_TO_CLEAN[@]} -eq 0 ]]; then
    DIRS_TO_CLEAN=(".")
fi

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log "## $0"
log "## https://github.com/anthropics/claude-code/issues/17087"
log "Directories to clean: ${DIRS_TO_CLEAN[*]}"

cleanup_dir() {
    local dir="$1"
    local file filepath perms

    # Skip if directory doesn't exist
    [[ -d "$dir" ]] || return 0

    for file in "${SPURIOUS_FILES[@]}"; do
        filepath="$dir/$file"

        # Check if file exists and is a regular file
        if [[ -f "$filepath" ]]; then
            # Get file permissions (Linux: stat -c, macOS: stat -f)
            perms=$(stat -c '%a' "$filepath" 2>/dev/null || stat -f '%Lp' "$filepath" 2>/dev/null || echo "")

            # Spurious files are empty AND have mode 444 (read-only)
            if [[ ! -s "$filepath" && "$perms" == "444" ]]; then
                rm -f "$filepath"
                log "Removed spurious file: $filepath (empty, mode 444)"
            elif [[ ! -s "$filepath" ]]; then
                log "Skipped empty file with unexpected permissions ($perms): $filepath"
            elif [[ "$perms" == "444" ]]; then
                log "Skipped non-empty file with mode 444: $filepath"
            fi
        fi
    done
}

for dir in "${DIRS_TO_CLEAN[@]}"; do
    cleanup_dir "$dir"
done

exit 0
