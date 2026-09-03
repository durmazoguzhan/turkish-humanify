# Layer 3 — Surface

Terminology, orthography, punctuation, numbers.

This layer is always on, in every register, because almost none of it is style.
A misplaced apostrophe is not a voice choice, and neither is translating a term
that has no Turkish equivalent. The two other layers can be dialled down for an
academic paper; those parts of this one cannot.

**One exception, and it was found the hard way.** Whether a mark is *correct* is
register-invariant. How *often* it appears is not. The semicolon is right in
every register and published Turkish uses it four times more freely in academic
prose than in a blog — see §5. This file previously opened by declaring that
"none of it is style", which is why §5 carried no register dose for six rounds
and why blind judges kept naming our semicolon rate. A frequency is a dose, and
a dose belongs to a register.

Every section below states its own register dose where it has one. That
statement is the specification; the table in `registers.md` is a summary of it.

---

## 1. Technical terminology — three buckets

The rule the whole skill is built around: **a term with no true Turkish
equivalent stays as it is.** Forcing a translation does not make the text more
Turkish, it makes it wrong, and a Turkish engineer reading "uç nokta" has to
translate back into English to understand it.

### Bucket 1 — kept verbatim

`Elasticsearch` · `Redis` · `cache` · `endpoint` · `deploy` · `pipeline` ·
`event-driven` · `commit` · `merge` · `rebase` · `container` · `framework` ·
`middleware` · `hash` · `key` · `log` · `queue` · `idempotent` · `stampede`

Forbidden outputs, stated so they cannot be reached for by accident:

> ✗ uç nokta ✗ olay güdümlü ✗ son nokta ✗ kap teknolojisi ✗ yığın taşması
> ✗ mikro hizmet ✗ çekme isteği ✗ dal birleştirme ✗ kaynak kod deposu

### Bucket 2 — an established Turkish word exists, so use it

| English | Turkish |
|---|---|
| developer | geliştirici |
| marketplace | pazaryeri |
| validation | doğrulama |
| production | canlı ortam / canlı |
| feature | özellik |
| security | güvenlik |
| performance | performans |
| user | kullanıcı |
| report | rapor |

### Bucket 3 — both circulate; pick one and hold it

`cache` / `önbellek` · `database` / `veritabanı` · `server` / `sunucu` ·
`request` / `istek` · `error` / `hata`

Choose per text, never mix inside one. On first occurrence the pair may be
given together, which is what real Turkish explanatory writing does:

> İnsan: Şirketin son 4 çeyrekte elde ettiği hisse başına kâr (earnings per share-EPS) ve şirket hisselerinin güncel fiyatı.

### The test for which bucket a term is in

Does a Turkish word already exist that Turkish engineers **actually say out
loud**? If yes, bucket 2. If the Turkish word exists only in dictionaries and
nobody uses it in a standup, bucket 1. If both are said, bucket 3, and
consistency decides.

---

## 2. A kept term still inflects — and the suffix follows pronunciation

This is the most common LLM error in Turkish technical writing. Turkish vowel
harmony operates on how a word is **said**, not how it is spelled, and an
English term keeps its English pronunciation while taking Turkish suffixes.

| written | said | correct |
|---|---|---|
| cache | keş | `cache'i`, `cache'e`, `cache'ten` |
| queue | kü | `queue'yu` |
| SQL | es-kü-el | `SQL'i` |
| JSON | ceyson | `JSON'ı` |
| Google | gugıl | `Google'ın` |
| Redis | redis | `Redis'i` |
| key | ki | `key'i`, `key'ler` |
| log | log | `log'dan` |
| hash | heş | `hash'iyle` |
| commit | komit | `commit'ler` |

Guessing harmony from the spelling produces `cache'ı`, `queue'yü`, `SQL'ı` —
all wrong, all common.

**Where usage has not settled, say so rather than inventing a rule.**
`Elasticsearch` is *elastik-sörç* for some Turkish engineers and *elastik-serç*
for others, so `Elasticsearch'ü` and `Elasticsearch'i` are both defensible. The
rule there is internal consistency: one text, one choice. A fabricated single
answer is worse than a stated preference.

---

## 3. Apostrophe (`kesme işareti`)

Verified against tdk.gov.tr.

**Takes an apostrophe:**

- Inflectional suffixes on proper nouns: `Türkiye'de`, `Redis'i`,
  `Kapadokya'da`, `Atatürk'üm`
- Suffixes on abbreviations: `TBMM'nin`, `TDK'nin`, `MCP'yi`, `API'yi`,
  `TV'ye`, `ABD'de`
