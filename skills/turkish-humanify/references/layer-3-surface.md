# Layer 3 — Surface

Terminology, orthography, punctuation, numbers.

This layer is always on, in every register, because none of it is style. A
misplaced apostrophe is not a voice choice, and neither is translating a term
that has no Turkish equivalent. The two other layers can be dialled down for
an academic paper; this one cannot.

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
long dash belongs to dialogue lines and to ranges. Using it the English way —
to bracket an aside — is the single punctuation calque that survives into
otherwise clean machine Turkish. Replace it with a semicolon, a connective
(`böylece`, `bu sayede`, `ayrıca`, `çünkü`), or a sentence break.

> AI: Kurulum sihirbazı projelerinizi aktarır — böylece ilk günden dolu bir çalışma alanıyla başlarsınız.
> İnsan: Kurulum sihirbazı projelerinizi aktarır; böylece ilk günden dolu bir çalışma alanıyla başlarsınız.

**The Turkish semicolon is legitimate and must not be purged.** It joins
closely related independent clauses and separates grouped list items. What
grates is the English `; and` chain, not the mark itself. Removing every
semicolon from Turkish prose is its own kind of damage.

**Range dashes are correct** and are not the same thing: `04.30–05.00`,
`Nisan–haziran`, `3–4 kilometre`, `MÖ 738 – MÖ 696`. Leave them alone.

---

## 6. Numbers and units

- The percent sign leads: `%41`, not `41%`.
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

**An honest note on this section.** Across the twelve-text baseline corpus and
the human reference texts, this list scored zero hits on both sides. Nothing
here has been shown to detect anything in current model output. It is kept as a
guard against phrases that would be wrong if they appeared, not as evidence
that they do.
