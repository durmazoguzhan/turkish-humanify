**Register teşhisi:** Deneme-blog (pazarlama landing page — doğrudan hitap, konuşma tonu, ikinci tekil emir kipi). Kullanıcıya doğrulatma adımı atlandı, seçim skill tarafından yapıldı. Faz 2'de uygulanacaklar: Sinyal 15 (cümle uzunluğu patlamaları), Sinyal 16 (konuşma bağlaçları), Sinyal 17 (retorik soru), Sinyal 18 (öz-düzeltme), Sinyal 22 (birinci çoğul). Faz 2 landing page formatının izin verdiği ölçüde ölçülü uygulandı — pazarlama metni kararlı ses ister, aşırı tereddüt satmaz.

---

## 1. Tespit Raporu

**Baskın sinyaller**

- **Sinyal 1a — Cümle-içi uzun tire (2 örnek).**
  - Hero: "[Ürün Adı] küçük işletmeler için tasarlandı — muhasebe bilgisi gerektirmez."
  - Nakit akışı bloğu: "…tahmin edin — sürprizlerle değil, verilerle karar verin."
  - İkisi de TDK'nın konuşma çizgisi kullanımı değil, İngilizce em dash mantığı.

- **Sinyal 1b — Noktalı virgül suistimali (2 örnek).**
  - "Neden [Ürün Adı]?" listesi: "Web ve mobil uygulama; verileriniz her cihazda güncel."
  - SSS-1: "…bunun için tasarlandı; teknik terim yerine sade Türkçe kullanıyoruz."
  - İkisi de TDK'nın üç kullanımına girmiyor; klasik AI "iki fikri birleştir" noktalı virgülü.

- **Sinyal 12 — İngilizce vurgu-doldurucusu (1 örnek).**
  - SSS-1: "**tam da** bunun için tasarlandı." Cümleden çıkınca anlam kaybı yok.

**İkincil sinyaller**

- **Sinyal 11 — Pasif yapı (2 örnek).** "…faturanız doğrudan GİB'e **iletilir**", "[Ürün Adı] bunun için **tasarlandı**". Özne kayboluyor; ürünün ne yaptığını anlatan bir metinde bu maliyetli.
- **Sinyal 14 — Yüklemsiz fragment (2 örnek).** "…dışa aktarım tek tık.", "Şifreli altyapı, günlük yedekleme ve KVKK uyumlu veri saklama."

**Toplam:** 5 baskın + 4 ikincil = 9 sinyal.

**YOK olduğu için not düştüklerim** — metinde beklenip bulunmayanlar:

- Sinyal 2 (cümle monotonluğu): yok. Uzunluk varyansı zaten iyi — "Evet." gibi tek kelimelik patlamalar ile 15 kelimelik cümleler yan yana.
- Sinyal 3a ("-mektedir" salgını): sıfır. Metinde tek bir "-maktadır" bile yok.
- Sinyal 3b (bürokratik bağlaç yığını): sıfır. "Bu bağlamda", "söz konusu", "bu doğrultuda" hiç geçmiyor.
- Sinyal 3c (AI kapanış klişesi): sıfır. Hiçbir paragraf "kritik bir rol oynamaktadır" ile bitmiyor.
- Sinyal 4 ("sadece X değil, aynı zamanda Y"): sıfır. "Sorunuz olduğunda robot değil, insan yanıtlar" doğal Türkçe karşıtlık, o aile değil.
- Sinyal 5 (boş övgü + boş kapanış): sıfır. "Eşsiz", "benzersiz", "hayati", "kritik" yok.
- Sinyal 6 (adeta/sanki): sıfır.
- Sinyal 7 (zorlama üçlü liste): yok. Üçlülerin hepsi gerçekten ayrı şeyler (fatura/tahsilat/nakit akışı; KDV/tevkifat/e-belge).
- Sinyal 10 (somut anchor eksikliği): tersi geçerli — 30 saniye, 14 gün, GİB, KVKK, Excel, WhatsApp, e-Arşiv. Anchor bakımından zengin metin.
- Sinyal 13 (eş anlamlı rotasyonu): yok. "Mali müşavir" hep mali müşavir, "fatura" hep fatura.
- Sinyal 1d (bitişik "ki") ve 1e (slash-ayırıcı): sıfır.

Kısacası bu metin ortalama AI çıktısından belirgin şekilde temiz. Ağır olan tek şey noktalama katmanı.

---

## 2. Sinyal Yoğunluğu (Nicel Metrik)

Metin uzunluğu: ~375 kelime (başlıklar ve yer tutucular dâhil).

