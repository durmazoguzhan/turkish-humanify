## Veritabanı migration'larını güvenli hale getirmek

Kod deploy'unu geri alabilirsiniz. Migration'ı çoğu zaman alamazsınız. Bu asimetri, şema değişikliklerine neden ayrı bir dikkatle yaklaşmak gerektiğini tek başına açıklıyor.

**Şema ile kodu aynı anda değiştirmeyin**

En sık yapılan hata bu: kolonu rename eden migration ile yeni kolonu okuyan kod aynı deploy'da gidiyor. Deploy sırasında iki sürüm bir süre yan yana çalışıyorsa (rolling deploy, canary, hatta sadece uzun süren bir restart), eski sürüm bir anda olmayan bir kolona bakmaya başlıyor.

Çözüm, değişikliği üçe bölmek:

1. **Genişlet.** Yeni kolonu nullable olarak ekle, eski kolona dokunma. Kod ikisine de yazsın, okumaya eski kolondan devam etsin.
2. **Taşı.** Veriyi backfill et, sonra okumayı yeni kolona çevir.
3. **Daralt.** Eski kolonu, hiçbir yerden referans verilmediğini doğruladıktan sonra düşür.

Her adım tek başına geri alınabilir, çünkü hiçbiri yıkıcı değil. Üçüncü adımı bir sonraki sürüme, hatta bir sonraki haftaya bırakmak bedava sigorta.

**Backfill'i tek sorguda yapmayın**

Milyonlarca satırı tek UPDATE ile güncellemek uzun bir transaction demek: kilitlenen satırlar, şişen WAL veya undo alanı, gecikmeye giren replica'lar. Bunun yerine primary key aralığıyla batch'lere bölün, her batch'ten sonra commit edin, araya küçük bir bekleme koyun. İşin yarısında durdurulduğunda kaldığı yerden devam edebilen bir backfill, hızlı olandan daha değerlidir.

**Kilit sürelerini sınırlayın**

Tehlike genelde ALTER TABLE'ın kendisi değil, kilit kuyruğu: migration tablo kilidini beklerken arkasında biriken sorgular uygulamayı durdurabiliyor. Migration bağlantısında lock_timeout ve statement_timeout ayarlamak, "bekleyemedim, çıktım" davranışını "yarım saat siteyi kapattım"a tercih etmenizi sağlıyor. Kullandığınız veritabanının hangi işlem için hangi kilidi aldığını dokümantasyondan teyit edin; sürümler arasında değişebiliyor.

**Prod'a benzeyen veriyle test edin**

500 satırlık staging'de 40 milisaniyede biten migration, 80 milyon satırda kaç dakika sürer? Bunu tahmin etmeye çalışmak yerine ölçün: prod boyutundaki bir kopya üzerinde bir kez çalıştırın. Süreyi, kilit davranışını ve disk kullanımını orada görürsünüz, gece yarısı canlıda değil.

**Geri dönüş planı yazın, ona güvenmeyin**

Her migration'ın down script'i olsun, ama gerçek güvenceniz o olmasın. Veri silen bir adımın down'ı yoktur; sadece yedekten dönüş vardır. Riskli adımı atmadan önce yedeğin gerçekten geri yüklenebildiğini kontrol etmiş olmak da planın parçası, çünkü test edilmemiş yedek yedek değil.

İyi migration süreci heyecansızdır. Küçük ve geri alınabilir adımlar, ölçülmüş süreler, bir sonraki sürüme bırakılmış silme işlemleri. Cuma akşamı stres yaşamamanın sırrı cuma akşamı deploy etmemek değil; deploy'un o kadar sıkıcı hale gelmesi.
