# Rewrite mode

Everything specific to repairing a text that already exists. The grammar itself
is in the shared layer files; this file holds what only applies when there is an
input.

Two parts: **fidelity**, which is the constraint that makes repair different
from writing, and **the diagnostic pass**, which routes the work.

---

## Fidelity — the constraint that only exists here

The input is somebody else's text and the claims in it are theirs. That single
fact produces every rule below, and none of them transfer to write mode, where
there is no source to be faithful to.

1. **Nothing enters the output that was not in the input.** No number, name,
   date, causal explanation, or first-person experience. Check both directions:
   every claim in the input survives, and nothing new appears.
2. **A voice is built from stance toward existing material**, never from new
   material. See `voices.md`, "Where voice comes from".
3. **How certain the source was is part of what it said.** `görülmektedir` says
   somebody observed this; `başlıca` says the list is not exhaustive;
   `eğiliminde` says it is a tendency. Deleting one promotes the claim without
   adding a word, and adding one where the source was certain retracts it. Both
   are failures, and the first is easy to commit while cleaning `-mAktAdIr` or
   converting a passive to an active.
4. **The relations between the source's statements are content too.** Two
   sentences side by side assert two things. Joined with `çünkü`, `bu yüzden`,
   `yani`, `dolayısıyla` or a converb, they assert a third — that one causes,
   explains or follows from the other. If the source did not state the relation,
   putting it in is an addition, even when both halves are word-for-word
   faithful. `layer-2-sentence.md` §2 tells you to fuse clauses with converbs
   and it is right; in repair mode the relation the converb encodes has to be
   the source's, not yours.

**Why this is the skill's business here and not in write mode.** Fabrication in
general is not a Turkish problem and this skill has no standing to legislate it.
But fidelity to a supplied text *is* a property of the transformation being
performed. Keep it here; do not carry it across.

**This section used to end by saying the record was perfect — zero additions
across twenty-one repair inputs — and that is no longer true.** Round seven
found four, all four in technical register and none anywhere else.

The claim it replaces was also weaker than it sounded: the check that produced
those six clean rounds asked only for material **absent** from the source, and
round seven's also asked for source material **strengthened**. Two of the four
below would have been caught before and two would not. The record was never as
clean as "zero" implied, which is the second reason not to keep a boast here.

| source said | output said | which rule |
|---|---|---|
| "Genel kural, güncellemek yerine silmektir", then: updating on write can leave the cache permanently wrong | "Genel kural … silmek. **Daha doğrusu ikisi de çalışır, ama** …" | rule 1 — a claim that was not in the input, and it contradicts one that was |
| "**Yaygın** yaklaşım ikisini birlikte kullanmaktır" | "**En yaygın** yaklaşım …" | rule 3 — a superlative the source did not reach for |
| "tipik bir imajın boyutunu … üçte birine indirmek **mümkündür**" | title: "Docker imajını **üçte birine indirmek**" | rule 3 — a possibility restated as an outcome |
| three items, uncounted | "Pratikte dikkat edilecek **üç** şey" | rule 1 — a number, even though the count is correct |

Three of the four are one word. None of them needed a sentence to be invented;
they happened while tightening prose, which is exactly what rule 3 warns about
and exactly when nobody is thinking about fidelity.

**Why the boast is removed rather than updated.** A rule that opens by reporting
its own perfect compliance reads as a constraint already satisfied, and a
constraint already satisfied does not get checked. The record is what it is;
the four failures stay written here instead, because they are the four shapes
this failure actually takes.

**The measured case for rule 4, because it is the least obvious of the four.**
The source of `evals/input/technical-4.md` puts two statements in two
paragraphs:

> …düşük kardinaliteli kolonlara tek başına index atmak **neredeyse hep
> israftır.**
>
> **Böyle durumlarda** kısmi index (partial index) çok daha isabetlidir:

Three of five generations joined them: *"neredeyse hep israf. **Neredeyse,
çünkü** böyle durumlarda kısmi index çok daha isabetli."* That asserts the
partial index is what makes the waste only *almost* always — a claim the source
does not make, and one that does not hold, because the example indexes
`created_at` and not the low-cardinality column the sentence is about.

Nothing was invented and no hedge was deleted. A hedge was **explained**, which
is a thing this file had not named until it was measured three times.

**The title is a site of its own, and it survived the first fix.** Round eight
cut the four findings above to one, and the one is a title:
`Mikroservislerde Dağıtık Transaction Yönetimi` became `Mikroservislerde dağıtık
transaction: rollback yok, telafi var`, where the body says *"**Yaygın** çözüm
Saga desenidir"*. Nothing was invented; a hedge simply did not survive the trip
from body to heading.

This one is a collision between two correct rules rather than a lapse.
`layer-1-structure.md` §4 says to turn a category label into a claim, and a
claim is an assertion, so fidelity governs it. **Before rewriting any title or
heading, check that its claim appears in the body at the same strength.** That
section now carries the same rule from the other side.

**Technical register is where the rest happens, and it is worth knowing why.** Its
dosage line says correctness outranks voice, so the work there is compression —
shorter predicates, tighter claims, hedges that read as padding. Every one of
the four above is a hedge that looked like padding. In this register, before
deleting a qualifier, check whether it was carrying certainty: *yaygın*,
*tipik*, *mümkün*, *çoğu*, *genellikle*, *olabilir* are load-bearing, and the
sentence is shorter without them because it now says more than the source did.

