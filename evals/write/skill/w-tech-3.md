# İki farklı client'ınız yoksa GraphQL'in çözdüğü sorun sizde yok

Tartışma çoğu ekipte yanlış yerden başlıyor: hangisi daha modern, hangisi daha hızlı. İki soru da karara götürmüyor. REST ile GraphQL arasındaki asıl fark tek bir noktada: yanıtın şeklini kim belirliyor. REST'te sunucu belirler, GraphQL'de client. Cache'ten yetkilendirmeye, monitoring'den hata yönetimine kadar geri kalan her şey bu tek farkın sonucu.

REST'in elinde HTTP'nin kendisi var. Bir GET isteğinin URL'i aynı zamanda cache key'i olduğu için tarayıcı, CDN ve ters proxy yanıtı sizin adınıza saklar; ETag ile Cache-Control dışında bir şey yazmanız gerekmez. GraphQL'de istekler tek bir /graphql yoluna POST gittiğinden bu katman devre dışı kalır. Daha doğrusu, tamamen kaybolmuyor: persisted query kullanıp query'yi hash'iyle GET üzerinden gönderdiğinizde CDN yeniden işe yarar. Ama o kurulumu artık siz yapıyorsunuz.

Tek yola düşen istekler monitoring'i de zorlar. Endpoint başına gecikme grafikleri anlamını yitirir; 5xx oranına bakan alarm sessiz kalır, çünkü GraphQL hataları çoğu kurulumda 200 yanıtın içindeki errors alanıyla döner. Ölçümü alan ve resolver seviyesine indirmek gerekir. Şemayı client'a açtığınız anda iç içe geçmiş query yazma imkânını da vermiş olursunuz; depth limit, query cost analizi ve veritabanı çağrılarını batch'leyen bir katman olmadan yeterince derin tek bir query sunucuyu zorlamaya yeter. Bunlar sonraya bırakılacak işler değil.

GraphQL'in çözdüğü sorun da gerçek. Bir mobil uygulama, bir web arayüzü ve bir yönetim paneli aynı veriyi farklı derinlikte istediğinde REST'te iki yol kalıyor: ya her ekran için ayrı endpoint açarsınız ya da client üç dört isteği toplayıp birleştirir. Birincisinde backend ekibi ekran taleplerinin arkasından koşar, ikincisinde mobil tarafta gereksiz veri ve fazladan gidiş dönüş birikir. GraphQL'de şema tek; isteğin şeklini client kendisi kurar. Şema tipli olduğu için client kodunu üretebilir, alanı silmek yerine deprecate ederek /v2 açmadan yol alabilirsiniz.

Karar da çoğu zaman ikisinden biri olmuyor. Dışarıya açık, kimin ne çağıracağını bilmediğiniz bir API'de REST hem destek hem de rate limit tarafında daha ucuza geliyor; servisler arası iç trafikte de öyle. GraphQL'i client'larla konuşan katmanda tutup arkasında REST ya da gRPC ile devam etmek yaygın bir düzen.

Seçerken tek bir şeye bakın: aynı veriyi kaç farklı şekle sokmak zorunda olduğunuza. Tek şekil yetiyorsa REST'te kalın. GraphQL o durumda size esneklik değil, bakmanız gereken bir katman daha getirir.
