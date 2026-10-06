# 🏍️ VixionMods Studio - Panduan Lengkap Deployment & Tugas Pertemuan 7

Aplikasi **VixionMods Studio** adalah sistem manajemen katalog part modifikasi khusus **Yamaha Vixion Old Gen 2 (2011)** yang terdiri atas:
1. **Backend:** Laravel REST API (`backend-laravel/`)
2. **Frontend:** Flutter Light Mode Mobile App (`frontend_flutter/`)

---

## 🛠️ 1. Uji Coba Lokal (Local Development)

### A. Menjalankan Backend API di Komputer Lokal (Dengan Laragon)
1. Buka terminal pada folder `backend-laravel`:
   ```powershell
   cd backend-laravel
   ```
2. Jalankan server backend menggunakan file script otomatis `start_server.bat`:
   ```powershell
   .\start_server.bat
   ```
   * Server REST API otomatis menginisialisasi database SQLite & Seeder 6 item Vixion Old 2011 out-of-the-box!
   * Endpoint API berjalan live di: `http://127.0.0.1:8000/api/spareparts`

---

### B. Menjalankan Aplikasi Flutter
1. Buka terminal pada folder `frontend_flutter`:
   ```bash
   cd frontend_flutter
   ```
2. Ambil semua dependencies:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi ke Emulator Android atau Web/Desktop:
   ```bash
   flutter run
   ```
   * **Catatan:** Jika menggunakan Emulator Android, `ApiService.baseUrl` di `lib/services/api_service.dart` sudah otomatis di-setting ke `http://10.0.2.2:8000/api`.
   * Kamu juga bisa mengubah Base URL secara langsung di aplikasi dengan menekan tombol **Icon Setting Ethernet** di pojok kanan atas layar AppBar Flutter!

---

## ☁️ 2. Langkah-Langkah Deployment ke Server Hosting Gratis (Render.com / Railway)

### Langkah 1: Push Project ke GitHub
1. Inisialisasi Git di folder project:
   ```bash
   git init
   git add .
   git commit -m "Initial commit VixionMods Studio"
   ```
2. Buat Repository baru di GitHub (misal: `vixion-mods-studio`).
3. Hubungkan dan push kode ke GitHub:
   ```bash
   git remote add origin https://github.com/USERNAME/vixion-mods-studio.git
   git branch -M main
   git push -u origin main
   ```
   *(Pastikan file `.env` TIDAK ikut ter-push ke GitHub karena sudah ada di `.gitignore`)*

---

