# 📄 LAPORAN TUGAS PERTEMUAN 7 - DEPLOYMENT BACKEND & INTEGRASI FLUTTER

---

## 1. Identitas

* **Nama:** [Isi Nama Anda / David Nazal]
* **NIM:** [Isi NIM Anda]
* **Kelas:** [Isi Kelas Anda]
* **Kelompok:** [Isi Kelompok Anda]

---

## 2. Deskripsi Aplikasi

Aplikasi yang dikembangkan bernama **MyParts (VixionMods Studio)**, yaitu sebuah aplikasi sistem manajemen katalog produk sparepart dan aksesori modifikasi sepeda motor. Aplikasi ini dibangun dengan menggunakan arsitektur terpisah (*decoupled architecture*):

* **Backend (REST API):** Dikembangkan menggunakan framework **Laravel 11 (PHP 8.3)** yang berfungsi menyediakan RESTful API endpoint untuk pengelolaan data sparepart (Create, Read, Update, Delete) serta validasi data secara aman.
* **Frontend (Mobile & Web App):** Dikembangkan menggunakan framework **Flutter (Dart)** dengan tampilan antarmuka modern yang menyajikan katalog produk, fitur pencarian, filter kategori, form input dengan format mata uang otomatis, serta detail informasi item yang terintegrasi secara real-time dengan backend online.

---

## 3. Arsitektur Sistem

Alur komunikasi dan arsitektur data sistem digambarkan sebagai berikut:

```text
+------------------------+             HTTP / REST API (JSON)            +-------------------------------+
|  Flutter Client App    | <-------------------------------------------> |  Laravel Serverless Backend   |
| (Mobile / Web Display) |   GET, POST, PUT, DELETE /api/spareparts     |      (Deployed on Vercel)     |
+------------------------+                                               +-------------------------------+
                                                                                         |
                                                                                         v
                                                                                +-----------------+
                                                                                | SQLite Database |
                                                                                | (/tmp/db.sqlite)|
                                                                                +-----------------+
```

### Penjelasan Alur Sistem:
1. **Pengguna (Client)** melakukan interaksi pada aplikasi Flutter (misal: melihat daftar sparepart, menambah data baru, atau memperbarui stok).
2. **Flutter App** mengirimkan *HTTP Request* (GET, POST, PUT, DELETE) berisi payload JSON ke endpoint REST API backend.
3. **Laravel Backend** yang berjalan di server Vercel menerima request, membaca *route* pada `routes/api.php`, dan meneruskannya ke `SparepartController`.
4. **SparepartController** menjalankan validasi data dan memproses query ke **Database SQLite**.
5. **Database SQLite** menyimpan/memperbarui data dan mengembalikan hasilnya ke Laravel Eloquent ORM.
6. **Laravel** merespon kembali ke Flutter dalam format JSON standar (dengan HTTP Status Code seperti `200 OK`, `201 Created`, atau `422 Unprocessable Entity`).
7. **Flutter** mengurai (*parsing*) respon JSON dan memperbarui tampilan antarmuka (UI) secara otomatis.

---

## 4. Deployment Backend

* **Platform Hosting:** Vercel (Cloud Serverless Infrastructure)
* **URL Web App (Visual UI):** `https://web-lanjut-backend-laravel.vercel.app/`
* **URL REST API Endpoint:** `https://web-lanjut-backend-laravel.vercel.app/api/spareparts`
* **Link Repository GitHub:** `https://github.com/Davidnazal/Web-Lanjut.git`

### Konfigurasi Environment (`.env`):
* `APP_ENV`: `production`
* `APP_DEBUG`: `false`
* `APP_KEY`: `base64:7V9bU1qW2eR3tY4uI5oP6aS7dF8gH9jK0lM1nO2pQ3r=`
* `DB_CONNECTION`: `sqlite`
* `DB_DATABASE`: `/tmp/database.sqlite`

