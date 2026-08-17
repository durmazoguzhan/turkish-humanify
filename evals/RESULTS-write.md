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

Measured `-mektedir` density per 100 words:

| file | no skill | skill |
|---|---|---|
| `w-acad-1` | 0.0 | **2.8** |
| `w-acad-2` | 0.0 | **2.1** |
| `w-acad-3` | 0.0 | **1.9** |

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

`-mektedir` per 100 words on the academic tasks:

| file | no skill | before | **after** |
|---|---|---|---|
| `w-acad-1` | 0.0 | 2.8 | **0.3** |
| `w-acad-2` | 0.0 | 2.1 | **0.3** |
| `w-acad-3` | 0.0 | 1.9 | **0.6** |

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
  result does not close it.
- **The removal of the no-fabrication rule from write mode is part of this
  change**, so some of the gain may come from the skill no longer bracketing
  what it could simply write around, rather than from the mode split as such.
  The two were shipped together and this round does not separate them.
