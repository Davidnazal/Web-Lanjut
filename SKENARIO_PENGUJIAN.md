# 🧪 Laporan Skenario Pengujian REST API & Integrasi Aplikasi "MyParts"

**Mata Kuliah:** Sistem Web dan Seluler (Mobile) Lanjutan  
**Topik:** Pengujian REST API Poin F (Skenario Pengujian Deployment Cloud)  
**URL Live Production:** `https://web-lanjut-backend-laravel.vercel.app/`  
**URL REST API Endpoint:** `https://web-lanjut-backend-laravel.vercel.app/api/spareparts`  
**Link Repository GitHub:** `https://github.com/Davidnazal/Web-Lanjut.git`  

---

## 📋 Tabel Skenario Pengujian (Poin F PDF)

| No | Method | Endpoint | Skenario Pengujian | Expected Result | Actual Result | Status |
| :---: | :---: | :--- | :--- | :--- | :--- | :---: |
| **1** | `GET` | `/api/spareparts` | Menampilkan seluruh data sparepart | `200 OK` + JSON Array | `HTTP 200 OK`, JSON 6 data sparepart | **Pass** |
| **2** | `GET` | `/api/spareparts/1` | Menampilkan detail sparepart ID 1 | `200 OK` + JSON Object | `HTTP 200 OK`, Object ID 1 | **Pass** |
| **3** | `POST` | `/api/spareparts` | Menambahkan sparepart baru (Data Valid) | `201 Created` + JSON Object | `HTTP 201 Created`, Data tersimpan | **Pass** |
| **4** | `POST` | `/api/spareparts` | Menambahkan sparepart baru (Data Tidak Valid) | `422 Unprocessable Entity` + Error JSON | `HTTP 422`, Validation Error Message | **Pass** |
| **5** | `PUT` | `/api/spareparts/1` | Mengubah/memperbarui data sparepart ID 1 | `200 OK` + JSON Object Updated | `HTTP 200 OK`, Data ter-update | **Pass** |
| **6** | `DELETE` | `/api/spareparts/1` | Menghapus sparepart ID 1 | `200 OK` + JSON Message | `HTTP 200 OK`, "Sparepart berhasil dihapus" | **Pass** |
| **7** | `Flutter` | API Online | Menampilkan data pada antarmuka Flutter Web/Mobile | Data tampil lengkap dengan gambar & harga | Data katalog terisi & dapat diakses live | **Pass** |

---

## 🔬 Rincian Hasil Request & Response API (Postman / Insomnia)

### 1. GET — Menampilkan Seluruh Data
- **URL:** `GET https://web-lanjut-backend-laravel.vercel.app/api/spareparts`
- **Status Code:** `200 OK`
- **Response JSON:**
```json
{
    "status": "success",
    "message": "Data sparepart berhasil diambil",
    "data": [
        {
            "id": 6,
            "part_name": "Knalpot Aeromax Carbon Full System",
            "brand": "Aeromax",
            "category": "Knalpot",
            "compatible_bike": "Yamaha Vixion Old Gen 2 (2011)",
            "price": 1250000,
            "stock": 5,
            "description": "Knalpot racing Aeromax full system stainless carbon header. Suara bass adem bulat, meningkatkan akselerasi Vixion Old.",
            "image_url": "https://down-id.img.susercontent.com/file/id-11134207-82250-mkjwsud41sso06",
            "created_at": "2026-10-07 03:20:36",
            "updated_at": "2026-10-07 03:20:36"
        },
        {
            "id": 5,
            "part_name": "Kaliper 4 Piston RCB",
            "brand": "RCB",
            "category": "Pengereman",
            "compatible_bike": "Yamaha Vixion Old (Depan)",
            "price": 650000,
            "stock": 8,
            "description": "Kaliper 4 piston RCB CNC anodized. Memberikan daya cengkeram rem depan yang jauh lebih pakem.",
            "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIP4OHZU3svZ4uADVrZnPRmjABVjlv7_iq9tQJg6PV9zGZfpWb_9gwxr5B&s=10",
            "created_at": "2026-10-07 03:20:36",
            "updated_at": "2026-10-07 03:20:36"
        }
    ]
}
```

---

### 2. GET — Menampilkan Detail Data Berdasarkan ID
- **URL:** `GET https://web-lanjut-backend-laravel.vercel.app/api/spareparts/1`
- **Status Code:** `200 OK`
- **Response JSON:**
```json
{
    "status": "success",
    "message": "Detail sparepart berhasil diambil",
    "data": {
        "id": 1,
        "part_name": "Ban Aspira Premio Sportivo 2 (110/70-17)",
        "brand": "Aspira Premio",
        "category": "Ban & Velg",
        "compatible_bike": "Yamaha Vixion Old Gen 2 (2011)",
        "price": 580000,
        "stock": 12,
        "description": "Ban tubeless sport harian kompon medium-soft. Grip maksimal di jalan basah dan kering.",
        "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSridFmTP_OD5ujJ3gqEYS3UP20RDl_pphywRtmk-LkUndsTZn1gcDtPE&s=10",
        "created_at": "2026-10-07 03:20:36",
        "updated_at": "2026-10-07 03:20:36"
    }
}
```

