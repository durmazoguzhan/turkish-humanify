
# Docker İmajlarını Küçültme Yöntemleri

Şişkin bir Docker imajı disk alanından fazlasını götürür. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtım hızını düşürür, saldırı yüzeyini genişletir. İyi tarafı da var. Tipik bir imajın boyutunu birkaç basit teknikle üçte birine, kimi zaman onda birine indirebilirsiniz.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda gizlidir. `ubuntu` veya `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır. Çoğu uygulama için `-slim` varyantları fazlasıyla yeterli. Alpine tabanlı imajlar daha da küçük. Ne var ki musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabilirler. Geçmeden önce test edin. Go veya Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarının çalışma zamanında bulunmasına gerek yok. Daha doğrusunu söyleyelim. Uygulamayı derleyen şeylerin nihai imajda hiç işi yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları ve paket yöneticisi önbellekleri yalnızca build sırasında lazım. Çok aşamalı derlemede ilk aşamada uygulamayı derler, ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Tek başına yüzlerce megabaytlık fark yaratır bu yaklaşım. Bir de derleme araçlarının doğurduğu güvenlik risklerinden kurtulursunuz.

## Katman sayısını ve içeriğini kontrol edin

Docker imajları katmanlardan oluşur ve bir katmanda sildiğiniz dosya önceki katmanda durmaya devam eder. Silmek tek başına yetmiyor yani. Kurulumu ve temizliği aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı gereksiz önerilen paketleri engeller. Paket yöneticilerinde de benzer seçenekler var. `npm ci --omit=dev` ya da `pip install --no-cache-dir` önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları build context'e girdiğinde hem imajı büyütür hem de build süresini uzatır. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç sağlar.

## Ölçün ve doğrulayın

Nereden başlamalı? Ölçün önce, tahmin yürütmeyin. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlamak, en çok kazanç getiren noktaya odaklanmanızı sağlar.

## Özet

Sıralama basit. Önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın. Beşi birlikte çoğu projede imaj boyutunu düşürür ve dağıtımı hızlandırır.

