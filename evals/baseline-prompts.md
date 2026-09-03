# Baseline prompts

The twelve files in this directory are raw LLM Turkish. Each was produced by a
separate subagent with clean context, given only the short prompt below and a
length hint. No prompt engineering, no mention of this project, no style
guidance.

The prompts are deliberately the kind of thing a Turkish user actually types.
An elaborate prompt would produce an elaborate answer, and the baseline would
then measure the prompt rather than the model. What we want on file is what an
LLM hands a normal person who asks for a blog post in Turkish.

| File | Prompt |
|---|---|
| `blog-1.md` | Kapadokya'da 3 gün nasıl geçirilir, bir blog yazısı yaz. |
| `blog-2.md` | Evde kahve demlemeyi ciddiye almak üzerine bir yazı yaz. |
| `blog-3.md` | Tek başına seyahat etmek hakkında bir blog yazısı yaz. |
| `technical-1.md` | Redis'te cache invalidation üzerine bir yazı yaz. |
| `technical-2.md` | Mikroservislerde dağıtık transaction yönetimini anlatan bir yazı yaz. |
| `technical-3.md` | Git rebase ile merge arasındaki farkı anlatan bir yazı yaz. |
| `corporate-1.md` | SaaS ürünümüz için landing page metni yaz. Ürünümüz küçük işletmeler için bir ön muhasebe ve fatura takip yazılımı. |
| `corporate-2.md` | Yeni açılan kahve dükkanımız için Instagram tanıtım metni yaz. |
| `corporate-3.md` | Şirketimizin uzaktan çalışma politikasını duyuran bir e-posta yaz. |
| `academic-1.md` | Yapay zekânın eğitimdeki rolü üzerine bir makale girişi yaz. |
| `academic-2.md` | Kentleşmenin sosyal ilişkiler üzerindeki etkisi hakkında bir makale özeti yaz. |
| `academic-3.md` | Uzaktan eğitimin öğrenci motivasyonuna etkisi üzerine bir literatür taraması girişi yaz. |

## What was edited out

Nothing inside the texts. Several subagents ended their reply with a line
addressed to whoever dispatched them — "yaklaşık 380 kelime", "istenirse tonu
daha samimi hale getirebilirim", "köşeli parantezleri kendi bilgilerinizle
doldurun". Those are the assistant talking to its caller, not part of the
requested text; a user pasting the result into a CMS would not carry them
across either. They were removed and nothing else was touched.

## Two contamination incidents, and how they were caught

**Reading the repository.** The first batch ran with this repository as their
working directory, and five of the twelve used file tools. Three of those read
`docs/design/2026-08-17-turkish-humanify-design.md` and `evals/rubric.md`
before writing a word, then said so in their reports and refused to file their
output — correctly. One of them measured itself: `len_sd` 6.7, zero em dashes,
zero calques. It had written skill *output*, not a baseline. All five were
re-run with one added constraint that says nothing about style: do not read or
write files, do not use tools.

**Reading the directory name.** The re-run of `corporate-1` used no tools at
all and still came back as a landing page for an AI Turkish-humanising product.
The working directory is named `turkish-humanify`, and that name reaches the
subagent through its environment. The prompt was reissued naming a neutral
product. Any future corpus work should assume the directory name is visible
even to a subagent that touches nothing.

## Baseline signals

Measured with `evals/count.sh`. Frequency columns are per 100 words.

```
file            words  sentences  len_mean  len_sd  em_dash  mektedir_p  dir_p  mis_p  ve_p  part_p  calque_p  forced  tilde  pct_wrong  bold  bullets
academic-1.md   356    25         14.2      6.6     0        0.0         0.0    0.6    1.1   1.1     0.0       0       0      0          0     0
academic-2.md   358    23         15.6      6.0     0        0.6         4.5    0.3    2.8   0.3     0.3       0       0      0          1     0
academic-3.md   377    15         25.1      10.6    0        1.1         3.4    0.5    4.5   0.5     0.0       0       0      0          1     0
blog-1.md       252    21         12.0      5.1     0        0.0         0.4    1.2    4.0   0.4     0.0       0       0      0          16    4
blog-2.md       344    36         9.5       5.4     5        0.0         2.3    0.9    0.9   0.9     0.0       0       0      0          0     0
blog-3.md       334    30         11.1      3.9     0        0.0         2.1    0.6    0.3   0.3     0.0       0       0      0          0     0
corporate-1.md  186    22         8.5       3.0     5        0.0         1.1    0.0    7.0   0.5     0.0       0       0      0          20    5
corporate-2.md  340    38         8.8       5.8     4        0.0         0.0    0.0    1.5   0.0     0.0       0       0      0          0     0
corporate-3.md  314    33         9.5       4.7     0        0.0         0.0    0.6    1.6   0.0     0.0       0       0      0          4     0
technical-1.md  357    33         10.8      5.1     0        0.0         3.9    0.6    2.0   0.8     0.0       0       0      0          1     0
technical-2.md  208    18         11.6      5.8     0        0.0         7.7    1.4    3.8   1.4     0.0       0       0      0          6     0
technical-3.md  410    34         12.1      5.5     0        0.0         1.2    1.5    2.0   1.0     0.0       0       0      0          5     0
```

