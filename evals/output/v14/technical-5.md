# Docker imajı şişkinse sorun sadece disk değil

Şişkin bir imajın maliyeti diskte bitmiyor. Her yüz megabaytlık fazlalık CI süresini uzatır, dağıtım hızını düşürür, saldırı yüzeyini de genişletir. İyi tarafı, tipik bir imajı birkaç basit teknikle üçte birine, kimi zaman onda birine indirmek mümkün.

## Doğru temel imajla başlayın

En büyük kazanç genellikle ilk satırda saklı. `ubuntu` ya da `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır. Çoğu uygulama için `-slim` varyantları fazlasıyla yeterli.

Alpine tabanlı imajlar daha da küçük. Ama musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabilirler. Geçmeden önce test edin. Go ya da Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` imajları neredeyse sıfır ek yük getirir.

## Çok aşamalı derlemeye (multi-stage build) geçin

Derleme araçlarının çalışma zamanında bulunmasına gerek yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları ve paket yöneticisi önbellekleri yalnızca build sırasında lazım. Çok aşamalı derlemede uygulamayı ilk aşamada derleyip ikinci aşamada sadece üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Bu yaklaşım tek başına yüzlerce megabaytlık fark yaratır; derleme araçlarının oluşturduğu güvenlik risklerini de ortadan kaldırır.

## Katman sayısını ve içeriğini kontrol edin

Docker imajları katmanlardan oluşur. Bir katmanda sildiğiniz dosya önceki katmanda durmaya devam eder. Bu yüzden kurulumu ve temizliği aynı `RUN` komutunda yapın:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı önerilen gereksiz paketleri engeller. Aynı mantıkla `npm ci --omit=dev`, `pip install --no-cache-dir` gibi seçenekler önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları ve yerel ortam dosyaları build context'e girdiğinde hem imajı büyütür hem de build süresini uzatır. Küçük bir `.dockerignore` çoğu projede anında kazanç sağlar.

## Ölçün ve doğrulayın

Tahmin yürütmek yerine ölçün. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme işine buradan başlarsanız en çok kazanç getiren noktaya odaklanırsınız.

Sıralama basit: önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın. Bu beş adım çoğu projede imaj boyutunu dramatik biçimde düşürür, dağıtım süreçlerinizi de belirgin şekilde hızlandırır.
