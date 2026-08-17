# Redis'te cache invalidation: veriyi ne zaman unutmalı

Cache'leme kolaydır. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermektir. Phil Karlton'ın meşhur sözü boşuna değil: bilgisayar bilimlerindeki iki zor problemden biri cache invalidation.

## TTL: en basit ve çoğu zaman en doğru yaklaşım

Redis'te invalidation'ın en yalın hali `EXPIRE`. Veriye bir ömür biçersiniz, süre dolunca Redis onu kendisi temizler:

```
SET user:1042 "{...}" EX 300
```

Bu yaklaşımın iyi tarafı, hata durumunda kendini toparlaması. Invalidation mantığınızda bir bug olsa bile bayat veri en fazla TTL kadar hayatta kalır.

Dezavantaj ise şu: TTL boyunca kullanıcılar eski veriyi görebilir. Ürün fiyatı için 5 dakika kabul edilebilirken, kullanıcı yetkileri için felaket olabilir.

## Write-through ve explicit invalidation

Veri değiştiğinde cache'i doğrudan silmek (`DEL`) ya da güncellemek daha keskin bir kontrol sağlar. Buradaki asıl soru şu: silmek mi, güncellemek mi?

Genel kural, **güncellemek yerine silmek**. Cache'i yazma anında güncellerseniz, eşzamanlı iki yazma işleminin sırası karışabilir, cache de kalıcı olarak yanlış değeri tutabilir. Silme ise idempotent; bir sonraki okuma veriyi veritabanından tazeler.

Silmenin de bir sırası var: önce veritabanını yazın, sonra cache'i silin. Tersini yaparsanız, silme ile yazma arasındaki pencerede araya giren başka bir okuma eski veriyi tekrar cache'e koyabilir.

## Cache stampede problemi

Popüler bir key expire olduğu anda yüzlerce istek aynı anda veritabanına yönelir. Buna cache stampede denir; canlı ortamda veritabanını çökertecek kadar ciddi bir problem.

İki pratik çözüm var. Birincisi, bir lock key ile yalnızca tek bir isteğin veriyi yeniden üretmesine izin vermek:

```
SET lock:user:1042 1 NX EX 10
```

`NX` sayesinde yalnızca ilk istek lock'u alır, diğerleri ya kısa süre bekler ya da bayat veriyi döner.

İkincisi ise probabilistic early expiration: TTL dolmadan biraz önce, rastgele seçilen küçük bir istek yüzdesinin cache'i proaktif olarak yenilemesi.

## Grup halinde invalidation

Tek bir key'i silmek kolay, ama "bu kullanıcıya ait tüm cache'leri sil" demek zor. `KEYS user:1042:*` komutu asla kullanılmamalı; Redis tek thread'li çalıştığı için bu komut tüm sunucuyu bloke eder. `SCAN` daha güvenli ama yine de yavaş.

Daha temiz yöntem versiyon damgası. Key'lere bir versiyon numarası gömersiniz:

```
user:1042:v7:profile
```

Kullanıcı verisi değiştiğinde `INCR user:1042:version` yaparsınız. Eski versiyonlu key'ler o andan sonra hiç okunmaz, TTL'leri dolunca da sessizce ölür. Tek bir atomik komutla binlerce key'i geçersiz kılmış olursunuz. Daha doğrusu silmiş olmazsınız; mantıksal olarak geçersiz kılmış olursunuz.

## Hangi stratejiyi seçmeli

Doğru strateji, verinin bayatlığa toleransına bağlı. Tolerans yüksekse TTL yeterli; düşükse explicit invalidation ve versiyonlama gerekir.

Her durumda TTL'i bir güvenlik ağı olarak bırakın. Invalidation mantığınız er ya da geç bir senaryoyu kaçıracak; o an sizi kurtaran şey verinin kendi kendine ölmesi olur.
