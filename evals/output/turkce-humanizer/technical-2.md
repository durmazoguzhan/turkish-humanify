# Türkçe Humanizer — Çıktı Raporu

**Kaynak:** `evals/input/technical-2.md`
**Register teşhisi:** Analitik / teknik blog (Deneme-blog ucunda). Metin baştan sona "siz" hitabı kullanıyor, retorik soru zaten var, ton öğretici ama resmi değil. Bu yüzden Faz 2'yi tam uyguladım — argo ve ağır konuşma dili ("valla," "ulan") hariç, çünkü metin teknik bir referans olarak da okunacak.

*(Skill register onayı istiyor; talimat gereği kararı kendim verdim ve ilerledim.)*

---

## 1. Tespit Raporu

Metin **zaten temiz sayılır**. Türkçe AI metinlerinin en ağır fenotipleri burada yok. Bulunanlar ağırlıklı olarak noktalama katmanında.

### Baskın sinyaller

**Sinyal 1b — Noktalı virgül suistimali (3 örnek).** Üçü de TDK'nın tanıdığı üç kullanımın hiçbirine girmiyor; klasik AI "iki fikri birleştir" hamlesi:
- Saga paragrafı: *"...geri alma (rollback) yapmazsınız; onun yerine..."*
- Outbox maddesi: *"...atomik değildir; ikisi arasında servis çökerse..."*
- Semantik kilit maddesi: *"...geçici olarak tutarsız görünür; sipariş 'beklemede' durumundayken..."*

Not: Orkestrasyon maddesindeki noktalı virgül (*"...hata yönetimi nettir; karşılığında..."*) **TDK-uygun** — ögeleri arasında virgül bulunan sıralı cümleleri ayırıyor. Dokunmadım.

**Sinyal 1c — Cümle-içi iki nokta üst üste (1 örnek).** *"2PC senkron ve bloklayıcıdır: koordinatör ikinci faz sırasında çökerse..."* Burada iki nokta, İngilizce inline-colon mantığıyla bir "çünkü" yerine geçiyor. Diğer iki iki-nokta (*"yazmak kolaydır:"*, *"Fikir basittir:"*) cümle sonunda ve açıklama getiriyor — TDK-uygun, korundu.

**Sinyal 5b — Boş değerlendirici kapanış (1 örnek).** Sonuç paragrafının son sözü: *"...çok daha sağlıklı bir tercihtir."* Bilgi taşımayan, ölçülemeyen bir kapanış sıfatı.

### İkincil sinyaller

**Sinyal 12 — İngilizce vurgu-doldurucusu (1 örnek).** *"tam olarak bu boşluğu doldurma çabasıdır."* "Tam olarak" çıkınca cümlenin anlamı hiç değişmiyor — dolgu-vurgu.

**Sinyal 11 / 3b akrabası — Kalıplaşmış paralel pasif açılış (1 örnek, 3 maddeye yayılmış).** "Pratikte Dikkat Edilecekler" bölümünün üç maddesi de aynı öznesiz kalıpla açılıyor: *"neredeyse zorunludur" / "ihmal edilemez" / "kabul edilmelidir."* Tek tek doğru, üst üste gelince liste makine ritmine düşüyor.

**Sinyal 8 — Devrik cümle yokluğu (belge geneli).** Yaklaşık 400 kelimede tek bir devrik yok. Tek başına kanıt değil ama diğerleriyle birlikte sayılır.

### Eşik altında kalanlar (dokunulmadı)

**Sinyal 14 — Fragment cümle:** 2 örnek var (*"iki UPDATE cümlesi, bir COMMIT, bitti."* ve *"Teoride temiz, pratikte sorunlu."*). Eşik 3+. Üstelik bunlar AI tikî değil; ikisi de bilinçli ritim kırılması gibi duruyor ve metnin en canlı iki anı. Korudum.

**Sinyal 7 — Zorlama üçlü liste:** *"(NoSQL veritabanları, mesaj kuyrukları, üçüncü parti API'ler)"* — üçü gerçekten farklı teknoloji sınıfı, dolgu değil. Korundu.

---

## 2. Sinyal Yoğunluğu

Metin ~400 kelime.

| | Sinyal sayısı | 100 kelimede |
|---|---|---|
| **Önce** | 8 | 2.0 |
| **Sonra** | 1 | 0.25 |

**İyileşme oranı: %88.**

Kalan 1 sinyal: orkestrasyon maddesindeki noktalı virgül. TDK-uygun olduğu için bilerek bırakıldı, sayıma yine de dahil edildi.

Karşılaştırma için: ağır AI-imzalı Türkçe metinler tipik olarak 6-9 sinyal/100 kelime bandında geliyor. Bu metin daha baştan 2.0 ile geldi — yani yazının iskeleti insan işi, sorun ince ayarda.

---

## 3. Onarılmış Versiyon

# Mikroservislerde Dağıtık Transaction Yönetimi

