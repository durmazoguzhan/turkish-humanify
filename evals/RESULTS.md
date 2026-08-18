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

> **Correction, added after round five.** The 0.039 is right and is correctly
> described as one-directional, but the sentence after it is not. The
> conventional test here is two-sided, and two-sided this is **p = 0.078** — it
> does not clear 0.05. Round three was the first round to point clearly in one
> direction; it was not the first to clear significance. `repair-protocol.md`
> now fixes the two-sided sign test as the reported statistic so this cannot
> drift again.

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

## Round five — pre-registered before running it

Two things are outstanding here and they turn out to be one thing. The repair
record (15–6) was measured before `references/rewrite-mode.md` became its own
file, so it describes the skill one revision back. And the corporate register's
2–3 predates the list-to-prose fix in the round above, so the only register this
skill loses has an untested record. Neither can be settled by reading; both are
settled by the same run.

### Design, fixed before generating anything

- The same twenty-one inputs in `evals/input/`.
- Our arm regenerated with the current post-split skill into `evals/output/v9/`.
- **The competitor arm is held byte-identical** — `turkce-humanizer-text/` is
  already on disk and is not regenerated. One variable moves: our skill.
- Twenty-one blind pairwise judgments, labels stripped, order re-randomised,
  judges given no knowledge that a skill is involved.
- Fidelity checked on all twenty-one of ours, same procedure as round three.
- Fidelity outranks the ranking, as pre-registered from the start.

### The corporate question, stated now so the round tests it

Corporate is the one register lost in both modes. In write mode it recovered
from 1–2 to 2–1 after the split, leaving one loss: `w-corp-1`, a bakery post.
Reading that pair side by side suggests a mechanism, and it is written down here
**before** the round rather than found in its results.

The unaided text that won states its limits **as things tried and decided**, not
as facts about the present:

> "Ekşi mayalı somunumuz on iki saat bekliyor; bunu kısaltmanın bir yolunu bulamadık, denedik de olmadı."
> "Bazı müşterilerimiz 'biraz fazla koyu olmuş' diyor, biz öyle seviyoruz, o yüzden değiştirmiyoruz."
> "her şey her gün olmuyor, olsun diye de zorlamıyoruz"
> "Bunları öve öve anlatmak istemiyoruz aslında, normal olması gereken şeyler. Ama artık normal olmadığı için söylüyoruz."

Ours states limits too — *"her şey her zaman elimizde olmuyor"*, *"Cumartesi
öğleden sonra tezgahın yarısı boş kalıyor"*, *"Oturacak yer sayılı"* — four of
them, so the difference is not that we omit them. The difference is that ours
are current-state facts and theirs carry a history and a refusal behind them.
The last quote goes further: the writer steps outside the marketing frame to
comment on it.

**This is one file and one judge, which is not enough for a rule**, and the
`voices.md` self-correction section already records what happens when a device
that reads as human is applied without something real behind it: judges penalise
it exactly as often as they reward it. So it is registered as a question, with
the answer conditions fixed in advance:

| outcome | reading |
|---|---|
| corporate ≥ 3–2 for us | the list-to-prose fix worked; the register is no longer a systematic loss |
| the mechanism above appears in ≥ 2 corporate judgments | promote to a candidate rule in `registers.md` and test it in a later round |
| it appears in ≤ 1 | it stays an observation about one bakery, and is not written into the skill |

The failure mode being guarded against is the obvious one: finding the mechanism
in the results because it was the thing being looked for.

---

## Round five — the result

Run as registered above. Twenty-one inputs, our arm regenerated into
`evals/output/v9/`, the competitor arm untouched, order re-randomised by
`evals/pair.sh`, twenty-one clean-context judges.

### Fidelity first, because it outranks the ranking

| | files with additions | total additions |
|---|---|---|
| `turkish-humanify` v9 | **0 of 21** | **0** |

