### Kanıt: toplu kuyruğu içeriden besleyen yok

Tüm repo taraması:
- `orders.export.single` (**publish**, tek kayıt) → tek iç üretici `ExportScheduler.cs:88`; aktarım onaylandıktan sonra işaretlemek için.
- `orders.export.batch` (**publish**, toplu, `BatchExportMessage` listesi) → **hiçbir iç üreticisi yok**, sadece consumer tanımı + kontrat şeması. Yalnızca dış entegrasyon için var. Partner trafiği bu kuyruğa düşüyor.
