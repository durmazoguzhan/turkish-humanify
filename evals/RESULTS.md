# Results

Three-way comparison over the twelve-text corpus: raw model Turkish,
`turkce-humanizer`, and `turkish-humanify`.

**Date.** 2026-08-17
**Comparison target.** `github.com/bushrabeg/turkce-humanizer`, cloned at HEAD.

---

## How the comparison was made fair

Two adjustments were needed, and both are recorded because either one would
have produced a misleading result.

**1. `turkce-humanizer` emits three sections, not a text.** Its designed output
is a detection report, then the repaired text, then notes. Measuring the whole
file scored the report: em dashes 10–20 per file, bold spans up to 59, word
counts double the input. Only the section under "Onarılmış Versiyon" was
extracted for comparison. This is a difference in output contract, not a defect
— but comparing a report against a text measures nothing.

**2. `turkce-humanizer` asks the user to confirm the register before
proceeding.** In a batch run there is no user, so each run was told to make the
choice itself and continue. This removes an interaction step its design
intends; noted so the comparison is not read as covering that part of its
behaviour.

Both skills were run by clean-context subagents given the same English wrapper
instruction and one input file each.

---

## 1. Countable signals

Frequency columns per 100 words. `input` → `th` → `ours` for the signals where
the two skills diverge.

| file | `bold` | `bullets` | `em_dash` | `dir_p` |
|---|---|---|---|---|
| blog-1 | 16 → 16 → **4** | 4 → 4 → 4 | 0 → 0 → 0 | 0.4 → 0.4 → **0.0** |
| blog-2 | 0 → 0 → 0 | 0 → 0 → 0 | 5 → **0** → **0** | 2.3 → 1.1 → **0.9** |
| corporate-1 | 20 → 20 → **7** | 5 → 5 → **3** | 5 → 3 → **0** | 1.1 → 1.6 → **0.0** |
| corporate-2 | 0 → 0 → 0 | 0 → 0 → 0 | 4 → **0** → **0** | 0.0 → 0.0 → 0.0 |
| technical-1 | 1 → 1 → 1 | 0 → 0 → 0 | 0 → 0 → 0 | 3.7 → 1.0 → **0.5** |
| technical-2 | 6 → 6 → **0** | 0 → 0 → 0 | 0 → 0 → 0 | 7.7 → 6.0 → **0.3** |
| academic-2 | 1 → 1 → 1 | 0 → 0 → 0 | 0 → 0 → 0 | 4.5 → 3.4 → 3.9 |
| academic-3 | 1 → 1 → 1 | 0 → 0 → 0 | 0 → 0 → 0 | 3.4 → **0.5** → 3.5 |

**Structural furniture.** `turkce-humanizer` preserves bold and bullets exactly,
by an explicit design rule: *"Madde listeleri liste olarak kalır. Paragrafa
çevirme… Belge iskeletine dokunma."* That is a defensible choice — it protects
document skeletons. But calibration found this furniture to be the clearest
measured difference between machine Turkish and published Turkish, so the
choice costs it the signal that matters most.

**`-DIr` density.** Both reduce it; we reduce it further in technical register
(`technical-2`: 7.7 → 6.0 → 0.3).

**Academic `-DIr` is a deliberate loss for us.** On `academic-3`,
`turkce-humanizer` drops `dir_p` to 0.5 while we hold at 3.5. That is our
register dosage working as designed: `-DIr` is correct in academic Turkish and
stripping it makes the paper read like a blog. We are "worse" on that number on
purpose, and we would make the same choice again.

## 2. Blind three-way ranking

Twelve triples, order randomised per file, labels stripped, key held
separately. One clean-context judge per triple, told only to rank the three by
which reads as written by a Turkish person and to quote the deciding sentences.

| | 1st | 2nd | 3rd | mean rank |
|---|---|---|---|---|
| `turkish-humanify` | 6 | 6 | 0 | **1.50** |
| `turkce-humanizer` | 6 | 3 | 3 | 1.75 |
| raw model output | 0 | 3 | 9 | 2.75 |

