# Results — write mode

Everything in `RESULTS.md` measures **repair mode**: every run there was handed
an input text. This file covers the other half of the skill, which had never
been run until now.

**Date.** 2026-08-17

---

## Design

Twelve fresh prompts, three per register, on topics that appear nowhere in the
repair corpus. Each prompt was run twice under identical conditions: once by a
subagent that reads the skill and follows it, once by a subagent given the
prompt alone. **Both arms were generated new.** Reusing the repair baselines
would have compared a tool-using arm against one forbidden from tools, which is
not the variable under test.

Twelve blind pairwise judgments followed, order randomised per file, key held
separately, judges told only to pick the text that reads as written by a Turkish
person.

**No fidelity check.** There is no source to be faithful to, so the repair-mode
check does not transfer. Anything surprising was found by reading.

## The tally

| | skill | no skill |
|---|---|---|
| **all 12** | **7** | 5 |

p = 0.387 under a fair coin. **Noise.** On this evidence the skill does not
improve write-mode Turkish overall.

By register — where it gets interesting:

| register | skill | no skill |
|---|---|---|
| **blog / essay** | **3** | 0 |
| technical | 2 | 1 |
| corporate | 1 | 2 |
| academic | 1 | 2 |

Blog is a clean sweep and academic and corporate are net losses. Three files per
register is too few to call any of these, but the two losses have identifiable
causes and both are the skill's own rules misfiring.

---

## The unaided baseline is much higher here than in repair mode

Worth saying before anything else, because it reframes the comparison.

The twelve no-skill outputs are markedly better Turkish than the twenty-one
repair baselines. They contain, unprompted, most of what the sentence layer
teaches:

> "Meğer bitkiler benden pek bir şey istemiyormuş; ben onlara fazla yükleniyormuşum." — evidential `-mIş`
> "Doğru muydu bilmiyorum, ama o yalanın bana faydası oldu." — self-correction
> "Hepsi buydu, ve fena bir hepsi değildi." — inversion

No leak: the prompts were checked and the subagents had clean context. The cause
is topic. Prompts like *"kırk yaşında yüzme öğrenmek"* are personal-essay shaped
and summon that voice by themselves; the repair corpus is mostly guides,
explainers and announcements, which is where the flatness lives.

**This qualifies the project's premise.** "LLMs write soulless Turkish" is not
true of every task — it is true of particular text types. The skill's room to
help in write mode is correspondingly narrower, and the 7–5 should be read
against a strong opponent rather than as a weak result.

---

## Finding 1: a repair-mode rule misfires in write mode

Measured `-mektedir` density per 100 words (corrected — see "Round three", the
figures first published here were 2.8 / 2.1 / 1.9 from a counter that was
missing half the suffix):

| file | no skill | skill |
|---|---|---|
| `w-acad-1` | 0.0 | **4.5** |
| `w-acad-2` | 0.0 | **3.7** |
| `w-acad-3` | 0.0 | **2.9** |

The judges penalised it in exactly those words: *"neredeyse her yüklem
`-mektedir/-maktadır` kalıbında"*, *"paragrafların hepsi aynı uzunlukta"*.

**This is a direct side effect of a fix made an hour earlier.** The academic
dosage row was corrected to read "`-mektedir` **stays**", to stop the skill
stripping evidential markers out of academic source texts. In repair mode
"stays" means *do not delete what is there*. In write mode nothing is there, so
the same word reads as *produce this* — and the skill produces it to the point
of monotony.

The dosage table's whole vocabulary is repair vocabulary: *cleanup*, *stays*,
*off*. Those verbs presuppose an existing text. Write mode needs its own column,
or the rows need phrasing that means the same thing in both directions. Not
fixed here, for the reason this document has now recorded four times.

## Finding 2: honesty about unknowns loses the blind test

The write-mode rule says: if the piece needs a specific you do not have, find it
or ask — do not invent. Placeholders counted:

| file | no skill | skill |
|---|---|---|
| `w-corp-1` | 3 | **18** |
| `w-corp-2` | 1 | **22** |
| `w-corp-3` | 0 | **5** |

Both corporate losses turn on this, and one judge diagnosed it unprompted while
ruling against us:

> "Not: A'nın üstünlüğünün önemli bir kısmı somut tarih/sayı taşımasından
> geliyor (1 Eylül, 14→18 gün, 28 Ağustos Cuma 14.00) — bunlar kaynakta yoksa
> uydurma sayılır, yani bu karşılaştırma insan-benzerliği ölçüyor, sadakati
> değil."

For a leave-policy email the user never specified, the unaided arm invented an
effective date, a day count, a policy change and a meeting time. The skill wrote
`[yürürlük tarihi]` and `[eski gün sayısı]`. The judge preferred the invention
and said so.

**The skill's behaviour is right and the metric is wrong**, again. A company
announcing its own leave policy knows its own dates; a draft full of confident
fabrications is worse than a draft with blanks, because the fabrications have to
be hunted down. This is the write-mode form of the finding already recorded in
`RESULTS.md`: a blind human-likeness test rewards invention, and here it rewards
it even when the invention is obviously a placeholder's job.