### Langkah 2: Deploy Backend ke Render.com (Gratis)
1. Buka [render.com](https://render.com) dan buat akun baru.
2. Klik **New +** $\rightarrow$ **Web Service**.
3. Hubungkan dengan repository GitHub `vixion-mods-studio` kamu.
4. Isi data konfigurasi berikut:
   * **Name:** `vixion-mods-api`
   * **Root Directory:** `backend-laravel`
   * **Environment:** `PHP`
   * **Build Command:** `composer install --no-dev --optimize-autoloader`
   * **Start Command:** `vendor/bin/heroku-php-apache2 public/` (atau `php artisan serve --host=0.0.0.0 --port=10000`)
5. Tambahkan **Environment Variables** di dashboard Render:
   * `APP_ENV` = `production`
   * `APP_DEBUG` = `false`
   * `APP_KEY` = *(isi dengan string base64 dari php artisan key:generate)*
   * `DB_CONNECTION` = `sqlite` (atau kredensial MySQL jika menggunakan Supabase/Aiven)
6. Setelah deployment berhasil, kamu akan mendapatkan URL publik, contoh:
   ```text
   https://vixion-mods-api.onrender.com
   ```

---

### Langkah 3: Jalankan Migration di Server Hosting
Buka tab **Shell** di dashboard Render kamu dan jalankan:
```bash
php artisan migrate --force
php artisan db:seed --force
```

---

### Langkah 4: Hubungkan Flutter ke URL Server Live
Buka file `frontend_flutter/lib/services/api_service.dart` dan ubah `baseUrl` menjadi:
```dart
static String baseUrl = 'https://vixion-mods-api.onrender.com/api';
```
Atau cukup jalankan aplikasi Flutter dan ubah URL melalui tombol **Setting Ethernet** di layar utama app.

---

## 🧪 3. Pengujian API (Postman / Insomnia)

Gunakan URL live backend kamu (misal `https://vixion-mods-api.onrender.com/api/spareparts`) untuk diuji di Postman:

| No | Operation | HTTP Method | Endpoint URL | Request Body (JSON) | Expected Response |
| :---: | :--- | :---: | :--- | :--- | :---: |
| **1** | **Get List** | `GET` | `/api/spareparts` | *(Kosong)* | `200 OK` (JSON List 6 item Vixion) |
| **2** | **Get Detail** | `GET` | `/api/spareparts/1` | *(Kosong)* | `200 OK` (JSON Detail Knalpot Aeromax) |
| **3** | **Post Valid** | `POST` | `/api/spareparts` | `{"part_name":"Gearset SSS 415","brand":"SSS","category":"Mesin","compatible_bike":"Vixion Old","price":380000,"stock":6}` | `201 Created` |
| **4** | **Post Invalid (Validation)** | `POST` | `/api/spareparts` | `{"part_name":""}` | `422 Unprocessable Entity` |
| **5** | **Put Update** | `PUT` | `/api/spareparts/1` | `{"price":1300000,"stock":4}` | `200 OK` |
| **6** | **Delete** | `DELETE` | `/api/spareparts/1` | *(Kosong)* | `200 OK` |

---

## 📸 4. Checklist Screenshot & Bukti Tugas (Poin G Modul)

Pastikan kamu mengumpulkan 7 bukti berikut:
1. **Link Repository GitHub** (misal: `https://github.com/username/vixion-mods-studio`)
2. **URL Backend Online** (misal: `https://vixion-mods-api.onrender.com`)
3. **Screenshot Dashboard Deployment** (Menunjukkan status "Deployed / Live" di Render)
4. **Screenshot Pengujian Postman/Insomnia** (GET, GET Detail, POST, PUT, DELETE, & Error 422)
5. **Screenshot Database Server** (Tabel `spareparts` yang sudah terisi data)
6. **Screenshot Flutter** (Aplikasi Flutter menampilkan data dari backend online)
7. **Video Demonstrasi 5-10 menit** (Menjelaskan alur aplikasi dan testing)

---

## 🎯 5. Jawaban Responsi (Persiapan Tanya Jawab Dosen)

1. **Mengapa `localhost` tidak dapat digunakan oleh Flutter saat backend sudah di-deploy?**
   *Karena `localhost` menunjuk ke perangkat itu sendiri (loopback interface). Saat backend sudah di-deploy, Flutter harus memanggil IP/Domain publik agar bisa diakses dari jaringan internet luar.*
2. **Perbedaan `localhost` dengan URL API production?**
   *`localhost` hanya bisa diakses lokal di dalam komputer pengembang. URL API Production dapat diakses oleh siapa saja di internet.*
3. **Fungsi file `.env` pada Laravel?**
   *Menyimpan variabel konfigurasi lingkungan (database, app key, debug mode) secara terpisah dari kode program.*
4. **Mengapa `.env` tidak boleh dimasukkan ke repository publik?**
   *Karena berisi data rahasia/kredensial sensitif seperti password database dan app key yang bisa disalahgunakan jika bocor.*
5. **Fungsi migration?**
   *Version control untuk struktur database, memungkinkan skema tabel dibuat, diubah, dan ditransfer antar komputer secara konsisten.*
6. **Mengapa konfigurasi database lokal berbeda dengan database hosting?**
   *Karena server hosting memiliki alamat IP/host, username, password, dan nama database tersendiri yang diberikan oleh penyedia cloud.*
7. **Fungsi `APP_ENV=production`?**
   *Memberitahu Laravel bahwa aplikasi berjalan di server publik untuk mengoptimalkan performa dan keamanan.*
8. **Mengapa `APP_DEBUG` sebaiknya `false` di production?**
   *Agar saat terjadi error, rincian kode, path file, dan kredensial sensitif tidak muncul ke publik.*
9. **Perbedaan HTTP method GET, POST, PUT/PATCH, DELETE?**
   * `GET`: Mengambil data.
   * `POST`: Membuat data baru.
   * `PUT/PATCH`: Memperbarui data yang sudah ada.
   * `DELETE`: Menghapus data.
10. **Arti HTTP status code 200, 201, 400, 401, 403, 404, 500?**
    * `200`: Success OK
    * `201`: Created (berhasil dibuat)
    * `400`: Bad Request (request salah/tidak valid)
    * `401`: Unauthorized (perlu login)
    * `403`: Forbidden (tidak punya hak akses)
    * `404`: Not Found (endpoint/data tidak ditemukan)
    * `500`: Internal Server Error (kesalahan pada kode server)
11. **Bagaimana cara mengetahui bahwa error terjadi pada Flutter atau Laravel?**
    *Cek HTTP Status Code dan Payload response. Jika menerima response JSON error/status code 4xx/5xx dari HTTP request, error terjadi di Laravel. Jika crash pada UI atau Exception Dart, error terjadi di Flutter.*
12. **Bagaimana Postman/Insomnia membantu proses debugging API?**
    *Memungkinkan pengujian endpoint API secara langsung dan cepat tanpa harus menunggu tampilan UI aplikasi mobile selesai dibuat.*
13. **Bagaimana Flutter mengetahui URL backend yang digunakan?**
    *Melalui variabel `baseUrl` yang diset pada HTTP Client (`ApiService.dart`).*
14. **Apa yang terjadi jika server backend tidak dapat diakses?**
    *Aplikasi Flutter akan mengalami `SocketException` / Timeout dan menampilkan pesan error koneksi pada UI.*
15. **Jelaskan alur ketika pengguna menekan tombol Tambah Data pada Flutter sampai data tersimpan di database:**
    *User mengisi Form $\rightarrow$ Flutter melakukan validasi lokal $\rightarrow$ Flutter mengirim `POST HTTP Request` + JSON payload $\rightarrow$ Server Laravel membaca `routes/api.php` $\rightarrow$ `SparepartController@store` $\rightarrow$ Request Validation $\rightarrow$ Eloquent Model `Sparepart::create()` $\rightarrow$ MySQL/SQLite DB Simpan Data $\rightarrow$ Laravel mengembalikan `JSON Response 201 Created` $\rightarrow$ Flutter menerima response dan memperbarui layar Catalog.*
