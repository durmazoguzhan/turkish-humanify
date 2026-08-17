#!/usr/bin/env bash
# Asserts the repository layout that all three distribution channels expect.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

fail=0
check() { if eval "$1" >/dev/null 2>&1; then echo "ok   $2"; else echo "FAIL $2"; fail=1; fi; }

check '[ -f .claude-plugin/plugin.json ]'                 "plugin manifest exists"
check 'node -e "JSON.parse(require(\"fs\").readFileSync(\".claude-plugin/plugin.json\",\"utf8\"))"' \
                                                          "plugin manifest is valid JSON"
check '[ "$(node -p "require(\"./.claude-plugin/plugin.json\").name")" = turkish-humanify ]' \
                                                          "plugin name is turkish-humanify"
check '[ -d skills/turkish-humanify/references ]'         "skill directory exists"
check '[ -f .claude-plugin/marketplace.json ]'            "marketplace manifest exists"
check 'python3 -c "import json,sys; json.load(open(\".claude-plugin/marketplace.json\"))"' "marketplace manifest is valid JSON"
check '[ -f LICENSE ]'                                    "LICENSE exists"
check '[ -f README.md ]'                                  "README exists"

exit $fail
