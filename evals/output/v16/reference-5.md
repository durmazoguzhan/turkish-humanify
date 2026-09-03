### Kanıt: toplu kuyruğu içeriden besleyen yok

Repoyu baştan sona taradım:
- `orders.export.single` (**publish**, tek kayıt) → aktarım onaylandıktan sonra işaretlemek için tek iç üretici var: `ExportScheduler.cs:88`.
- `orders.export.batch` (**publish**, toplu, `BatchExportMessage` listesi) → **hiçbir iç üreticisi yok**, sadece consumer tanımı ve kontrat şeması. Yalnızca dış entegrasyon için var, partner trafiği de buraya düşüyor.
