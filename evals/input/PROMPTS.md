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
blog-1.md       252    21         12.0      5.1     4        0.0         0.4    1.2    4.0   0.4     0.0       0       0      0          16    4
blog-2.md       344    36         9.5       5.4     5        0.0         2.3    0.9    0.9   0.9     0.0       0       0      0          0     0
blog-3.md       334    30         11.1      3.9     0        0.0         2.1    0.6    0.3   0.3     0.0       0       0      0          0     0
corporate-1.md  186    22         8.5       3.0     5        0.0         1.1    0.0    7.0   0.5     0.0       0       0      0          20    5
corporate-2.md  340    38         8.8       5.8     4        0.0         0.0    0.0    1.5   0.0     0.0       0       0      0          0     0
corporate-3.md  314    33         9.5       4.7     0        0.0         0.0    0.6    1.6   0.0     0.0       0       0      0          4     0
technical-1.md  375    36         10.2      5.3     0        0.0         3.7    0.5    1.9   0.8     0.0       0       0      0          1     0
technical-2.md  208    18         11.6      5.8     0        0.0         7.7    1.4    3.8   1.4     0.0       0       0      0          6     0
technical-3.md  410    34         12.1      5.5     0        0.0         1.2    1.5    2.0   1.0     0.0       0       0      0          5     0
```

These numbers are not what the plan predicted, and the discussion of why is in
`evals/rubric.md` under "Calibration results". Short version: most of the AI
tells this field talks about are already gone from this model's Turkish, and
the ones that remain are structural rather than lexical.