**Both skills beat the raw output decisively.** Unaided model Turkish never
took first place and came last nine times out of twelve. Whatever else this
corpus shows, it shows that the problem is real and that intervention helps.

**Between the two skills, the ranking is a tie.** Six firsts each. We never
came last; `turkce-humanizer` came last three times, all in registers where its
structural preservation left the input's furniture intact. A mean-rank gap of
0.25 across twelve items is not a result to claim anything from.

## 3. Fidelity — and why it outranks the ranking

The plan fixed this before any of it ran: a text that reads beautifully and
invents a fact has failed, and failing this check outranks winning the blind
ranking. Each of the twelve inputs was checked against both outputs by a
subagent asked to list every number, name, date, claim or experience assertion
present in the output and absent from the source.

| | files with additions | total additions |
|---|---|---|
| `turkish-humanify` | **0 of 12** | **0** |
| `turkce-humanizer` | 9 of 12 | 23 |

Ours added nothing, anywhere, in any register.

The additions on the other side are not typos. From `blog-1` alone:

> "Aşağıdaki rotayı **biz de yürüdük**" — the source says only "İşte denenmiş… bir plan", impersonally
> "**Bizde kalan**, sabahın köründe vadiye çöken o sessizlik **oldu**" — the source addresses the reader in the future tense: "Geri döndüğünüzde aklınızda kalan… olacak"
> "**Adı katedral, aslı manastır.**" — a fact about Selime that is nowhere in the source
> "**Kışı da yazacaktım**, karlı manzarası gerçekten güzel" — an authorial intention invented outright
> "Zaten kimse bitiremiyor." — a general claim with no source

And on `academic-3`, a distortion rather than an addition: the source says
Deci and Ryan treat motivation as "yalnızca bir nicelik meselesi **değil, aynı
zamanda** bir nitelik meselesi"; the output says they treat it "bir nicelik
meselesi **olarak değil**, bir nitelik meselesi olarak". In an academic text
that is a misstatement of what a cited theory claims.

### The finding this comparison actually produced

**The blind judge ranked `blog-1` first *because of* the fabrications.** Its
cited reasons were "Aşağıdaki rotayı biz de yürüdük" and "Bizde kalan… o
sessizlik oldu" — the two invented experience claims — plus "Adı katedral, aslı
manastır", the invented fact. It called them "yalnızca gerçekten yazan birinin
ekleyeceği yan bilgi ve itiraflar".

It is right that those sentences make the text feel human. That is the point.
The fastest way to make Turkish prose sound like a person wrote it is to have a
person's experiences in it, and the fastest way to get those is to make them
up.

So a blind human-likeness test, run alone, rewards fabrication. Any evaluation
of a humanising tool that stops at "which reads more human" is measuring
something that can be won by lying. This is why the fidelity check was
pre-registered as outranking the ranking, and it is the single most useful
thing this comparison produced.

---

## Verdict

**Against raw model output:** both skills are a clear improvement, ours by a
mean rank of 1.50 against 2.75.

**Against `turkce-humanizer` on reading quality:** a tie. Six firsts each. We
do not claim to beat it here, and the README will not say we do.

**Against `turkce-humanizer` on fidelity:** we do not add anything; it adds 23
claims across 9 of 12 files, including one misstatement of a cited theory. For
repair work — where the input is somebody's text and the claims in it are
theirs — this is the difference that matters.

**Where it is better than us:** it preserves document structure exactly, which
is the right behaviour when the skeleton is load-bearing — a form, a
specification, a template. Our composition layer will rewrite that structure
unless the register says not to. Anyone repairing a document whose shape must
survive should prefer its approach, or run ours in academic register where the
composition layer is off.

**No hard failures on our side.** Forced term translations: 0 across all twelve.
Explanatory em dashes in output: 0. Added claims: 0. No re-run was required.

---

