# Mikroservislerde Dağıtık Transaction Yönetimi

Monolitik bir uygulamada para transferi yazmak kolay: iki UPDATE cümlesi, bir COMMIT, bitti. Atomikliği veritabanı garanti eder. Aynı işlemi Hesap Servisi ile Bildirim Servisi arasında bölüştürdüğünüzde ise elinizde iki ayrı veritabanından ve aralarındaki güvenilmez ağ bağlantısından başka bir şey kalmaz. Dağıtık transaction yönetimi, tam olarak bu boşluğu doldurma çabası.

## Neden Klasik Yöntem Çalışmıyor

İlk akla gelen çözüm iki fazlı commit (2PC) olur. Bir koordinatör bütün katılımcılara "hazır mısın?" diye sorup hepsi onay verirse "commit et" der. Teoride temiz, pratikte sorunlu. 2PC senkron ve bloklayıcı: koordinatör ikinci faz sırasında çökerse katılımcılar kilitli kaynaklarla beklemede kalır. Dahası çoğu modern altyapı (NoSQL veritabanları, mesaj kuyrukları, üçüncü parti API'ler) XA protokolünü desteklemez. Yüksek trafikli sistemlerde 2PC, mikroservislere geçme sebebiniz olan bağımsızlığı geri alır.

## Saga Deseni

Yaygın çözüm Saga deseni. Fikir basit: büyük transaction'ı, her biri kendi servisinde lokal olarak commit edilen bir adımlar zincirine bölersiniz. Bir adım başarısız olursa geri alma (rollback) yapmazsınız; onun yerine daha önce tamamlanmış adımlar için **telafi işlemleri** (compensating transactions) çalıştırırsınız. Ödeme alındıysa iade edilir, stok düşüldüyse geri eklenir.

Saga'yı iki şekilde kurgulayabilirsiniz:

**Koreografi**: Servisler olayları dinleyip tepki verir. Merkezi bir otorite yok, bağımlılık düşük. Ancak akış kodun içine dağıldığı için beş-altı adımdan sonra "şu an ne oluyor?" sorusunun cevabı zorlaşır.

**Orkestrasyon**: Merkezi bir orkestratör adımları sırayla çağırıp durumu takip eder. Akış tek yerde görünür, hata yönetimi net; karşılığında orkestratör hem yeni bir bileşen hem de potansiyel bir darboğaz. Adım sayısı arttıkça orkestrasyon genelde daha sürdürülebilir hale gelir.

## Pratikte Dikkat Edilecekler

**Outbox deseni** neredeyse zorunlu. Veritabanına yazıp ardından mesaj kuyruğuna event göndermek atomik değil; ikisi arasında servis çökerse tutarsızlık kalıcı olur. Çözüm şu: event'i aynı transaction içinde bir `outbox` tablosuna yazarsınız, kuyruğa aktarmayı ayrı bir süreç üstlenir.

**İdempotency**'yi ihmal edemezsiniz. Mesaj kuyrukları "en az bir kez" teslim garantisi verir, yani aynı event iki kez gelebilir. Her tüketici ya işlediği mesajların kimliğini saklayacak ya da işlemi baştan tekrar-güvenli tasarlayacak.

**Semantik kilit yokluğunu** kabul etmek gerekir. Saga sırasında veriler geçici olarak tutarsız görünür; sipariş "beklemede" durumundayken stok çoktan rezerve edilmiş olur. Bu ara durumları modelinize açıkça yazın, gizlemeye çalışmayın.

## Sonuç

Dağıtık sistemlerde mükemmel tutarlılık ücretsiz değil. Sorulacak asıl soru "tutarlılığı nasıl garanti ederim?" değil; "hangi tutarsızlık penceresini, hangi maliyetle kabul ediyorum?" Çoğu iş senaryosu için nihai tutarlılık (eventual consistency) ve iyi tasarlanmış telafi işlemleri, 2PC'nin getirdiği kırılganlıktan çok daha sağlıklı bir tercih.