**A caveat against over-claiming this.** Eighteen to twenty-two placeholders in
a 400-word text is a lot, and some of them are probably the skill being timid
rather than principled — a bakery post can say "sabahları taze çıkıyor" without
inventing a clock time or leaving a bracket. The rule is right; its calibration
is untested.

---

## Verdict

**Write mode is not established.** 7–5 is noise, the sample is twelve, and the
judges are language models.

**Blog is the one place with a hint of a result** at 3–0, and it is also the
register the skill was designed around.

**Two of the losses are the skill working as designed** — one from a rule that
does not transfer between modes, one from refusing to invent. The first is a
defect and should be fixed. The second is a defect in the measurement, not in
the skill, and fixing it would mean teaching the skill to lie.

**What this does not cover:** brief adherence was deliberately not scored, no
competing skill was compared against because `turkce-humanizer` has no write
mode, and every fidelity claim in this repository remains a repair-mode claim.

---

## Round two — the split, and the first clean single-variable result

The skill was restructured into shared / `write-mode.md` / `rewrite-mode.md`, and
the two defects above were addressed. Then the same twelve prompts were re-run.

**Only one thing changed.** The no-skill arm's twelve files were not regenerated
— they are byte-identical to round one. Same prompts, same judge protocol, same
randomisation procedure. The only variable is the skill.

### The tally

| | skill | no skill |
|---|---|---|
| round one | 7 | 5 |
| **round two** | **11** | **1** |

p = 0.0032 for the new result. Round one was p = 0.387.

| register | round one | round two |
|---|---|---|
| blog | 3–0 | **3–0** |
| technical | 2–1 | **3–0** |
| academic | 1–2 | **3–0** |
| corporate | 1–2 | **2–1** |

Academic went from a net loss to a sweep, and technical and corporate both
gained. This is the first result in the project where a single variable moved,
the control was held fixed, and the outcome cleared significance.

### Both mechanisms measurably fixed

Not just the score — the two things diagnosed as causes both moved.

`-mektedir` per 100 words on the academic tasks (corrected — see "Round three";
first published as 2.8/2.1/1.9 → 0.3/0.3/0.6):

| file | no skill | before | **after** | published Turkish |
|---|---|---|---|---|
| `w-acad-1` | 0.0 | 4.5 | **0.8** | 0.4 – 2.3 |
| `w-acad-2` | 0.0 | 3.7 | **1.2** | 0.4 – 2.3 |
| `w-acad-3` | 0.0 | 2.9 | **0.8** | 0.4 – 2.3 |

Placeholders on the corporate tasks:

| file | no skill | before | **after** |
|---|---|---|---|
| `w-corp-1` | 3 | 18 | **4** |
| `w-corp-2` | 1 | 22 | **1** |
| `w-corp-3` | 0 | 5 | **3** |

And the judges' reasoning tracks the fixes. On `w-acad-1` the deciding praise was
*"`-mektedir` düzeninin tutarlı korunması"* — the same suffix that lost the
previous round on monotony now wins on consistency. The register was never
wrong about `-mektedir`; the dose was.

### What still loses

`w-corp-1`, the bakery post, and for a reason worth keeping. The judge preferred
the unaided text for *"Bunları öve öve anlatmak istemiyoruz aslında, normal
olması gereken şeyler. Ama artık normal olmadığı için söylüyoruz."* — a
defensive, faintly sardonic shopkeeper's aside. That is not a rule the skill
holds; it is a thing a person happened to say. Some share of good writing is not
reachable by rule, and this file is a reminder of where that line sits.

### Discounts

- **Twelve files, and judges that are language models.** A four-file swing at
  n=12 carries real variance. What raises confidence above the count is that the
  design was within-subject — same prompts, same control texts — and that both
  diagnosed mechanisms moved in the predicted direction.
- **`-mektedir` at 0.3 is now near the unaided rate of 0.0**, and whether that
  is correct or now *under*-using is untested. Published Turkish academic prose
  does use the form, and there is no academic text in
  `evals/human-reference/` to calibrate against. That gap is real and this
  result does not close it. — *Closed in Round three, and the premise was wrong
  twice over: the rate was 0.8, not 0.3, and 0.8 is inside the published band.*
- **The removal of the no-fabrication rule from write mode is part of this
  change**, so some of the gain may come from the skill no longer bracketing
  what it could simply write around, rather than from the mode split as such.
  The two were shipped together and this round does not separate them.

---

## Round three — the counter was blind to half of `-mektedir`

Set out to close the calibration gap above by adding Turkish academic text to
`evals/human-reference/`. Found a bug in the measuring instrument first.

### The bug

`count.sh` matched `-mektedir` with the regex `(mekte|makta)dır`. Turkish vowel
harmony gives the suffix two forms, and that regex only matches one of them:

```
$ printf 'görülmektedir yapılmaktadır gerekmektedir kullanılmaktadır\n' \
  | grep -oE '(mekte|makta)dır'
maktadır
maktadır
```

Two of four. The column is *named* `mektedir_p` and it could not see
`-mektedir` — only the back-vowel `-maktadır`. After front-vowel stems, which
is where the most common academic verbs live (`görül-`, `gerek-`, `edil-`,
`bulun-`, `değerlendiril-`), every occurrence was invisible.

