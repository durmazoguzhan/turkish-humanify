# Redis'te Cache Invalidation: Doğru Veriyi Doğru Zamanda Unutmak

Cache'leme kolaydır. Zor olan, cache'lenmiş verinin ne zaman geçersiz hale geldiğine karar vermektir. Phil Karlton'ın meşhur sözü boşuna değil: bilgisayar bilimlerindeki iki zor problemden biri cache invalidation.

## TTL: En basit ve çoğu zaman en doğru yaklaşım

Redis'te invalidation'ın en yalın hali `EXPIRE` kullanmaktır. Veriye bir ömür biçersiniz, süre dolunca Redis onu kendisi temizler:

```
SET user:1042 "{...}" EX 300
```

Bu yaklaşımın güzelliği, hata durumunda kendini toparlamasıdır. Invalidation mantığınızda bir bug olsa bile, bayat veri en fazla TTL kadar hayatta kalır. Dezavantajı ise, TTL süresince kullanıcıların eski veriyi görebilmesidir. Ürün fiyatı için 5 dakika kabul edilebilirken, kullanıcı yetkileri için felaket olabilir.

## Write-through ve explicit invalidation

Veri değiştiğinde cache'i doğrudan silmek (`DEL`) ya da güncellemek daha keskin bir kontrol sağlar. Burada kritik soru şudur: silmek mi, güncellemek mi?

Genel kural, **güncellemek yerine silmektir**. Cache'i yazma anında güncellerseniz, eşzamanlı iki yazma işleminin sırası karışabilir ve cache kalıcı olarak yanlış değeri tutabilir. Silme işlemi ise idempotenttir; bir sonraki okuma veriyi veritabanından tazeler.

Sıralama da önemlidir: önce veritabanını yazın, sonra cache'i silin. Tersi sırada, silme ile yazma arasındaki pencerede başka bir okuma eski veriyi tekrar cache'e koyabilir.

## Cache stampede problemi

Popüler bir key expire olduğu anda, yüzlerce istek aynı anda veritabanına yönelir. Buna cache stampede denir ve production'da veritabanı çökertecek kadar ciddidir.

İki pratik çözüm var. Birincisi, bir lock key ile yalnızca tek bir isteğin veriyi yeniden üretmesine izin vermek:

```
SET lock:user:1042 1 NX EX 10
```

`NX` sayesinde yalnızca ilk istek lock'u alır, diğerleri ya kısa süre bekler ya da bayat veriyi döner. İkincisi ise probabilistic early expiration: TTL dolmadan biraz önce, rastgele seçilen küçük bir istek yüzdesinin cache'i proaktif olarak yenilemesi.

## Grup halinde invalidation

Tek bir key'i silmek kolay, ama "bu kullanıcıya ait tüm cache'leri sil" demek zordur. `KEYS user:1042:*` komutu asla kullanılmamalıdır; Redis tek thread'li çalıştığı için bu komut tüm sunucuyu bloke eder. `SCAN` daha güvenlidir ama yine de yavaştır.

Daha temiz yöntem, versiyon damgasıdır. Key'lere bir versiyon numarası gömersiniz:

```
user:1042:v7:profile
```

Kullanıcı verisi değiştiğinde `INCR user:1042:version` yaparsınız. Eski versiyonlu key'ler artık hiç okunmaz ve TTL'leriyle sessizce ölür. Tek bir atomik komutla binlerce key'i mantıksal olarak geçersiz kılmış olursunuz.

## Kapanış

Doğru strateji, verinin bayatlığa toleransına bağlıdır. Tolerans yüksekse TTL yeterlidir; düşükse explicit invalidation ve versiyonlama gerekir. Her durumda TTL'i bir güvenlik ağı olarak bırakın: invalidation mantığınız er ya da geç bir senaryoyu kaçıracaktır ve o an sizi kurtaracak olan şey, verinin kendi kendine ölmesidir.
