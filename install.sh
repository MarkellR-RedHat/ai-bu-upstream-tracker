#!/bin/bash
# Install upstream tracker commands into Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.claude/commands"

echo ""
echo "ai-bu-upstream-tracker"
echo "Early warning system for upstream breaking changes"
echo ""

# Check prerequisites
if ! command -v gh &> /dev/null; then
  echo "Warning: GitHub CLI (gh) not found. The commands use gh to query repositories."
  echo "Install it: https://cli.github.com/"
  echo ""
fi

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

INSTALLED=0
for cmd in "${COMMANDS[@]}"; do
  if [ -f "${SCRIPT_DIR}/commands/${cmd}.md" ]; then
    cp "${SCRIPT_DIR}/commands/${cmd}.md" "${TARGET_DIR}/${cmd}.md"
    INSTALLED=$((INSTALLED + 1))
  else
    echo "Warning: ${cmd}.md not found in commands/, skipping"
  fi
done

echo "Installed ${INSTALLED} commands to ${TARGET_DIR}"
echo ""
echo "  Threat Detection"
echo "    /upstream <project>               Threat assessment for a single project"
echo "    /upstream-weekly                   Weekly threat briefing across all projects"
echo "    /upstream-breaking                 Breaking changes threat sweep"
echo ""
echo "  Deep Analysis"
echo "    /upstream-impact <repo> <PR#>      Blast radius analysis of a specific change"
echo "    /upstream-migration <repo> <v1> <v2>  Field upgrade playbook between versions"
echo "    /upstream-health <project>         Dependency risk assessment"
echo "    /upstream-forecast <project>       Forward-looking intelligence"
echo ""
echo "  Community Intelligence"
echo "    /upstream-contributor <project>    Contributor power map"
echo "    /upstream-opportunity              Strategic contribution targets"
echo ""
echo "Quick start: /upstream-breaking"
echo "  Scans all tracked projects for breaking changes in the last 14 days."
echo ""
echo "Note: Project definitions live in ${SCRIPT_DIR}/projects/."
echo "Keep this repo cloned at its current location."
echo ""
