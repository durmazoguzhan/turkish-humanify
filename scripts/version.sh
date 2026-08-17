#!/usr/bin/env bash
# WendtVer for this repository: https://wendtver.org
#
#   Start at 0.0.0. Every commit increments PATCH.
#   PATCH rolls over to 0 at 10 and increments MINOR.
#   MINOR rolls over to 0 at 10 and increments MAJOR.
#
# which makes the version nothing more than the commit count written one digit
# at a time. That is the point: it is derived, not decided, so it cannot drift
# the way a hand-maintained number does — and this repository has already proved
# it drifts, having shipped `1.0.0` through a mode split, a recalibration and
# seven counting-bug fixes without once moving.
#
# SemVer is not used because a skill has no contract to break. There is no API
# whose removal is a MAJOR event and no addition that is a MINOR one; every
# change is "the prose is different now". A version that pretends otherwise is
# decoration, and decoration that has to be maintained by hand gets forgotten.
#
# Usage:
#   scripts/version.sh            print the version the next commit should carry
#   scripts/version.sh --current  print the version HEAD should carry
#   scripts/version.sh --check    verify plugin.json matches HEAD's commit count
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

manifest=".claude-plugin/plugin.json"

encode() { printf '%d.%d.%d' "$(( $1 / 100 ))" "$(( ($1 / 10) % 10 ))" "$(( $1 % 10 ))"; }

count=$(git rev-list --count HEAD)

case "${1:-}" in
  --current) encode "$count"; echo ;;
  --check)
    want=$(encode "$count")
    have=$(python3 -c "import json;print(json.load(open('$manifest')).get('version',''))")
    if [ "$want" = "$have" ]; then
      printf 'ok   version %s matches %s commits\n' "$have" "$count"
    else
      printf 'FAIL %s says version %s; %s commits means %s\n' "$manifest" "${have:-<unset>}" "$count" "$want" >&2
      printf '     fix: scripts/version.sh --write\n' >&2
      exit 1
    fi ;;
  --write)
    want=$(encode "$(( count + 1 ))")
    python3 - "$manifest" "$want" <<'PY'
import json, sys, collections
path, want = sys.argv[1], sys.argv[2]
with open(path) as fh:
    data = json.load(fh, object_pairs_hook=collections.OrderedDict)
data["version"] = want
with open(path, "w") as fh:
    json.dump(data, fh, indent=2, ensure_ascii=False)
    fh.write("\n")
PY
    printf 'wrote version %s (for commit %d)\n' "$want" "$(( count + 1 ))" ;;
  *) encode "$(( count + 1 ))"; echo ;;
esac
