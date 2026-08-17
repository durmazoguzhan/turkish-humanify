
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

