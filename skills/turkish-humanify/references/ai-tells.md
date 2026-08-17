# AI tells — the diagnostic pass

Repair mode only. Read the text once and mark what is actually present before
rewriting anything, so the work goes where the damage is.

This file is a router, not a sixth rulebook. Each row names the tell, how to
spot it, and which layer file fixes it.

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
| **`-mektedir` outside academic** | "artmaktadır" in a blog post | **rare** — appears only in academic texts, where it belongs |
| **Forced term translation** | "uç nokta", "olay güdümlü" | **not observed** — but a hard failure if it appears |
| **Calqued idioms** | "günün sonunda", "kritik öneme sahip" | **not observed** in current output |
| **`~` or `41%`** | wrong-side percent sign, tilde for approximation | rare |

---

## What this means for where to spend effort

The tells that actually fire are structural and syntactic: bold and bullets,
trailing modifiers, `ve` where a converb belongs, `-DIr`, and the complete
absence of inversion and particles. Those five account for most of what makes
current model Turkish feel unwritten.

The famous lexical tells — calqued idioms, `-mektedir` everywhere, "sadece X
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
  and **`-mektedir` in academic register**. Both are the register working.
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
