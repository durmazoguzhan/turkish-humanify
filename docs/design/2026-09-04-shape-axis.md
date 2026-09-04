# Register is not the only axis: document shape is the other one

**Status:** accepted for layer 1; the rest is recorded, not built.
**Driven by:** [#9 Devriklik, Akıcılık](https://github.com/durmazoguzhan/turkish-humanify/issues/9)
and [#8 microcopy](https://github.com/durmazoguzhan/turkish-humanify/issues/8).

## The two reports say the same thing from opposite ends

**#9.** A technical evidence section — a heading, a lead-in label, two bullets,
one per endpoint — came back as a single running paragraph. The reporter names
the symptom as too much `devrik cümle` and lost fluency.

**#8.** A round of UI microcopy: chip labels, a button, a placeholder, one
inline warning. The verdict on layer 1 was *"tamamen ölü"* — every rule in it
(opening move, paragraph rhythm, closing, bold inflation, bullet dependence,
title templates) has no referent in a three-word chip.

One says layer 1 is inert. The other says layer 1 is harmful. Both are the same
observation: **layer 1 is not a register-dependent layer, it is a
shape-dependent one, and the skill has no shape axis to hang it on.**

## Why the four registers cannot absorb this

The registers answer *who is speaking and how much of the writer is audible*.
That is a real axis and `registers.md` calibrates it well — the `-mAktAdIr` band,
the semicolon dose, the inversion permission all vary along it, correctly.

What they do not answer is *what kind of object this is*. A runbook and a
tutorial are both technical register and the same voice; one is scanned and
returned to, the other is read once from the top. An API reference and an
engineering blog post are both written for someone who will act on the text. The
dose table says "structure: medium" for all four of those, and "medium" is the
wrong answer to a question nobody asked.

The evidence that this is not a hair-split:

- **Corporate already forced the split, and nobody noticed it was a split.**
  `registers.md` turns the list-to-prose conversion **off** in corporate on
  measured grounds — 2–3 with it on, 4–1 with it off, held at 4–1. But corporate
  is not a tone in which lists matter more; a landing page is a *scanned object*.
  The fix was made on the shape and filed under the register, and it therefore
  did not generalise to the runbook one register over.
- **The corpus had no shape variety at all.** Twenty-one baselines: zero tables,
  one technical file with a real bullet list. Every input was prose. That is not
  an accident of sampling — it is what the twelve original prompts asked for, and
  it is why a whole class of failure had no test.
- **#8's blind spot is a shape problem too.** Subject clarity across three
  adjacent chips is not a Turkish-architecture question and no register dose
  reaches it. It is a property of atomic strings read side by side.

## The axis

| shape | what it is | what layer 1 may do |
|---|---|---|
| **prose** | read once, top to bottom | everything: opening, rhythm, closing, titles, list-to-prose |
| **structured** | scanned, returned to, looked up | work inside the units; the skeleton is not yours |
| **atomic** | a string read beside its neighbours, not in a flow | nothing; layer 1 has no referent |

Layer 2 and layer 3 stay register-indexed. Nothing about branching direction,
converbs, `-DIr` or vowel harmony varies by whether a document is a table or a
paragraph.

## What is being built now, and what is not

**Built (round nine).** The prose/structured distinction, in layer 1 only, tested
on a countable target. The rule is that a structured source keeps its skeleton
and §5 and §6 work inside it. `registers.md`'s corporate row becomes an instance
of the general rule rather than an exception to a rule that had it backwards.

**Recorded, not built.** The `atomic` column is #8's, and it needs #8's own
evidence — a microcopy corpus this repository does not have, and two checks
(subject presence, subject consistency across neighbours) that no existing layer
covers. Writing it now on the strength of one report would be the thing
`CONTRIBUTING.md` exists to prevent.

### Issue #8 read sceptically, because of what it is

#8 is a pasted transcript of the tool assessing its own usefulness on a round of
UI strings. That provenance matters: it is not a reader reporting bad Turkish, it
is the model reporting on itself, and most of what it asserts is about a private
repository nobody here can check. Two of its claims are checkable in this one,
and both hold.

**"Layer 1 tamamen ölü" is very nearly literally true.** The layer has eight
sections and seven of them name a unit a three-word chip label does not have:
the opening move, the paragraph skeleton, the closing, the title, the bullet
list, the subheading, and "the writer must be present in the middle". Only §6,
bold and emoji, has any referent at all. This is checkable by reading the file
rather than by trusting the report.

**The reading cost is real and it is not specific to microcopy.** The repair path
is `SKILL.md` plus `rewrite-mode.md`, `registers.md`, `voices.md` and the three
layers — **1,876 lines**, and `SKILL.md` asks for the layer files to be read at
the moment each layer runs rather than from memory. That is the same 1,876 lines
whether the input is a journal article or fifteen button labels. The skill has no
cheap path, and nothing about that observation depends on believing #8.

**Its own best observation contradicts its recommendation.** #8 proposes adding a
microcopy register, and then says the round's most valuable fix was subject
clarity across three adjacent chips — *"özne netliği Türkçe-mimarisi problemi
değil, UX-copy problemi"*. If the defect is not a Turkish-architecture problem,
a Turkish-architecture skill acquiring a register for it does not address it; it
just gives the skill a place to hold a rule it has no standing to write.
`SKILL.md` already ends by saying what this skill is not.

So the atomic row stays recorded and unbuilt, and the specific proposal in #8 is
**declined on the strength of #8's own evidence** rather than deferred for want
of a corpus.

**One thing did land in that column, and it arrived from somewhere else.** A
reader noticed that YouTube renders *Watch later* as `Daha sonra izle` and not
`Sonra izle`, which turned out to be measurable: given the English string two
generations produced the bare form, and given the same task described in Turkish
the same model produced the full one. The rule that came out of it is in
`layer-3-surface.md` §8 and it is not about that phrase. It is that **a word
which borrows its meaning from a neighbour breaks when it is given no
neighbour** — `sonra`, `önce`, `orada`, `bunu`, `tekrar`. Prose supplies the
antecedent for free and hides the entire problem; a chip, a tooltip, a column
heading and a push notification supply nothing.

That is an `atomic`-column rule reached without an `atomic` register, which is
the case for the axis rather than against it: the failure is a property of the
object being read alone, it is invariant across every register, and it needed no
new tone bucket to be written down. It is also #8's own blind spot arriving from
the other side — subject clarity across three adjacent chips is the same problem
with a different anaphor.

**Deliberately not built: a fifth register.** "Reference" and "microcopy" both
read like registers and are not. Adding them would give every future rule two
plausible homes and would put the tone axis and the shape axis in the same
column, which is the confusion that produced both issues.

## The rejected alternative, and why it is worth naming

The competing skill solved this in v3.0–v3.2 with a
register-independent pre-pass called **Yapı Koruma**: lists stay lists, headings,
tables, blockquotes and code blocks are untouched, and the document skeleton is
off limits unless the user explicitly asks for it to change. It sidesteps the
axis question by making structure preservation unconditional.

That is the smaller change and it is very nearly what round nine implements. It
is not adopted wholesale for one reason: it also forbids the conversion in
prose-shaped documents, where §5's worked example is genuinely right — a list of
three coffee tips that reads as an outline nobody wrote up. This repository
cannot currently *measure* that case, which is recorded honestly in
`baseline-prompts.md` rather than resolved by copying someone else's rule. An
unmeasured rule kept is a smaller error than an unmeasured rule deleted.

**Two things from the same source are not adopted at all**, and the reason is
that this repository has data and they do not: their absolute ban on the
semicolon contradicts the 0.2–2.4 per 100 words measured across five Turkish
journal articles and TDK's own listing, and their absolute ban on fragment
sentences would delete the *Olmadı.* that `layer-2-sentence.md` §13 asks for.

## What issue #9 still leaves open

The layer-2 half. Post-verbal trailing material — predicate mid-sentence, then a
colon, an apposition and a verbless `-mAk için` tail — is what readers of the #9
output describe as `devrik`, and §8 does not cover it because nothing is fronted.
It is not being written this round because `count.sh` cannot measure inversion
and says so in its own header, which makes the rule unfalsifiable under this
project's one contribution rule.

`evals/fixtures/devrik.md` exists so that whoever builds the counter has labels
to validate against, separated into the three classes that a single blended rate
would merge. That is the whole of the preparatory work; the rule waits for the
instrument.
