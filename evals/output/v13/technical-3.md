**Git'te merge geçmişe ekler, rebase geçmişi yeniden yazar**

Bir dalda çalışırken ana dal ilerlemeye devam eder. Er ya da geç bu iki çizgiyi birleştirmeniz gerekir. Git de bunun için iki yol sunar: merge ve rebase. İkisi de sonuçta aynı kodu bir araya getirir, ama commit geçmişine bıraktıkları iz taban tabana zıt.

**Merge ne yapar?**

`git merge` iki dalın ucunu alıp iki ebeveynli yeni bir commit oluşturur. Mevcut commit'lerin hiçbirine dokunmaz. Hepsi kimliğiyle, yani hash'iyle olduğu gibi kalır. Geçmiş, dalların nerede ayrılıp nerede yeniden buluştuğunu gösteren bir grafiğe dönüşür.

Bunun en büyük avantajı dürüstlüğü. Projede gerçekte ne olduysa geçmişte de o görünür; kimin ne zaman hangi daldan ayrıldığı kaybolmaz.

Dezavantajı ise kalabalık. Onlarca kişinin çalıştığı bir depoda log çıktısı birbirine giren çizgilerden okunmaz hâle gelebilir. "Merge branch 'main' into feature" commit'leri de bilgi taşımadan yer kaplar.

**Rebase ne yapar?**

`git rebase` ise dalınızdaki commit'leri toplayıp hedef dalın en son hâlinin üzerine tek tek yeniden uygular. Yani commit'leriniz sanki baştan beri güncel main üzerinde yazılmış gibi görünür. Ortaya düz, doğrusal, yukarıdan aşağıya okunan bir geçmiş çıkar.

Buradaki kritik nokta şu: commit'ler taşınmaz, yeniden yaratılır. Aynı değişikliği taşıyan yeni commit'lerin hash'i farklı olur. Eskiler teknik olarak hâlâ ortada durur ama artık dalınız onlara işaret etmez.

Somut düşünelim. main'den ayrılıp üç commit attınız, bu sırada ekip main'e beş commit ekledi. Merge yaparsanız bu sekiz commit'in yanına bir de birleştirme commit'i eklenir, dalınızın nereden çıktığı grafikte görünür kalır. Rebase yaparsanız sizin üç commit'iniz ekibin beş commit'inin üzerine taşınır. Grafikte hiç çatal kalmaz, hepsi sıraya girmiş gibi olur.

**Asıl ayrım: geçmişi yeniden yazmak**

Merge geçmişe ekler, rebase geçmişi değiştirir. Buradan da altın kural doğar: paylaşılan dalları rebase etmeyin. Bir commit'i push ettiyseniz ve başkası onu almışsa, rebase sonrasında herkesin geçmişi çatallanır. `--force` ile push etmek de arkadaşlarınızın çalışmasını uçurabilir. Rebase, henüz kimsenin görmediği kendi yerel dalınız için biçilmiş kaftan.

Çakışmalar da farklı davranır. Merge'de tüm çakışmaları tek seferde çözersiniz. Rebase'de commit'ler sırayla uygulandığı için aynı dosyada birkaç kez çakışma çözmeniz gerekebilir; karşılığında her commit'i kendi başına anlamlı tutmuş olursunuz.

**Pratikte nasıl karar verilir?**

Yaygın yaklaşım ikisini birlikte kullanmak: özellik dalınızı güncel tutmak için `git rebase main` yapın, gözden geçirilmiş dalı ana dala katarken merge kullanın. Böylece hem temiz bir commit dizisi elde eder hem de özelliğin projeye ne zaman girdiğini geçmişte görünür bırakırsınız.

Bazı ekipler bunu tek adıma indirger, pull request'i squash ile birleştirip dalın tüm çalışmasını tek commit'e düşürür. Hangisini seçerseniz seçin, önemli olan ekibin aynı kuralı uygulaması. Karışık kullanılan bir geçmiş her iki yöntemin de faydasını götürür.

Merge "ne oldu"yu, rebase "ne anlatmak istediğinizi" kaydeder. Doğru cevap ekibinizin geçmişten ne beklediğine bağlı.