- Suffixes on numerals: `1985'te`, `8'inci madde`, `657'yle`
- Suffixes on a specific calendar date: `17 Aralık'a kadar`
- Titles following a personal name: `Nihat Bey'e`, `Ayşe Hanım'dan`

**Does not take an apostrophe:**

- Derivational suffixes on proper nouns, and anything after them: `Türkçe`,
  `Türklük`, `Türkleşmek`, `Türkçü`, `Ahmetler`, `Türklerin`, `Ankaralı`
- **Suffixes on institution and organisation names** — the error most worth
  catching, because it looks like the proper-noun rule: `Türkiye Büyük Millet
  Meclisine`, `Türk Dil Kurumundan`, `Bakanlar Kurulunun`. Note the contrast
  with the abbreviation rule above: `TDK'nin` but `Türk Dil Kurumunun`.
- A proper noun already ending in a third-person possessive suffix, when
  further suffixes follow: `Boğaz Köprümüzün güzelliği`

---

## 4. `da/de` and `ki`

The conjunction `da/de` is written separately, obeys vowel harmony, and is
**never** written `ta/te` and never attached with an apostrophe.

> ✓ Kızı da geldi, gelini de. · Sen de mi? · Gidip de gelmemek var.
> ✗ Ayşe'de geldi (this is the locative suffix, meaning "on Ayşe")
> ✗ Gidip te gelmemek

The locative suffix `-da/-de/-ta/-te` is attached: `masada`, `kitapta`,
`cache'te`.

The conjunction `ki` is written separately (`Öyle yoruldum ki`, `Demek ki`);
the suffix `-ki` is attached (`benimki`, `yarınki`, `akşamki`).

---

## 5. Punctuation

**The em dash is not a Turkish explanatory mark.** In Turkish typography the
long dash belongs to dialogue lines. Using it the English way —
to bracket an aside — is the single punctuation calque that survives into
otherwise clean machine Turkish. Replace it with a semicolon, a connective
(`böylece`, `bu sayede`, `ayrıca`, `çünkü`), or a sentence break.

> AI: Kurulum sihirbazı projelerinizi aktarır — böylece ilk günden dolu bir çalışma alanıyla başlarsınız.
> İnsan: Kurulum sihirbazı projelerinizi aktarır; böylece ilk günden dolu bir çalışma alanıyla başlarsınız.

**The Turkish semicolon is legitimate and must not be purged.** It joins
closely related independent clauses and separates grouped list items. What
grates is the English `; and` chain, not the mark itself. Removing every
semicolon from Turkish prose is its own kind of damage.

**But it carries a register dose, and that dose is not flat.** Measured per 100
words by the `semi_p` column of `evals/count.sh` across the published Turkish in
`evals/human-reference/`:

| register | published rate | what it rests on |
|---|---|---|
| academic / official | **0.2 – 2.4** | 29 semicolons in 2 647 words, five journal articles |
| blog, technical | **0.2 – 0.5** | 3 semicolons in 613 words, four texts |

Roughly a quarter as often outside academic prose. This skill wrote **1.39** in
blog and technical for six rounds — academic rates everywhere — and blind judges
named it three times while choosing the other text:

> "A kısa bir metinde beş kez noktalı virgülle iki bağımsız cümleyi birleştiriyor … İngilizcedeki '; moreover / while' kalıbının Türkçeye taşınmış hali"
> "Türkçe blog yazısında bu yoğunlukta noktalı virgül neredeyse hiç görülmez; bu, çeviri/düzenleme kokan bir noktalama alışkanlığı"

In blog and technical register, a semicolon joining two independent clauses is
usually a sentence break waiting to happen. Ask whether the second clause could
stand alone with a full stop; outside academic prose it nearly always can, and
nearly always should.

**Where this stops.** Not at zero. The mark is right for a genuinely tight pair
of clauses and for separating grouped list items; it is wrong as a default
connective. A text with no semicolons at all has overshot in the direction this
section opened by warning about.

**How weak that floor is, stated plainly.** The non-academic figure above is
three semicolons, and **two of the three are in
`gezinomi-negative-control.md`** — a file kept in the corpus precisely as an
example of formulaic human writing, not as a model. Drop it and published
non-academic Turkish measures one semicolon in 512 words, **0.20**, which is
indistinguishable from the 0.19 this section cites as the competitor's
overshoot. So the honest reading of the band is *0.2 to 0.5*, and the claim that
0.32 is the human rate is more than this corpus can carry. What the corpus does
establish is the size of the old error: 1.39 was three to seven times too high.
The academic side of the table was strengthened with five pre-2022 journal
articles; this side was not, and until it is, treat the lower bound as soft.

