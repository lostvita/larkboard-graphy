#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

pass=0
fail=0

check() {
  local name="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} $name"
    ((pass++))
  else
    echo -e "  ${RED}✗${NC} $name"
    ((fail++))
  fi
}

echo "larkboard-graphy preflight check"
echo "================================"
echo ""

echo "Dependencies:"
check "Node.js >= 18" node -e "process.exit(parseInt(process.version.slice(1)) >= 18 ? 0 : 1)"
check "@larksuite/whiteboard-cli" npx -y @larksuite/whiteboard-cli --version
check "lark-cli installed" command -v lark-cli

echo ""
echo "Authentication:"
if lark-cli auth status --as user 2>&1 | grep -q "logged in"; then
  echo -e "  ${GREEN}✓${NC} lark-cli user login"
  ((pass++))
else
  echo -e "  ${RED}✗${NC} lark-cli user login (run: lark-cli auth login --as user)"
  ((fail++))
fi

echo ""
echo "================================"
echo -e "Result: ${GREEN}${pass} passed${NC}, ${RED}${fail} failed${NC}"

if [ "$fail" -gt 0 ]; then
  exit 1
fi
