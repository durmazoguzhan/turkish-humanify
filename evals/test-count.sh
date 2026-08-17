#!/usr/bin/env bash
# Asserts count.sh against a fixture whose counts were verified by hand.
# The fixture table in docs/plans/2026-08-17-turkish-humanify.md is the
# authority: if a number disagrees, fix count.sh, never the fixture.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

expected="words=32 sentences=5 len_mean=6.4 len_sd=3.6 em_dash=1 mektedir=1 dir_copula=2 ve_per100=3.1 particles=1 calque=2 forced=0 tilde=0 pct_wrong=0 bold=0 bullets=2"

row=$(./count.sh fixtures/known.md | tail -n 1)
read -r _file words sentences len_mean len_sd em_dash mektedir dir_copula \
        ve_per100 particles calque forced tilde pct_wrong bold bullets <<<"$row"

actual="words=$words sentences=$sentences len_mean=$len_mean len_sd=$len_sd em_dash=$em_dash mektedir=$mektedir dir_copula=$dir_copula ve_per100=$ve_per100 particles=$particles calque=$calque forced=$forced tilde=$tilde pct_wrong=$pct_wrong bold=$bold bullets=$bullets"

if [ "$actual" = "$expected" ]; then
  echo "ok   count.sh matches the hand-verified fixture"
else
  echo "FAIL count.sh disagrees with the fixture"
  echo "  expected: $expected"
  echo "  actual:   $actual"
  exit 1
fi
