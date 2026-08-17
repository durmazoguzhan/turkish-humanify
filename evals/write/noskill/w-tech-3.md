## REST mi GraphQL mi: karar neye bağlı

Bu tartışma çoğu zaman yanlış sorudan başlıyor. "Hangisi daha modern" diye soruyoruz, oysa kararı belirleyen şey elimizdeki client sayısı ve o client'ların birbirinden ne kadar farklı veri istediği.

GraphQL'in çözdüğü problem gerçek. Bir mobil uygulamanız, bir yönetim paneliniz ve bir de partner entegrasyonunuz varsa üçü de aynı kaynaklardan farklı şeyler bekler. REST'te bunun klasik cevabı ya over-fetching'e katlanmak ya da endpoint'e `?include=`, `?fields=` gibi parametreler ekleyip onu yavaş yavaş kendi yarım kalmış query dilinize dönüştürmek. İkinci yolu seçen ekiplerin bir noktada "biz zaten GraphQL yazıyoruz, sadece kötüsünü yazıyoruz" dediğine birkaç kez tanık oldum.

Maliyet tarafı da o kadar gerçek ama, ve genelde demo aşamasında görünmüyor.

Caching en can sıkıcısı. REST'in HTTP'den bedavaya aldığı şeyi GraphQL'de kendiniz kurmanız gerekiyor; `POST /graphql`in önüne CDN koyamazsınız. Persisted query ile GET'e dönmek mümkün, ama bu artık bedava değil, ayrı bir iş kalemi.

N+1 sorunu ikinci sırada. Resolver'lar birbirinden habersiz çalıştığı için batching'i (DataLoader ya da muadili) baştan kurmazsanız, tek bir iç içe sorgu veritabanına yüzlerce istek atabilir.

Yetkilendirme modeli de değişiyor. REST'te "bu endpoint'e kim erişebilir" diye düşünürsünüz; GraphQL'de aynı soruyu her field için ayrı ayrı sormak zorundasınız. Bunu ortak bir katmanda çözmezseniz kontroller resolver'lara dağılır ve gözden kaçanı bulmanın kolay yolu olmaz.

Rate limiting ve observability tarafı da benzer. Her sorgunun maliyeti farklı olduğu için "dakikada 1000 istek" gibi bir limit fazla anlam taşımıyor, query complexity puanlaması kurmak gerekiyor. Loglara bakıp "hangi endpoint yavaş" diye soramamak da alışılması gereken bir şey.

Pratikte şöyle bir eşik işime yarıyor: client sayısı bir ya da iki ise ve işin çoğu CRUD ise REST'te kalın. Dışa açık, üçüncü tarafların tüketeceği bir API yazıyorsanız yine REST — yoksa GraphQL'in öğrenme eğrisini müşterinize ödetmiş olursunuz. Frontend hızlı değişiyor, veri modeli iç içe ve ekipler yeni endpoint bekleyip birbirini bloke ediyorsa GraphQL'in bedelini ödemeye değer. Servis-servis trafikte ise ikisi de en iyi seçenek değil; orada gRPC'ye bakın.

Bir de kararı geri alınabilir tutmak var. GraphQL'i mevcut REST servislerinin üstünde ince bir BFF katmanı olarak başlatırsanız hem geçiş yolunuz olur hem de işe yaramadığında çıkış yolunuz. Tersi, yani her şeyi tek bir GraphQL şemasının içine gömüp sonra vazgeçmek, çok daha pahalı.
