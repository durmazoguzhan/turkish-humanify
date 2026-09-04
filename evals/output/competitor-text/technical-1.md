
# Redis'te Cache Invalidation: Doğru Veriyi Doğru Zamanda Unutmak

Cache'leme kolaydır. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermek. Phil Karlton'ın meşhur sözü boşuna değil. Bilgisayar bilimlerindeki iki zor problemden biri cache invalidation'dır.

## TTL: En basit ve çoğu zaman en doğru yaklaşım

Redis'te invalidation'ın en yalın hali `EXPIRE` kullanmak. Veriye bir ömür biçersiniz, süre dolunca Redis onu kendisi temizler:

```
SET user:1042 "{...}" EX 300
```

Bu yaklaşımın güzelliği, hata durumunda kendini toparlaması. Invalidation mantığınızda bir bug olsa bile bayat veri en fazla TTL kadar yaşar. Sonra kendiliğinden ölür. Dezavantajı ise TTL süresince kullanıcıların eski veriyi görmesi. Ürün fiyatı için 5 dakika kabul edilebilir, kullanıcı yetkileri için felaket olabilir.

## Write-through ve explicit invalidation

Veri değiştiğinde cache'i doğrudan silmek (`DEL`) ya da güncellemek daha keskin bir kontrol sağlar. Peki hangisi doğru, silmek mi güncellemek mi?

Genel kural, **güncellemek yerine silmektir**. Ya da daha dikkatli söyleyelim, güncellemek de çalışır ama yanlış gittiğinde sessizce yanlış gider. Cache'i yazma anında güncellerseniz eşzamanlı iki yazma işleminin sırası karışabilir ve cache kalıcı olarak yanlış değeri tutabilir. Silme işlemi ise idempotent. Bir sonraki okuma veriyi veritabanından tazeler.

Sıralama da önemli. Önce veritabanını yazın, sonra cache'i silin. Tersi sırada, silme ile yazma arasındaki pencerede başka bir okuma eski veriyi tekrar cache'e koyabilir.

## Cache stampede problemi

Popüler bir key expire olduğu anda yüzlerce istek aynı anda veritabanına yönelir. Buna cache stampede denir. Production'da veritabanı çökertecek kadar da ciddidir.

İki pratik çözüm var. Birincisi, bir lock key ile yalnızca tek bir isteğin veriyi yeniden üretmesine izin vermek:

```
SET lock:user:1042 1 NX EX 10
```

`NX` sayesinde yalnızca ilk istek lock'u alır, diğerleri ya kısa süre bekler ya da bayat veriyi döner. İkincisi ise probabilistic early expiration. TTL dolmadan biraz önce, rastgele seçilen küçük bir istek yüzdesi cache'i kendiliğinden yeniler.

## Grup halinde invalidation

Tek bir key'i silmek kolay. Ama "bu kullanıcıya ait tüm cache'leri sil" demek zor. `KEYS user:1042:*` komutunu asla kullanmayın. Redis tek thread'li çalışır, bu komut da tüm sunucuyu bloke eder. `SCAN` daha güvenli, yine de yavaş.

Daha temiz yöntem, versiyon damgası. Key'lere bir versiyon numarası gömersiniz:

```
user:1042:v7:profile
```

Kullanıcı verisi değiştiğinde `INCR user:1042:version` yaparsınız. Eski versiyonlu key'ler artık hiç okunmaz, TTL'leriyle sessizce ölür. Tek bir atomik komutla binlerce key'i mantıksal olarak geçersiz kılmış olursunuz.

## Kapanış

Doğru strateji, verinin bayatlığa toleransına bağlıdır. Tolerans yüksekse TTL yeterlidir; düşükse explicit invalidation ve versiyonlama gerekir. Her durumda TTL'i bir güvenlik ağı olarak bırakın. Invalidation mantığınız ne kadar dikkatli kurulursa kurulsun, bir gün mutlaka kaçırırsınız bir senaryoyu. O an sizi kurtaran şey, verinin kendi kendine ölmesi olur.

