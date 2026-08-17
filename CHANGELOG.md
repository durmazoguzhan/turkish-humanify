# Changelog

## 1.0.0 — 2026-08-17

First release.

### The skill

- Three-layer architecture behind a thin router: composition, sentence,
  surface. Each layer is a reference file read at the moment it is used.
- Fourteen sentence-level phenomena where Turkish and English genuinely
  diverge, each with worked before/after pairs and an explicit statement of
  where the rule stops. The "where it stops" lines matter as much as the rules:
  inversion is wrong in a contract, `-mIş` is a lie about who witnessed what,
  and stripping `-DIr` from a specification makes the specification wrong.
- Four registers with a dosage matrix. Surface is always on because
  orthography and terminology are correctness, not style.
- Five voice profiles, each specified on nine observable dimensions rather than
  with adjectives, plus a procedure for extracting a voice from a user's own
  sample.
- Terminology policy in three buckets, with the rule that a kept English term
  inflects from its pronunciation rather than its spelling.
- Repair-mode diagnostics that record how often each tell actually appears, so
  a repair pass works the common ones first.

### Evaluation

- Twelve-text baseline corpus of unaided model Turkish from clean-context
  subagents given ordinary short prompts, plus published Turkish excerpts for
  calibration.
- `count.sh` and a fixture test with hand-verified counts.
- Three-way comparison against `turkce-humanizer` in `evals/RESULTS.md`:
  both skills beat raw model output decisively; the two skills tie on blind
  reading quality; fidelity is 0 added claims against 23.

### Decisions recorded rather than assumed

- `docs/design/2026-08-17-turkish-humanify-design.md` — the design and its
  reasoning.
- `experiments/prose-language/RESULT.md` — whether the skill should explain
  itself in English or Turkish, settled by running both arms over the corpus
  and judging blind. Result 7–5 for Turkish, p=0.387, which is noise; English
  wins by a tiebreaker fixed before the experiment ran.
- `evals/rubric.md` — four measurement bugs the calibration exposed, each of
  which had already produced a confident wrong finding, and what separates
  machine Turkish from published Turkish once they are fixed.