## Round two — the reference-review changes, and why they mostly did not work

After the review in `docs/design/2026-08-17-reference-review.md`, the skill
gained a sprinkling section, a middle-third rule, contrast-point paragraph
breaks, fidelity-safe voice guidance, and self-correction as a device. The six
files this skill lost in round one were re-run and re-judged blind against the
**same** `turkce-humanizer` outputs.

| file | round-one | round-two |
|---|---|---|
| academic-2 | lost | **won** |
| blog-1 | lost | lost |
| blog-2 | lost | lost |
| corporate-1 | lost | lost |
| corporate-2 | lost | lost |
| technical-1 | lost | lost |

**One of six.** The changes did not move reading quality where it was being
lost, and saying otherwise would be dressing up a failed round.

### What did work

`academic-2` flipped, and for the reason the changes predicted. The judge
rejected the competitor's self-correction as fake — *"hiçbir şeyi düzeltmeyen
yapay bir 'kendini toparlama' hamlesi ve bir akademik özette kimsenin
yazmayacağı bir kalıp"* — and rewarded register consistency. That is precisely
the "where it stops" limit written into the self-correction rule and the
academic dosage row. Boundaries on rules do work.

### What did not, and the measured reason

**Self-correction appears zero times in all six of our round-two outputs.**
`turkce-humanizer` uses it in five of six. The judges named it as the deciding
factor three times — *"Ya da değildi, bilmiyorum"*, *"Ya da daha dikkatli
söyleyelim"*, *"Bilmiyoruz."* The device was added to `voices.md` and the skill
did not reach for it once.

Two plausible causes, neither yet tested:

1. **It is filed where it is not seen.** The device lives in `voices.md`, which
   the router reads for choosing a voice, not for generating sentences. It
   probably belongs in `layer-2-sentence.md` as a numbered device with its own
   worked pairs.
2. **The same round made the skill more conservative.** Section 15 tells it to
   delete devices that are not working; the check step adds a delete-test. Both
   are correct, and together they may suppress adding anything at all. A rule
   that says "remove what does not earn its place" and a rule that says "reach
   for this device" pull against each other, and the first one is louder
   because it is a check.

### A third cause, and it is my error

The quality bar added in the same round asks: *"Would a Turkish editor publish
this without touching it?"*

The judges reward the opposite. Their praise across both rounds is for text
that sounds **unedited**: *"gerçek bir esnaf ağzına daha yakın"*, *"kendi
kendine konuşma tonu"*, *"bir insanın klavyeden döktüğü cümleler"*. Their
criticism of our output is *"cilalanmış"*, *"editoryal"*, *"fazla düzgün"*,
*"ütülü"*. An editor-safe text is a tidy text, and tidy is the register they
penalise.

So the bar as written pulls toward the failure mode it was meant to prevent. It
needs replacing with something closer to "would a Turkish reader believe nobody
edited this", and that change is **not made here** — it would be another
untested edit in a round that has just shown untested edits do not reliably
help.

### What this round is worth

Not much for the skill, and a good deal for the record. It establishes that
`blog-1` in particular cannot be won honestly: the judge cited the same three
fabricated sentences — *"Adı katedral, aslı manastır"*, *"Kışı da yazacaktım"*,
*"Turu neden ilk güne değil de ikinci güne koyduk?"* — for the third time
across three independent judgments. On that file the competitor's entire
advantage is invention, and matching it means matching the invention.

## Round three — twenty-one files, and the first result that is not noise

The corpus was expanded from twelve baselines to twenty-one (three more blog,
two technical, two corporate, two academic; blog is now six of twenty-one
because that is where the comparison was being lost). Self-correction was moved
from `voices.md` into `layer-2-sentence.md` as numbered section 15, with worked
pairs and a fidelity-safe form. All 21 files were then run through both skills
and judged blind, order randomised per file, key held separately.

### The tally

| | ours | competitor |
|---|---|---|
| **all 21 files** | **15** | 6 |