Twenty-one independent checks, each asked to list every number, name, date,
place, causal claim and experience assertion present in the output and absent
from the source. Nothing, anywhere, in any register. Several checkers flagged
borderline items on their own initiative and then ruled them out — a title
lifted verbatim from the body, a hedge made explicit, an agentless passive given
the first person the surrounding narration already established. The one case
worth naming is `blog-6`, where the rewrite inserts *"Daha doğrusu verirdi de,
yazılacak gibi değildi"*: a self-correction, and the checker's judgement was that
it restates the two sentences immediately after it rather than adding to them.
That is the `voices.md` device operating inside its stated limit.

### The tally

| | ours | competitor |
|---|---|---|
| **all 21 files** | **16** | 5 |

Two-sided sign test: **p = 0.027**.

| register | round three | **round five** |
|---|---|---|
| blog | 4–2 | **5–1** |
| technical | 4–1 | **4–1** |
| corporate | 2–3 | **4–1** |
| academic | 5–0 | **3–2** |

### The pre-registered corporate question, answered

**The threshold was met.** Corporate was registered as passing at ≥ 3–2; it came
in at **4–1**, from 2–3. The list-to-prose fix is the only change between those
two rounds that targets this register, and corporate is no longer the register
this skill loses.

**The mechanism was rejected, and that is the more useful half.** The candidate
— limits stated as things tried and decided rather than as present facts —
needed to appear in at least two corporate judgments to be promoted. It appeared
in **none of the five**. Where we won, the judges named entirely different
things: the calque *"aynı sayfada olun"*, `-DIr` stacking, participle pile-ups
before the head noun, Title Case headings. So it stays an observation about one
bakery and is not written into the skill.

This is what the pre-registration was for. Without it, five corporate judgments
would have been read looking for a mechanism, and something in them would have
been made to fit.

### Academic went the other way, 5–0 to 3–2

The clearest regression in the round, and the two judges who ruled against us
gave overlapping reasons: our semicolon density, and prose they called *"fazla
parlatılmış"* and *"düzenlenmiş metin izi"*.

The semicolon half of that is checkable now, because the corpus finally contains
published Turkish academic prose. Semicolons per 100 words:

| | range |
|---|---|
| published Turkish journal articles, 2015–2019 | 0.34 – 2.42 |
| **ours, v9 academic** | **0.79 – 1.97** |
| competitor, academic | 0.00 – 0.54 |

Every one of our five files sits inside the published band. Both files we lost
(1.12 and 1.14) sit near its middle. The competitor's texts, praised for not
having the habit, sit at or below the floor in four of five — including three
files with **no semicolon at all**, which no article in the reference set
matches.

**So on this specific point the judges are wrong about Turkish**, and the
reference corpus is what makes it possible to say so rather than either accepting
the criticism or waving it away. What remains unchecked is the rest of their
objection — nominalisation, paragraph length, the repetition of *"tam da"* — and
those may well be right. A judge can reach a correct verdict through a wrong
reason.

`-mAktAdIr` and `-DIr` in the same five files, against the band from
`human-reference/`:

| file | `mektedir_p` | `dir_p` |
|---|---|---|
| `academic-1` | 0.0 | 0.0 |
| `academic-2` | 1.7 | 4.8 |
| `academic-3` | 1.9 | 3.2 |
| `academic-4` | 2.3 | 3.1 |
| `academic-5` | 1.7 | 3.3 |
| *published Turkish* | *0.4 – 2.3* | *2.3 – 4.0* |

Four of five inside the band on both. `academic-1` reads 0.0/0.0 because its
**source** reads 0.0/0.0 — it is the one baseline written as an essay rather than
an article, and preserving that is the register layer working, not failing.
`academic-2` sits above the `-DIr` ceiling at 4.8.

### Countable signals

| | `em_dash` | `bold` | `bullets` | `dir_p` |
|---|---|---|---|---|
| input | 22 | 75 | 22 | 2.2 |
| **ours** | **0** | **35** | 22 | **0.9** |
| competitor | 3 | 75 | 22 | 1.3 |