Monolitik bir uygulamada para transferi yazmak kolaydır: iki UPDATE cümlesi, bir COMMIT, bitti. Veritabanı atomikliği garanti eder. Aynı işlemi Hesap Servisi ile Bildirim Servisi arasında bölüştürdüğünüzde ise elinizde iki ayrı veritabanı ve aralarında güvenilmez bir ağ bağlantısı kalır. Dağıtık transaction yönetimi bu boşluğu doldurma çabasıdır.

## Neden Klasik Yöntem Çalışmıyor

İlk akla gelen çözüm iki fazlı commit (2PC) olur. Bir koordinatör tüm katılımcılara "hazır mısın?" diye sorar, hepsi onay verirse "commit et" der. Teoride temiz, pratikte sorunlu. 2PC senkron çalışır ve bloklar. Koordinatör ikinci faz sırasında çökerse katılımcılar kilitli kaynaklarla beklemede kalır. Peki ne kadar bekler? Belli değil. Üstelik çoğu modern altyapı (NoSQL veritabanları, mesaj kuyrukları, üçüncü parti API'ler) XA protokolünü desteklemez. Yüksek trafikli sistemlerde 2PC, mikroservislere geçme sebebiniz olan bağımsızlığı geri alır.

## Saga Deseni

Yaygın çözüm Saga desenidir. Fikir basittir: büyük transaction'ı, her biri kendi servisinde lokal olarak commit edilen bir adımlar zincirine bölersiniz. Bir adım başarısız olursa geri alma (rollback) yapmazsınız. Onun yerine daha önce tamamlanmış adımlar için **telafi işlemleri** (compensating transactions) çalıştırırsınız. Ödeme alındıysa iade edilir, stok düşüldüyse geri eklenir.

Saga'yı iki şekilde kurgulayabilirsiniz:

**Koreografi**: Servisler olayları dinler ve tepki verir. Merkezi bir otorite yoktur, bağımlılık düşüktür. Ama akış kodun içinde dağıldığı için beş-altı adımdan sonra "şu an ne oluyor?" sorusunun cevabı zorlaşır.

**Orkestrasyon**: Merkezi bir orkestratör adımları sırayla çağırır ve durumu takip eder. Akış tek yerde görünür, hata yönetimi nettir; karşılığında orkestratör yeni bir bileşen ve potansiyel bir darboğazdır. Adım sayısı arttıkça orkestrasyonun daha sürdürülebilir olduğunu görüyoruz.

## Pratikte Dikkat Edilecekler

**Outbox deseni** neredeyse zorunludur. Veritabanına yazıp ardından mesaj kuyruğuna event göndermek atomik bir işlem değildir. İkisi arasında servis çökerse tutarsızlık kalıcı olur. Çözüm, event'i aynı transaction içinde bir `outbox` tablosuna yazmak ve ayrı bir süreçle kuyruğa aktarmaktır.

**İdempotency**'yi atlamayın. Mesaj kuyrukları "en az bir kez" teslim garantisi verir, yani aynı event iki kez gelebilir. Her tüketici ya işlediği mesaj kimliklerini saklamalı ya da işlemi baştan tekrar-güvenli tasarlamalıdır.

**Semantik kilit yokluğu** kabullenmeniz gereken bir maliyettir. Saga sırasında veriler geçici olarak tutarsız görünür. Sipariş "beklemede" durumundayken stok zaten rezerve edilmiştir. Bu ara durumları modelinize açıkça yazın, gizlemeye çalışmayın.

## Sonuç

Bedava değil dağıtık sistemlerde tutarlılık. Gerçek soru "tutarlılığı nasıl garanti ederim?" değil, "hangi tutarsızlık penceresini, hangi maliyetle kabul ediyorum?" sorusudur. Çoğu iş senaryosunda nihai tutarlılık (eventual consistency) ve iyi tasarlanmış telafi işlemleri, 2PC'nin kırılganlığını taşımaktan daha ucuza gelir. Daha doğrusu, maliyeti öngörülebilir bir yere taşır.

---

## 4. Notlar

### Faz 1'de ne yapıldı

- **1b:** Üç noktalı virgül üç ayrı cümleye bölündü. Saga paragrafındaki bölünme ayrıca "rollback yapmazsınız" ile "telafi çalıştırırsınız" karşıtlığını görünür kıldı — noktalı virgül bu iki fikri birbirine yapıştırıp zıtlığı yumuşatıyordu.
- **1c:** *"2PC senkron ve bloklayıcıdır: koordinatör..."* → *"2PC senkron çalışır ve bloklar. Koordinatör... beklemede kalır."* İki nokta gitti, ayrıca "bloklayıcıdır" sıfat-yüklemi "bloklar" fiiline döndü (aktif çatı, Sinyal 11).
- **5b:** *"...çok daha sağlıklı bir tercihtir"* → *"...daha ucuza gelir."* Ölçülebilir bir iddiaya çevrildi ve paragrafın açılışındaki "bedava değil" imgesiyle bağlandı.
- **12:** *"tam olarak"* silindi.
- **11 / kalıp:** Üç maddenin açılışı farklılaştırıldı — bir haber cümlesi, bir emir kipi, bir "siz"li zorunluluk. Bilgi aynı, ritim tekdüze değil.
- Ayrıca *"elinizdeki tek şey ... bağlantısıdır"* → *"elinizde ... kalır"*: isim-yüklemli kuruluş fiile döndü.

### Faz 2'de ne yerleştirildi (register uygun olduğu için)

- **Sinyal 15 — Cümle uzunluğu patlaması:** *"Belli değil."* (2 kelime) 2PC paragrafının ortasına kondu. Anlamın gerçekten durduğu yer orası: koordinatör çökünce bekleme süresinin üst sınırı yoktur, cümle de bunu taklit ediyor.
- **Sinyal 16 — Konuşma bağlaçları:** *"Ancak"* → *"Ama"*, *"Dahası"* → *"Üstelik"*.
- **Sinyal 17 — Retorik soru:** *"Peki ne kadar bekler?"* eklendi. Metinde zaten bir retorik soru vardı (Sonuç), bu ikincisi onu yalnız bırakmıyor.
- **Sinyal 18 — Öz-düzeltme:** Son cümle. *"Daha doğrusu, maliyeti öngörülebilir bir yere taşır."* Yazarın kendi iddiasını bir tık düzeltmesi; LLM ilk cümlesini kurar ve üstüne düşünmez.
- **Sinyal 22 — Birinci çoğul:** *"...daha sürdürülebilir olduğunu görüyoruz."* Tek örnekte bırakıldı; metnin geri kalanı "siz" hitabında ve fazlası register kaymasına yol açardı.
- **Sinyal 8 — Devrik:** Sonuç bölümünün açılışı devrik kuruldu: *"Bedava değil dağıtık sistemlerde tutarlılık."*

### Kasıtlı tercih sayıp dokunmadıklarım

- İki fragment cümle (*"...bir COMMIT, bitti."* / *"Teoride temiz, pratikte sorunlu."*). Bunlar AI fragmenti değil, yazarın ritim kırıcıları. Faz 2'nin zaten üretmeye çalıştığı şeyi metin kendi başına yapmış.
- Orkestrasyon maddesindeki noktalı virgül — TDK'nın ikinci kullanımına uyuyor.
- İngilizce terimlerin parantezle verilmesi (rollback, compensating transactions, eventual consistency). Teknik yazıda yerleşik ve işlevsel bir gelenek.
- Madde başlarındaki kalın etiket + iki nokta yapısı (**Koreografi**:, **Outbox deseni**...). Bunlar cümle-içi noktalama değil, belge iskeleti. Yapı Koruma gereği ellenmedi.
- Başlık hiyerarşisi, `outbox` kod işareti, liste yapısı: birebir korundu.

### YOK olduğu için not düştüklerim

Yazarın hakkını teslim etmek gerek — Türkçe AI metninin en yaygın imzalarının çoğu bu metinde hiç görünmedi:

- **Uzun tire (—) enflasyonu:** sıfır. Metinde tek bir em dash yok. Bu Türkçe AI çıktısında olağanüstü nadirdir.
- **"-mektedir / -maktadır" salgını:** sıfır. Dört yüz kelimelik teknik bir metinde tek bir örneği bile yok; yüklemler geniş zamanda ve fiil çekimli.
- **"Sadece X değil, aynı zamanda Y" ailesi:** sıfır.
- **Bürokratik bağlaç yığını** ("bu bağlamda," "söz konusu," "bu doğrultuda," "bu çerçevede"): sıfır.
- **AI kapanış klişeleri** ("kritik bir rol oynamaktadır," "hayati önem taşımaktadır"): sıfır. Her bölüm bilgi taşıyan bir cümlede bitiyor.
- **Boş övgü sıfatları** ("eşsiz," "çok boyutlu," "vazgeçilmez"): sıfır.
- **"Adeta" / "sanki" bağımlılığı:** sıfır.
- **Slash-ayırıcı alternatifler:** sıfır.
- **Eş anlamlı rotasyonu:** yok. "Telafi işlemi" hep telafi işlemi, "orkestratör" hep orkestratör. Türkçe teknik yazıda doğru davranış tekrar etmektir, metin bunu yapıyor.
- **Somut anchor eksikliği:** yok. Soyut iddialar hemen somutla takip ediliyor — "ödeme alındıysa iade edilir," "sipariş beklemede durumundayken stok rezerve edilmiştir," "beş-altı adımdan sonra."

Kısaca: bu metinde onarılacak olan retorik değil, noktalama ve ritimdi. Faz 1 müdahalesi cerrahi kaldı, asıl kazanç Faz 2'den geldi.