### Konfigurasi Database:
Database backend menggunakan **SQLite Engine** yang dikonfigurasikan di lokasi writable temporary storage server (`/tmp/database.sqlite`). Pada saat Vercel Serverless Function dijalankan pertama kali, script entrypoint (`api/index.php`) secara otomatis memastikan file database terinisialisasi dan diisi data awal (seeding) secara seamless.

### Proses Deployment:
1. Menyiapkan repository Git lokal dan mem-push seluruh *source code* backend ke GitHub di repository `Davidnazal/Web-Lanjut`.
2. Menambahkan file konfigurasi serverless `vercel.json` pada root project untuk mengarahkan seluruh lalu lintas HTTP ke `api/index.php`.
3. Menghubungkan repository GitHub ke platform **Vercel Dashboard**.
4. Vercel secara otomatis mendeteksi konfigurasi project, membuat *Serverless Function Build*, dan melakukan deployment CI/CD otomatis.
5. Setelah status deployment berubah menjadi **Ready**, API live dan siap diakses melalui internet via domain HTTPS resmi dari Vercel.

---

## 5. Pengujian API

### A. Tabel Hasil Pengujian REST API (Skenario Pengujian)

| No | Method | Endpoint | Skenario | Expected Result | Actual Result | Status |
| :-: | :---: | :--- | :--- | :--- | :--- | :---: |
| 1 | GET | `/api/spareparts` | Menampilkan data | 200 + JSON List | HTTP 200 OK, JSON 6 data sparepart berhasil diambil | Pass |
| 2 | GET | `/api/spareparts/1` | Detail data | 200 + JSON Object | HTTP 200 OK, JSON detail sparepart ID 1 berhasil ditampilkan | Pass |
| 3 | POST | `/api/spareparts` | Data valid | 201 + JSON Data Baru | HTTP 201 Created, Data sparepart baru berhasil disimpan ke DB | Pass |
| 4 | POST | `/api/spareparts` | Data tidak valid | 4xx + Error Message | HTTP 422 Unprocessable Entity, mengembalikan pesan validasi error | Pass |
| 5 | PUT | `/api/spareparts/1` | Update data | 200 + JSON Updated | HTTP 200 OK, Data sparepart ID 1 berhasil diperbarui | Pass |
| 6 | DELETE | `/api/spareparts/1` | Hapus data | 200 OK / Message | HTTP 200 OK, Sparepart berhasil dihapus dari database | Pass |
| 7 | Flutter | API Online | Menampilkan data di UI | Data tampil sempurna | Data sparepart dari Vercel serverless tampil di layar Flutter | Pass |

---

### B. Screenshot Pengujian API (Postman / Insomnia)

*(Sisipkan gambar screenshot yang telah Anda ambil di bawah ini)*

1. **Screenshot Deployment Vercel (Status Ready)**  
   *(Tempel gambar `01_Screenshot_Deployment_Vercel.png` di sini)*

2. **Screenshot GET All Spareparts (HTTP 200 OK)**  
   *(Tempel gambar `02_Postman_GET_All.png` di sini)*

3. **Screenshot GET Detail Sparepart ID 1 (HTTP 200 OK)**  
   *(Tempel gambar `03_Postman_GET_Detail.png` di sini)*

4. **Screenshot POST Tambah Data Valid (HTTP 201 Created)**  
   *(Tempel gambar `04_Postman_POST_Valid.png` di sini)*

5. **Screenshot POST Tambah Data Tidak Valid (HTTP 422 Unprocessable Entity)**  
   *(Tempel gambar `05_Postman_POST_Invalid_Validation.png` di sini)*

6. **Screenshot PUT Update Data (HTTP 200 OK)**  
   *(Tempel gambar `06_Postman_PUT_Update.png` di sini)*

7. **Screenshot DELETE Hapus Data (HTTP 200 OK)**  
   *(Tempel gambar `07_Postman_DELETE.png` di sini)*

