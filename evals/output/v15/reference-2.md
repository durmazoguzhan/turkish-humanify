# Sipariş Servisi REST API Referansı

Sipariş oluşturmak, sorgulamak, güncellemek, iptal etmek: sipariş servisi hepsini tek bir HTTP arayüzü üzerinden sunar. Tüm istekler `https://api.example.com/v1` altında toplanır. Gövde formatı `application/json`, kimlik doğrulama da `Authorization: Bearer <token>` header'ı üzerinden.

## Endpoint'ler

### `POST /orders`

Yeni sipariş oluşturur. İstek gövdesi zorunludur.

| Alan | Tip | Zorunlu | Açıklama |
|---|---|---|---|
| `customerId` | string | Evet | Müşteri kimliği (UUID) |
| `items` | array | Evet | En az bir kalem içermeli |
| `items[].sku` | string | Evet | Ürün stok kodu |
| `items[].quantity` | integer | Evet | 1 ile 999 arası |
| `currency` | string | Hayır | ISO 4217 kodu, varsayılan `TRY` |
| `note` | string | Hayır | En fazla 500 karakter |

### `GET /orders/{orderId}`

Tek bir siparişin tüm detayını döner. `orderId` path parametresi zorunludur.

### `GET /orders`

Sipariş listesini sayfalayarak döner.

| Parametre | Tip | Varsayılan | Açıklama |
|---|---|---|---|
| `customerId` | string | - | Belirli bir müşteriye göre filtreler |
| `status` | string | - | `pending`, `paid`, `shipped`, `cancelled` |
| `createdAfter` | string | - | ISO 8601 tarih-saat |
| `page` | integer | `1` | Sayfa numarası |
| `pageSize` | integer | `20` | En fazla `100` |

### `PATCH /orders/{orderId}`

Sipariş üzerinde kısmi güncelleme yapar. Yalnızca `note` ve `shippingAddress` alanları güncellenebilir, kalemler ise değiştirilemez.

### `DELETE /orders/{orderId}`

Siparişi iptal eder. Sipariş kargoya verilmişse iptali reddeder.

## Dönüş kodları

| Kod | Anlamı |
|---|---|
| `200 OK` | İstek başarılı, gövdede kaynak var |
| `201 Created` | Sipariş oluşturuldu, `Location` header'ı kaynağı gösterir |
| `204 No Content` | İptal başarılı, dönecek gövde yok |
| `400 Bad Request` | Doğrulama hatası; alan bazlı detay `errors` dizisinde |
| `401 Unauthorized` | Token yok, geçersiz veya süresi dolmuş |
| `403 Forbidden` | Token geçerli ama bu sipariş çağıran hesaba ait değil |
| `404 Not Found` | Sipariş bulunamadı |
| `409 Conflict` | Sipariş durumu işleme izin vermiyor (kargolanmış siparişin iptali gibi) |
| `422 Unprocessable Entity` | Gövde geçerli ama iş kuralına takılıyor (stok yetersiz) |
| `429 Too Many Requests` | Rate limit aşıldı, `Retry-After` header'ına bakın |
| `500 Internal Server Error` | Beklenmeyen sunucu hatası |

## Örnek istek

```bash
curl -X POST https://api.example.com/v1/orders \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: 9f1c7a2e-4b18-4d5f-8c31-2a6e0b5d7f44" \
  -d '{
    "customerId": "c3a91e70-5d2b-4f88-9a10-6b7c8d9e0f12",
    "currency": "TRY",
    "items": [
      { "sku": "TR-4821", "quantity": 2 },
      { "sku": "TR-9013", "quantity": 1 }
    ],
    "note": "Kapıda teslim edilsin"
  }'
```

Örnek yanıt (`201 Created`):

```json
{
  "orderId": "8d4b1f62-0c93-4a77-b5e8-1f2a3c4d5e6f",
  "status": "pending",
  "total": 749.90,
  "currency": "TRY",
  "createdAt": "2026-09-04T11:23:07Z"
}
```

`Idempotency-Key` header'ı isteğe bağlı ama göndermenizi öneririz. Aynı anahtarla tekrarlanan `POST` isteği yeni sipariş açmaz, ilk yanıtı aynen döner. Anahtar 24 saat saklanır.
