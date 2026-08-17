# Migration yazmak kolay, geri almak zor

Migration'lar test ortamında hep çalışır. Orada tablolar küçük, kimse aynı anda o tabloya yazmıyor, beklenecek bir lock yok. Canlı ortamda ise aynı SQL bambaşka bir işe dönüşür: dolu bir tablo, arkada duran uzun transaction'lar, saniyede gelen istekler.

En sık ısıran şey de migration'ın süresi değil, lock kuyruğu. `ALTER TABLE` uzun süren bir sorgunun arkasında beklemeye başlayınca, o tabloya gelen bütün yeni sorgular da ALTER'ın arkasına dizilir. Kolonu eklemek kendi başına çok kısa sürer; kesintinin uzunluğunu belirleyen şey kuyrukta biriken istekler. Bu yüzden `lock_timeout` verip, lock'u alamayınca migration'ı bırakıp tekrar denemek en ucuz koruma.

Hangi işlemin tabloyu baştan yazdığını bilmek de gerekiyor. PostgreSQL 11'den beri sabit bir default değeriyle kolon eklemek tabloyu taramaz, sadece katalogu günceller; ama `NOT NULL` eklemek tam tarama ister. Bunu ikiye bölebilirsiniz: constraint'i `CHECK ... NOT VALID` ile koyup ardından `VALIDATE CONSTRAINT` çalıştırmak, yazma trafiğini bloke etmeden aynı garantiyi verir. Index'te de benzer bir çıkış var: `CREATE INDEX CONCURRENTLY` transaction içinde çalışmaz ve yarıda kalırsa geride invalid bir index bırakır, o yüzden iş bittikten sonra index'in geçerli olup olmadığına bakın. MySQL tarafında online DDL her ALTER'ı kapsamaz; gh-ost gibi araçlar tam bu boşluk için çıktı.

Bir de deploy sırası var. Rolling deploy'da uygulamanın iki sürümü bir süre yan yana çalışır, yani migration hem yeni koda hem eski koda uymak zorunda. Kolon adını değiştirmek bu yüzden en kötü hamle: eski sürüm eski adı sorar ve hata alır. Yerine dört adım:

1. Yeni kolonu nullable olarak ekleyin.
2. Kodu iki kolona da yazacak hale getirin.
3. Eski veriyi parça parça backfill'leyin; tek bir transaction'da değil, replication lag'i şişirmemek için.
4. Okumayı yeni kolona alın, eskisini de sonraki deploy'da silin.

Yavaş görünüyor, gerçekten de yavaş. Ama her adımı tek başına geri alabilirsiniz.

Rollback tarafında dürüst olmak gerekiyor. Down migration'lar neredeyse hiç test edilmez, çünkü kimse canlıda denemek istemez. Çalıştığında bile işi yarım bırakır. Daha doğrusu: şemayı geri alır, silinmiş veriyi geri getirmez. Yıkıcı adımı, yani kolon silmeyi ve tablo düşürmeyi, bu yüzden ayrı bir deploy'a bırakın; arada birkaç gün olsun.

Yazdığınız her migration için sorulacak tek soru şu: canlıda şu an duran uygulama sürümü, bu migration çalıştıktan sonra da çalışır mı? Cevap hayırsa elinizdeki migration ikiye bölünecek demektir.
