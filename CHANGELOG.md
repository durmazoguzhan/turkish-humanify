# Changelog

## Unreleased

### Versioning, distribution and project docs

- **The documented install path could not work.** The README said
  `/plugin install turkish-humanify@durmazoguzhan`, but the repository had no
  `.claude-plugin/marketplace.json`, so there was no marketplace to install
  from. Added, along with the missing `/plugin marketplace add` line.
- **The version was pinned at `1.0.0` and never moved**, through the mode split,
  the recalibration and seven counter fixes. Claude Code uses that field as the
  update key and skips the update when it matches, so anyone who installed at
  1.0.0 would have received none of it.
- Switched to [WendtVer](https://wendtver.org), derived from the commit count by
  `scripts/version.sh` and enforced by CI. SemVer is not used because a skill has
  no contract to break. The one-time consequence is that the version goes
  **backwards**, 1.0.0 to 0.3.6; the update check compares for equality, not
  order, so installed users still get the change.
- `.github/workflows/ci.yml` runs the layout check, the counter fixture test and
  the version gate on every push and pull request.
- Added `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md` and a pull
  request template.

### Mode split

- `SKILL.md` now routes to `references/rewrite-mode.md` or
  `references/write-mode.md` before anything else. Fidelity to the supplied text
  lives in the repair file, where it has a referent; the dosage table's repair
  verbs (*cleanup*, *stays*, *off*) get an explicit write-mode translation.
- Measured in `evals/RESULTS-write.md`: 11–1 against the same prompts without
  the skill (p=0.0032), up from 7–5 (p=0.387), with the no-skill arm held
  byte-identical.

### Academic register calibrated against published text

- Five Turkish journal articles published 2015–2019 added to
  `evals/human-reference/`, chosen with a pre-2022 cutoff so none of them can be
  model output. They put the `-mektedir` band at 0.4–2.3 per 100 words and the
  `-DIr` band at 2.3–4.0; `registers.md` and `layer-2-sentence.md` §7 now carry
  those numbers instead of a bare "stays".
- The shipped dose measures inside both bands. Unaided output measures 0.0 on
  both — the register's characteristic present tense and copula are absent, not
  merely sparse.

### Repair mode re-measured after the split

- Round five in `evals/RESULTS.md`: **16-5 against `turkce-humanizer` across
  twenty-one files**, two-sided p=0.027, competitor arm held byte-identical.
  Corporate went from 2-3 to 4-1 and is no longer the register this skill loses;
  academic went from 5-0 to 3-2.
- Fidelity: zero added claims across all twenty-one outputs.
- `evals/repair-protocol.md` and `evals/pair.sh` commit the procedure that four
  earlier rounds only described.

### Fixed

- `count.sh` matched `-mektedir` with `(mekte|makta)dır`, which sees only the
  back-vowel `-maktadır`. The column was blind to the form it is named after,
  and every `mektedir_p` figure published before 2026-08-17 is about half the
  real rate; 52 of 183 corpus files change. The fixture now carries both
  harmony forms so the old regex fails `test-count.sh`.
- `p2` was missing the `-dInIz` variants `dunuz/dünüz/tınız/tiniz/tunuz/tünüz`.
  Closing the gap moves no number on the current corpus.
- `sentences`, `len_mean` and `len_sd` were line-bound: a hard-wrapped paragraph
  counted one sentence per source line, so one file measured 45 sentences of 7.5
  words where it has 19 of 17.8. 42 of 183 files affected. `prose()` now joins
  each paragraph onto one line before splitting.
- `ve_p` matched ` ve ` and so missed every `ve` sitting next to a line break or
  a sentence start; now `\b[Vv]e\b`. 16 files change.
- `em_dash` counted date ranges whose left side ends in a word ("15 Aralık – 2
  Ocak"), because the range exclusion only skipped a dash preceded by a digit.
  It now requires a non-digit on both sides. Round five briefly reported a
  hard-rule violation that was not one.
- Neither moves a conclusion: `len_sd` still fails to separate unaided from
  published non-academic Turkish (5.6 against 5.6), and the prose-language arms
  stay indistinguishable. The fixture now carries a wrapped sentence and a
  line-initial `ve`, so both bugs fail `test-count.sh`.

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
