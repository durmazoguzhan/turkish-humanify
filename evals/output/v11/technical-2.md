# Mikroservislerde Dağıtık Transaction Yönetimi

Monolitik bir uygulamada para transferi yazmak kolay: iki UPDATE cümlesi, bir COMMIT, bitti. Atomikliği veritabanı garanti eder. Aynı işlemi Hesap Servisi ile Bildirim Servisi arasında bölüştürdüğünüzde ise elinizde kalan tek şey iki ayrı veritabanı, bir de aralarındaki güvenilmez ağ bağlantısı. Dağıtık transaction yönetimi, tam olarak bu boşluğu doldurma çabası.

## Klasik yöntem neden çalışmıyor

İlk akla gelen çözüm iki fazlı commit (2PC) olur. Bir koordinatör tüm katılımcılara "hazır mısın?" diye sorar, hepsi onay verirse "commit et" der. Teoride temiz, pratikte sorunlu.

2PC hem senkron hem bloklayıcı: koordinatör ikinci faz sırasında çökerse katılımcılar kilitli kaynaklarla beklemede kalır. Dahası çoğu modern altyapı (NoSQL veritabanları, mesaj kuyrukları, üçüncü parti API'ler) XA protokolünü desteklemez. Yüksek trafikli sistemlerde 2PC, mikroservislere geçme sebebiniz olan bağımsızlığı geri alır.

## Saga deseni

Yaygın çözüm Saga deseni. Fikir basit: büyük transaction'ı, her biri kendi servisinde lokal olarak commit edilen bir adım zincirine bölersiniz. Bir adım başarısız olursa geri alma (rollback) yapmazsınız. Onun yerine daha önce tamamlanmış adımlar için **telafi işlemleri** (compensating transactions) çalıştırırsınız: ödeme alındıysa iade edilir, stok düşüldüyse geri eklenir.

Saga'yı iki şekilde kurgulayabilirsiniz.

Koreografide servisler olayları dinleyip tepki verir. Merkezi bir otorite yok, bağımlılık düşük. Ancak akış kodun içine dağıldığı için beş-altı adımdan sonra "şu an ne oluyor?" sorusunun cevabı zorlaşır.

Orkestrasyonda ise merkezi bir orkestratör adımları sırayla çağırıp durumu takip eder. Akış tek yerde görünür, hata yönetimi net; karşılığında orkestratör hem yeni bir bileşen hem de potansiyel bir darboğaz. Adım sayısı arttıkça orkestrasyon genelde daha sürdürülebilir.

## Pratikte dikkat edilecek üç şey

Outbox deseni neredeyse zorunlu. Veritabanına yazıp ardından mesaj kuyruğuna event göndermek atomik değil. İkisi arasında servis çökerse tutarsızlık kalıcı olur. Çözüm, event'i aynı transaction içinde bir `outbox` tablosuna yazmak, sonra ayrı bir süreçle kuyruğa aktarmaktır.

İdempotency ihmal edilemez. Mesaj kuyrukları "en az bir kez" teslim garantisi verir, yani aynı event iki kez gelebilir. Her tüketici ya işlediği mesajların kimliğini saklamalı ya da işlemi baştan tekrara dayanıklı tasarlamalı.

Semantik kilit yok, bunu kabul etmek zorundasınız. Saga sırasında veriler geçici olarak tutarsız görünür: sipariş "beklemede" durumundayken stok zaten rezerve edilmiş olur. Bu ara durumları modelinize açıkça yazın, gizlemeye çalışmayın.

## Dağıtık sistemlerde mükemmel tutarlılık bedava değil

Gerçek soru "tutarlılığı nasıl garanti ederim?" değil, "hangi tutarsızlık penceresini, hangi maliyetle kabul ediyorum?" sorusu. Çoğu iş senaryosunda nihai tutarlılık (eventual consistency) ve iyi tasarlanmış telafi işlemleri, 2PC'nin getirdiği kırılganlıktan çok daha sağlıklı bir tercih.
