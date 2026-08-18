**Git'te merge ile rebase: aynı kod, farklı geçmiş**

Bir dalda çalışırken ana dal ilerlemeye devam eder. Er ya da geç bu iki çizgiyi birleştirmeniz gerekir, Git de bunun için iki yol sunar: merge ve rebase. İkisi de sonuçta aynı kodu bir araya getirir. Commit geçmişine bıraktıkları iz ise taban tabana zıt.

**Merge ne yapar?**

`git merge` iki dalın uçlarını alıp iki ebeveyni olan yeni bir commit oluşturur. Mevcut commit'lerin hiçbirine dokunmaz; hepsi kimliğiyle, yani hash'iyle olduğu gibi kalır. Geçmiş de dalların nerede ayrılıp nerede tekrar buluştuğunu gösteren bir grafiğe dönüşür.

Bunun en büyük avantajı dürüstlüğü: projede gerçekte ne olduysa geçmişte de o görünür. Kimin ne zaman hangi daldan ayrıldığı kaybolmaz.

Dezavantajı ise kalabalık. Onlarca kişinin çalıştığı bir depoda log çıktısı birbirine giren çizgilerden okunmaz hâle gelebilir. "Merge branch 'main' into feature" commit'leri de bilgi taşımadan yer kaplar.

**Rebase ne yapar?**

`git rebase` dalınızdaki commit'leri toplayıp hedef dalın en son hâlinin üzerine tek tek yeniden uygular. Yani commit'leriniz sanki baştan beri güncel main üzerinde yazılmış gibi görünür. Sonuçta düz, doğrusal, yukarıdan aşağıya okunan bir geçmiş kalır.

Kritik ayrım şurada: commit'ler taşınmaz, yeniden yaratılır. Aynı değişikliği içeren yeni commit'lerin hash'leri farklı olur. Eskiler hâlâ ortada durur. Daha doğrusu teknik olarak durur, dalınız artık onlara işaret etmez.

Somut düşünelim. main'den ayrıldınız, üç commit attınız. Bu sırada ekip main'e beş commit ekledi. Merge yaparsanız bu sekiz commit'in yanına bir de birleştirme commit'i eklenir, dalınızın nereden çıktığı grafikte görünür kalır. Rebase yaparsanız sizin üç commit'iniz ekibin beş commit'inin üzerine taşınır. Grafikte hiç çatal kalmaz, hepsi sıraya girmiş gibi olur.

**Asıl ayrım: geçmişi yeniden yazmak**

Merge geçmişe ekler, rebase geçmişi değiştirir. Altın kural da buradan doğar: paylaşılan dalları rebase etmeyin. Push ettiğiniz bir commit'i başkası almışsa, rebase sonrası herkesin geçmişi çatallanır. `--force` ile push etmek de arkadaşlarınızın çalışmasını uçurabilir. Rebase, henüz kimsenin görmediği kendi yerel dalınız için biçilmiş kaftan.

Çakışmalar da farklı davranır. Merge'de tüm çakışmaları tek seferde çözersiniz. Rebase'te commit'ler sırayla uygulandığı için aynı dosya için birkaç kez çakışma çözmeniz gerekebilir. Karşılığında her commit'i kendi başına anlamlı tutmuş olursunuz.

**Pratikte nasıl karar verilir?**

En yaygın yaklaşım ikisini birlikte kullanmak: özellik dalınızı güncel tutmak için `git rebase main` yapın, gözden geçirilmiş dalı ana dala katarken merge kullanın. Böylece hem temiz bir commit dizisi elde eder hem de özelliğin projeye ne zaman girdiğini geçmişte görünür bırakırsınız. Bazı ekipler bunu tek adıma indirir, pull request'i squash ile birleştirip dalın tüm çalışmasını tek commit'e düşürür. Hangisini seçerseniz seçin, önemli olan ekibin aynı kuralı uygulaması. Karışık kullanılan bir geçmiş her iki yöntemin de faydasını götürür.

Merge "ne oldu"yu kaydeder, rebase "ne anlatmak istediğinizi". Doğru cevap da ekibinizin geçmişten ne beklediğine bağlı.