**A warning about how this gets measured.** A blind "which reads more human"
test rewards fabrication, because inventing the writer's experience is the
fastest route to sounding like a writer. Four independent judges preferred a
competing text specifically for three invented sentences. Fidelity outranks that
test; see `evals/RESULTS.md` in the project repository
(https://github.com/durmazoguzhan/turkish-humanify/blob/master/evals/RESULTS.md).

---

## Reading the dosage table in repair mode

`registers.md` is written in repair verbs, and here they mean what they say:

- **cleanup** — remove this from the input where it appears
- **stays** — leave what is there; do not delete it
- **off** — do not touch this dimension at all

---

## The diagnostic pass

Read the text once and mark what is actually present before rewriting anything,
so the work goes where the damage is.

Each row names the tell, how to spot it, and which layer file fixes it.

The **frequency** column is not a guess. It records how often each tell
appeared across a twelve-text corpus of unaided model Turkish, measured against
published Turkish writing. Work the common ones first; several of the famous
ones turn out to be rare.

---

## Composition — `layer-1-structure.md`

| Tell | How to spot it | Frequency |
|---|---|---|
| **Bold inflation** | more than two bold spans on a screen of prose | **very common** — up to twenty in one page |
| **Bullet dependence** | a list whose items are not things a reader would ever look up separately | **very common** |
| **Announcing opening** | first sentence describes the article instead of starting it: "Günümüzde X giderek önem kazanmaktadır" | **very common** |
| **Restating closing** | "Sonuç olarak", "Özetle", "Görüldüğü üzere" followed by a replay | **common** |
| **Template title** | "X Nedir? Bilmeniz Gereken Her Şey", "X: Kapsamlı Bir Rehber" | common |
| **Paragraph loop** | topic sentence, three supports, restatement — four times running | common |
| **Title Case headings** | "Pratik Notlar Ve Öneriler" | occasional |
| **Emoji** | any, in prose | occasional, and always in marketing copy |

## Sentence — `layer-2-sentence.md`

| Tell | How to spot it | Frequency |
|---|---|---|
| **Trailing modifiers** | a head noun followed by its qualifiers, hooked on with a dash or `ki` | **very common** |
| **`ve` between predicates** | two verbs joined by `ve` where a converb belongs | **very common** |
| **`-DIr` as default copula** | sentences ending `-dır/-dir/-dur/-dür` outside definitions | **very common in technical and academic** |
| **No inversion at all** | every sentence verb-final for a whole page | **very common** |
| **No discourse particles** | no `de`, `ise`, `işte`, `zaten`, `bir de` anywhere | **very common** |
| **Noun-compound chains** | four or more nouns stacked | common |
| **Passive bleed** | "yapılmaktadır", "edilmiştir" outside academic register | common |
| **`-yor` for properties** | progressive tense describing what something *does* | common |
| **No `-mIş`** | narrative or hearsay content told entirely in `-DI` | common where the content narrates |
| **Redundant pronouns** | `ben`/`siz` repeated where the verb ending already carries it | occasional |
| **Relative `ki`** | "bir sistem kurduk ki bu sistem…" | occasional |
| **"Sadece X değil, aynı zamanda Y"** | the English rhetorical frame, rendered literally | **rare in current output** |

## Surface — `layer-3-surface.md`

| Tell | How to spot it | Frequency |
|---|---|---|
| **Explanatory em dash** | ` — ` bracketing an aside. Ranges like `04.30–05.00` are correct, leave them | **common** — three of twelve texts |
| **Suffix guessed from spelling** | `cache'ı`, `SQL'ı`, `queue'yü` | common wherever English terms are inflected |
| **Apostrophe on an organisation name** | `Türk Dil Kurumu'ndan` | occasional |
| **`-mAktAdIr` outside academic** | "artmaktadır" in a blog post | **rare** — appears only in academic texts, where it belongs |
| **Forced term translation** | "uç nokta", "olay güdümlü" | **not observed** — but a hard failure if it appears |
| **Calqued idioms** | "günün sonunda", "kritik öneme sahip" | **not observed** in current output |
| **`~` or `41%`** | wrong-side percent sign, tilde for approximation | rare |

---

## What this means for where to spend effort

The tells that actually fire are structural and syntactic: bold and bullets,
trailing modifiers, `ve` where a converb belongs, `-DIr`, and the complete
absence of inversion and particles. Those five account for most of what makes
current model Turkish feel unwritten.

The famous lexical tells — calqued idioms, `-mAktAdIr` everywhere, "sadece X
değil aynı zamanda Y" — are largely gone from current output. Their rules stay
in this skill because a rule that fires rarely is still right when it fires,
but a repair pass that finds only those has not found the problem.

If a text shows none of the common tells, say so and change little. Rewriting
a text that was already fine is a failure mode too, and a quieter one.

---

## Do not flag these

A repair pass that cuts everything on this list will make the text worse. Check
against it before starting.

- **Clean grammar and correct punctuation.** Machine text is usually correct.
  Correctness is not the tell.
- **A single em dash used as a range**: `04.30–05.00`, `Nisan–haziran`,
  `MÖ 738 – MÖ 696`. Correct Turkish.
- **Semicolons.** The Turkish semicolon is legitimate. Only the English
  `; and` chain grates.
- **`-DIr` in a definition, a specification, a standard, or a legal clause**,
  and **`-mAktAdIr` in academic register**. Both are the register working.
- **The passive in a methods section.** A convention of the form.
- **One short sentence.** Length variance means variance, and a short sentence
  is half of it.
- **Formal vocabulary in a formal text.** An academic abstract is supposed to
  sound like one.
- **Bullets that are genuinely a list** — prices, hours, prerequisites, an
  ordered procedure.
- **Bold on the one warning that prevents data loss**, or on a landing page's
  single primary action.
- **A text that already reads well.** The correct output is then the input.