| | Sinyal sayısı | 100 kelimede |
|---|---|---|
| **Önce** | 9 | 2.4 |
| **Sonra** | 1 | 0.3 |

**İyileşme oranı: %89.**

Kalan 1 sinyal: fiyatlandırma bloğundaki yüklemsiz plan satırları (Sinyal 14 sınırında). Şablon gereği bilinçli bir liste formatı olduğu için dokunulmadı.

---

## 3. Onarılmış Versiyon

# [Ürün Adı]

## Hero
**Muhasebe, işinizin en zor kısmı olmasın.**

Faturanızı 30 saniyede kesin, tahsilatlarınızı otomatik takip edin, nakit akışınızı anlık görün. [Ürün Adı] küçük işletmeler için tasarlandı. Muhasebe bilgisi gerektirmez.

**[14 gün ücretsiz deneyin]** · Kredi kartı gerekmez, kurulum yok.

---

## Sorun
Ayın sonunda hangi faturanın ödendiğini Excel'de aramak, tahsilat için müşteriyi aramaya çekinmek, mali müşavire evrak yetiştirmek… Tanıdık geldi mi? Küçük işletmelerde muhasebe, asıl işten çalınan zamandır. Biz o zamanı size geri veriyoruz.

---

## Neler yapabilirsiniz

**Saniyeler içinde fatura kesin**
Müşterinizi seçin, kalemleri girin, gönderin. e-Fatura ve e-Arşiv entegrasyonu faturanızı doğrudan GİB'e iletir. Tekrar eden faturalar için bir kez tanımlayın, her ay kendisi çıksın.

**Tahsilatı takip etmeyi bırakın, sistem takip etsin**
Vadesi yaklaşan ve geçen faturalar için otomatik hatırlatma e-postaları gider. Hangi müşteri ne kadar borçlu, tek ekranda görün. Ortalama tahsilat sürenizin nasıl kısaldığını raporlarda izleyin.

**Nakit akışınızı önceden görün**
Gelir ve giderlerinizi kategorilere ayırın, banka hareketlerinizi eşleştirin. Önümüzdeki ay kasanızda ne kadar para olacağını bugünden görün. Sürprizle değil, veriyle karar verin.

**Mali müşavirinizle aynı sayfada olun**
Müşavirinize ücretsiz erişim verin. Dönem sonunda klasör taşımak, WhatsApp'tan fiş fotoğrafı göndermek yok. Tüm kayıtlar zaten sistemde, dışa aktarmak tek tık.

**Cari, stok ve gider yönetimi**
Müşteri ve tedarikçi carilerinizi, stok hareketlerinizi ve masraflarınızı tek yerden yönetin. Fişinizin fotoğrafını çekin, sistem tutarı ve tarihi kendisi okusun.

---

## Neden [Ürün Adı]?

- **Dakikalar içinde başlayın.** Kayıt olun, işletme bilgilerinizi girin, ilk faturanızı kesin. Eğitim ya da danışman gerekmez.
- **Her yerden erişin.** Web ve mobil uygulama var, verileriniz her cihazda güncel.
- **Verileriniz güvende.** Altyapı şifreli, yedekleme günlük, veri saklama KVKK'ya uygun.
- **Türkiye'ye özel.** KDV, tevkifat, e-belge süreçleri ve mevzuat güncellemeleri hazır gelir.
- **Gerçek destek.** Sorunuz olduğunda robot değil, insan yanıtlar.

---

## Fiyatlandırma
Şeffaf ve aylık. Sözleşme yok, istediğiniz an iptal edin.

**Başlangıç** — [X] TL/ay · Tek kullanıcı, aylık [X] fatura
**Profesyonel** — [X] TL/ay · Çoklu kullanıcı, stok ve banka entegrasyonu
**İşletme** — [X] TL/ay · Sınırsız fatura, çoklu şube, öncelikli destek

Tüm planlarda mali müşavir erişimi ücretsizdir.

---

## Sık sorulanlar
**Muhasebeden anlamıyorum, kullanabilir miyim?** Evet. Daha doğrusu, [Ürün Adı] zaten bunun için var. Teknik terim yerine sade Türkçe kullanıyoruz.
**Mevcut verilerimi taşıyabilir miyim?** Excel dosyanızı yükleyin, müşteri ve ürün listeniz otomatik aktarılsın. Ekibimiz isterseniz sizin için yapar.
**Deneme sürümü sonunda ne oluyor?** Otomatik ücretlendirme yok. Devam etmek isterseniz plan seçersiniz, verileriniz olduğu gibi kalır.

---

