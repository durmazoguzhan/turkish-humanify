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

*Who is speaking:* someone who just got back and is telling you about it across a table, not writing it up.

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

*Who is speaking:* the colleague who debugged this at 2am last month and is saving you the same night.

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

*Who is speaking:* someone working out what they think while writing, and willing to let you watch.

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

*Who is speaking:* the founder answering a customer's email personally, because the company is still small enough that they do.

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

*Who is speaking:* nobody, deliberately — but a nobody who has been edited by someone competent.

address **impersonal** · length long, moderate swing · linkage semicolon and
`-mAktAdIr` chains · mood `-mAktAdIr` and `-DIr` · particles none ·
terminology established Turkish, English in parentheses on first use ·
inversion never · paragraphs long and even · concreteness moderate — citations
and defined terms

> Bu çerçeve, uzaktan eğitim bağlamında özellikle işlevseldir; çünkü çevrim içi ortamlar öğrenciye belirgin bir özerklik sunarken ilişkiselliği zayıflatma riski taşımaktadır.
> Ampirik alanyazın tek yönlü bir tablo sunmamaktadır.

---

## Where voice comes from — and where it must not

**Repair mode.** This section governs rewriting a supplied text. In write mode
there is no source, so the boundary it draws does not apply the same way — see
`write-mode.md`, "Facts you do not have".

It exists because of a measured result.

In a blind comparison, a judge ranked one text first and named three sentences
as proof a human wrote it: *"Aşağıdaki rotayı biz de yürüdük"*, *"Bizde kalan,
sabahın köründe vadiye çöken o sessizlik oldu"*, *"Adı katedral, aslı
manastır"*. None of the three was in the source. A voice had been manufactured
by inventing the writer's experience.

The judge was not wrong that those sentences read as human. **That is the
problem.** Inventing first-person experience is the fastest available route to
sounding like a person, which means a "does this read as human" test can be won
by lying, and a skill that optimises for it will learn to lie.

**Voice comes from stance toward material that is already there.** Not from
new material.

Available, always:

- **Ordering** — what you put first, what you make the reader wait for
- **Emphasis** — which of the source's own points gets the preverbal slot
- **Hedging** — *sanırım*, *bana kalırsa*, *galiba*, *bildiğim kadarıyla*, where
  the source's own claim is genuinely uncertain
- **Admitting difficulty** — *burası kolay değil*, *bunu ilk okuduğumda
  anlamamıştım*, where the material really is hard
- **Self-correction** — see below
- **Register and address** — the nine dimensions above

Forbidden, always:

- A first-person experience the source does not report: *biz de gittik*, *bizde
  kalan*, *denedim*, *başıma geldi*
- A fact, name, date, number or causal explanation the source does not contain
- Turning the source's advice to the reader into the writer's own decision:
  source *"turu ikinci güne koymak akıllıca"* → output *"turu neden ikinci güne
  koyduk?"* is a fabrication, not a rewrite

**In write mode this boundary does not transfer,** because there is no source to
have exceeded. Whether a draft carries plausible specifics or leaves them open
belongs to the conversation the user is having, not to this skill. See
`write-mode.md`.

### Self-correction

The device the blind judges rewarded most consistently is the writer visibly
revising mid-sentence: *"Daha doğrusu, …"*, *"Ya da şöyle demek daha doğru
olur"*, *"Ya da değildi, bilmiyorum"*, *"Ya da daha dikkatli söyleyelim, …"*.

It works because it shows someone thinking rather than reciting.

> AI: Silme işlemi idempotenttir, bu yüzden tercih edilir.
> İnsan: Silme idempotent olduğu için tercih ediliyor. Daha doğrusu, güncellemek de çalışır; ama yanlış gittiğinde sessizce yanlış gider.

**The limit, and it is strict.** The correction must correct something. Judges
penalised it exactly as often as they rewarded it when it did not: *"hiçbir
düzeltme getirmeyen 'Ya da şöyle demek daha doğru olur' ara cümlesi"*, *"araya
sıkıştırılmış, akışı bozan yapay bir samimiyet eki"*. And the corrected version
must still be a claim the source makes — narrowing or qualifying what is there,
never adding.

At most once or twice in a piece. It is a hesitation, and a writer who
hesitates in every paragraph is not thinking, they are performing.

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
