# Registers and dosage

Four registers. Each decides **how much** of each layer runs — not whether the
skill is right, but how hard it presses.

The reason this exists: a rule applied outside its register does damage. An
inverted sentence in a contract reads as carelessness. A `-mIş` in a methods
section is a lie about who witnessed what. Stripping `-DIr` out of a
specification makes the specification wrong. Every layer-2 rule carries a
"where it stops" line for this reason; the dosage table is those lines
collected into one decision.

---

## The table

| Layer | blog / essay | technical | corporate | academic / official |
|---|---|---|---|---|
| **structure** | full | medium | medium | off |
| **sentence** | full — inversion, particles and `-mIş` all in play | restricted — no inversion, few particles; branching, converbs, focus and `-DIr` cleanup active | medium — branching, converbs, focus; **no list-to-prose conversion** | branching, converbs and focus only — **`-mAktAdIr` stays** |
| **surface** | full | full | full | full |

**Surface is always on.** Orthography and terminology are correctness, not
style. An academic paper with `cache'ı` instead of `cache'i` is simply
misspelled.

**This table is written in repair verbs** — *cleanup*, *stays*, *off* — and they
presuppose an existing text. In write mode there is nothing to remove, so read
them through the translation table in `write-mode.md` before applying any row.
Taking "stays" literally where nothing is there turns it into "produce this",
which has already been measured doing damage.

---

## Recognising each register

### blog / essay
Addressed to a reader who chose to read it. The writer is allowed to have an
opinion and to be present in the text. Travel writing, personal essays,
opinion columns, most company engineering blogs when they are any good.

*Dose:* everything. This is the only register where inversion and discourse
particles are fully in play, and the only one where narrative `-mIş` is
routinely correct.

### technical
Explains a system or a procedure to somebody who will act on it. Correctness
outranks voice, but voice is not banned — the best Turkish technical writing
has a person in it.

*Dose:* sentence layer without inversion, and particles only where they carry
real tonal work. `-DIr` cleanup is important here: it is the strongest machine
signal measured in technical Turkish. Structure at medium — bullets often earn
their place in a procedure.

### corporate / marketing
A brand speaking, asking for a decision. The failure mode is not stiffness but
inflation: bold everywhere, a superlative in every clause.

*Dose:* medium across structure and sentence, with one rule **off**:
**do not convert lists to prose in this register.**

The highest-value work here is still layer 1, but it is deleting bold and emoji,
not dissolving structure. A feature list, a price table, a set of campaign terms
and a benefits list are exactly the things a reader scans and returns to — which
is the test `layer-1-structure.md` §5 already states, and which this register
fails most often. Melting them into prose produces the one outcome blind readers
named unprompted:

> "maddeleri paragrafa eritmesi … insan elinden çıkmış gibi değil, düzleştirilmiş gibi okunuyor"
> "tüm katalogu tek cümleye noktalı virgüllerle sıkıştırıyor … bu Türkçede kimsenin kurmadığı bir cümle"

Both were losses in the blind comparison, and corporate is the only register this
skill loses. Keep the list, fix what is inside it.

### academic / official
Conventions are binding and deviation costs credibility. Journal articles,
theses, legal notices, official correspondence, policy documents.

*Dose:* structure **off** — the opening is supposed to state the subject, the
closing is supposed to state the contribution. Sentence layer limited to
branching, converbs and focus. `-DIr` stays. `-mAktAdIr` **stays**. The passive
stays. `-mIş` stays out.

**Why `-mAktAdIr` stays, and what happened when it did not.** An earlier version
of this table listed "`-mAktAdIr` cleanup" in this row, contradicting
`layer-2-sentence.md` §7, which says to keep it in academic register. The
contradiction did measurable damage: `-mAktAdIr` is the form that carries
**evidential distance** in Turkish academic prose, so cleaning it here strips
the marker that says whose claim this is.

> Kaynak: "çalışmaların görece sınırlı kaldığı **görülmektedir**" — we observe this; the literature reports it
> Çıktı: "çalışmalar görece sınırlı **kalmaktadır**" — this is the case; the author asserts it

Measured on the eval corpus before the fix: evidential-distance forms
(`görülmektedir`, `bulunmaktadır`, `düşünülmektedir`, `bildirilmektedir`) fell
from 4 to 1 on one academic text and 3 to 2 on another. No word was added, and
the claims got stronger than their source. A reviewer would flag it.

**How much is "stays".** "Stays" is not "as much as possible", and the band has
two ends. Measured across five Turkish journal articles published between 2015
and 2019 — early enough that none of them can be model output — `-mAktAdIr` runs
**0.4 to 2.3 per 100 words** (median 1.6) and the `-DIr` copula runs **2.3 to
4.0**. The articles are in `evals/human-reference/`.

Both ends are live failures, not hypotheticals:

| | `-mAktAdIr` per 100 words |
|---|---|
| unaided model Turkish, asked for an academic text | **0.0** — not restrained, absent; `-DIr` is 0.0 too |
| published Turkish journal articles, 2015–2019 | **0.4 – 2.3** |
| an earlier version of this file | **2.9 – 4.5** — above the human ceiling, and a blind reader called the result monotonous |

The two articles at the low end of the band reach for the aorist instead
(*değerlendirilir*, *belirler*, *karşılaşırlar*); the two at the high end are
`-mAktAdIr` throughout. Both read as published. So the target is the band, not a
number inside it — and a text that never uses the form at all has missed the
register, which is the specific thing unaided output does.

**The residual case.** Hedging is also carried by qualifier words, not only by
suffixes — dropping *"başlıca"* from "başlıca nedenleri şunlardır" turns an open
list of main causes into an exhaustive one. That is not a `-mAktAdIr` problem and
this row does not cover it; see the invariant in `SKILL.md`.

---

## The same sentence at three doses

Input, unaided:

> Cache stratejisinin doğru belirlenmesi, sistem performansı açısından kritik öneme sahiptir.

**academic / official** — surface removes the calque `kritik öneme sahip`;
`-DIr` stays because this is a definitional claim in a register that asserts
that way; no inversion, no particle:

> Cache stratejisinin doğru belirlenmesi, sistem performansı açısından belirleyicidir.

**technical** — active voice, `-DIr` dropped, the focus tightened onto the
preverbal slot; still no inversion and no particle:

> Cache stratejisini doğru belirlemek performansı doğrudan belirler.

**blog / essay** — inversion and a particle now permitted:

> Performansı belirleyen şey cache stratejisi işte.

The claim is identical in all three. What changes is how much of the writer is
audible. That is the whole point of the dosage table: it modulates presence,
never content.

---

## When the register is unclear

Ask what the text costs the reader if it is wrong. A blog post that is stiff
loses attention; a contract that is chatty loses standing. When two registers
are both arguable, take the more conservative one — under-applying this skill
produces text that is merely unremarkable, while over-applying it produces text
that is wrong for its purpose, and the second failure is much harder for a
reader to forgive.