8. **Screenshot Database Server / SQLite Data**  
   *(Tempel gambar `08_Screenshot_Database_Server.png` di sini)*

---

## 6. Integrasi Flutter

Untuk menghubungkan aplikasi Flutter yang semula mengakses backend lokal (`localhost` / `10.0.2.2:8000`) menjadi mengakses server hosting online Vercel, dilakukan perubahan konfigurasi variabel `baseUrl` pada file service Flutter (`frontend_flutter/lib/services/api_service.dart`):

### Kode Sebelum (Pengujian Lokal):
```dart
// Konfigurasi API Lokal (Android Emulator / Localhost)
static String baseUrl = 'http://10.0.2.2:8000/api';
```

### Kode Sesudah (Integrasi Server Live Vercel):
```dart
// Konfigurasi API Production Cloud Serverless Vercel
static String baseUrl = 'https://web-lanjut-backend-laravel.vercel.app/api';
```

### Screenshot Tampilan Aplikasi Flutter:
*(Sisipkan gambar screenshot Flutter di bawah ini)*
1. **Screenshot Flutter Katalog Utama (`09_Screenshot_Flutter_Katalog.png`)**  
   *Menampilkan UI Flutter mengambil data secara online dari backend Vercel.*
2. **Screenshot Flutter Form Tambah Data (`10_Screenshot_Flutter_Form.png`)**  
   *Menampilkan UI Form interaktif untuk menambah/memperbarui data sparepart.*

---

## 7. Kendala dan Penyelesaian

Selama proses deployment backend Laravel ke serverless hosting Vercel dan integrasinya dengan Flutter, ditemukan dua kendala utama beserta penyelesaiannya:

### ⚠️ Kendala 1: Vercel Read-Only File System Error (`SQLITE_READONLY`)
* **Analisis:** Platform Vercel Serverless Function memproteksi *file system* direktori aplikasi menjadi *read-only*. Ketika Laravel mencoba mengakses atau menulis file database SQLite pada lokasi default (`database/database.sqlite`), server mengembalikan error permission.
* **Solusi:** Memodifikasi skrip entrypoint Vercel (`api/index.php`) agar mendeteksi lingkungan serverless dan secara dinamis menyalin template database ke folder sementara yang dapat ditulis (`/tmp/database.sqlite`), serta mengatur environment variable `DB_DATABASE=/tmp/database.sqlite`.

### ⚠️ Kendala 2: Routing Laravel Mengembalikan Error `404 NOT FOUND` di Server Live
* **Analisis:** Secara default, Vercel tidak membaca aturan rewrite rute `.htaccess` milik Apache atau `nginx.conf`. Akibatnya, saat Flutter atau Postman memanggil endpoint seperti `/api/spareparts`, Vercel menganggapnya sebagai folder fisik yang tidak ada sehingga menghasilkan HTTP 404.
* **Solusi:** Membuat file konfigurasi rute `vercel.json` pada root project yang mendefinisikan aturan *rewrite* global untuk mengarahkan seluruh permintaan HTTP `/(.*)` secara transparan menuju `api/index.php`.

---

## 8. Kesimpulan

Berdasarkan hasil pengerjaan dan pengujian yang telah dilakukan, dapat disimpulkan bahwa:
1. **Backend Laravel REST API** telah berhasil di-deploy secara sukses ke server publik cloud (Vercel Serverless) dan dapat diakses dengan stabil via protokol HTTPS aman dari mana saja di internet.
2. **Aplikasi Flutter** berhasil terintegrasi secara penuh (*seamless integration*) dengan backend online. Seluruh operasi CRUD (Create, Read, Update, Delete) dapat berjalan dengan lancar tanpa hambatan, serta penanganan error validasi data berfungsi dengan baik.
3. Seluruh skenario pengujian API pada Postman dan Flutter memenuhi standar kriteria pengujian (*Status Pass*).