Under a fair coin, the probability of 15 or more out of 21 in one direction is
**0.039**. This is the first round in this project that clears conventional
significance rather than landing in noise.

By register:

| register | ours | competitor |
|---|---|---|
| academic | **5** | 0 |
| technical | **4** | 1 |
| blog | **4** | 2 |
| corporate | 2 | **3** |

### The confound, stated before the conclusion

Two variables changed in the same round: the corpus grew and the skill changed.
Splitting the files separates them, and the split is uncomfortable.

| subset | ours–competitor | p |
|---|---|---|
| the original 12 (where v5 scored 6–6) | **7–5** | 0.387 — noise |
| the 9 new files | **8–1** | 0.020 |

**On the same twelve files, the skill changes moved the score by one.** The
overall signal comes almost entirely from the nine new files. So the honest
reading is not "the skill improved and here is the proof" — it is "the skill
improved by an amount this corpus cannot resolve, and a larger sample favours
us."

Two explanations, and both are probably partly true:

1. **The old twelve have a built-in ceiling.** They contain the four files this
   skill has never won: `blog-1`, `blog-2`, `corporate-1`, `corporate-2`. On
   `blog-1` the competitor's advantage is fabrication, confirmed by four
   independent judgments now citing the same invented sentences. That file
   cannot be won honestly, so the old subset caps below 12–0 by construction.
2. **I chose the new topics.** Not cherry-picked — same generation method, clean
   context, ordinary prompts — but the selection was mine, including the
   deliberate choice to make `blog-6` a narrative. That is a degree of freedom,
   and it should be discounted accordingly.

### Two further discounts

**`blog-6` was aided by a competitor defect.** The competitor wrote a meta-line
inside its own repaired-text section — *"Faz 1'de çıkarılacak sinyal, Faz 2'de
yerleştirilecek boşluk bulunmadığı için metin değişmeden kalır."* — and the
judge called it disqualifying on its own. This is not an artifact of our
extraction: the line sits below the "Onarılmış Versiyon" heading in the
competitor's file, so a user copying that section would get it. It is a real
defect, and it is also not a fact about Turkish prose. Excluding `blog-6`:
**14–6 of 20, p = 0.058** — just outside conventional significance.

The same leak appears in `blog-5`, where **we lost anyway**. Two of 21
competitor outputs leak; it is not systematic.

**Corporate is our only losing register, 2–3.** The judges' reasons are
consistent: our composition layer converts marketing bullet lists into prose,
and on a landing page or a campaign announcement they read that as
*"düzleştirilmiş"* rather than as human. This is the register dosage being
wrong, not the layer being wrong — corporate is currently set to "medium"
structure, and the evidence says the list-to-prose conversion should be off or
much weaker there. **Not changed in this round**, because changing it and
re-measuring in the same pass is the mistake that made round two
uninterpretable.

### Fidelity on the nine new files

The pre-registered invariant: a text that reads beautifully and invents a fact
has failed, and that outranks the blind ranking. Each new input was checked
against both outputs by a subagent asked to list every number, name, date,
claim or experience assertion present in the output and absent from the source.

| | files with additions |
|---|---|
| ours | **0 of 9** |
| competitor | 4 of 9 |

Ours added nothing again — nine for nine, twenty-one for twenty-one across the
whole project. On `blog-6`, a family story where invention would be easiest and
would read best, the check found the body *word for word identical* to the
source.

The competitor's additions on the new files are milder than on `blog-1` — mostly
restatements rather than invented facts — with two that assert more than the
source does:

> `blog-4`: "Kitap okumak insana bilgi de kazandırır, tamam." — the source says the opposite: *"Kitap okumanın gerçek getirisi bilgi değil, dikkatin geri kazanılmasıdır."*
> `technical-4`: "Yani sorun index'te değil, tahminde." — the source says the gap *"istatistik sorununa işaret eder"*, which is weaker than asserting the index is fine.

