# Mikroservislerde Dağıtık Transaction Yönetimi

Monolitik bir uygulamada para transferi yazmak kolaydır: iki UPDATE cümlesi, bir COMMIT, bitti. Veritabanı atomikliği garanti eder. Aynı işlemi Hesap Servisi ve Bildirim Servisi arasında bölüştürdüğünüzde ise elinizdeki tek şey iki ayrı veritabanı ve aralarında güvenilmez bir ağ bağlantısıdır. Dağıtık transaction yönetimi, tam olarak bu boşluğu doldurma çabasıdır.

## Neden Klasik Yöntem Çalışmıyor

İlk akla gelen çözüm iki fazlı commit (2PC) olur. Bir koordinatör tüm katılımcılara "hazır mısın?" diye sorar, hepsi onay verirse "commit et" der. Teoride temiz, pratikte sorunlu. 2PC senkron ve bloklayıcıdır: koordinatör ikinci faz sırasında çökerse katılımcılar kilitli kaynaklarla beklemede kalır. Dahası çoğu modern altyapı (NoSQL veritabanları, mesaj kuyrukları, üçüncü parti API'ler) XA protokolünü desteklemez. Yüksek trafikli sistemlerde 2PC, mikroservislere geçme sebebiniz olan bağımsızlığı geri alır.

## Saga Deseni

Yaygın çözüm Saga desenidir. Fikir basittir: büyük transaction'ı, her biri kendi servisinde lokal olarak commit edilen bir adımlar zincirine bölersiniz. Bir adım başarısız olursa geri alma (rollback) yapmazsınız; onun yerine daha önce tamamlanmış adımlar için **telafi işlemleri** (compensating transactions) çalıştırırsınız. Ödeme alındıysa iade edilir, stok düşüldüyse geri eklenir.

Saga'yı iki şekilde kurgulayabilirsiniz:

**Koreografi**: Servisler olayları dinler ve tepki verir. Merkezi bir otorite yoktur, bağımlılık düşüktür. Ancak akış kodun içinde dağıldığı için beş-altı adımdan sonra "şu an ne oluyor?" sorusunun cevabı zorlaşır.

**Orkestrasyon**: Merkezi bir orkestratör adımları sırayla çağırır ve durumu takip eder. Akış tek yerde görünür, hata yönetimi nettir; karşılığında orkestratör yeni bir bileşen ve potansiyel bir darboğazdır. Adım sayısı arttıkça orkestrasyon genelde daha sürdürülebilirdir.

## Pratikte Dikkat Edilecekler

**Outbox deseni** neredeyse zorunludur. Veritabanına yazıp ardından mesaj kuyruğuna event göndermek atomik değildir; ikisi arasında servis çökerse tutarsızlık kalıcı olur. Çözüm, event'i aynı transaction içinde bir `outbox` tablosuna yazmak ve ayrı bir süreçle kuyruğa aktarmaktır.

**İdempotency** ihmal edilemez. Mesaj kuyrukları "en az bir kez" teslim garantisi verir, yani aynı event iki kez gelebilir. Her tüketicinin işlenmiş mesaj kimliklerini saklaması veya işlemi doğal olarak tekrar-güvenli tasarlaması gerekir.

**Semantik kilit yokluğu** kabul edilmelidir. Saga sırasında veriler geçici olarak tutarsız görünür; sipariş "beklemede" durumundayken stok zaten rezerve edilmiştir. Bu ara durumları modelinize açıkça yazın, gizlemeye çalışmayın.

## Sonuç

Dağıtık sistemlerde mükemmel tutarlılık ücretsiz değildir. Gerçek soru "tutarlılığı nasıl garanti ederim?" değil, "hangi tutarsızlık penceresini, hangi maliyetle kabul ediyorum?" sorusudur. Çoğu iş senaryosu için nihai tutarlılık (eventual consistency) ve iyi tasarlanmış telafi işlemleri, 2PC'nin getirdiği kırılganlıktan çok daha sağlıklı bir tercihtir.
