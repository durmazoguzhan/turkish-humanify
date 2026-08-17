# Kubernetes'te request'i scheduler okur, limiti kernel uygular

Pod Pending'de bekliyor, `kubectl describe node` çıktısında ise CPU'nun yarısı
boş görünüyor. Bu tabloyu bir kez gören herkes iki alanın aynı şey olmadığını
anlar: request yerleştirme kararını ilgilendirir, limit çalışma anındaki tavanı.

Request bir rezervasyon. Scheduler bir pod'u yerleştirirken node'un o an ne
kadar CPU harcadığına bakmaz, o node'daki pod'ların request toplamına bakar. 4
CPU'luk bir node'da 500m, yani yarım çekirdek isteyen yedi pod duruyorsa,
sekizincisi hepsi idle olsa bile yerleşmez. Kapasite kullanılmıyor ama ayrılmış
durumda.

Limit ise bir tavan; onu uygulayan da Kubernetes değil. Değer container'ın
cgroup ayarlarına yazılır, aşıldığında müdahale eden şey kernel olur.

## Limit aşıldığında ne oluyor

CPU sıkıştırılabilir bir kaynak, o yüzden limiti aşan container öldürülmez,
throttle edilir. CFS varsayılan olarak 100 ms'lik periyotlar üzerinden çalışır;
container kotasını periyodun ortasında bitirdiğinde kalan süre boyunca sırasını
bekler. Ortaya çıkan şey p99 gecikmesinde görünen ama hiçbir yere hata olarak
düşmeyen bir yavaşlama.

Memory'de böyle bir esneklik yok. Limitini aşan container OOMKill edilir, 137
exit code'uyla kapanır ve restart olur. `kubectl describe pod` çıktısında son
durumun sebebi olarak `OOMKilled` yazar.

Pratik sonuç şu: memory'de limit koymamak riskli, CPU'da ise fazla düşük
tutulmuş bir limit performansı sessizce bozar. Daha doğrusu, bozan şey limitin
kendisi değil, gerçek kullanımın altında kalmış bir limit.

## Request tahliye sırasını da belirliyor

Bir pod'un bütün container'larında request ile limit birbirine eşitse pod
Guaranteed sınıfına girer. Değerlerin bir kısmı verilmişse Burstable, hiçbiri
verilmemişse BestEffort olur. Node'da memory baskısı oluştuğunda kubelet önce
BestEffort pod'ları, ardından request'inin üzerine çıkmış Burstable pod'ları
tahliye eder. Yani request, "baskı altında ne kadar korunuyorum" sorusunun da
cevabı.

Sık rastlanan bir hata da limit verip request'i boş bırakmak. Kubernetes bu
durumda request'i limite eşitler; farkında olmadan hem Guaranteed bir pod hem de
ihtiyacınızdan büyük bir rezervasyon almış olursunuz. Namespace genelinde bu
işi LimitRange ile yönetmek, her deployment'ta tek tek uğraşmaktan kolay.

İkisi de tahminle değil ölçümle doldurulacak alanlar. Bir süre canlıda
çalıştırıp gerçek kullanımı gördükten sonra request'i oraya çekmek, ilk gün bir
sayı uydurmaktan çok daha sağlıklı.