**The `technical-1` row was corrected on 2026-09-04, and the reason is a
counting bug, not a changed text.** `count.sh`'s prose view was reading fenced
code as Turkish prose, so this file's three Redis commands were contributing
eighteen words and three sentences to its own denominator. `technical-4` and
`technical-5` moved for the same reason and are not in this table. Nothing else
in the corpus changed, and no conclusion in `RESULTS.md` rests on the figures
that moved — the semicolon and `-mAktAdIr` bands are calibrated on
`human-reference/`, which contains no code and did not move.

These numbers are not what the plan predicted, and the discussion of why — plus
the three measurement bugs the calibration exposed on the way — is in
`evals/rubric.md` under "Calibration results".

## The reference-shaped corpus, added 2026-09-04

Issue #9 reported a repair that dissolved a two-item evidence list into one
running paragraph, and the corpus could neither confirm nor reject it: across
the twenty-one baselines there were **no tables at all**, and exactly one
technical file carried a real bullet list. Every input was prose. A rule about
what happens to a document's structure cannot be measured on a corpus that has
none, so four reference-shaped baselines were generated the same way as the
original twelve — separate subagents, clean context, no tools, no style
guidance.

| File | Prompt |
|---|---|
| `reference-1.md` | Bir kod tabanında bir endpoint'in nereden çağrıldığını araştırdın. Bulgularını, teknik bir analiz dokümanının "Kanıt" bölümü olarak yaz. |
| `reference-2.md` | Bir sipariş servisinin REST API'si için Türkçe referans dokümantasyonu yaz. Endpoint'ler, parametreler, dönüş kodları ve örnek istek yer alsın. |
| `reference-3.md` | Üretim ortamında veritabanı bağlantı havuzu tükendiğinde nöbetçi mühendisin izleyeceği adımları bir runbook olarak yaz. |
| `reference-4.md` | Dün yaşanan bir ödeme kesintisi için Türkçe bir incident raporu yaz. İçinde zaman çizelgesi tablosu, etki, kök neden ve alınacak aksiyonlar olsun. |

`prose_pct` is what these were added for: 20.9, 18.7 and 41.0 for the three
structured ones, against 87–99 for every prose baseline in the corpus. Between
them they carry 42 table rows, 10 bullets, 25 headings and 2 code fences.

**`reference-1` came back as unbroken prose and is kept that way on purpose.**
The prompt asked for an evidence section and the model wrote six paragraphs with
no list in them. That makes it the control the round needed anyway: a
reference-register document that is prose-shaped, where a structure rule must do
nothing.

**Two blog prompts were run and neither is in the corpus.** *"Uzaktan çalışırken
odaklanmayı korumak üzerine bir blog yazısı yaz"* and *"Ev taşırken nelere
dikkat edilmeli, bir blog yazısı yaz"* were generated to serve as the positive
control for `layer-1-structure.md` §5 — a blog post whose list a human editor
would dissolve. **Both came back with zero bullet lists**, as did `blog-2`
through `blog-6` before them; the only blog baseline in the corpus that bullets
anything is `blog-1`, and its list is a day-by-day itinerary that the rule
correctly leaves alone.

That is worth stating as a finding rather than filing as a failed attempt:
**current unaided model Turkish does not bullet a blog post.** §5's list-to-prose
conversion therefore has no positive test case in blog register and cannot be
given one without prompting for a list, which would measure the prompt. The rule
is not thereby wrong — it is unmeasured, which is a different thing and should
be read as such wherever it is cited.