**A range takes the short hyphen, not a long dash.** This file said the
opposite until it was checked. TDK lists two marks — `kısa çizgi` (`-`) and
`uzun çizgi` (`—`, the dialogue dash) — and gives the range to the short one:

> *"Arasında, ve, ile, ila, …-den …-e anlamlarını vermek için kelimeler veya
> sayılar arasında kullanılır"* — `1914-1918 Birinci Dünya Savaşı`,
> `Ankara-İstanbul`

There is no en dash (`–`) in Turkish punctuation at all. Across the nine
published Turkish texts in `evals/human-reference/`, ranges are written with the
plain hyphen **seventy times** and with an en dash **three**.

> AI: Balon turu `04.30–05.00` arası başlıyor, `Nisan–haziran` en iyi dönem, yürüyüş `3–4` kilometre.
> İnsan: Balon turu `04.30-05.00` arası başlıyor, `Nisan-haziran` en iyi dönem, yürüyüş `3-4` kilometre.

Normalise `–` to `-` wherever it stands between two numbers, dates or words.
This is surface work, so it runs in every register.

**Why this was missed for six rounds.** The old rule did not just permit the en
dash, it named it correct, and `evals/count.sh` was then built to exclude range
dashes from the `em_dash` signal — so the instrument was configured to look away
from the exact thing the rule got wrong. A blind judge found it instead, calling
it *"çeviri/dizgi kokusu veren bir detay"* while choosing the other text.

---

## 6. Numbers and units

- **The percent sign leads: `%41`.** TDK is explicit — *"Yüzde ve binde
  işaretleri yazılırken sayılarla işaret arasında boşluk bırakılmaz: %25"*.
  But published Turkish financial and technical writing frequently uses the
  English order (`17,5%`, `99,95%`), so this is not a rule to enforce blindly:
  use TDK order by default; if the source or a stated house style consistently
  uses the other, keep it; never mix the two orders in one text.
- Decimal comma, thousands period: `1.250,75`.
- No tilde for approximation — write `yaklaşık %41`, not `~%41`.
- Multiples: `10 kat`, `üç katına`.
- Currency: `90 TL`, `₺90`.
- Clock: `04.30` or `04:30`, consistently within a text.

---

## 7. Circumflex

Use `â / î / û` **only where they disambiguate**: `kâr` (profit) against `kar`
(snow), `hâlâ` (still) against `hala` (aunt), `âlem` against `alem`. Never as
decoration — `hakim`, `sahip`, `katil` take no circumflex.

---

## 8. Calqued idioms and empty intensifiers

Delete or replace. These carry no information and are the phrases that make a
paragraph feel assembled from parts.

`günün sonunda` · `değer katmak` · `kritik öneme sahip` · `hayati önem
taşımak` · `bir adım öteye taşımak` · `oyunun kurallarını değiştirmek` ·
`X'in ötesinde` · `son derece` · `oldukça` (as a filler) · `büyük ölçüde` ·
`yadsınamaz` · `göz ardı edilemez` · `önemli bir rol oynamak` · `dikkat çekici
bir şekilde` · `bilmeniz gereken her şey` · `kapsamlı bir rehber` · `giderek
önem kazanmak`

> AI: Cache stratejisi, sistem performansı açısından kritik öneme sahiptir.
> İnsan: Cache stratejisi performansı doğrudan belirliyor.

This list is mirrored in `evals/signals/calques.txt` so the skill and the
measurement agree on what a calque is.

**The comparative English keeps inside the word.** English marks comparison
morphologically — *lat-er*, *earli-er*, *long-er* — and Turkish marks it with a
separate word, `daha`. The two are not the same operation, and translating the
English word by the Turkish stem alone does not produce a milder version of it.

It produces **a different word**, and that is the whole of the rule. The Turkish
stems these map onto are mostly words in their own right with their own
meanings, so dropping `daha` lands on one of those instead of failing visibly:

| English | correct | what the bare stem actually means |
|---|---|---|
| later | `daha sonra` | `sonra` — *after*, *then* |
| earlier | `daha önce` | `önce` — *before*, *first* |
| less | `daha az` | `az` — *little*, *not much* |
| further | `daha ileri` | `ileri` — *forward*, *advanced* |

> AI: Sonra izle · Sonra hatırlat · Önce gönderilenleri göster · Az veri kullan
> İnsan: Daha sonra izle · Daha sonra hatırlat · Daha önce gönderilenleri göster · Daha az veri kullan

