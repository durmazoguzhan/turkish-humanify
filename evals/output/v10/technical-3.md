**Git'te merge ile rebase: fark kodda değil geçmişte**

Bir dalda çalışırken ana dal ilerlemeye devam eder. Er ya da geç bu iki çizgiyi birleştirmeniz gerekecek. Git bunun için iki yol sunuyor: merge ve rebase. İkisi de sonuçta aynı kodu bir araya getirir. Ama commit geçmişine bıraktıkları iz taban tabana zıt.

**Merge iki ucu birbirine bağlar**

`git merge` iki dalın ucunu alıp iki ebeveynli yeni bir commit oluşturur. Mevcut commit'lerin hiçbirine dokunmaz; hepsi kimliğiyle, yani hash'iyle olduğu gibi kalır. Geçmiş, dalların nerede ayrılıp nerede yeniden buluştuğunu gösteren bir grafiğe dönüşür.

Bunun en büyük avantajı dürüstlüğü: projede gerçekte ne olduysa geçmişte de o görünür. Kimin ne zaman hangi daldan ayrıldığı kaybolmaz.

Dezavantajı ise kalabalık. Onlarca kişinin çalıştığı bir depoda log çıktısı, birbirine giren çizgilerden okunmaz hâle gelebilir. "Merge branch 'main' into feature" commit'leri de bilgi taşımadan yer kaplar.

**Rebase commit'leri baştan yazar**

`git rebase` dalınızdaki commit'leri toplayıp hedef dalın en son hâlinin üzerine tek tek yeniden uygular. Yani commit'leriniz sanki baştan beri güncel main üzerinde yazılmış gibi görünür. Sonuç düz, doğrusal, yukarıdan aşağıya okunabilen bir geçmiş.

Şurası önemli: commit'ler taşınmaz, yeniden yaratılır. Aynı değişikliği içeren yeni commit'lerin hash'leri farklı olur. Daha doğrusu, eskiler yok olmuyor; teknik olarak hâlâ ortada duruyorlar, ama dalınız artık onlara işaret etmiyor.

Somut düşünelim. main'den ayrıldınız, üç commit attınız; bu sırada ekip main'e beş commit ekledi. Merge yaparsanız bu sekiz commit'in yanına bir de birleştirme commit'i eklenir. Dalınızın nereden çıktığı grafikte görünür kalır. Rebase yaparsanız sizin üç commit'iniz ekibin beş commit'inin üzerine taşınır; grafikte hiç çatal kalmaz, hepsi sıraya girmiş gibi olur.

**Asıl ayrım: geçmişi yeniden yazmak**

Merge geçmişe ekler, rebase geçmişi değiştirir. Buradan da altın kural doğar: paylaşılan dalları rebase etmeyin. Bir commit'i push ettiyseniz, başkası da onu almışsa, rebase sonrası herkesin geçmişi çatallanır; `--force` ile push etmek de arkadaşlarınızın çalışmasını uçurabilir. Rebase, henüz kimsenin görmediği kendi yerel dalınız için biçilmiş kaftan.

Çakışmalar da farklı davranır. Merge'de tüm çakışmaları tek seferde çözersiniz. Rebase'te ise commit'ler sırayla uygulandığından aynı dosyada birkaç kez çakışma çözmeniz gerekebilir; karşılığında her commit kendi başına anlamlı kalmış olur.

**Pratikte nasıl karar verilir?**

Yaygın yaklaşım ikisini birlikte kullanmak: özellik dalınızı güncel tutmak için `git rebase main` yapın, gözden geçirilmiş dalı ana dala katarken merge kullanın. Böylece hem temiz bir commit dizisi elde eder hem de özelliğin projeye ne zaman girdiğini geçmişte görünür bırakırsınız.

Bazı ekipler bunu tek adıma indiriyor: pull request'i squash ile birleştirip dalın bütün çalışmasını tek commit'e düşürüyorlar. Hangisini seçerseniz seçin, önemli olan ekibin aynı kuralı uygulaması. Karışık kullanılan bir geçmiş her iki yöntemin de faydasını götürür.

Merge "ne oldu"yu, rebase "ne anlatmak istediğinizi" kaydeder. Doğru cevap ekibinizin geçmişten ne beklediğine bağlı.
