# GraphQL'e geçmeden önce kaç client'ınız olduğunu sayın

Tartışma çoğu ekipte aynı cümleyle başlıyor: "REST'te endpoint sayısı çığ gibi büyüdü, GraphQL'e mi geçsek?" Sonraki bir saat iki teknolojinin özelliklerini yan yana koymakla geçiyor. Oysa seçimi belirleyen şey teknolojilerin özellikleri değil, API'yi kimin tükettiği.

REST kaynak başına sabit bir response üretir. Sunucu ne döndüreceğini bilir, client ne alacağını. Tek bir web arayüzü besliyorsanız bunun bedeli yok; HTTP'nin kendi araçları hazır geliyor, cache'leme, CDN, ETag, rate limiting, hepsi GET'in üstüne kurulu. GraphQL'de bütün istekler aynı URL'e giden POST'lar olduğu için bu araçların hiçbirini olduğu gibi kullanamıyorsunuz.

Denklem client sayısı arttıkça değişiyor. Web, iOS ve bir partner entegrasyonu aynı veriyi farklı şekillerde isteyince REST tarafında iki seçenek kalıyor: her ekran için özel endpoint açmak, ya da herkese en geniş response'u döndürüp mobil tarafın gereksiz alan indirmesine razı olmak. Birincisi bakımı zor bir endpoint yığını bırakıyor. İkincisinde ise faturayı mobil kullanıcı, kötü bir bağlantıda ödüyor. GraphQL'in çözdüğü asıl problem burası: şemayı bir kez tanımlıyorsunuz, hangi alanın kime gideceğine client karar veriyor.

Bedeli de peşin ödeniyor. Sorgunun şeklini client belirlediği için hangi query'nin veritabanına ne kadar yükleneceğini önceden bilmiyorsunuz; N+1 problemi, derinlik limiti ve query maliyeti hesabı sizin işiniz oluyor. Cache'lemeyi de alan seviyesinde yeniden kurmanız gerekir. Beş kişilik bir ekipte bu, ürüne değil altyapıya giden birkaç hafta demek.

Bir de o toplantıda kimsenin açmadığı taraf var: şemanın sahibi kim olacak. REST'te her ekip kendi endpoint'ini açıp kendi takviminde deploy edebiliyor. Tek bir GraphQL şeması ise ortak mülk; alan eklemek kolay, alan kaldırmak o alanı hangi client'ın hangi query'sinde kullandığını bilmeden mümkün değil. Bu, teknik olmaktan çok organizasyonel bir iş; ekip sayısı üçü geçtiğinde federation gibi bir düzen kurmadan yürümüyor.

O yüzden iki client besleyen bir ekip için REST'te kalmak hâlâ makul. Daha doğrusu, GraphQL o ekipte de çalışır; ama esnekliğini kullanacak kadar farklı talep gelmediğinden ödediğiniz faturanın karşılığını göremiyorsunuz.

Pratikte işleyen yol şu: REST'le başlayın, üçüncü client geldiğinde ya da mobil ekip tek bir ekranı doldurmak için üç ayrı istek attığını söylediğinde yalnızca o yüzeyi GraphQL'e taşıyın. İkisinin bir arada durmasında da sakınca yok; partner entegrasyonları ve webhook'lar REST'te kalmaya devam eder, mobilin veri ihtiyacını GraphQL karşılar. Karar tek seferlik ve geri dönüşsüz değil, o yüzden baştan doğru cevabı bulmaya çalışmak yerine ilk somut belirtiyi bekleyin.