The explanatory dash is gone from all twenty-one files. Bold is halved; the
competitor preserves it exactly, which is its stated design. Bullets are
identical across all three arms, which is the corporate fix holding — lists are
no longer being dissolved.

### An instrument bug found inside the round

`em_dash` first read 1, in `corporate-5`, which would have been a hard-rule
violation. It was **"15 Aralık – 2 Ocak"** — a date range, correct Turkish. The
range exclusion added in the first calibration only skipped dashes preceded by a
digit, so a range whose left side ends in a word slipped through. Fixed to
require a non-digit on both sides.

Seventh counting bug, and the same shape as the previous six: an exclusion
written to cover the examples that had been looked at.

### Discounts

- **The wrapper was reconstructed, not recovered.** Rounds one through four
  never committed the generation instruction, so round five's is written from
  their prose description. Comparing 16–5 against round three's 15–6 therefore
  carries a caveat that the comparison against the fixed competitor arm does
  not. `repair-protocol.md` ends that problem going forward.
- **The generation was run twice.** The `-mAktAdIr` notation change landed while
  the first run was in flight. It altered no rule, but it moved a second variable
  inside a round, so those outputs were discarded and all twenty-one regenerated
  against the frozen skill. The committed v9 is the second run.
- **Twenty-one files, model judges.** Same limit as every round here.
- **`blog-1` lost to fabrication for the fifth time.** The judge chose the
  competitor and quoted *"Aşağıdaki rotayı biz de yürüdük"* and *"Bizde kalan,
  sabahın köründe vadiye çöken o sessizlik oldu"* — neither sentence is in the
  source. Five independent judgments have now named the same invented lines. The
  file remains unwinnable without lying, and the fidelity result above is the
  reason we do not.

---

## Round six — the rest of the academic objection, tested

Round five left two of the judges' three academic complaints unchecked. Both are
now checked, and the reference corpus settles them differently.

### Nominalisation: not a defect

Verbal nouns carrying a further suffix (`-mA` + possessive/case, `-mAK` + case)
plus `-lIk` abstract nouns, per 100 words:

| | range |
|---|---|
| published Turkish journal articles, 2015–2019 | 4.64 – 8.55 |
| **ours, v9 academic** | **4.50 – 8.52** |
| competitor, academic | 2.96 – 7.00 |

We sit inside the published band; the competitor sits below its floor in three
of five files. The two files we lost measure 7.00 and 8.52, against a published
ceiling of 8.55. So this objection goes the same way the semicolon one did: the
judges named a feature that published Turkish academic prose has.

The measure is a floor, not a census — it cannot see `-Iş` nominals or
noun-noun compounding, so the real rate is higher than these numbers in every
column equally.

### Paragraph length: a real defect, in exactly one file

This one is confirmed, and it is ours.

| file | source | ours | competitor |
|---|---|---|---|
| `academic-1` | 71 w/para, 5 paragraphs | **51 w, 7 paragraphs** | 60 w |
| `academic-2` | 51 | 50 | 44 |
| `academic-3` | 63 | 63 | 53 |
| `academic-4` | 46 | 46 | 48 |
| `academic-5` | 72 | 72 | 70 |

Four of five are returned untouched, which is the register working. `academic-1`
is not: the skill split two paragraphs in a register whose dosage sets the
structure layer to **off**, and the judge named that specific thing while
choosing the other text — *"B aynı içeriği sekiz kısa bloğa bölmüş … İngilizce
web yazısı formatına benziyor"*.

**The rule's own limit did not mention the register.** `layer-1-structure.md` §2
tells you to break a paragraph where the text turns, and its "where it stops"
named only procedural writing. The dosage table said off; the rule did not say
so where the rule is read. Fixed by naming academic in §2.

A caution about the earlier attempt at this measurement: paragraph length across
the *full* article bodies reads 14, 49, 54, 106 and 274 words, which looks like
a finding and is not one — those numbers are an artefact of the reflow scripts
used to extract the PDFs, which produced different paragraph granularity per
file. Only the hand-checked excerpts are usable here. Same lesson as the `len_sd`
episode: a number computed through a pipeline you built is a number about the
pipeline until you check it.