Effect: every `mektedir_p` figure published in this file before 2026-08-17 is
roughly **half** the real rate. `RESULTS.md` and the prose-language experiment
never quoted the column, so nothing there moves — but `RESULTS.md`'s
evidential-form table was hand-counted from the text rather than taken from
`count.sh`, and re-checking it against the corrected regex leaves it standing
(`academic-5`: 4 in the source, 4 after the fix). Re-measuring the whole
corpus, **52 of 183 files change**: 36 of them academic register, and the other
16 all inside `evals/output/turkce-humanizer/`, where the hits turn out to be the
competitor's own commentary *about* the suffix (`"Kritik bir rol oynamaktadır"
ailesinden hiçbiri`) rather than its Turkish output — those comparisons run on
`turkce-humanizer-text/`, so they do not move.

No blind-judgement result moves at all: the 11–1 tally is judge-based, not
counter-based. What moves is the mechanism table, in both directions at once —
the "before" was worse than reported and the "after" is higher than reported.

This is the fifth counting bug in this instrument, and the fifth time the numbers
and the reading disagreed with the numbers on the losing side. The fixture now
carries both harmony forms (`artmaktadır`, `edilmektedir`), so the old regex
fails `test-count.sh` instead of passing it.

### The calibration

Five Turkish journal articles, all on DergiPark, all published **2015–2019** —
chosen with a pre-2022 cutoff so that none of them can be model output. Sociology,
literature, education, political economy, information systems. Measured over the
full article body, introduction through conclusion, references and English
abstract stripped:

| article | year | words | `mektedir_p` | `dir_p` |
|---|---|---|---|---|
| Tanzimat romanı (literature) | 2018 | 4988 | 0.4 | 2.8 |
| Psikolojik danışmanlar (education) | 2019 | 3730 | 0.6 | 2.5 |
| Risk toplumu (political economy) | 2018 | 4120 | 1.6 | 2.3 |
| Yönetim bilgi sistemi (information systems) | 2019 | 6813 | 1.6 | 2.8 |
| Toplumsal ekoloji (sociology) | 2015 | 4477 | 2.3 | 4.0 |

**Band: 0.4 – 2.3, median 1.6.** `-DIr` copula: 2.3 – 4.0, median 2.8.

The spread inside the band is a real stylistic choice, not noise. The two
low-rate articles use the aorist where the others use `-mektedir`
(*değerlendirilir*, *belirler*, *karşılaşırlar*, *savunur*). Both halves read as
published academic Turkish, which is why the target is a band and not a number.

### What it says about the skill

| | `mektedir_p` | `dir_p` |
|---|---|---|
| unaided, asked for an academic text | 0.0 / 0.0 / 0.0 | 0.0 / 0.0 / 0.0 |
| skill, round one | 4.5 / 3.7 / 2.9 | 5.0 / 4.3 / 4.8 |
| **skill, round two (shipped)** | **0.8 / 1.2 / 0.8** | **3.3 / 2.1 / 3.7** |
| published Turkish, 2015–2019 | 0.4 – 2.3 | 2.3 – 4.0 |

Three things follow, and the middle one was not expected.

1. **The shipped dose is inside the band**, on both signals. The worry recorded
   in Round two — that 0.3 was now under-using — was an artefact of the bug. No
   rule change is warranted, and making one on the strength of the wrong number
   would have repeated the Round-one mistake in the opposite direction.
2. **Unaided model Turkish does not use these forms at all.** Not sparingly:
   0.0 on both, in all three academic tasks. Asked for a Turkish journal-style
   text, the model writes prose with neither the register's characteristic
   present tense nor its copula. That is a larger miss than the over-use it was
   corrected into, and it is the clearest single measurement in this file of what
   "LLM Turkish has no register" means concretely.
3. **Round one was above the human ceiling on both signals**, which is what the
   judges were reacting to when they wrote *"neredeyse her yüklem
   `-mektedir/-maktadır` kalıbında"*. That reading is now quantified rather than
   inferred.

### Discounts

- **Five articles.** Enough to bound the band, not to establish a distribution.
  The band's ends are two articles each, so either end could move with a sixth.
- **The committed files are excerpts**, roughly 400–580 words of the opening of
  each article, while the band above is measured on full bodies. Running
  `count.sh` on `evals/human-reference/dergipark-*.md` gives 0.2 – 2.3 — the same
  ceiling, a lower floor, and per-article the excerpt runs denser in three of
  five, thinner in one, level in one. So the two views agree on the band but not
  file by file. The full-body figures are the calibration; the excerpts are what
  the repo can carry.
- **`dir_p` and `mektedir_p` overlap by construction** — `-maktadır.` satisfies
  both regexes. They are separate columns measuring overlapping things, which is
  fine for tracking movement and wrong for summing.
- **The band is descriptive, not normative.** These five articles are published,
  not good. `evals/human-reference/gezinomi-negative-control.md` exists to make
  exactly that distinction, and nothing here promotes "matches the band" to
  "reads well".
