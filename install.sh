#!/bin/bash
# Install upstream tracker commands into Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.claude/commands"

echo "Installing upstream tracker commands..."

# Create target directory if it does not exist
mkdir -p "${TARGET_DIR}"

# Copy command files
COMMANDS=(
  "upstream"
  "upstream-weekly"
  "upstream-breaking"
  "upstream-contributor"
  "upstream-opportunity"
  "upstream-impact"
  "upstream-migration"
  "upstream-health"
  "upstream-forecast"
)

for cmd in "${COMMANDS[@]}"; do
  cp "${SCRIPT_DIR}/commands/${cmd}.md" "${TARGET_DIR}/${cmd}.md"
done

echo ""
echo "Installed ${#COMMANDS[@]} commands:"
echo ""
echo "  Core Intelligence"
echo "  /upstream <project>             - Intelligence report on a single project"
echo "  /upstream-weekly                - Weekly digest across all tracked projects"
echo "  /upstream-breaking              - Breaking changes risk assessment"
echo ""
echo "  Deep Analysis"
echo "  /upstream-impact <repo> <PR#>   - Deep impact analysis of a specific change"
echo "  /upstream-migration <repo> <v1> <v2> - Migration guide between versions"
echo "  /upstream-health <project>      - Project health assessment and dependency risk"
echo "  /upstream-forecast <project>    - Predict what ships next and planning implications"
echo ""
echo "  Community Intelligence"
echo "  /upstream-contributor <project> - Contributor landscape and influence map"
echo "  /upstream-opportunity           - Strategic contribution opportunities"
echo ""
echo "Commands installed to: ${TARGET_DIR}"
echo ""
echo "Note: The commands reference project definitions in ${SCRIPT_DIR}/projects/."
echo "Make sure this repo stays cloned at its current location, or update the"
echo "command files to point to the correct path."
echo ""
echo "Prerequisites:"
echo "  - Claude Code (https://docs.anthropic.com/en/docs/claude-code)"
echo "  - GitHub CLI (gh) installed and authenticated"
echo ""
echo "Quick start: try /upstream-health vllm-project/vllm"
echo ""
echo "Done."