### Pre-registered, before running anything

The fix touches one register and, on this corpus, can only move one file.

| outcome | reading |
|---|---|
| academic ≥ 4–1 and `academic-1` flips | the dosage violation was the cause on that file |
| academic stays 3–2 | the paragraph split was not why `academic-1` lost, and the remaining cause is unidentified |
| academic worse than 3–2 | the fix broke a file it should not have touched; revert |

**This is weak evidence by construction and is recorded as such**: one file can
change, so the round can confirm a mechanism but cannot establish a size. The
value is the check that the other four are not disturbed.

---

## `blog-1` — we were looking in the wrong place

`blog-1` has lost five rounds and the explanation on file was fabrication: the
competitor invents *"Aşağıdaki rotayı biz de yürüdük"* and two more sentences,
judges reward them, and the file is therefore unwinnable honestly. That is true
and it is not the whole account. Re-reading the judgement for what else it said
turns up two defects that are ours, and neither needs a lie to fix.

### The `ama` tic

| | sentence-final `ama` |
|---|---|
| source | **0** |
| competitor | **0** |
| ours | 4 (judge's count), 2 by strict end-of-sentence match |

Every one was introduced by us. `layer-2-sentence.md` §16 is about exactly this
failure and did not name the device; it does now.

### The en dash, which was a wrong rule rather than a slip

| | en dashes |
|---|---|
| the nine published Turkish texts in `human-reference/` | **3** (against 70 plain-hyphen ranges) |
| competitor output, 21 files | **0** — it normalises every one |
| our input corpus | 7 |
| **our output, 21 files** | **9** |

We do not merely preserve the source's en dashes, we add two. The judge named
it: *"Türkçe yazan biri bunları normalde düz tire ile yazar; bu, çeviri/dizgi
kokusu veren bir detay"*, contrasting our `04.30–05.00` with the competitor's
`04.30-05.00`.

The cause is that `layer-3-surface.md` said range dashes were **correct** and to
leave them alone. TDK says otherwise: it lists `kısa çizgi` and `uzun çizgi`,
gives ranges to the short hyphen (`1914-1918`, `Ankara-İstanbul`), and does not
recognise an en dash at all.

**And the instrument was built around the wrong rule.** When `em_dash` was fixed
in the first calibration, range dashes were excluded from it — because the rule
said they were fine. So the counter was configured to look away from precisely
the thing the rule had wrong, which is why six rounds passed without noticing. A
blind judge found it instead. New signal: `endash`, raw count, any occurrence is
an error.

### What this changes about the fabrication story

Nothing, and that is the point worth keeping. The three invented sentences are
still invented and we still do not write them. What changes is the claim that
they were the *only* reason we lost this file — that claim was never tested, it
was inferred from the loudest part of one judgement, and two of the judge's
other reasons turn out to be measurable defects on our side.

Whether fixing them flips the file is unknown and probably not; the fabricated
sentences are strong. The reason to fix them anyway is that both are wrong in
every file, not just this one.

**Answered in rounds six and seven: it does not flip.** Both defects went to zero
in `v10` and stayed there in `v11`, and `blog-1` lost both rounds. Examined a
third time in round seven, the judge's remaining twelve objections did not
survive counting, and the competitor's text was found to carry five additions
rather than three. "Probably not" was right, and the fixes were still worth
making for the reason given.

---

## Round six — the result

Run as pre-registered. Same twenty-one inputs, our arm regenerated into
`evals/output/v10/` against the frozen skill, competitor arm byte-identical,
order re-randomised, twenty-one clean-context judges.

### The mechanisms, checked before the judging

| | input | v9 | **v10** |
|---|---|---|---|
| en dashes, 21 files | 7 | 9 | **0** |
| sentence-final `ama` | 0 | 2 | **0** |
| `academic-1` paragraphs | 5 | 7 | **5** |

All three did exactly what they were meant to, and the other four academic files
came back with their paragraph counts untouched.

### The tally

**16–5**, two-sided sign test p = 0.027 — the same total as round five, and a
different distribution.

| register | round five | round six |
|---|---|---|
| academic | 3–2 | **5–0** |
| corporate | 4–1 | 4–1 |
| blog | 5–1 | **4–2** |
| technical | 4–1 | **3–2** |

### The pre-registered academic question

**Confirmed.** The threshold was academic ≥ 4–1 with `academic-1` flipping. It
came in at **5–0**, and `academic-1` flipped. `academic-2` flipped as well,
which the pre-registration did not predict and which is therefore the weaker
half of the result.

The judge that had chosen against us on `academic-1` for splitting paragraphs
now chose us, and named the register discipline: *"A baştan sona bu türün
Türkçedeki yerleşik kaydında duruyor"*.

### Two files went the other way, and the first explanation was wrong

`blog-3` and `technical-5` moved from wins to losses. My first hypothesis was
that naming the `ama` tic had made the skill timid with conversational devices.

**The data refuted it.** Discourse-particle density across blog and technical
went *up*, not down:

| | `part_p`, blog + technical |
|---|---|
| v9 | 0.73 |
| **v10** | **0.89** |
| competitor | 0.85 |

So the losses are not timidity. Both judges named something else, and it is
measurable.

### The semicolon, and why the academic answer did not transfer

Semicolons per 100 words, blog and technical only:

| | rate |
|---|---|
| published Turkish (Midas, Biz Evde Yokuz) | **0.32** |
| competitor | 0.19 |
| v9 | 1.33 |
| **v10** | **1.33** |

**Four times the published rate**, unchanged by this round, and named by the
judges on `technical-5` (*"A kısa bir metinde beş kez noktalı virgülle iki
bağımsız cümleyi birleştiriyor … İngilizcedeki '; moreover / while' kalıbının
Türkçeye taşınmış hali"*), `technical-1` and `blog-1`.

Round five refuted the same objection **in academic register** — there our
0.79–1.97 sits inside the published 0.34–2.42. That refutation was correct and
it does not generalise. Published Turkish uses the semicolon at academic rates
in academic prose and at roughly a quarter of that in blogs and technical
writing; the skill uses academic rates everywhere, because
`layer-3-surface.md` §5 defends the mark without giving it a register dose.

This is the same shape as the `-mAktAdIr` episode: a mark that is correct in one
register, carried into all of them at one rate.

### Pre-registered for round seven

`layer-3-surface.md` §5 now carries the register split. Before running anything:

| outcome | reading |
|---|---|
| blog + technical semicolons fall to ≈0.3–0.5 **and** the register tallies recover | the dose was the cause |
| the rate falls but the tallies do not move | the semicolon was a symptom, not the cause; look again |
| the rate falls below 0.2 | over-corrected — published Turkish does use the mark, and purging it is the failure `layer-3` §5 already warns about |

The third row matters. `layer-3` §5 exists because removing every semicolon from
Turkish prose is its own kind of damage, and the competitor's 0.19 is not a
target.

## Round seven — the semicolon dose landed, and the tally stopped being the useful instrument

Run as pre-registered. Same twenty-one inputs, our arm regenerated into
`evals/output/v11/` against the frozen skill, competitor arm byte-identical,
order re-randomised by `pair.sh`.

### Three changes to the instrument, recorded before any result

**1. `count.sh` gained a `semi_p` column.** The semicolon acquired a numeric
register dose in round six and the counter could not measure it, which is the
same hole the en dash sat in for six rounds. It is the one signal scoped to the
prose view rather than the whole body: `layer-3` §5 permits the mark for
separating grouped list items, so counting list-item semicolons would score a
permitted usage against the text, hardest in the list-heavy corporate register.
Round six's semicolon figures were measured by hand; the committed column reads
**1.39** where round six reported 1.33 on the same files. Nothing in round six's
conclusion turns on the difference.

**2. Majority of three judges**, per `repair-protocol.md` §3. The third judge is
consulted only where the first two disagree, which is verdict-identical to
running all three and costs only the 2–1 census. **This tally is not comparable
to rounds one to six**, which used one judge each.

**3. A prompt inconsistency, which is a defect and not a design.** Judge one got
the long prompt used in rounds one to six, which asks for verbatim quotations;
judges two and three got a terse two-line form asking the same question with no
justification. Demanding quoted evidence plausibly changes the vote, so those
votes should not have been pooled. `repair-protocol.md` §3 now standardises all
three voting judges on the terse prompt and moves quotation to a diagnostic
judge outside the tally.

### Fidelity, read first

Twenty-one outputs checked against their sources for additions and
strengthenings. **Academic 5/5 clean. Blog 6/6 clean. Corporate 5/5 clean.
Technical 4 findings across 5 files.**

| file | source | ours | class |
|---|---|---|---|
| `technical-1` | "Genel kural, güncellemek yerine silmektir" + a warning that updating can leave a permanently wrong value | "Genel kural … silmek. **Daha doğrusu ikisi de çalışır, ama** …" | added evaluative claim, and it contradicts the source |
| `technical-3` | "**Yaygın** yaklaşım ikisini birlikte kullanmaktır" | "**En yaygın** yaklaşım …" | superlative the source does not support |
| `technical-5` | "tipik bir imajın boyutunu … üçte birine … indirmek **mümkündür**" | title: "Docker imajını **üçte birine indirmek**" | hedged possibility stated as flat outcome |
| `technical-2` | three bolded items, uncounted | "Pratikte dikkat edilecek **üç** şey" | a count the source does not state, though it is true of the source's own list |

**All four are in one register and none is in the other three.** That is the
finding. The strengthening failure is not diffuse; it is localised in the
register whose dosage line says correctness outranks voice, which is the
register where a strengthened claim does the most damage. `technical-1` is the
serious one — the source warns that updating the cache can leave it permanently
wrong, and the rewrite says both approaches work.

This is a recurrence. The round-seven architecture work traced the academic
losses to one false sentence and one unmarked authority claim and enforced the
rule mechanically; the same class came back four times in a register that work
did not look at.

### The countable prediction

Pre-registered before the round: blog and technical semicolons fall to ≈0.3–0.5,
and below 0.2 counts as over-correction. Measured by `semi_p`:

| | blog + technical |
|---|---|
| published Turkish, including the negative control | 0.49 |
| published Turkish, excluding the negative control | 0.20 |
| competitor | 0.19 |
| v10 | 1.39 |
| **v11** | **0.32** |

**Hit.** Per register: blog 0.36, technical 0.28, corporate 0.45. The academic
control moved 1.14 → **0.85** and stayed inside the published academic band,
which the committed column measures as 0.2–2.4 across the five journal articles.
No register fell below the 0.2 floor.

**The target it hit is weaker than it looks, and this is worth more than the
hit.** The non-academic figure rests on **three semicolons in 613 words**, and
two of the three are in `gezinomi-negative-control.md` — a file kept in the
corpus as an example of formulaic human writing, not as a model. Drop it and
published non-academic Turkish measures one semicolon in 512 words, 0.20, which
is the competitor's rate and the same number this round's pre-registration
called over-correction. So the corpus supports "1.39 was three to seven times
too high" and does not support "0.32 is the human rate". `layer-3` §5 has been
restated to say so. The academic side of that table was strengthened with five
pre-2022 journal articles; this side still needs the same treatment.

### The tally, which is the secondary check

**17–4**, two-sided sign test p = 0.0072.

| register | round six (1 judge) | round seven (majority of 3) |
|---|---|---|
| academic | 5–0 | 5–0 |
| corporate | 4–1 | 4–1 |
| blog | 4–2 | 4–2 |
| technical | 3–2 | **4–1** |

One file of movement, across a change of judging method that makes the two
columns formally incomparable. The standing rule is that three files or fewer is
noise, so **the pre-registered reading is the second row, not the first**: the
rate fell as designed and the tallies did not move. The semicolon was not shown
to be the cause of the round-six losses. It was a real defect — four times the
published rate, named by three judges — and fixing it did not buy a file.

**Judge disagreement: 4 of 21 pairwise, 19%.** That implies a per-judge minority
rate of 10.7% and a majority-of-three error of 3.2% — 2.2 files and 0.7 files of
twenty-one. `repair-protocol.md` had assumed 15% and 6%; the measured figures
are better than assumed, with the two cautions now recorded there.

### What still loses, and what happened when the reasons were checked

Four losses: `blog-1`, `blog-4`, `corporate-2`, `technical-5`. Each got a
diagnostic judge on the long prompt, outside the tally. **Three of the four
rationales do not survive measurement, and two of those fail in the same
direction.**

**`blog-4` — the passive voice.** The judge chose the competitor and named
*"edilgen çatıya fazla yüklenip ('liste yapılıyor', 'başlanıyor')"*. Counting
passive predicates finds **the same two hits in both texts** — `yapılıyor` and
`kurulur` — 0.58 per 100 words in ours against 0.53 in the competitor's. Across
all six blog files the rate is 0.50 against 0.49. The named defect is not
present.

**`corporate-2` — the wrong word for a coffee shop.** The judge chose the
competitor, calling our *"mağazada"* *"yerine oturmayan bir seçimle çeviri
kokuyor"* against the competitor's `dükkan`. **`mağazada` is the source's own
word, carried through unchanged**; the competitor replaced it. The judge
preferred the text that departed from the source and penalised the one that kept
it.

**`blog-1` — twelve named machine signals.** The longest-standing loss, examined
for the second time. The diagnostic judge produced a detailed bill of
particulars against our text. Counting it:

| the judge's claim | measured |
|---|---|
| "şablon düzenliliği … metnin en güçlü makine sinyali" — every section the same length | paragraph-length CV **0.28 ours vs 0.18** the competitor's; sentence-length SD **4.5 vs 3.4**. Ours is the more varied text on both proxies |
| scare quotes as an English typographic habit | 4 in our blog files against 3 in the competitor's |
| the contrastive semicolon | one occurrence, `semi_p` 0.4 — inside the dose this round set |
| inanimate subject + `izin veriyor` as an "allows" calque | one occurrence, **and it is in the source**; published Turkish runs 0.03 per 100 words |

What remains from that list is a handful of single-instance translated idioms
(*"özünü kavramaya fazlasıyla yeter"*, *"akıldan çıkması uzun sürüyor"*, *"Ama
değer, kesinlikle"*), none of which recurs anywhere else in the corpus. The same
judge, unprompted, flagged the competitor's text for inventing first-hand
experience: *"B insan sesini kısmen uydurarak kazanıyor: 'Aşağıdaki rotayı biz
de yürüdük' … Kaynakta olmayan bir birinci tekil/çoğul deneyim iddiası bu."*

**`technical-5`** is the one loss whose rationale nothing here contradicts: the
judge preferred the competitor's spoken-register asides.

### The four winning texts, put through our own fidelity check

The obvious hypothesis, tested rather than assumed. The same check that was run
on our twenty-one outputs was run on the competitor's four winners.

| | additions found |
|---|---|
| `blog-1` | **5** |
| `blog-4` | **1** |
| `corporate-2` | clean |
| `technical-5` | clean |

`blog-1`, which this skill has now lost five rounds running, is won with
invented material of exactly the kind `rewrite-mode.md` names:

> Kaynak: "İşte **denenmiş**, yorulmadan uygulanabilir bir plan."
> Rakip: "Aşağıdaki rotayı **biz de yürüdük**, yorulmadan uygulanıyor."

> Kaynak: "Geri döndüğünüzde **aklınızda kalan, büyük ihtimalle** … **olacak**."
> Rakip: "**Bizde kalan**, sabahın köründe vadiye çöken o sessizlik **oldu**."

> Kaynak: "ardından Selime Katedrali'yle turu tamamlayın."
> Rakip: "Turu Selime Katedrali'nde tamamlayın. **Adı katedral, aslı manastır.**"

An agentless passive becomes a first-person claim, a second-person prediction
becomes the writer's own completed memory, and a fact about a monument appears
that the source does not contain. The judge that chose this text named the first
two itself while choosing it.

**So the four losses are three different things.** Two are to texts that invented
material and one penalised us for keeping the source's own word. Only
`technical-5` is a loss where the competing text is faithful and ours is not —
and ours is not because of the title finding in the fidelity table above.

### What this round actually establishes

The instrument, not the score. At 17–4 the blind tally has stopped resolving
anything about our text. A one-file move sits inside a measured 0.7-file
majority-of-three error and a 3.2-file regeneration noise floor. Three of the
four residual judge rationales fail on counting. And of the four texts that beat
us, two did it while inventing material and a third did it by changing a word
the source had chosen.

That is the round's real result, and it was pre-registered before any of it:
**fidelity outranks the ranking.** The ranking now disagrees with fidelity often
enough that the two cannot both be optimised, and the order between them was
settled in round one for exactly this situation.

Meanwhile the one thing this round measured objectively — the fidelity check —
found four strengthenings in a single register, and that is the defect worth a
round.

### Pre-registered for round eight

**Primary, countable, and it outranks the tally:** the fidelity check returns
**zero** additions or strengthenings across all twenty-one files, technical
register included. Four findings in five technical files is the baseline to
beat. Any non-zero result is a failed round regardless of what the judges say.

The change being tested: `references/rewrite-mode.md` no longer opens its
fidelity section by reporting a perfect record. A rule that states its own
compliance reads as a constraint already met, and this one had reported six
clean rounds while failing four times in the seventh. The boast is replaced by
the four failures, by the observation that three of the four are a single
deleted word, and by a named list of load-bearing qualifiers for the register
where it happened — *yaygın*, *tipik*, *mümkün*, *çoğu*, *genellikle*,
*olabilir*.

**The prediction, stated so it can fail:** if the mechanism is the boast and the
missing qualifier list, technical returns to zero findings and the other three
registers stay at zero. If findings persist in technical, the cause is the
compression the register asks for and the fix has to move into
`layer-2-sentence.md`, not the fidelity section.

**Secondary:** no register's `semi_p` falls below 0.2 and none rises above its
band — the dose landed this round and must not drift.

**No judging at all this round, decided before generating anything.** The
question round eight asks is countable, and `repair-protocol.md` §5 says a
countable target is tested by measuring it with zero judges. Round seven is the
evidence that this is not a shortcut: at 17–4 the tally could not resolve a
one-file move, three of its four residual rationales failed on counting, and two
of the four texts that beat us did it with invented material. A judge cannot
answer "did the strengthenings go to zero", and the counters answer the
regression question — `semi_p`, `len_sd`, `part_p`, `endash`, `em_dash`, `bold`
and `bullets` all run for free. **The tally therefore does not appear in round
eight's report, and its absence is not a result.**

**The round runs in two phases, so a failed mechanism costs six subagents rather
than twenty-five.** All four findings were in technical register, so technical is
regenerated and checked first. If findings persist there, the mechanism is
refuted, the other sixteen files are not generated, and the fix moves to
`layer-2-sentence.md` — where the compression this register asks for actually
lives. Only a clean technical probe buys the rest of the corpus.

**The skill is frozen from here to the end of generation.** Round five was
invalidated by an edit made mid-run. Distinguishing a skill that wins 17 of 21 from one that wins 18
needs either a harder comparison arm or judges that are not drawn from one model
family, and neither is a change to the skill.

## What this does not establish

Twelve texts, one model, one afternoon, and judges that are themselves language
models. The fidelity check is objective and the numbers behind it are solid.
The ranking is softer: it says two skills are indistinguishable on a measure
that, as shown above, can be won by cheating. Read it accordingly.
