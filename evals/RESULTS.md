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

## What this does not establish

Twelve texts, one model, one afternoon, and judges that are themselves language
models. The fidelity check is objective and the numbers behind it are solid.
The ranking is softer: it says two skills are indistinguishable on a measure
that, as shown above, can be won by cheating. Read it accordingly.
