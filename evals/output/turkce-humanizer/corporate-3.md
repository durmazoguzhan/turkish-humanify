# Türkçe Humanizer — corporate-3.md

**Register teşhisi:** Akademik-kurumsal (kurum içi politika duyurusu / şirket e-postası).
Metin bir e-posta olduğu için tonu analitik registerin sınırına yaklaşıyor, ama insanların üzerine iş kurup uygulayacağı bir politika metni olması nedeniyle muhafazakâr tarafta kaldım. Faz 2'de yalnızca **Sinyal 15 (cümle uzunluğu varyansı)** ve **Sinyal 18 (öz-düzeltme)** devrede. Konuşma bağlaçları, retorik soru, duyusal detay uygulanmadı.

*(Skill normalde register'ı kullanıcıya doğrulatır; bu çalıştırmada karar bana bırakıldığı için yukarıdaki seçimi kendim yaptım.)*

---

## 1. Tespit Raporu

Belge 8 gövde paragrafı + 4 bölüm başlığı + selamlama/imza bloğu. Paragraf sınıflandırması:

| Sınıf | Paragraflar |
|-------|-------------|
| Yüksek AI-imzalı (3+ baskın sinyal) | — yok |
| Orta AI-imzalı (1-2 baskın sinyal) | P4 ("Çalışma saatleri"), P8 ("Sırada ne var") |
| Temiz (0 baskın sinyal) | P1, P2, P3, P5, P6, P7, P9 |

**Bulunan sinyaller:**

- **Sinyal 1b — Noktalı virgül suistimali (baskın).** İki gerçek ihlal:
  - P4, c.2: "…ulaşılabilir olmanızı bekliyoruz**;** gerisini kendi ritminize göre düzenleyebilirsiniz." — İki bağımsız cümle, ögeleri arasında virgül yok, gruplama yok, vurgu amaçlı özne-sonrası kullanım değil. TDK'nın üç kullanımının hiçbirine girmiyor; klasik AI "iki fikri birleştir" hamlesi.
  - P8, c.2: "…soru-cevap toplantısı yapacağız**;** takvim davetini bugün göndereceğiz." — Aynı yapı.
- **Sinyal 1b — tespit edildi, ihlal sayılmadı.** P2, c.3: "Ofis günlerini ekipler kendi içinde belirleyecek**;** tek şartımız, aynı ekipteki herkesin en az bir gününün ortak olması." İkinci sıralı cümlenin ögeleri arasında virgül var. TDK'nın 2. kullanımına giriyor. **Dokunmadım.**
- **Sinyal 8 — Devrik cümle yokluğu (ikincil).** 330 kelimelik belgede tek bir devrik cümle yok. Tek başına zayıf bir sinyal ama belge boyu bu kadar düz kalması dikkat çekiyor.
- **Sinyal 1c — tespit edildi, ihlal sayılmadı.** P4/P5/P6 birer iki nokta üst üste ile açılıyor ("Çalışma saatleri:", "Ekipman:", "Yurt dışından çalışma:"). Bunlar cümle-içi mini açıklama değil, paragraf başı konu etiketi — belge iskeletinin parçası. **Yapı Koruma** gereği yerinde bırakıldı.

## 2. Sinyal Yoğunluğu

Belge uzunluğu: ~330 kelime.

| | Sinyal sayısı | 100 kelime başına |
|---|---|---|
| **Önce** | 3 (1b ×2, 8 ×1) | **0,9** |
| **Sonra** | 0 | **0,0** |

**İyileşme oranı: %100.** Ama asıl bulgu şu: başlangıç yoğunluğu zaten çok düşüktü. Referans olarak skill'in ağır AI-imzalı metin örneği 8,4 sinyal/100 kelime. Bu metin onun sekizde biri. Bu bir temizleme değil, rötuş.

## 3. Onarılmış Versiyon

Konu: Uzaktan Çalışma Politikamız 1 Eylül'de Yürürlüğe Giriyor

Merhaba,

Uzun süredir üzerinde çalıştığımız uzaktan çalışma politikasını sonunda paylaşabiliyoruz. Geçtiğimiz yıl boyunca yaptığımız denemeler, ekip anketleri ve yöneticilerle yürüttüğümüz görüşmeler sonucunda ortaya çıkan modeli aşağıda özetledim.

**Nasıl çalışacağız**

1 Eylül itibarıyla hibrit bir düzene geçiyoruz. Herkes haftanın iki gününü ofiste, kalan üç gününü dilediği yerden geçirebilecek. Ofis günlerini ekipler kendi içinde belirleyecek; tek şartımız, aynı ekipteki herkesin en az bir gününün ortak olması. Böylece planlama toplantıları, tasarım incelemeleri ve yeni katılan arkadaşların işe alışma süreci yüz yüze ilerleyebilecek.

Tam zamanlı uzaktan çalışmak isteyenler için ayrı bir başvuru yolu var. Rolü buna uygun olan ve şirkette ilk altı ayını tamamlamış herkes, yöneticisinin onayıyla başvurabilir. Başvuruları İK ile birlikte üç haftada bir değerlendireceğiz.

**Pratik konular**

Çalışma saatleri: 10.00-16.00 arası ortak mesai saatimiz olacak. Bu aralıkta ulaşılabilir olmanızı bekliyoruz. Gerisini kendi ritminize göre düzenleyebilirsiniz.

Ekipman: Evden çalışanlara bir defaya mahsus 15.000 TL'lik kurulum bütçesi tanımlıyoruz. Sandalye, masa, monitör, kulaklık gibi ihtiyaçlarınızı bu bütçeden karşılayabilirsiniz. Talep formunu intranette "Uzaktan Çalışma" başlığı altında bulacaksınız.

Yurt dışından çalışma: Vergi ve sigorta yükümlülükleri nedeniyle yılda en fazla 30 gün mümkün, önceden bildirmek kaydıyla. Daha uzun süreler İK onayına tabi.

**Neden bu model**

Denemeler bize iki şeyi gösterdi. Odaklanma gerektiren işlerde evden çalışmak verimi belirgin biçimde artırıyor. Buna karşılık yeni fikirlerin çıktığı, sorunların birkaç dakikada çözüldüğü anların çoğu hâlâ aynı odada bulunmaktan doğuyor. Hibrit model bu ikisini birden korumaya çalışıyor.

Politikanın taşa kazınmış olmadığını da belirtmek isterim. Daha doğrusu, bir kısmını uygularken öğreneceğiz. İlk altı ayın sonunda tekrar anket yapacak, işleyen ve işlemeyen tarafları birlikte gözden geçireceğiz. Ekiplerden gelen geri bildirim, bu politikayı bugünkü hâline getiren şeyin ta kendisi.

**Sırada ne var**

Önümüzdeki hafta yöneticiler ekipleriyle ofis günlerini netleştirecek. 25 Ağustos'ta tüm şirkete açık bir soru-cevap toplantısı yapacağız. Takvim davetini bugün göndereceğiz. Politikanın tam metnine intranetten ulaşabilirsiniz.

Aklınıza takılan bir şey olursa bana ya da İK'dan [İsim]'e yazmaktan çekinmeyin. Özellikle bakım yükümlülüğü, ulaşım mesafesi gibi kendine özgü durumları olan arkadaşlarımız için ayrıca çözüm bulmaya çalışacağız.

İyi çalışmalar,

[İsim]
[Unvan]

## 4. Notlar

**Yapılan dört müdahale:**

1. **P4, c.2 — Sinyal 1b onarımı.** Noktalı virgül noktaya çevrildi, cümle ikiye ayrıldı. "Gerisini kendi ritminize göre düzenleyebilirsiniz." artık kendi başına duruyor; politika metninde bu cümlenin ayrı durması içerik olarak da daha net.
2. **P8, c.2 — Sinyal 1b onarımı.** Aynı işlem. Yan fayda: paragrafın cümle uzunlukları 7-10-5-5'e indi, Sinyal 15 açısından daha nefesli.
3. **P6, c.1 — Sinyal 8 onarımı.** "…yılda en fazla 30 gün, önceden bildirmek kaydıyla mümkün" → "…yılda en fazla 30 gün mümkün, önceden bildirmek kaydıyla." Yüklem öne alındı, koşul arkaya düştü. Belgedeki tek devrik cümle bu ve zorlama değil — cümle zaten bu sıralamada daha rahat okunuyor. Anlam birebir korundu.
4. **P7 — Faz 2 / Sinyal 18 enjeksiyonu.** "Daha doğrusu, bir kısmını uygularken öğreneceğiz." cümlesi eklendi. Yazarın kendi iddiasını yumuşatıp yeniden ifade etmesi. Bilgi olarak yeni bir şey söylemiyor; hemen ardından gelen "ilk altı ayın sonunda tekrar anket yapacağız" taahhüdünün zaten söylediği şeyi açık ediyor. 6 kelime olduğu için aynı zamanda Sinyal 15 patlaması işlevi görüyor.

**Kasıtlı tercih sayıp dokunmadıklarım:**

- P2'deki noktalı virgül. TDK-uygun (ikinci sıralı cümlenin ögeleri arasında virgül var). Belgedeki üç noktalı virgülden yalnızca bu meşru; silmek yazarın doğru kullandığı bir işareti cezalandırmak olurdu.
- "Pratik konular" bölümündeki üç konu etiketi ("Çalışma saatleri:", "Ekipman:", "Yurt dışından çalışma:"). Yapı Koruma kapsamında — bunlar cümle içi noktalama değil, alt başlık işlevi gören belge iskeleti.
- Başlıklar, kalın vurgular, selamlama/imza bloğu, "Konu:" satırı: hiçbirine dokunulmadı.

**Register kısıtı nedeniyle uygulanmayanlar:** Sinyal 16 (konuşma bağlaçları), 17 (retorik soru), 19 (duyusal detay), 20 (zaman kipi kayması), 21 (diyalog izi). Metin bir e-posta olduğu için bunlara register açık gibi görünebilir, ama insanların uygulayacağı bir politika duyurusunda "Ne var ki", "Peki bu doğru mu?" gibi hamleler ciddiyeti aşındırır. Muhafazakâr kaldım.

**YOK olduğu için not düştüklerim** — beklenip bulunamayan sinyaller, yani yazarın hanesine yazılacaklar:

- **Sinyal 1a — uzun tire enflasyonu:** sıfır. Belgede tek bir em dash yok. Kurumsal AI metinlerinde en sık görülen imza bu, hiç yok.
- **Sinyal 2 — cümle monotonluğu:** yok. Uzunluklar 5 ile 18 kelime arasında serbestçe geziniyor. "Denemeler bize iki şeyi gösterdi." (5 kelime) tam da skill'in Faz 2'de *yerleştirmeyi* önerdiği nefes noktası — yazar kendi koymuş.
- **Sinyal 3a — "-mektedir/-maktadır" salgını:** sıfır kullanım. Belge boyunca şimdiki zaman ve gelecek zaman, aktif çatı.
- **Sinyal 3b — bürokratik bağlaç yığını:** sıfır. "Bu bağlamda", "söz konusu", "bu doğrultuda", "bu çerçevede" hiç geçmiyor. Yerlerinde gerçek mantıksal bağlar var: "Böylece", "Buna karşılık".
- **Sinyal 3c — AI kapanış klişeleri:** sıfır. "Kritik bir rol oynamaktadır" ailesinden hiçbir şey yok.
- **Sinyal 4 — "sadece X değil, aynı zamanda Y":** sıfır. En dirençli AI imzası, hiç yok.
- **Sinyal 5 — boş övgü ve boş kapanış:** sıfır. "Eşsiz", "hayati", "kritik", "vazgeçilmez" yok. Paragraflar bilgiyle bitiyor, değerlendirmeyle değil.
- **Sinyal 6 — "adeta/sanki" bağımlılığı:** sıfır.
- **Sinyal 7 — zorlama üçlü liste:** yok. Listeler var ama hepsi gerçek ("denemeler, anketler, görüşmeler" üç ayrı yöntem; "sandalye, masa, monitör, kulaklık" dört ayrı eşya). Ritim doldurma yok.
- **Sinyal 10 — somut anchor eksikliği:** tam tersi. 1 Eylül, iki gün/üç gün, altı ay, üç haftada bir, 10.00-16.00, 15.000 TL, 30 gün, 25 Ağustos. Bir politika duyurusundan beklenen her sayı yerinde. Bu metnin en insani tarafı bu.
- **Sinyal 11 — pasif yapı bağımlılığı:** yok. Aksine birinci çoğul hâkim ("geçiyoruz", "bekliyoruz", "tanımlıyoruz", "değerlendireceğiz") — bu zaten Sinyal 22'nin kendisi, Faz 2'de eklemeye gerek kalmadı.
- **Sinyal 12 — İngilizce vurgu-doldurucuları:** sıfır. "Tam da", "tam anlamıyla", "esasen", "nihayetinde" yok.
- **Sinyal 13 — eş anlamlı rotasyonu:** yok. "Ekip" baştan sona "ekip"; "politika" baştan sona "politika". Türkçenin sevdiği tekrar.
- **Sinyal 14 — fragment cümle bağımlılığı:** yok. "Daha uzun süreler İK onayına tabi." kısa ama tam bir isim cümlesi, fragment değil.

**Genel değerlendirme:** Bu metin insan yazısı gibi okunuyor ve büyük ihtimalle öyle. "Taşa kazınmış olmadığını", "şeyin ta kendisi", "aklınıza takılan bir şey" gibi deyimsel kullanımlar, bakım yükümlülüğü ve ulaşım mesafesi gibi gerçek hayattan gelen istisna örnekleri, sayıların bolluğu — bunların hiçbiri LLM refleksi değil. Dört müdahale yaptım, üçü noktalama ve söz dizimi rötuşu. Bu belgeye daha fazlasını yapmak, düzeltmek değil bozmak olurdu.
