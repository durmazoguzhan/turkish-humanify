# Migration çalışırken eski kod hâlâ ayakta

`CREATE INDEX idx_siparis_durum ON siparis (durum);`

Bu satır geliştirme makinesinde göz açıp kapayana kadar döner. Canlı ortamda, tablo yeterince büyükse, Postgres index'i kurarken tabloyu yazmaya kapatır; o birkaç dakika boyunca hiçbir sipariş kaydedilmez. `CONCURRENTLY` eklemek kilidi hafifletiyor ama bedava değil: migration daha uzun sürer, ortasında hata alırsa da arkasında geçersiz bir index bırakır ve onu elle silmek gerekir.

Kilit süresi ölçülebilir bir şey, o yüzden bir migration'a bakarken ilk durulacak yer burası. İkinci yer daha az görünür.

## Bir değişiklik, iki deploy

Şema ile kod aynı saniyede değişmez. Migration bittiğinde eski sürüm hâlâ birkaç instance'ta ayakta olur, deploy geri alınırsa da tek başına kalır. Her migration bu yüzden bir süre boyunca hem eski hem yeni kodla çalışmak zorunda.

Kolon silmek, kolon adını değiştirmek, tipini daraltmak: bunlar tek adıma sığmıyor. Adımları ayrı sürümlere dağıtmak gerekiyor.

1. Yeni kolonu NULL kabul edecek şekilde ekleyin; kod bir süre hem eskisine hem yenisine yazsın.
2. Eski satırları parça parça doldurun. Tek bir `UPDATE` ile milyonlarca satıra dokunmak, tabloyu kilitlemenin en kısa yolu.
3. Okumaları yeni kolona geçirip bir sürüm bekleyin.
4. `NOT NULL` constraint'ini ve eski kolonun silinmesini en sona bırakın.

Tek satırlık bir değişiklik için dört deploy fazla görünüyor. Fazla değil, çünkü aradaki her aşamada geri dönebiliyorsunuz; hiçbirinde eski kod bozulmuyor.

## Geri alma planı `down` script'i değil

Her migration'ın bir `down` adımı olması gerektiği söylenir. Daha doğrusu, `down` yazmak iyi; ama bir kez bile koşturulmadığı sürece elinizde plan değil iyi niyet var.

Bir de hiç geri alınamayan migration'lar var. Silinen kolon `down` çalışınca geri gelmiyor, daraltılan tip eski değerleri hatırlamıyor, birleştirilen iki satır ayrılmıyor. Değişikliği geri alınabilir parçalara bölmek zaten bu yüzden işe yarıyor: geri alınamayan adım en sona kalıyor ve sıra ona geldiğinde yeni kod günlerdir canlıda çalışıyor oluyor.

Veritabanı tarafında test etmenin de bir sınırı var. Boş bir şemada geçen migration, veri hacmi ve index sayısı farklı olduğu için canlıda başka davranır. Kilit süresini gerçekten öğrenmek istiyorsanız üretim verisinin bir kopyası gerekiyor, örnek veri yetmiyor.

Bir migration'ı incelemeye üç soruyla başlayın: hangi tabloyu ne kadar süre kilitliyor, kaç satıra dokunuyor, eski kod bu şemayla ayakta kalır mı. Üçünün de cevabı yoksa o migration'ı canlıya yakın bir kopyada bir kez koşturmadan geçirmeyin.