**Where the failure comes from, because it says where to look for it.** Measured
2026-09-04, and the control is what makes it readable. Given the English
strings, two independent generations both wrote `Sonra izle`, `Sonra oku`,
`Sonra hatırlat`. Given the same tasks described in Turkish, with no English in
front of it, the same model wrote **`Daha Sonra İzle`**. Its Turkish is not the
problem; the mapping is. And the trigger is the morphology and not the meaning —
where English spends a separate word on the comparison, `older posts` and `see
more`, `daha` survives every time: `Daha eski gönderileri yükle`, `Daha fazlasını
gör`.

So the place to look is any Turkish written with an English string in view: an
interface, a spec, a translated heading. Prose composed in Turkish rarely does
it.

**Where it stops, and the limit is most of the uses.** Every one of those bare
stems is a correct and ordinary Turkish word, and none of them is being banned.
`sonra` as a postposition — *işlem bittikten sonra* — and as a sequencer inside
running prose, where the sentence before it supplies what comes *after* what;
`önce` the same; `az` wherever the quantity is small rather than smaller.
`layer-2-sentence.md` §8 has *"Konuşuruz bunu sonra."* as a worked example and it
is right, because that sentence has a conversation in front of it.

The test is one question: **is a comparison being made?** If something is later
*than* something, less *than* something, `daha` is not optional. If nothing is
being compared, the bare word was never the wrong one. Context answers this in
prose and cannot answer it in a string standing on its own, which is why the
failure lives there.

**This one is deliberately not in `evals/signals/calques.txt`.** Every other
entry in this section is a fixed phrase a substring match can find. This is a
word that is correct in most of its occurrences, so a counter for it would
report the postposition and the sequencer as defects — and a count that cannot
tell a right use from a wrong one reports direction, never correctness. See
`CONTRIBUTING.md`.

**An honest note on this section.** Across the twelve-text baseline corpus and
the human reference texts, the fixed-phrase list above scored zero hits on both
sides. Nothing in it has been shown to detect anything in current model output;
it is kept as a guard against phrases that would be wrong if they appeared, not
as evidence that they do. The comparative entry is the exception and the first
thing in this section measured actually firing.

---

## 9. Collocation — the verb the noun actually takes

Turkish pairs particular verbs with particular nouns, and the pairing is not
derivable from the meanings. `sarımsak ezilir`, `hamur açılır`, `çay demlenir`,
`karar verilir`, `göz atılır`. Swap in a verb that means the same thing and the
sentence stays grammatical and stops being Turkish.

This is the failure that survives every other layer. Structure, syntax and
orthography can all be right while the sentence describes something nobody does,
and it is the one a reader trips on first, because it is the one they hear as
somebody who does not cook, or does not use the thing being described.

> AI: Sarımsaklı yoğurdu ezdim.
> İnsan: Yoğurda sarımsak ezdim.

> AI: Tabağa koyduğumda rengi doğruydu.
> İnsan: Tabağa koyduğumda rengi tam olmuştu.

> AI: Mantılar suya girdiğinde yüzeye çıkmalarını izledim.
> İnsan: Mantıları suya attığımda yüzeye çıkmalarını izledim.

Three shapes, and they are worth telling apart because the repair differs.
The first is a **wrong pairing**: crushing is what happens to the garlic, not to
the yoghurt. The second is a **calque of an English pairing** — *the colour was
right* — where Turkish reaches for a different predicate entirely. The third is
**agency**: dumplings do not enter water, somebody puts them in, and the middle
voice quietly removes the cook from her own kitchen.

**How to find them, since no count will.** Ask, sentence by sentence, whether
somebody who has actually done this would describe it this way. That question
needs the world and not the grammar, which is why it belongs to the reading half
of `evals/rubric.md` and not to `count.sh`.

**Where it stops.** Do not rewrite a pairing that is merely unusual — Turkish
tolerates a fresh combination, and hunting for stock phrasing is how prose gets
flattened into cliché. The target is the pairing that is *wrong*, the one that
makes a reader stop and reconstruct what was meant. And an established term is
never a collocation error, however odd it looks from outside: *dava açmak*,
*hesap kesmek*, *sözleşme feshetmek* are what they are.

**What this rests on.** One paragraph, one reader, three findings — thinner than
most of this file. It is here on strength of a different kind: every one of the
three is checkable by anybody who has crushed garlic, so the evidence does not
depend on trusting the reader's ear. The paragraph had been through nine
evaluation rounds, both skills' outputs and every counting pass with none of
them noticed.
