# Docker imajını küçültmenin beş yolu

Şişkin bir Docker imajı yalnızca disk alanı sorunu değil. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtım hızını düşürür ve saldırı yüzeyini genişletir. Neyse ki tipik bir imajın boyutunu birkaç basit teknikle üçte birine, kimi zaman onda birine indirebilirsiniz.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda gizli. `ubuntu` veya `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır; `-slim` varyantları ise çoğu uygulama için fazlasıyla yeterli.

Alpine tabanlı imajlar daha da küçük. Ama musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabilir; geçmeden önce test edin. Go veya Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarının çalışma zamanında bulunmasına gerek yok. Derleyiciler, geliştirme header'ları, test bağımlılıkları ve paket yöneticisi önbellekleri yalnızca build sırasında lazım. Çok aşamalı derlemede uygulamayı ilk aşamada derler, ikinci aşamada yalnızca üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Bu yaklaşım tek başına yüzlerce megabaytlık fark yaratır; üstelik derleme araçlarının oluşturduğu güvenlik risklerini de ortadan kaldırır.

## Katman sayısını ve içeriğini kontrol edin

Docker imajları katmanlardan oluşur; bir katmanda sildiğiniz dosya bir önceki katmanda durmaya devam eder. Kurulumu ve temizliği bu yüzden aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı önerilen gereksiz paketleri engeller. `npm ci --omit=dev`, `pip install --no-cache-dir` gibi seçenekler de önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

Build context'e giren `.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları hem imajı büyütür hem de build süresini uzatır. Bunun için küçük bir `.dockerignore` dosyası yeter; çoğu projede kazancı anında görürsünüz.

## Ölçün ve doğrulayın

Tahmin yürütmek yerine ölçün. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir, `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlamak, en çok kazanç getiren noktaya odaklanmanızı sağlar.

## Hangi sırayla

Sıralama basit: önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın.
