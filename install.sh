#!/bin/bash
# Install upstream tracker commands into Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.claude/commands"

echo "Installing upstream tracker commands..."

# Create target directory if it does not exist
mkdir -p "${TARGET_DIR}"

# Copy command files
cp "${SCRIPT_DIR}/commands/upstream.md" "${TARGET_DIR}/upstream.md"
cp "${SCRIPT_DIR}/commands/upstream-weekly.md" "${TARGET_DIR}/upstream-weekly.md"
cp "${SCRIPT_DIR}/commands/upstream-breaking.md" "${TARGET_DIR}/upstream-breaking.md"
cp "${SCRIPT_DIR}/commands/upstream-contributor.md" "${TARGET_DIR}/upstream-contributor.md"
cp "${SCRIPT_DIR}/commands/upstream-opportunity.md" "${TARGET_DIR}/upstream-opportunity.md"

echo "Installed commands:"
echo "  /upstream <project>        - Summarize recent activity for a specific project"
echo "  /upstream-weekly           - Weekly digest across all tracked projects"
echo "  /upstream-breaking         - Breaking changes and deprecations only"
echo "  /upstream-contributor <p>  - Top contributors to a project this month"
echo "  /upstream-opportunity      - Find good-first-issue and help-wanted across projects"
echo ""
echo "Commands installed to: ${TARGET_DIR}"
echo ""
echo "Note: The commands reference project definitions in ${SCRIPT_DIR}/projects/."
echo "Make sure this repo stays cloned at its current location, or update the"
echo "command files to point to the correct path."
echo ""
echo "Done."
