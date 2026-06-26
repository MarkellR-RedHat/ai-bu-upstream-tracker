#!/bin/bash
#
# ai-bu-upstream-tracker installer
# Copies slash commands into ~/.claude/commands/ so they are available in Claude Code.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.claude/commands"

echo ""
echo "  ai-bu-upstream-tracker"
echo "  Early warning system for upstream breaking changes"
echo ""

# --- Prerequisites -----------------------------------------------------------

MISSING_PREREQS=0

if ! command -v gh &> /dev/null; then
  echo "  [!] GitHub CLI (gh) not found."
  echo "      The commands need gh to query repositories."
  echo "      Install: https://cli.github.com/"
  echo ""
  MISSING_PREREQS=1
fi

if [ ! -d "${SCRIPT_DIR}/commands" ]; then
  echo "  [ERROR] commands/ directory not found in ${SCRIPT_DIR}"
  echo "          Re-clone the repo and try again."
  exit 1
fi

# --- Install -----------------------------------------------------------------

mkdir -p "${TARGET_DIR}" || {
  echo "  [ERROR] Could not create ${TARGET_DIR}"
  echo "          Check permissions on your home directory."
  exit 1
}

COMMANDS=(
  "upstream"
  "upstream-weekly"
  "upstream-breaking"
  "upstream-impact"
  "upstream-migration"
  "upstream-health"
  "upstream-forecast"
  "upstream-contributor"
  "upstream-opportunity"
)

INSTALLED=0
FAILED=0

for cmd in "${COMMANDS[@]}"; do
  SRC="${SCRIPT_DIR}/commands/${cmd}.md"
  if [ -f "${SRC}" ]; then
    if cp "${SRC}" "${TARGET_DIR}/${cmd}.md"; then
      echo "  [ok] /${cmd}"
      INSTALLED=$((INSTALLED + 1))
    else
      echo "  [FAIL] /${cmd} - could not copy"
      FAILED=$((FAILED + 1))
    fi
  else
    echo "  [SKIP] /${cmd} - source file not found"
    FAILED=$((FAILED + 1))
  fi
done

echo ""
echo "  ${INSTALLED} commands installed to ${TARGET_DIR}"

if [ "${FAILED}" -gt 0 ]; then
  echo "  ${FAILED} commands had problems (see above)"
fi

if [ "${MISSING_PREREQS}" -gt 0 ]; then
  echo ""
  echo "  Install the missing prerequisites above before using the commands."
fi

echo ""
echo "  Try it now:"
echo ""
echo "    /upstream-breaking"
echo ""
echo "  Scans all 10 tracked projects for breaking changes in the last 14 days."
echo ""
