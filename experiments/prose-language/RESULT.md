# Prose-language experiment — result

**Question.** Should `SKILL.md` and the reference files explain themselves in
English or in Turkish? The examples are Turkish either way; only the
explanatory prose varies.

**Why it was run rather than argued.** Both positions are reasonable. English
is forkable — a developer adapting this repository for another language can
read the scaffolding. Turkish might connect the model more directly to its own
Turkish grammatical knowledge. Neither of those is knowable from an armchair,
so the repository owner asked for a measurement instead of a preference.

**Date.** 2026-08-17

---

## Design

Two arms, `en/` and `tr/`, containing `SKILL.md` and
`references/layer-2-sentence.md`. The rules, their order, every Turkish
example, the heading structure and the front matter `name` are identical;
`check-arms.sh` asserts this and is part of the repository, so the single
variable cannot drift as the arms are edited.

Each arm was run over all twelve corpus inputs by a clean-context subagent.
**Both arms received the same English wrapper instruction** — "read this skill
and follow it on this input" — because giving the Turkish arm a Turkish
instruction would have introduced a second variable and made the comparison
meaningless.

Twelve blind pairwise judgments followed, one per input. Arm order was
randomised per pair with `shuf`, the labels were stripped to A and B, and the
key was written to a separate file. Each judge was a clean-context subagent
told only to read one pair file and say which text reads as written by a
Turkish person, quoting the sentences that decided it. No judge was told that
an experiment was running, what the arms were, or that a skill had produced
either text.

---

## Countable signals

The two arms are indistinguishable. `em_dash` is 0 across all 24 outputs.
`bold` and `bullets` are identical file for file. `dir_p`, `mis_p`, `len_sd`
and `ve_p` differ only in the third significant figure, in both directions.

```
                      len_sd            dir_p             mis_p             part_p
file             en      tr        en      tr        en      tr        en      tr
academic-1      6.7     6.6       0.0     0.0       0.6     0.6       1.1     1.1
academic-2      6.0     6.2       3.3     3.3       0.3     0.3       0.3     0.3
academic-3      9.0     9.7       2.2     2.4       0.3     0.3       0.3     0.5
blog-1          5.2     5.2       0.0     0.0       1.2     1.2       2.0     1.6
blog-2          4.8     5.3       0.6     0.6       1.2     1.2       0.9     1.2
blog-3          4.0     4.2       0.0     0.0       0.3     0.6       0.6     1.2
corporate-1     3.4     2.9       0.0     0.0       0.0     0.0       1.1     0.5
corporate-2     5.3     5.4       0.0     0.0       0.0     0.0       0.0     0.0
corporate-3     4.4     4.4       0.0     0.0       0.3     0.6       0.6     0.3
technical-1     5.2     5.3       0.0     0.0       0.5     0.5       0.8     0.8
technical-2     8.1     5.6       0.0     0.0       1.4     1.4       1.0     1.0
technical-3     5.1     4.9       0.0     0.0       1.5     1.7       1.0     1.0
```

Full tables: `.scratch/en.txt`, `.scratch/tr.txt`, baseline in `.scratch/base.txt`.

## Blind pairwise judgment

| input | A | B | judge chose | arm |
|---|---|---|---|---|
| blog-1 | en | tr | A | **en** |
| blog-2 | en | tr | A | **en** |
| blog-3 | en | tr | B | **tr** |
| technical-1 | en | tr | B | **tr** |
| technical-2 | tr | en | B | **en** |
| technical-3 | tr | en | B | **en** |
| corporate-1 | tr | en | B | **en** |
| corporate-2 | en | tr | B | **tr** |
| corporate-3 | tr | en | A | **tr** |
| academic-1 | tr | en | A | **tr** |
| academic-2 | tr | en | A | **tr** |
| academic-3 | en | tr | B | **tr** |

**Turkish 7, English 5.** Under a fair coin, the probability of seeing 7 or
more out of 12 in one direction is 0.387. This is noise.

---

## Decision: English

The tiebreaker was fixed in the design document before the experiment ran:
if the difference is within noise, English wins, because in that case there is
no quality argument left and the remaining criterion is forkability. The
threshold was written down in advance as 8–4 or wider for signal, 7–5 or
narrower for noise, precisely so that a 7–5 could not be read afterwards as
"Turkish is ahead". It is being applied as written.

`skills/turkish-humanify/` already carries the English arm. No files change.

---

## What the judges' reasoning showed, which is worth more than the tally

The verdicts were not coin flips dressed up as prose — every judge cited
specific sentences, and the reasons cluster in a way that says something about
the skill rather than about the experiment.

**Both arms still leave translation smell.** In nearly every pair the judge
identified the losing text as "çeviri kokan" and quoted a real instance: a
colon-plus-list construction lifted from English presentation habits, a
stacked-noun phrase where a participle belonged, an "In the reverse order,"
calqued as "Ters sırada,". The sentence layer removes a great deal, and
demonstrably not all of it.

**The judges rewarded exactly what layer 2 teaches.** Unprompted, and without
knowing a skill existed, they named inversion (*"Özünü kavramaya fazlasıyla
yeter ama."*), evidential `-mIş` (*"Meğer ölçmediğim her değişken ... kendi
kafasına göre davranıyormuş."*), discourse particles (*"da öyle"*, *"Zaten ...
de"*), pro-drop (*"Evet, açıldık."* over *"Evet, biz açıldık."*), and
participle fronting over trailing clauses. That is independent evidence that
the fourteen phenomena are the right fourteen, whichever language describes
them.

**A hypothesis this experiment cannot settle.** The Turkish arm took all three
academic pairs and lost two of three blog pairs. With three items per register
that is nothing — it is offered only as something a larger experiment could
test, not as a finding.
