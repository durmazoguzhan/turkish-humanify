# Docker imajını küçültmek: önce ölçün, sonra daraltın

Şişkin bir imaj yalnızca disk meselesi değil. Fazladan taşıdığınız her yüz megabayt CI süresini uzatır, dağıtımı yavaşlatır, saldırı yüzeyini genişletir. İyi tarafı, tipik bir imajı birkaç basit teknikle üçte birine, kimi zaman onda birine indirebilirsiniz.

## Doğru temel imajla başlayın

En büyük kazanç çoğu zaman ilk satırda saklı. `ubuntu` ya da `node:20` gibi tam dağıtımlar yüzlerce megabayt taşır; `-slim` varyantları ise çoğu uygulamaya fazlasıyla yeter. Alpine tabanlı imajlar daha da küçük. Ama musl libc kullandıkları için native bağımlılıklarda beklenmedik sorunlar çıkarabiliyorlar. Geçmeden önce test edin. Go, Rust gibi statik binary üretebilen dillerde `scratch` ya da `distroless` neredeyse sıfır ek yük getirir.

## Çok aşamalı derleme (multi-stage build)

Derleme araçlarına çalışma zamanında ihtiyacınız yok. Derleyiciler, geliştirme başlıkları, test bağımlılıkları, paket yöneticisinin önbellekleri; hepsi yalnızca build sırasında lazım. Çok aşamalı derlemede uygulamayı ilk aşamada derleyip ikinci aşamada yalnızca üretilen çıktıyı ince bir temel imaja kopyalarsınız:

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /app

FROM gcr.io/distroless/static
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

Bu yaklaşım tek başına yüzlerce megabaytlık fark yaratır, üstelik derleme araçlarının getirdiği güvenlik risklerini de ortadan kaldırır.

## Katman sayısını ve içeriğini kontrol edin

Docker imajı katmanlardan oluşur; bir katmanda sildiğiniz dosya bir önceki katmanda durmaya devam eder. Kurulumla temizliği bu yüzden aynı `RUN` komutunda yapmanız gerekir:

```dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*
```

`--no-install-recommends` bayrağı, önerilen ama gerekmeyen paketleri engeller. `npm ci --omit=dev`, `pip install --no-cache-dir` gibi seçenekler de önbellek dosyalarının imaja sızmasını önler.

## .dockerignore dosyasını ihmal etmeyin

`.git`, `node_modules`, test verileri, log dosyaları, yerel ortam dosyaları build context'e girdiğinde hem imajı büyütür hem de build süresini uzatır. Küçük bir `.dockerignore` dosyası çoğu projede anında kazanç getirir.

## Ölçün ve doğrulayın

Tahmin yürütmek yerine ölçün. `docker history <imaj>` hangi katmanın ne kadar yer kapladığını gösterir. `dive` aracı ise katman katman gezinerek boşa giden alanı ortaya çıkarır. Küçültme çalışmasına buradan başlarsanız en çok kazanç getiren noktaya odaklanırsınız.

## Hangi sırayla

Sıralama basit: önce ölçün, sonra temel imajı daraltın, çok aşamalı derlemeye geçin, katmanları temizleyin, build context'i sınırlayın. Bu beş adım çoğu projede imaj boyutunu ciddi biçimde düşürür, dağıtım süreçlerinizi de hızlandırır.
