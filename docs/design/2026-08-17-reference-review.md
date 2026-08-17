# Reference review

What the eleven reference skills and the Turkish blog sources actually teach,
what this project already had, what it was missing, and what changed as a
result.

**Date.** 2026-08-17
**Method.** Each source read directly — GitHub raw where available, the
published page otherwise. Turkish sources read for verbatim prose, not summary.

---

## 1. The reference skills

### `blader/humanizer` — 35 rules, English

Closest relative. Four categories (content, language, style, chatbot
artifacts), every rule with a before/after pair, sourced from Wikipedia's
*Signs of AI writing*.

**Already had:** the before/after-pair discipline; the no-fabrication rule,
almost word for word.

**Taken:** two things.

*A consolidated false-positive list.* It carries a "Check for false positives"
section naming what must **not** be flagged — perfect grammar, academic
vocabulary, an em dash on its own, a single short sentence, pre-2022 text. Our
per-rule "where it stops" lines are more precise, but a repair pass benefits
from one list it can check against before it starts cutting. Added as the
closing section of `ai-tells.md`.

*Explicit output modes.* It defines three (report + rewrite, file mode, embedded
mode). Ours had one default plus explain-on-ask, which is right, but naming the
default explicitly is clearer.

**Not taken:** sixteen of its thirty-five rules are chatbot artifacts — "As an
AI language model", cutoff disclaimers, sycophancy. Those belong to a different
era of output and compress into one invariant here.

### `getsentry/blog-writing-guide` — English, engineering blog

The most useful source of the eleven, and the one that criticises this project
most directly.

**Taken, and it matters:**

*Personality only in the bookends.* Its exact diagnosis: "AI drafts open with a
personal anecdote, go impersonal for 80% of the post, then close with a CTA.
The author's voice should persist throughout." Three of our blind judges said
the same thing about our own output, unprompted — *"sonradan uygulanmış devrik
dokunuşlar gibi duruyor; iskelet neredeyse birebir aynı kalmış"*, *"samimiyet
sonradan serpiştirilmiş gibi duruyor"*. This is the reading-quality gap that
kept the three-way comparison at a tie, and neither the sentence layer nor the
voice file named it.

*Our own rules can produce AI tells.* It lists staccato dramatic fragments
("No errors. No warnings. Everything green."), bumper-sticker aphorisms,
three-beat reveals, smug simplicity ("That's it. That's all you need."), and
parallel-structure ad copy. Our layer-2 rule on length variance actively pushes
toward the first of those and had no stated limit. A rule without its failure
mode is half a rule.

*Break paragraphs at contrast points.* When a sentence turns — "but", "however"
— start a new paragraph rather than burying the turn. Directly portable to
Turkish: `ama`, `ancak`, `oysa`, `fakat`, `buna karşılık`.

*A quality bar that is an external test, not an adjective.* "Something a senior
engineer would share in their team's Slack." Ours had no bar at all.

*Voice as a situational persona.* "A senior developer at a conference
afterparty explaining something they're genuinely excited about — smart,
specific, a little irreverent, deeply knowledgeable." Our nine-dimension specs
are more checkable; a one-line persona is more generative. Both, not either.

*Numbers over adjectives*, and *feedback that quotes the weak passage, explains
why, and rewrites it* — which is exactly the shape our explanation mode should
take.

**Where we already agreed:** no em dashes, banned filler phrases, openings that
state something rather than announce, headings that carry information.

### `langchain-ai/deepagents` → `blog-post`

Short, and one idea worth having: **a mandatory research phase before writing**,
delegated to a researcher.

**Taken, reframed.** We forbid invention. That constraint has a cost — concrete
detail is what makes prose feel written by a person, and the honest way to get
it is to go and find it. So write mode now says: if the piece needs specifics
it does not have, research them or ask the user. Never fill the gap by
inventing. This turns our strictest rule from a pure restriction into a
procedure.

### `advertising-skills` — 27 skills, Schwartz methodology

Awareness levels, market sophistication, mechanism, then copy.

**Taken:** the ordering principle — establish what is true before writing a
word — which is the same argument our composition-before-sentences rule makes,
arrived at from a different direction. Also `claim-checker` as a named,
separate verification pass, which is what our fidelity check turned out to be.

**Not taken:** the Schwartz apparatus itself is a marketing framework, not a
language one, and would not survive contact with the academic register.

### `fullstack-mkt-skills` — 29 skills

**Taken as a note, not yet built:** its foundation-first architecture, where
every skill reads one `product-marketing-context.md` so the user states their
context once. The equivalent here would be a persistent file holding the user's
voice sample, terminology preferences and house style, instead of re-supplying
them each session. Recorded in "Not done" below.

### `prompts.chat/book-translation`

Structural setup — locale folders, MDX paths, JSON message keys. No translation
methodology. Nothing to take.

### `alterlab-ieu/alterlab-academic-skills` — 239 skills, 12 Turkish

The Turkish twelve are **tools, not style guides**: TR Dizin index lookup, YÖK
Akademik profile scraping, DergiPark OAI-PMH harvesting, doçentlik and akademik
teşvik scoring, KVKK data-management plans, TÜBİTAK proposal scaffolding. One
exception, `alterlab-tr-academic-style`, does Turkish APA-7 and TR Dizin
manuscript formatting — abbreviations like *ve ark.*, *vd.*, *Çev.*, *t.y.*,
*aktaran*, and the bilingual *öz*/abstract requirement.