One asymmetry worth naming, because it cuts against a rule of ours. Both skills
occasionally **weaken** a source claim rather than adding to it — ours wrote
*"Her sabah demeyeyim, çoğu sabah."* where the source said *"her sabah"*, and
*"Alıştı da denmez belki"* where the source said *"bacaklar alıştı"*. Those are
hedges, not fabrications, and the direction is retraction rather than invention.
But `voices.md` permits hedging only *"where the source's own claim is genuinely
uncertain"*, and "her sabah" was not uncertain. This is a small, real violation
of our own rule, found by the fidelity check rather than by reading, and it is
recorded rather than fixed for the same reason as the corporate dosage.

### A fidelity failure the rules do not cover: de-hedging

The academic checks surfaced something neither skill's rules address, and ours
commits it too.

Academic Turkish hedges its claims — *"bulgular bulunurken"*, *"görülmektedir"*,
*"olduğu düşünülmektedir"*. Those forms mark a claim as reported by the
literature rather than asserted by the author. Both skills strip them, and
stripping a hedge **promotes** a claim without adding a word:

> Source: "sınırlı bir verim artışı sağlayabileceği yönünde **bulgular bulunurken**"
> Competitor: "sınırlı bir verim artışı **sağlayabilir.**"
> — what the literature reports becomes what this paper asserts.

> Source: "çalışmaların görece sınırlı kaldığı **görülmektedir**"
> Ours: "çalışmalar görece sınırlı **kalmaktadır**"
> — an observation becomes a statement of fact.

Both academic files show it, which makes it a pattern rather than an incident:

| file | ours | competitor |
|---|---|---|
| `academic-4` | 1 (drops *"başlıca"*, turning an open list of main causes into an exhaustive one) | 4, including a causal link the source does not make |
| `academic-5` | 1 | 3 |

Both are wrong, and ours is not excused by being rarer. The competitor's worst
instance is the reverse of de-hedging — *adding* a connection: the source lists
two facts with *"ve"*, the output joins them with *"seyrettiğinden"* and asserts
that one causes the other.

**Why the rules missed it.** `voices.md` regulates *adding* hedges — permitted
"where the source's own claim is genuinely uncertain". It says nothing about
*removing* the source's hedges, and the sentence layer actively pushes that way:
`-mektedir` cleanup and passive-to-active conversion both tend to delete exactly
the constructions that carry epistemic distance in Turkish academic prose.

So two rules of ours, each defensible alone, combine into a fidelity failure the
fidelity check was not looking for. It found it anyway, which is the argument for
running the check on every register rather than only where fabrication seems
likely.

**Not fixed in this round.** The fix is a rule stating that a source's epistemic
markers are part of its claims and survive rewriting — which belongs in the
invariants, not in a layer. Writing it and re-measuring in the same pass is the
error that made round two uninterpretable.

### What the academic sweep shows

5–0, and it is the clearest positive result in the project. The judges rejected
the competitor's output for exactly the reason the register dosage predicts:
it applies conversational moves where the genre forbids them.

> "'Ya da şöyle demek daha doğru olur.' … bir akademik özette kimsenin
> yazmayacağı bir kalıp"
> "'Kaybolduğunu değil, soğrulduğunu söylüyoruz.' … bir özette yeri olmayan,
> sonradan eklenmiş retorik bir vurgu"
> "aynı paragrafta kip değiştirip kendini ele veriyor"

Register-aware dosage — running less of the skill where less is correct — is
the part of this design that measurably works.

### Self-correction: added, and barely used

The hypothesis from round two was that the device sat in the wrong file. It was
moved to the sentence layer. Result: **1 use across 12 outputs**, against 0
across 6 before. It fires now, and almost never.

A correction to an earlier claim in this document: the competitor was reported
as using the device in "five of six" files. That measurement was on a different
file subset. On the six files measured after the move, the competitor uses it in
one of five. The device is far less of a differentiator than the round-two
write-up implied, and the hypothesis built on it was weaker than stated.

