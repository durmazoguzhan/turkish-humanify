## What this changes

<!-- One or two sentences. If it changes the skill's behaviour, say which
     register and which layer. -->

## Evidence

<!-- Required if this adds, removes or changes a rule in
     skills/turkish-humanify/references/.

     Rules here are measured, not argued: see CONTRIBUTING.md and
     evals/repair-protocol.md. Several changes that looked obviously right made
     the output measurably worse, which is why this section exists.

     If you are reporting a problem rather than fixing one, an issue with the
     offending Turkish quoted is more useful than a PR. -->

- Round run:
- Tally, by register:
- Fidelity — additions against source:
- What got worse:

## Checklist

- [ ] `scripts/version.sh --write` run, version bumped
- [ ] `./scripts/check-structure.sh` passes
- [ ] `./evals/test-count.sh` passes
- [ ] If `evals/count.sh` changed: a fixture case the old version fails, and the
      number of corpus files affected stated in the commit message
- [ ] If a claim in `README.md`, `RESULTS.md` or the reference files is now
      stale, it is updated in this PR rather than left for later
