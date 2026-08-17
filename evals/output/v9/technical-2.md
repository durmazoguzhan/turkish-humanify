# Mikroservislerde Dağıtık Transaction Yönetimi

Monolitik bir uygulamada para transferi yazmak kolay: iki UPDATE cümlesi, bir COMMIT, bitti. Atomikliği veritabanı garanti eder. Aynı işlemi Hesap Servisi ve Bildirim Servisi arasında bölüştürdüğünüzde ise elinizdeki tek şey iki ayrı veritabanı ve aralarında güvenilmez bir ağ bağlantısı. Dağıtık transaction yönetimi, tam olarak bu boşluğu doldurma çabasıdır.

## Neden klasik yöntem çalışmıyor

İlk akla gelen çözüm iki fazlı commit (2PC) oluyor. Bir koordinatör tüm katılımcılara "hazır mısın?" diye sorar, hepsi onay verirse "commit et" der. Teoride temiz, pratikte sorunlu. 2PC hem senkron hem bloklayıcı: koordinatör ikinci faz sırasında çökerse katılımcılar kilitli kaynaklarla beklemede kalır.

Dahası çoğu modern altyapı (NoSQL veritabanları, mesaj kuyrukları, üçüncü parti API'ler) XA protokolünü desteklemez. Yüksek trafikli sistemlerde 2PC, mikroservislere geçme sebebiniz olan bağımsızlığı geri alır.

## Saga deseni

Yaygın çözüm Saga deseni. Fikir basit: büyük transaction'ı, her biri kendi servisinde lokal olarak commit edilen bir adımlar zincirine bölersiniz. Bir adım başarısız olursa geri alma (rollback) yapmazsınız; onun yerine daha önce tamamlanmış adımlar için telafi işlemleri (compensating transactions) çalıştırırsınız. Ödeme alındıysa iade edilir, stok düşüldüyse geri eklenir.

Saga'yı iki şekilde kurgulayabilirsiniz:

**Koreografi**: Servisler olayları dinleyip tepki verir. Merkezi bir otorite yok, bağımlılık düşük. Ancak akış kodun içine dağıldığı için beş-altı adımdan sonra "şu an ne oluyor?" sorusunun cevabı zorlaşır.

**Orkestrasyon**: Merkezi bir orkestratör adımları sırayla çağırıp durumu takip eder. Akış tek yerde görünür, hata yönetimi net; karşılığında orkestratör hem yeni bir bileşen hem de potansiyel bir darboğaz. Adım sayısı arttıkça orkestrasyon genelde daha sürdürülebilir oluyor.

## Pratikte dikkat edilecekler

Outbox deseni neredeyse zorunlu. Veritabanına yazıp ardından mesaj kuyruğuna event göndermek atomik bir işlem değil; ikisi arasında servis çökerse tutarsızlık kalıcı hale gelir. Çözüm, event'i aynı transaction içinde bir `outbox` tablosuna yazıp ayrı bir süreçle kuyruğa aktarmak.

İdempotency'yi de atlayamazsınız. Mesaj kuyrukları "en az bir kez" teslim garantisi verir; yani aynı event iki kez gelebilir. Her tüketici ya işlediği mesaj kimliklerini saklamalı ya da işlemi baştan tekrar-güvenli tasarlamalı.

Saga'da semantik kilit yok; bunu kabul edin. Saga sürerken veriler tutarsız görünür. Daha doğrusu, geçici olarak tutarsız görünür: sipariş "beklemede" durumundayken stok zaten rezerve edilmiş olur. Bu ara durumları modelinize açıkça yazın, gizlemeye çalışmayın.

## Asıl soru

Dağıtık sistemlerde mükemmel tutarlılık ücretsiz değil. Gerçek soru "tutarlılığı nasıl garanti ederim?" değil; "hangi tutarsızlık penceresini, hangi maliyetle kabul ediyorum?" Çoğu iş senaryosu için nihai tutarlılık (eventual consistency) ve iyi tasarlanmış telafi işlemleri, 2PC'nin getirdiği kırılganlıktan çok daha sağlıklı bir tercih.