**Assessment: complementary, not competing.** They handle the formal apparatus
of Turkish academia — citation shape, ethics routing, index compliance. We
handle whether the prose reads. A researcher wants both, and neither replaces
the other. Worth saying plainly in the README rather than implying this project
covers ground it does not.

---

## 2. The Turkish sources

### `getmidas.com` — Midas'ın Kulakları, Midas Akademi

Already the strongest source in the corpus, and it stayed so. Second-person
address that never becomes cloying, a question as an opening move, English
finance terms kept and paired on first use — *"hisse başına kâr (earnings per
share-EPS)"* — and narrative `-mIş` in the folk-history piece.

**One finding that corrected a rule of ours.** The TLY fund piece writes
`99,95%`, `17,5%`, `5.285%` — percent sign *after* the number. TDK prescribes
the opposite: *"Yüzde ve binde işaretleri yazılırken sayılarla işaret arasında
boşluk bırakılmaz: %25"*. Our surface layer stated the TDK order as a flat rule.
Published Turkish financial writing does not follow it. The rule is now: TDK
order by default; if the source or a house style consistently uses the other,
consistency wins over correction; never mix the two in one text.

### `bizevdeyokuz.com`

Opening moves that start the piece instead of announcing it, and the invented
`-cılık` noun — *"'Aman ilk giriş Yunanistan'dan olsun'culuk"* — which is the
kind of thing no model produces unprompted.

### `filgezi.com`

Long front-loaded participial stacks: *"İstanbul'un kaosundan ve gürültüsünden
yalnızca bir vapur yolculuğu kadar kısa bir sürede uzaklaşmayı mümkün kılan
Büyükada, …"* — twelve words before the head noun. Useful calibration: our
layer-1 branching rule puts the load limit at "roughly ten or twelve words",
and real Turkish blog writing sits right at that ceiling rather than well
below it. The rule stands as written.

### `gezinomi.com/gezi-rehberi` — the useful negative

Formulaic and interchangeable across articles: *"Yemyeşil alanları, doğa
manzaraları, serin akan suları, zengin bitki çeşitliliği…"*, *"Yemyeşil
alanları, ihtişamlı doğa manzaraları, yaylaları, şelale ve akarsuları ile…"*,
then four consecutive pieces opening *"X, Yalova'nın turistik ilçelerinden
biridir."*

This is human-written and it is bad. It matters because the whole evaluation
rests on comparing machine text against published human text, and this is a
reminder that **"human-written" is not the target — "good" is.** Added to
`evals/human-reference/` as a labelled negative control so nobody, including a
future version of this project, mistakes the reference set for a quality
ceiling.

### `eventmag.co`

Titles shaped like something a person would say: *"Nişantaşı'nda Yeni Açılan
Her Mekandan Haberi Olan Semt İnsanı Bu Aralar Hangi Mekanlara Gidiyor?"* —
already used in the composition layer.

### `tdk.gov.tr`

Consulted directly on two rules rather than written from memory, and it
corrected one of them: suffixes on **institution names take no apostrophe**
(*Türk Dil Kurumundan*) even though suffixes on their **abbreviations do**
(*TDK'nin*). Also confirmed the percent-sign order above, the `da/de`
conjunction rules, and the decimal-comma / thousands-period convention.

---

## 3. What this project had that none of the references do

Stated plainly, because the review found real gaps and the balance matters.

- **A grammar of the target language, not a list of tics.** Fourteen places
  Turkish and English structurally diverge — branching direction, the converb
  system, focus position, evidentiality — each with the conditions under which
  the rule stops applying. `turkce-humanizer` has five surface phenotypes;
  `humanizer` has thirty-five English-specific rules. Neither reaches the level
  at which English structure survives translation.
- **A register dosage matrix**, so a rule that is right in a blog post and
  wrong in a contract is not applied to both.
- **Measured tell frequencies.** `ai-tells.md` records how often each tell
  actually appears in current model output, so a repair pass works the common
  ones first and knows that calqued idioms and stray `-mektedir` are nearly
  extinct. No reference skill measures anything.
- **An evaluation corpus, a calibrated instrument, and a comparison whose
  losses are published.** `evals/RESULTS.md` records that the blind reading
  comparison was a tie, and says what the competing skill does better.

---

## 4. What changed as a result

In the skill:

1. `layer-2-sentence.md` — new section 15, **sprinkling**: the failure mode of
   this entire layer, with the Turkish forms of Sentry's over-application tells
   and the blind judges' own words as evidence.
2. `layer-1-structure.md` — paragraph breaks at contrast points; the opening
   must state the problem or start the scene; voice must persist through the
   middle, not only the bookends.
3. `voices.md` — a situational persona line per profile; **fidelity-safe
   voice**, which is the rule that converts the fabrication finding into
   guidance; self-correction as a device, with its limit.
4. `layer-3-surface.md` — the percent rule softened to match observed usage.
5. `SKILL.md` — a quality bar; and in write mode, research or ask rather than
   invent.
6. `ai-tells.md` — a consolidated do-not-flag list.
7. `evals/human-reference/` — a negative human control.

## 5. Not done, and why

- **A persistent user-context file** (the `fullstack-mkt-skills` pattern). Real
  value for repeat users, but it is a new interface rather than a language
  improvement, and it should be designed rather than bolted on.
- **The bilingual skill variant.** Offered as a third option before the
  prose-language experiment and dropped in favour of a clean two-arm
  comparison. Maintaining two synchronised copies of six reference files would
  cost more than the experiment suggests it could return.
- **SEO structure rules** from the Sentry guide. Sound advice, but a different
  problem from the one this skill solves.