## Son çağrı
**Bu ayın kapanışını gece yarısı yapmayın.**
Bugün başlayın, ilk faturanızı 5 dakika içinde kesin.

**[Ücretsiz hesap oluştur]**

---

## 4. Notlar

**Faz 1'de ne yapıldı**

- İki cümle-içi uzun tire kaldırıldı. Hero'da tire yerine nokta konuldu ("…tasarlandı. Muhasebe bilgisi gerektirmez."), böylece ikinci yarı bağımsız bir vurgu cümlesi oldu. Nakit akışı bloğunda tire kaldırılıp cümle ikiye bölündü ve "tahmin edin" ifadesi "bugünden görün" ile değiştirildi — ürünün iddiası bir tahminden bir yetkinliğe döndü, bilgi içeriği aynı kaldı.
- İki noktalı virgül ayrıldı. "Web ve mobil uygulama; …" → "Web ve mobil uygulama var, …" (aynı zamanda yüklemsizlik de giderildi). SSS-1'deki noktalı virgül nokta oldu.
- "Tam da" silindi (Sinyal 12). Yerine kelime eklenmedi; vurgu cümle yapısıyla kuruldu.
- Pasif "GİB'e iletilir" → aktif "entegrasyon faturanızı GİB'e iletir". Özne belirginleşti. "Tasarlandı" pasifi ise SSS'de "zaten bunun için var" ile aktifleştirildi.
- İki yüklemsiz fragment tamamlandı: "dışa aktarım tek tık" → "dışa aktarmak tek tık"; "Şifreli altyapı, günlük yedekleme ve KVKK uyumlu veri saklama." → "Altyapı şifreli, yedekleme günlük, veri saklama KVKK'ya uygun." İkincisi aynı zamanda üç öğeyi paralel yüklem yapısına oturttu, daha Türkçe bir ritim verdi.

**Faz 2'de ne eklendi (register uygun olduğu için)**

- **Sinyal 17 — Retorik soru:** "Sorun" bölümüne "Tanıdık geldi mi?" eklendi. Üç uzun mastar öbeğinden sonra okuru sürece davet eden nefes noktası; landing page'de en doğal yer burasıydı.
- **Sinyal 15 — Cümle uzunluğu patlaması:** Aynı yerdeki "Tanıdık geldi mi?" ve hero'daki "Muhasebe bilgisi gerektirmez." kısa cümle patlaması işlevi görüyor. Metinde zaten "Evet." gibi patlamalar vardı, üstüne yığmadım.
- **Sinyal 18 — Öz-düzeltme:** SSS-1'de "Evet. Daha doğrusu, [Ürün Adı] zaten bunun için var." Tek örnekle sınırlı tutuldu.
- **Sinyal 16 — Konuşma bağlacı:** "Zaten" iki yerde çalışıyor (biri metinde zaten vardı, biri eklendi). "Ama / Oysa / Ne var ki" eklenmedi — metinde gerçek bir karşıtlık yoktu, zorlama olurdu.
- **Sinyal 22 — Birinci çoğul:** Zaten mevcuttu ("Biz o zamanı size geri veriyoruz", "kullanıyoruz", "Ekibimiz"). Artırılmadı.

**Register kısıtı nedeniyle muhafazakâr davrandığım yerler**

- Öz-düzeltme (Sinyal 18) deneme-blog register'ında serbest olsa da pazarlama metninde tereddüt satmaz. Tek, hafif bir örnekle bırakıldı.
- Konuşma tonu genişletilmedi ("valla", "yani" tarzı) — bu ton edebi-yaratıcı register'a ait, kurumsal bir ürün sayfasına yakışmaz.
- Fiyatlandırma ve CTA blokları yapısal alan sayıldı, dile dokunulmadı.

**Kasıtlı tercih sayıp dokunmadıklarım**

- "Sorun" bölümündeki üç nokta (…) — bilinçli bir asılı bırakma ritmi, AI tiki değil.
- Yer tutucular ([Ürün Adı], [X] TL/ay, köşeli parantezli buton metinleri) aynen korundu.
- Başlık hiyerarşisi, madde listesi, yatay ayraçlar, kalın vurgular ve orta nokta ayıracı (·) olduğu gibi bırakıldı.

**Dil dışı bir gözlem (bilginize):** Hero "faturanızı 30 saniyede kesin" diyor, son çağrı "ilk faturanızı 5 dakika içinde kesin" diyor. İkisi farklı şeyleri kastediyor olabilir (fatura kesme süresi ve kurulumdan ilk faturaya kadar geçen süre) ama okur bunu tutarsızlık olarak okuyabilir. Bir dil sinyali olmadığı için değiştirmedim.