## Round four — the two fixes, and what measuring them showed

Two changes, in different registers so they do not interfere:

**1. Corporate: list-to-prose conversion off.** The repository owner called
melting list items into prose absurd, and the measurements agreed — both
corporate losses cited it, in the judges' own words: *"maddeleri paragrafa
eritmesi … düzleştirilmiş gibi okunuyor"*, *"tüm katalogu tek cümleye noktalı
virgüllerle sıkıştırıyor … bu Türkçede kimsenin kurmadığı bir cümle"*.
`registers.md` now turns the rule off for this register, and
`layer-1-structure.md` §5 adds a specific prohibition on chaining a list into
one semicolon sentence, which is worse than either the list or clean prose.

**2. Academic: `-mektedir` stays — a contradiction, not a missing rule.**

The de-hedging finding was first diagnosed here as a gap in the invariants. That
diagnosis was wrong, and reading the files instead of reasoning from the symptom
found the real cause: **the skill contradicted itself.**

> `registers.md`, academic row: "branching, converbs, focus and `-mektedir` cleanup only"
> `layer-2-sentence.md` §7: "Keep it in academic register; remove it everywhere else."

The dosage table ordered the opposite of the rule it named. And `-mektedir` is
precisely the form carrying evidential distance in Turkish academic prose, so the
skill was stripping hedges **because it had been told to**.

The fix is one line removing the contradiction, not a new rule layered on top of
a rule that already disagreed with itself. Worth stating because the first
instinct — add an invariant — would have left the contradiction in place and
built on it.

### Measured effect

Evidential-distance forms (`görülmektedir`, `bulunmaktadır`, `ilerlemektedir`, …):

| file | source | before fix | after fix |
|---|---|---|---|
| `academic-3` | 3 | 2 | **3** |
| `academic-5` | 4 | 2 | **4** |

Fully restored, both files. A one-line contradiction was doing all of the
damage.

Corporate structure:

| file | bullets: source → before → after | bold: source → before → after |
|---|---|---|
| `corporate-1` | 5 → 3 → **8** | 20 → 3 → 3 |
| `corporate-4` | 5 → 0 → **5** | 4 → 0 → 0 |
| `corporate-5` | 5 → 0 → **5** | 11 → 1 → 2 |

`corporate-4` and `corporate-5` now preserve their lists exactly, where before
the skill destroyed all five.

**`corporate-1` going from 5 to 8 looked like an overcorrection and is not.** The
three extra bullets are the pricing tiers, which the source marked with bold and
an em dash instead of a list marker:

> Kaynak: `**Başlangıç** — [X] TL/ay · Tek kullanıcı, aylık [X] fatura`
> Çıktı: `- Başlangıç: [X] TL/ay · Tek kullanıcı, aylık [X] fatura`

Three parallel price tiers are a list. Marking them with bold instead is the
bold-inflation tell, and converting them to a real list removed three em dashes
in the same move. The first reading of that number was mine and it was wrong: I
counted bullets without checking what had become one.

### The residual, and where it went

Hedging is also carried by words, not only suffixes — dropping *"başlıca"* from
"başlıca nedenleri şunlardır" turns an open list of main causes into an
exhaustive one, and no dosage row covers that. One sentence was added to
invariant 2 in `SKILL.md`: a source's certainty is part of its claim, deleting a
hedge promotes the claim, adding one where the source was certain retracts it,
and both directions are failures.

### Not yet done

The blind reading comparison has **not** been re-run after these fixes. The
countable signals show the mechanisms behaving as intended; whether that moves
the corporate register's 2–3 record is untested, and claiming it would be exactly
the error this document has already recorded twice.

## What this does not establish

Twelve texts, one model, one afternoon, and judges that are themselves language
models. The fidelity check is objective and the numbers behind it are solid.
The ranking is softer: it says two skills are indistinguishable on a measure
that, as shown above, can be won by cheating. Read it accordingly.
