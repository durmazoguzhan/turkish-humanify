# Voices

A voice is not "samimi" or "akıcı". Those words carry no instruction — two
writers told to be samimi produce different texts, and neither can tell whether
they succeeded.

A voice here is a position on **nine observable dimensions**, plus real
sentences that occupy that position. The sentences do most of the work; the
dimensions exist so a voice can be extracted from a sample, compared, and
checked.

---

## The nine dimensions

1. **Address** — ben / biz / sen / siz / impersonal
2. **Mean sentence length and variance** — roughly, and how wide the swing is
3. **Preferred clause linkage** — `ve` / converb / semicolon / sentence break
4. **Tense-mood distribution** — where `-DI`, `-mIş`, `-yor` and the aorist sit
5. **Particle density** — none / sparse / frequent
6. **Terminology preference** — English terms kept, or established Turkish
7. **Inversion rate** — never / two or three per piece / frequent
8. **Paragraph length** — uniform, or swinging between one line and eight
9. **Concreteness** — numbers, names and examples per paragraph

---

## Profiles

### `senli-benli anlatıcı`
Travel and lifestyle blogging. The default voice for blog register.

address **sen** · length short, wide swing · linkage converb and sentence break ·
mood `-DI` and `-mIş`, aorist for asides · particles **frequent** ·
terminology established Turkish · inversion frequent · paragraphs uneven ·
concreteness high — real place names, real prices

> Bugünlük piyasaları ve borsaları bir kenara bırakıp keyifli bir hikaye dinlemeye ne dersin?
> O zaman Midas'ı, bir de Midas'tan dinle.
> Selanik'e kimimizi arabayla çıkılan bir Balkanlar turu getiriyor, kimimizi komşudan alınan Schengen vizesine "Aman ilk giriş Yunanistan'dan olsun"culuk.
> Güzeldi orası, gerçekten.

### `teknik anlatıcı`
An engineer explaining to a peer, not to a beginner and not to a manager.

address **biz / impersonal, occasional sen** · length medium, moderate swing ·
linkage converb and semicolon · mood aorist and `-yor` · particles **sparse** ·
terminology English terms kept · inversion rare · paragraphs even ·
concreteness high — commands, numbers, failure modes

> Cache'leme kolaydır. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermektir.
> `KEYS user:1042:*` komutu asla kullanılmamalı; Redis tek thread'li çalıştığı için bu komut tüm sunucuyu bloke eder.
> Blog yazısı beş dakika eski kalabilir. Stok adedi kalamaz.

### `denemeci`
A thinking first person. Essay register, and the voice to reach for when the
piece has a turn in it rather than a list.

address **ben** · length wide swing, deliberately · linkage sentence break ·
mood `-DI` and aorist, `-mIş` for things realised later · particles sparse but
placed · terminology either, consistently · inversion two or three per piece ·
paragraphs uneven, one-sentence paragraphs used as pivots · concreteness
moderate — one concrete image carrying an abstract point

> Ben galiba o dikkati sevdim.
> Tadı da güzel oluyor tabii. Ama asıl mesele o değil.
> Meğer ölçmediğim her değişken her sabah kendi kafasına göre davranıyormuş.

### `kurumsal ama insan`
A brand addressing `siz`. Short, committed, no inflated adjectives, no emoji.

address **siz** · length short, low swing · linkage sentence break · mood
`-yor` and aorist · particles none · terminology established Turkish ·
inversion never · paragraphs short and even · concreteness high — prices,
hours, what actually happens next

> Fişin fotoğrafını çekmeniz yeterli; tutarı da tarihi de sistem kendisi okur.
> Beş kişiye kadar ücretsiz. Sonrası kullanıcı başına aylık 90 TL.
> Sözleşme yok, istediğiniz an iptal edersiniz.

### `nötr-resmi`
Academic and official. Impersonal but correct and fluent — the goal here is
not personality, it is prose that does not fight its reader.

address **impersonal** · length long, moderate swing · linkage semicolon and
`-mektedir` chains · mood `-mektedir` and `-DIr` · particles none ·
terminology established Turkish, English in parentheses on first use ·
inversion never · paragraphs long and even · concreteness moderate — citations
and defined terms

> Bu çerçeve, uzaktan eğitim bağlamında özellikle işlevseldir; çünkü çevrim içi ortamlar öğrenciye belirgin bir özerklik sunarken ilişkiselliği zayıflatma riski taşımaktadır.
> Ampirik alanyazın tek yönlü bir tablo sunmamaktadır.

---

## Extracting the user's own voice

When the user supplies a sample and says "şu metindeki gibi yaz", read the nine
dimensions off it **and write them down before writing anything**. Skipping
that step is how the next failure happens.

**The failure to avoid: extracting the topic instead of the voice.** Given a
travel piece as a sample and asked to write about database migrations, the
wrong move is to reach for scenery, second-person address and warmth because
the sample had them *as a travel writer*. The right move is to ask which of the
nine dimensions are properties of this writer and which are properties of that
subject. Sentence rhythm, clause linkage, particle density and inversion rate
travel across topics. Concrete imagery and address often do not.

If the sample is short — under a few hundred words — say so rather than
inventing a full profile from it. Three dimensions read confidently off a real
sample beat nine guessed from a paragraph.

---

## Choosing

Default to the register's own voice: blog → `senli-benli anlatıcı`, technical →
`teknik anlatıcı`, corporate → `kurumsal ama insan`, academic → `nötr-resmi`.
`denemeci` is never a default; it is chosen, because it puts a first person in
the text and that is a decision the writer has to want.

The user overrides by naming a profile, or by supplying a sample.
