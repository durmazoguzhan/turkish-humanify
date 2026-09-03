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
# Every pull request lands as exactly one commit, because squash is the only
# merge method this repository allows. That makes a branch's own commit count
# irrelevant to the version: four commits on a branch still add one to master.
# So the version a branch must carry is the *base* branch's count plus one, and
# computing it from HEAD instead is a mistake this script used to make — one that
# passed the pull-request gate (the version had moved forward) and would then
# have failed the push gate on master (it had moved forward by three).
#
# Usage:
#   scripts/version.sh            print the version this branch should carry
#   scripts/version.sh --current  print the version HEAD should carry
#   scripts/version.sh --check    verify plugin.json matches HEAD's commit count
#   scripts/version.sh --write    set plugin.json to the version this branch should carry
#
# BASE overrides the base branch, which defaults to master.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

manifest=".claude-plugin/plugin.json"

encode() { printf '%d.%d.%d' "$(( $1 / 100 ))" "$(( ($1 / 10) % 10 ))" "$(( $1 % 10 ))"; }

count=$(git rev-list --count HEAD)

# The count this branch will produce on the base branch once squashed: the
# base's own count plus the one commit the squash creates. Falls back to the
# local branch when there is no remote-tracking ref, and to HEAD's count when
# there is no base either, which is the case on master itself.
base_branch="${BASE:-master}"
target_count() {
  local ref
  for ref in "origin/$base_branch" "$base_branch"; do
    if git rev-parse --verify --quiet "$ref" >/dev/null; then
      git rev-list --count "$ref"
      return
    fi
  done
  echo "$count"
}

case "${1:-}" in
  --current) encode "$count"; echo ;;
  --check)
    # On the base branch the commit count is the truth and is checked directly.
    # On any other branch HEAD's count is not what will land, so the check is
    # against what the squash will produce; checking HEAD there reports a
    # failure for a version that is correct.
    if [ "$(git rev-parse --abbrev-ref HEAD)" = "$base_branch" ]; then
      n="$count"; how="$count commits"
    else
      n=$(( $(target_count) + 1 )); how="$base_branch + 1 squashed commit"
    fi
    want=$(encode "$n")
    have=$(python3 -c "import json;print(json.load(open('$manifest')).get('version',''))")
    if [ "$want" = "$have" ]; then
      printf 'ok   version %s matches %s\n' "$have" "$how"
    else
      printf 'FAIL %s says version %s; %s means %s\n' "$manifest" "${have:-<unset>}" "$how" "$want" >&2
      printf '     fix: scripts/version.sh --write\n' >&2
      exit 1
    fi ;;
  --write)
    want=$(encode "$(( $(target_count) + 1 ))")
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
    printf 'wrote version %s (%s + 1 squashed commit)\n' "$want" "$base_branch" ;;
  *) encode "$(( $(target_count) + 1 ))"; echo ;;
esac
