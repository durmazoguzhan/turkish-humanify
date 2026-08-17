# Request'i scheduler okur, limiti kernel uygular

Bir pod'un restart sayısı artıyor, kimse deploy etmemiş. Node'da yer var, CPU boş. Buna rağmen container iki dakikada bir ölüp geri geliyor. Bu tabloda bakılacak ilk yer request/limit çifti.

Request, scheduler'a verdiğiniz bilgi. `requests: memory: 512Mi` yazdığınızda Kubernetes bu pod'u ancak 512Mi'lik boşluğu olan bir node'a yerleştirir. Ama ölçtüğü şey node'un o anki kullanımı değil, o node'daki pod'ların request toplamı. Node gerçekte %20 doluyken bile yeni pod sığmayabilir; scheduler kullanımı değil verilmiş sözleri topluyor.

Bunun iki görünür sonucu var. Request'i olduğundan yüksek yazarsanız pod hiç ayağa kalkmadan Pending'de bekler, `kubectl describe` de size `Insufficient memory` der. İkincisi daha az bilinir: CPU tarafında request boşa gitmiyor, node kalabalıklaştığında kernel CPU zamanını container'ların request'leri oranında bölüştürür. 200m request'li container, 100m'liğin iki katı pay alır.

Limit ise çalışma anında geçerli. Kubernetes onu cgroup'a yazıyor, gerisini kernel yapıyor.

Burada CPU ile memory birbirine hiç benzemiyor. Farkın canınızı yaktığı yer de zaten burası. CPU sıkıştırılabilir bir kaynak: `limits: cpu: 500m` verdiğinizde container her 100 ms'lik periyotta 50 ms CPU zamanı alır, kotasını bitirince beklemeye geçer. Yavaşlar, ama ölmez. Memory'de böyle bir esneklik yok. Limiti aşan container'ı kernel öldürür, pod OOMKilled olarak geri gelir. İkisi aynı YAML bloğunda duruyor; sonuçları hiç aynı değil.

Bir de QoS tarafı var, çoğu ekibin gözünden kaçıyor. Bir pod'un bütün container'larında request ile limit birebir eşitse pod Guaranteed sınıfına girer. Request'i olup limiti farklı olan pod Burstable, hiçbir şey yazmayan pod BestEffort olur. Node'un memory'si sıkışınca kubelet önce BestEffort'u, sonra Burstable'ı tahliye eder. Yani hiç limit yazmamak pod'u özgür bırakmıyor, tahliye kuyruğunun en başına koyuyor. Namespace'te bir LimitRange duruyorsa hiçbir şey yazmasanız da değerler gelir; "ben limit koymadım" demek limit yok demek değil.

Pratikte iki alanı da aynı gözle doldurmuyoruz. Memory'de request ile limiti eşitleyip pod'u Guaranteed sınıfında tutuyoruz, çünkü memory'nin fazlasını sonradan geri vermenin yolu yok. CPU'da request'i mutlaka veriyoruz; limiti ölçmeden koymuyoruz. Daha doğrusu, CPU limitine karşı değilim: node bomboşken bile servisi yavaşlatan şey, `container_cpu_cfs_throttled_seconds_total` metriğine bakılmadan konmuş bir CPU limiti oluyor. O gecikmenin nereden geldiğini bulmak da ayrı bir akşam.
