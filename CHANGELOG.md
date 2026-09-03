# Changelog

## Unreleased

### Round nine — issue #9: both changes rejected, and one fidelity site found

- **No rule was added to the skill this round.** Both halves of the change under
  test failed, and `evals/RESULTS.md` carries why at length.
- **The list half** — a two-bullet evidence section coming back as one paragraph —
  reproduces, but once in two generations of the text and not at all in two
  generations of a structurally identical neutral twin. Across eleven generations
  the skill preserved the skeleton in ten: every row of a 25-row API reference,
  every bullet of a runbook. Below the rate bar in `repair-protocol.md`.
- **The emphasis half cleared its threshold and was still wrong**, which is the
  more useful failure. `bold` fell in four of eight runs; reading *which* spans
  went reverses it. A word bolded in both entries of a two-entry list
  distinguishes nothing, and that is what was deleted. The finding itself
  survived every run. A structural count says something moved and not whether
  moving it was right — and `bullets`, `rows` and `heads` share the weakness.
- **`layer-1-structure.md` §5 and §6 carry the episodes**, stated as diagnosis
  with the measurement's actual strength, not as new instructions.
- **`registers.md`: the corporate list rule is re-read as an instance rather than
  an exception.** A landing page is scanned, which is true of the object and not
  of its tone — which is why the rule, filed under a register, never reached a
  runbook one row up. `docs/design/2026-09-04-shape-axis.md` carries the argument
  and the case that issues #8 and #9 are one gap seen from two ends.
- **Pre-registered for round ten:** a scan label becoming a first-person account
  of the scan. `Tüm repo taraması:` → `Repoyu baştan sona taradım:`, in two
  independent texts across two arms.

### A round is seven files generated twice, not twenty-one generated once

- **`evals/repair-protocol.md` §0 defines a standing sample.** This is smaller
  *and* stronger, which is why it is not filed as an economy: round eight's bar
  is two appearances in *n* generations of the **same** input, and twenty-one
  files generated once cannot satisfy it at all — every result such a round
  produces is a lead by construction. Fourteen generations is fewer than
  twenty-one and all of them are bar-eligible.
- Seven files covering four registers and three document shapes; the rest of the
  corpus is reserve. **A change that clears the sample gets one confirmation
  generation on three reserve files before it ships**, because seven files is few
  enough to fit rules to.
- The blind tally is the one thing the default round can no longer do — at seven
  files a sign test needs 7–0 — and `rubric.md` §5 already called it the wrong
  instrument for most changes.

### Issue #8 — declined, on its own evidence

- **No microcopy register.** #8 is a transcript of the tool assessing itself, so
  it was read sceptically; its two checkable claims hold and its recommendation
  does not follow from them. Layer 1 really is inert for atomic strings — seven
  of its eight sections name a unit a three-word chip does not have — and the
  reading cost is real: the repair path is **1,876 lines** whether the input is a
  journal article or fifteen button labels. But #8's own best observation is that
  the defect it found was subject clarity, *"Türkçe-mimarisi problemi değil"*, and
  a Turkish-architecture skill acquiring a register for a non-Turkish problem
  gains only somewhere to put a rule it has no standing to write.
- Written up in `docs/design/2026-09-04-shape-axis.md`, which keeps the `atomic`
  row recorded and unbuilt.

### Layer 2 — a counter was attempted and is not being built

- The narrowest greppable surface of the shape issue #9 actually objects to — a
  sentence ending in a verbless purpose tail — returns **0 hits in 206 sentences
  of published Turkish**, which separates rare from absent not at all. Most of
  what it finds sits in list items the prose view already drops, and it cannot
  tell *"yanmasın diye."*, which is correct, from the defect. Numbers in
  `evals/fixtures/devrik.md` so nobody spends the effort twice; resolving it
  needs a parse, not a better regex.

### Contributing — a second rule

- **"A count tells you something moved, not whether moving it was right."**
  Written into `CONTRIBUTING.md` as a rule of its own rather than a footnote to
  round nine, and into `evals/repair-protocol.md` §5 where countable targets are
  chosen. Measuring is not enough: round nine cleared a threshold set before the
  data existed and its conclusion was still false, because three of the four
  movements it counted were the rule under test behaving correctly. Any signal
  that can legitimately move either way — bold, bullets, rows, headings, sentence
  length, hedge counts — needs its individual instances read before the rate
  means anything.

### Instrument

- **Two counting bugs, both the shape of the eight before them: the prose view
  was reading fenced code and table rows as Turkish.** `technical-5` carried 38
  words of Redis commands in its own denominator, an eleven percent error in
  every per-100 figure for that file. Three corpus files move; one stale row in
  `baseline-prompts.md` is corrected. No published conclusion moves — the
  semicolon and `-mAktAdIr` bands are calibrated on `human-reference/`, which has
  no code.
- **Four columns added: `heads`, `rows`, `fences` and `prose_pct`.** The last is
  the one that mattered: when a list becomes prose the word total is a different
  denominator, so no per-100 figure survives the comparison. On the reported
  failure the source's prose view is 3 words and the output's is 49, and the only
  previously visible trace was `bullets` falling to zero.
- `evals/fixtures/known.md` gained a code block and a table; `evals/test-count.sh`
  carries the hand-computed expectations. The old counter reports `words=64` on
  that fixture against a true 38.

### Documentation that had gone stale

- `README.md` still claimed **"zero added claims across twenty-one files"**, a
  boast `references/rewrite-mode.md` deleted two rounds ago on the grounds that a
  rule reporting its own perfect compliance does not get checked. Replaced with
  the actual record: four findings in round seven, one in round eight.
- `README.md` also conceded document-structure preservation to `turkce-humanizer`
  outright; round nine measured this skill at ten of eleven, so the concession is
  now stated at its measured size — their guarantee against our measurement.
- Corpus count 21 → 26, counting bugs 8 → 10, both in `README.md` and
  `evals/rubric.md`.

### Corpus

- **Four reference-shaped baselines**, `evals/input/reference-1..4`: an evidence
  section, an API reference, a runbook and an incident report. The corpus had no
  tables at all and one technical file with a real bullet list, so a rule about
  what happens to a document's structure had nothing to be measured on.
  `reference-5` is a five-line fragment, the public stand-in for the text in
  issue #9.
- **Recorded rather than filed away: unaided model Turkish does not bullet a blog
  post.** Two prompts were run specifically to produce a list a rule should
  dissolve and both came back with none, as did five of the six blog baselines
  already in the corpus. §5's conversion therefore has no positive test case in
  blog register and is unmeasured in both directions.

### Contributing

- **Three cases per class, written down as the norm.** A fixture is a tripwire,
  not a corpus. The loosening applies to deterministic checks only; the noise
  floors for the blind tally and the fidelity check are unchanged.


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

### The en dash was a wrong rule, not a slip

- `layer-3-surface.md` said range dashes were correct and to leave them alone.
  TDK gives ranges to the short hyphen (`1914-1918`, `Ankara-İstanbul`) and does
  not recognise an en dash at all; across the nine published Turkish texts in
  `evals/human-reference/` ranges use the plain hyphen 70 times against 3.
- The instrument had been configured to agree: `em_dash` was built to exclude
  range dashes *because* the rule called them correct, so six rounds passed
  without noticing. A blind judge found it. New `endash` signal, raw count.
- Also names sentence-final `ama` in `layer-2-sentence.md` §16. On `blog-1` the
  skill used it four times where the source and the competitor use it zero.

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