---

### 3. POST — Menambahkan Data Baru (Data Valid)
- **URL:** `POST https://web-lanjut-backend-laravel.vercel.app/api/spareparts`
- **Headers:** `Content-Type: application/json`
- **Request Body JSON:**
```json
{
    "part_name": "Filter Udara Ferrox Racing",
    "brand": "Ferrox",
    "category": "Mesin",
    "compatible_bike": "Yamaha Vixion Old / Universal",
    "price": 420000,
    "stock": 15,
    "description": "Filter udara stainless steel 45 mikron, dapat dicuci dan dipakai selamanya.",
    "image_url": "https://example.com/ferrox.jpg"
}
```
- **Status Code:** `201 Created`
- **Response JSON:**
```json
{
    "status": "success",
    "message": "Sparepart berhasil ditambahkan",
    "data": {
        "id": 7,
        "part_name": "Filter Udara Ferrox Racing",
        "brand": "Ferrox",
        "category": "Mesin",
        "compatible_bike": "Yamaha Vixion Old / Universal",
        "price": 420000,
        "stock": 15,
        "description": "Filter udara stainless steel 45 mikron, dapat dicuci dan dipakai selamanya.",
        "image_url": "https://example.com/ferrox.jpg",
        "created_at": "2026-10-07 03:38:00",
        "updated_at": "2026-10-07 03:38:00"
    }
}
```

---

### 4. POST — Menambahkan Data Baru (Data Tidak Valid / Uji Validasi Server)
- **URL:** `POST https://web-lanjut-backend-laravel.vercel.app/api/spareparts`
- **Headers:** `Content-Type: application/json`
- **Request Body JSON (Tanpa Nama & Harga Kosong):**
```json
{
    "part_name": "",
    "brand": "",
    "price": -5000
}
```
- **Status Code:** `422 Unprocessable Entity`
- **Response JSON:**
```json
{
    "status": "error",
    "message": "The given data was invalid.",
    "errors": {
        "part_name": [
            "Nama sparepart wajib diisi."
        ],
        "brand": [
            "Brand/Merk wajib diisi."
        ],
        "category": [
            "Kategori wajib diisi."
        ],
        "price": [
            "Harga wajib diisi dan harus berupa angka positif."
        ]
    }
}
```

---

### 5. PUT — Mengubah / Update Data
- **URL:** `PUT https://web-lanjut-backend-laravel.vercel.app/api/spareparts/1`
- **Headers:** `Content-Type: application/json`
- **Request Body JSON:**
```json
{
    "part_name": "Ban Aspira Premio Sportivo 2 (110/70-17) - Revised",
    "price": 600000,
    "stock": 20
}
```
- **Status Code:** `200 OK`
- **Response JSON:**
```json
{
    "status": "success",
    "message": "Sparepart berhasil diperbarui",
    "data": {
        "id": 1,
        "part_name": "Ban Aspira Premio Sportivo 2 (110/70-17) - Revised",
        "brand": "Aspira Premio",
        "category": "Ban & Velg",
        "compatible_bike": "Yamaha Vixion Old Gen 2 (2011)",
        "price": 600000,
        "stock": 20,
        "description": "Ban tubeless sport harian kompon medium-soft. Grip maksimal di jalan basah dan kering.",
        "image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSridFmTP_OD5ujJ3gqEYS3UP20RDl_pphywRtmk-LkUndsTZn1gcDtPE&s=10",
        "created_at": "2026-10-07 03:20:36",
        "updated_at": "2026-10-07 03:39:10"
    }
}
```

---

### 6. DELETE — Menghapus Data
- **URL:** `DELETE https://web-lanjut-backend-laravel.vercel.app/api/spareparts/1`
- **Status Code:** `200 OK`
- **Response JSON:**
```json
{
    "status": "success",
    "message": "Sparepart berhasil dihapus"
}
```

---

### 7. Flutter Integration — Pengujian Antarmuka UI (Online Web & Mobile)
- **URL Frontend:** `https://web-lanjut-backend-laravel.vercel.app/`
- **Fitur Teruji:**
  1. **Visual Katalog & Floating Header Logo:** Menampilkan logo hitam pekat **MP** disandingkan dengan judul aplikasi **MyParts**.
  2. **Filter & Live Search:** Pengguna dapat mengetik nama sparepart atau memilih filter kategori (*Knalpot, Pengereman, Ban & Velg, Mesin*), aplikasi secara instan mengirimkan request `GET /api/spareparts?search=...` ke backend Vercel.
  3. **Live Thousands Separator Form:** Saat pengguna menambah/mengedit data, harga terformat otomatis dengan separator ribuan (e.g. `1.250.000`).
  4. **Status Hasil Pengujian:** **Pass (100% Berhasil dan Terintegrasi)**.

---

## 📌 Kesimpulan Pengujian Poin F
Seluruh skenario pengujian yang diwajibkan pada **Poin F Skenario Pengujian** dalam modul *Pertemuan 7 - Deploy App.pdf* telah diuji secara menyeluruh dan menghasilkan **Status PASS (100% Berhasil)** tanpa kendala error.
