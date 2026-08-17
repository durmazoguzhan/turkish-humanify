# Request mi Limit mi? Kubernetes'te Kaynak Ayarlarının Anlamı

Yeni bir deployment yazarken `resources` bloğunu boş bıraktığınız oldu mu? Olduysa çok da endişelenmeyin, çoğu ekip bir noktada bunu yapıyor. Sonra bir gün production'da tek bir pod diğerlerinin CPU'sunu yemeye başlıyor ya da node üzerinde OOMKilled'lar görünüyor ve o boş blok akla geliyor.

**Request**, scheduler'a verdiğiniz bilgidir. "Bu container ayağa kalkarken en az bu kadar kaynağa ihtiyacı var" demenin yolu. Kube-scheduler bir pod'u yerleştirirken node'ların allocatable kapasitesine bakar ve üzerindeki request toplamını hesaba katar. Yani request aslında bir rezervasyon: o kaynak başkasına dağıtılamaz, pod gerçekten kullanmasa bile hesapta durur.

**Limit** ise tavandır. Container çalışırken bu değerin üstüne çıkamaz. Burada CPU ile memory arasında kritik bir davranış farkı var ve bu fark sık atlanıyor.

CPU sıkıştırılabilir bir kaynak. Limit'e dayandığınızda kernel'in CFS quota mekanizması container'ı throttle eder; yavaşlarsınız ama ölmezsiniz. Memory öyle değil. Limit'i aştığınız anda OOM killer devreye girer ve container restart edilir. Loglarda gördüğünüz o `Exit Code 137` tam olarak budur.

Peki ikisi arasındaki boşluk ne işe yarıyor? O boşluk pod'unuzun QoS class'ını belirliyor:

- request = limit ise pod **Guaranteed** olur. Node baskı altına girdiğinde en son evict edilecek sınıf bu.
- request < limit ise **Burstable**. Normalde request kadar alır, kaynak müsaitse limit'e kadar çıkar. Ama sıkışma anında evict listesinde Guaranteed'ın önündedir.
- İkisi de yoksa **BestEffort**. İlk gidenler bunlar.

Pratikte nasıl karar vereceksiniz? Memory için request ile limit'i eşit tutmak çoğu servis için doğru tercih. Memory'de "burst edip sonra geri verme" diye bir şey yok; aştıysanız zaten öldünüz, o esnekliğin size bir faydası olmuyor. CPU'da ise biraz alan bırakmak mantıklı, özellikle JVM gibi startup'ta yoğun CPU isteyen uygulamalarda. Bazı ekipler CPU limit'ini hiç koymayıp sadece request veriyor. Tartışmalı bir yaklaşım, ama arkasındaki gerekçe throttling'in latency'ye verdiği zarar.

Rakamları nereden bulacağınıza gelince: tahminle değil, ölçümle. VPA'yı recommender modunda çalıştırıp bir hafta bekleyin, ya da Prometheus'ta `container_memory_working_set_bytes` ve CPU kullanımı için p95/p99 değerlerine bakıp üstüne makul bir pay ekleyin.

Son olarak LimitRange ve ResourceQuota'yı da hatırlatalım. Namespace bazında default değer atamanızı ve tavan koymanızı sağlıyorlar. Multi-tenant bir cluster işletiyorsanız bunlar opsiyonel sayılmaz.
