# 🏘️ Sistem Pelayanan Administrasi dan Informasi RT Berbasis Web dan Mobile

> **Proyek Tugas Akhir – Teknik Informatika, Universitas Esa Unggul**

Sistem Pelayanan Administrasi dan Informasi RT merupakan aplikasi berbasis **web dan mobile** yang dikembangkan untuk membantu digitalisasi pelayanan administrasi, penyampaian informasi, serta komunikasi antara warga dan pengurus RT.

Sistem terdiri dari:

- 📱 **Aplikasi Mobile Warga** menggunakan Flutter
- 💻 **Web Admin / Pengurus RT** menggunakan Laravel dan Filament
- 🔗 **REST API** sebagai penghubung aplikasi mobile dan backend
- 🗄️ **MySQL** sebagai basis data
- 🔔 **Firebase Cloud Messaging (FCM)** untuk mendukung notifikasi

Proyek ini dikembangkan sebagai bagian dari **Tugas Akhir** dan diimplementasikan pada lingkungan server agar aplikasi mobile dan web dapat saling terhubung melalui jaringan internet.

---

# 📌 Tentang Proyek

Pelayanan administrasi pada lingkungan RT umumnya masih dilakukan melalui komunikasi langsung atau aplikasi pesan instan.

Proses tersebut dapat menyebabkan informasi pelayanan menjadi tersebar, warga kesulitan mengetahui perkembangan pengajuan, dan pengurus RT perlu melakukan pencatatan secara manual.

Sistem ini dikembangkan untuk menyediakan satu platform terintegrasi yang memungkinkan warga memperoleh informasi dan mengajukan pelayanan melalui aplikasi mobile, sementara pengurus RT dapat melakukan pengelolaan melalui dashboard berbasis web.

Dengan sistem ini, proses administrasi dan penyampaian informasi dapat dilakukan secara lebih terstruktur dan terdokumentasi.

---

# 🎯 Tujuan Pengembangan

Tujuan utama pengembangan sistem ini adalah:

1. Membantu digitalisasi pelayanan administrasi di lingkungan RT.
2. Mempermudah warga dalam memperoleh informasi dari pengurus RT.
3. Memungkinkan warga melakukan pengajuan pelayanan administrasi secara digital.
4. Memudahkan warga memantau perkembangan status pelayanan.
5. Membantu pengurus RT mengelola data warga dan pelayanan melalui dashboard.
6. Menyediakan media untuk menyampaikan laporan darurat.
7. Meningkatkan efektivitas komunikasi antara warga dan pengurus RT.
8. Mengintegrasikan aplikasi mobile dengan sistem backend melalui REST API.
9. Menyediakan sistem notifikasi untuk mendukung penyampaian informasi dan perubahan status pelayanan.

---

# 👥 Pengguna Sistem

Sistem memiliki beberapa jenis pengguna dengan hak akses yang berbeda.

## 👤 Warga

Warga menggunakan aplikasi mobile untuk:

- Login ke dalam aplikasi
- Melihat informasi RT
- Melihat pengumuman
- Mengajukan pelayanan administrasi
- Melihat riwayat pelayanan
- Memantau status pelayanan
- Mengakses dokumen hasil pelayanan
- Mengirim laporan darurat
- Melihat informasi nomor penting
- Menerima notifikasi
- Mengelola informasi profil

---

## 👨‍💼 Ketua RT

Ketua RT menggunakan dashboard berbasis web untuk:

- Mengelola informasi RT
- Mengelola pengumuman
- Mengelola data warga
- Melihat pengajuan pelayanan
- Memproses pelayanan administrasi
- Memperbarui status pelayanan
- Mengelola dokumen pelayanan
- Melihat laporan darurat warga
- Mengelola informasi nomor penting
- Mengelola pengguna
- Memantau aktivitas sistem

---

## 🛡️ Super Admin

Super Admin memiliki hak akses yang lebih luas untuk:

- Mengelola data pengguna
- Mengelola role dan hak akses
- Mengelola akun pengurus RT
- Mengelola data sistem
- Melakukan administrasi sistem secara keseluruhan

---

# ✨ Fitur Utama

## 📱 Aplikasi Mobile Warga

### 🔐 Autentikasi

Sistem menyediakan mekanisme autentikasi agar hanya pengguna yang memiliki akun aktif yang dapat menggunakan layanan aplikasi.

Fitur autentikasi mencakup:

- Login pengguna
- Penyimpanan sesi pengguna
- Logout
- Validasi akun pengguna

---

### 📰 Informasi RT

Warga dapat memperoleh berbagai informasi yang disampaikan oleh pengurus RT melalui aplikasi.

Informasi dapat mencakup:

- Pengumuman lingkungan
- Informasi kegiatan
- Pemberitahuan pelayanan
- Informasi penting lainnya

---

### 📄 Pelayanan Administrasi

Warga dapat melakukan pengajuan pelayanan administrasi melalui aplikasi mobile.

Proses pelayanan meliputi:

1. Warga memilih jenis pelayanan.
2. Warga mengisi data pengajuan.
3. Pengajuan dikirim ke sistem.
4. Pengurus RT menerima pengajuan.
5. Pengurus RT melakukan pemeriksaan.
6. Status pelayanan diperbarui.
7. Warga dapat melihat perkembangan pelayanan.

---

### 🔎 Pemantauan Status Pelayanan

Setiap pengajuan memiliki status yang dapat dipantau oleh warga.

Hal ini memungkinkan warga mengetahui apakah pengajuan:

- Baru diajukan
- Sedang diproses
- Memerlukan tindakan tertentu
- Telah selesai
- Ditolak atau tidak dapat diproses

Dengan adanya fitur ini, warga tidak perlu selalu menghubungi pengurus RT hanya untuk mengetahui perkembangan pengajuan.

---

### 📚 Riwayat Pelayanan

Warga dapat melihat kembali pelayanan yang pernah diajukan.

Riwayat pelayanan membantu pengguna mengetahui:

- Jenis pelayanan
- Tanggal pengajuan
- Status pelayanan
- Detail pengajuan
- Hasil pelayanan

---

### 🚨 Laporan Darurat

Aplikasi menyediakan fitur laporan darurat yang memungkinkan warga menyampaikan kejadian tertentu kepada pengurus RT.

Laporan dapat digunakan untuk memberikan informasi mengenai situasi yang membutuhkan perhatian pengurus.

---

### ☎️ Nomor Penting

Warga dapat melihat informasi nomor penting yang berhubungan dengan lingkungan atau kebutuhan darurat.

---

### 🔔 Notifikasi

Sistem mendukung penggunaan **Firebase Cloud Messaging (FCM)** untuk kebutuhan notifikasi.

Notifikasi dapat digunakan untuk memberikan informasi kepada warga mengenai perubahan atau aktivitas tertentu pada sistem.

---

### 👤 Profil Pengguna

Pengguna dapat melihat informasi akun dan profil yang digunakan dalam aplikasi.

---

# 💻 Web Admin / Pengurus RT

Dashboard administrasi dikembangkan menggunakan **Laravel** dan **Filament**.

Filament digunakan untuk menyediakan antarmuka administrasi yang membantu pengurus RT dalam mengelola berbagai data sistem.

---

## 📊 Dashboard

Dashboard digunakan sebagai pusat pengelolaan sistem dan memberikan akses cepat terhadap fitur administrasi.

---

## 👥 Manajemen Data Warga

Pengurus RT dapat melakukan pengelolaan data warga.

Data warga digunakan sebagai bagian penting dalam proses pelayanan administrasi.

---

## 📢 Manajemen Informasi

Pengurus dapat membuat dan mengelola informasi yang akan ditampilkan kepada warga pada aplikasi mobile.

---

## 📑 Manajemen Pelayanan

Pengurus RT dapat:

- Melihat daftar pengajuan
- Melihat detail pengajuan
- Memproses pelayanan
- Mengubah status
- Mengelola hasil pelayanan

---

## 🚨 Manajemen Laporan Darurat

Laporan yang dikirim melalui aplikasi mobile dapat dilihat dan dikelola melalui dashboard web.

---

## 👤 Manajemen Pengguna

Sistem menyediakan pengelolaan akun dan akses pengguna berdasarkan role yang dimiliki.

---

# 🏗️ Arsitektur Sistem

Sistem menerapkan arsitektur **client-server**.

Aplikasi Flutter bertindak sebagai client yang berkomunikasi dengan backend Laravel melalui REST API.

```text
┌──────────────────────────┐
│                          │
│    APLIKASI MOBILE       │
│        FLUTTER           │
│                          │
│         WARGA            │
│                          │
└────────────┬─────────────┘
             │
             │ HTTPS / REST API
             │
             ▼
┌──────────────────────────┐
│                          │
│         LARAVEL          │
│                          │
│       BACKEND API        │
│                          │
└────────────┬─────────────┘
             │
             │
             ▼
┌──────────────────────────┐
│                          │
│          MySQL           │
│                          │
│        DATABASE          │
│                          │
└──────────────────────────┘


             ▲
             │
             │
┌────────────┴─────────────┐
│                          │
│    LARAVEL + FILAMENT    │
│                          │
│    WEB ADMIN / RT        │
│                          │
└──────────────────────────┘


             │
             │
             ▼
┌──────────────────────────┐
│                          │
│ FIREBASE CLOUD MESSAGING │
│          (FCM)           │
│                          │
└──────────────────────────┘
```

---

# 🔄 Alur Sistem

Secara umum alur komunikasi sistem adalah:

```text
Warga
   │
   ▼
Flutter Mobile App
   │
   │ Request
   ▼
REST API
   │
   ▼
Laravel Backend
   │
   ├──────────────► MySQL Database
   │
   │
   └──────────────► Firebase Cloud Messaging
   │
   ▼
Response
   │
   ▼
Flutter Mobile App
   │
   ▼
Warga
```

Sementara pengurus RT mengakses backend melalui:

```text
Pengurus RT
     │
     ▼
Web Browser
     │
     ▼
Laravel + Filament
     │
     ▼
Database
```

---

# 🛠️ Teknologi yang Digunakan

## Mobile Development

| Teknologi | Penggunaan |
|---|---|
| Flutter | Framework aplikasi mobile |
| Dart | Bahasa pemrograman Flutter |
| REST API | Komunikasi aplikasi dengan backend |
| Firebase Cloud Messaging | Push notification |

---

## Backend Development

| Teknologi | Penggunaan |
|---|---|
| Laravel | Backend dan REST API |
| PHP | Bahasa pemrograman backend |
| Filament | Dashboard administrasi |
| REST API | Integrasi mobile dan backend |

---

## Database

| Teknologi | Penggunaan |
|---|---|
| MySQL | Penyimpanan data aplikasi |

---

## Infrastruktur

| Teknologi | Penggunaan |
|---|---|
| Linux Server / VPS | Hosting backend |
| Nginx | Web server |
| HTTPS | Komunikasi aplikasi yang lebih aman |
| Git | Version control |
| GitHub | Repository source code |

---

# 📂 Struktur Repository

Repository dibagi menjadi dua aplikasi utama.

```text
TA_Noval-Yusuf-Alfian/
│
├── Backend/
│   │
│   ├── app/
│   ├── bootstrap/
│   ├── config/
│   ├── database/
│   ├── public/
│   ├── resources/
│   ├── routes/
│   ├── storage/
│   └── ...
│
├── Mobile/
│   │
│   ├── android/
│   ├── assets/
│   ├── lib/
│   ├── test/
│   ├── pubspec.yaml
│   └── ...
│
├── .gitignore
│
└── README.md
```

### `Backend/`

Berisi aplikasi:

- Laravel
- Filament Admin Panel
- REST API
- Database migration
- Authentication
- Business logic
- Integrasi backend

### `Mobile/`

Berisi aplikasi Flutter yang digunakan oleh warga.

---

# 🔌 REST API

REST API digunakan sebagai penghubung antara aplikasi Flutter dan backend Laravel.

Secara umum komunikasi API menggunakan format:

```text
Flutter
   │
   ├── HTTP GET
   ├── HTTP POST
   ├── HTTP PUT/PATCH
   └── HTTP DELETE
           │
           ▼
       Laravel API
           │
           ▼
       JSON Response
```

Contoh konsep response:

```json
{
    "success": true,
    "message": "Data berhasil diproses",
    "data": {}
}
```

---

# 🔐 Authentication & Authorization

Sistem menggunakan autentikasi pengguna untuk membatasi akses terhadap fitur.

Setiap pengguna memiliki role yang menentukan hak aksesnya.

Contoh role:

```text
warga
ketua_rt
super_admin
```

Hak akses aplikasi mobile dan web diberikan berdasarkan role pengguna tersebut.

---

# 🔔 Firebase Cloud Messaging

Firebase Cloud Messaging digunakan untuk mendukung kebutuhan push notification pada aplikasi mobile.

Secara umum alur FCM:

```text
Mobile App
    │
    ▼
FCM Device Token
    │
    ▼
Laravel Backend
    │
    ▼
Firebase Cloud Messaging
    │
    ▼
Push Notification
    │
    ▼
Perangkat Warga
```

> Credential atau service account Firebase tidak disimpan pada repository publik.

---

# 🗄️ Database

Database digunakan untuk menyimpan berbagai informasi sistem, antara lain:

- Data pengguna
- Data warga
- Role pengguna
- Informasi RT
- Pengumuman
- Pengajuan pelayanan
- Status pelayanan
- Laporan darurat
- Informasi nomor penting
- Device token
- Data pendukung lainnya

---

# 📱 Dokumentasi Aplikasi Mobile

## Login

Digunakan oleh warga untuk masuk ke dalam aplikasi menggunakan akun yang telah terdaftar.

> Screenshot akan ditambahkan.

---

## Beranda

Beranda menampilkan informasi dan akses menuju fitur utama aplikasi.

> Screenshot akan ditambahkan.

---

## Informasi RT

Menampilkan informasi atau pengumuman yang diberikan oleh pengurus RT.

> Screenshot akan ditambahkan.

---

## Pelayanan Administrasi

Digunakan untuk melakukan pengajuan pelayanan kepada pengurus RT.

> Screenshot akan ditambahkan.

---

## Status Pelayanan

Warga dapat melihat perkembangan pelayanan yang telah diajukan.

> Screenshot akan ditambahkan.

---

## Laporan Darurat

Digunakan untuk menyampaikan laporan kepada pengurus RT.

> Screenshot akan ditambahkan.

---

## Profil

Menampilkan informasi akun pengguna.

> Screenshot akan ditambahkan.

---

# 🖥️ Dokumentasi Web Admin

## Login Admin

Halaman autentikasi untuk pengurus RT.

> Screenshot akan ditambahkan.

---

## Dashboard

Dashboard menampilkan informasi utama sistem dan menu pengelolaan.

> Screenshot akan ditambahkan.

---

## Pengelolaan Warga

Digunakan untuk mengelola data warga yang terdaftar pada sistem.

> Screenshot akan ditambahkan.

---

## Pengelolaan Pelayanan

Digunakan untuk melihat dan memproses pengajuan pelayanan warga.

> Screenshot akan ditambahkan.

---

## Pengelolaan Informasi

Digunakan untuk membuat dan mengelola informasi yang akan ditampilkan pada aplikasi warga.

> Screenshot akan ditambahkan.

---

## Pengelolaan Laporan Darurat

Digunakan untuk melihat laporan yang disampaikan oleh warga.

> Screenshot akan ditambahkan.

---

# 🧪 Pengujian Sistem

Pengujian dilakukan untuk memastikan fitur-fitur utama aplikasi dapat berjalan sesuai dengan fungsi yang dirancang.

Metode pengujian utama yang digunakan dalam pengembangan adalah:

## Black Box Testing

Black Box Testing digunakan untuk menguji fungsi sistem berdasarkan input dan output tanpa melihat proses internal kode program.

Beberapa fungsi yang diuji antara lain:

- Login
- Akses informasi
- Pengajuan pelayanan
- Pemrosesan pelayanan
- Perubahan status
- Laporan darurat
- Pengelolaan data
- Integrasi aplikasi mobile dengan REST API

Hasil pengujian digunakan untuk memastikan fungsi sistem dapat berjalan sesuai kebutuhan.

---

# 🚀 Deployment

Backend sistem telah disiapkan agar dapat berjalan pada server online sehingga aplikasi mobile tidak harus berada pada jaringan lokal yang sama dengan backend.

Arsitektur deployment secara umum:

```text
Internet
   │
   ▼
Domain / HTTPS
   │
   ▼
Nginx
   │
   ▼
Laravel Backend
   │
   ├────────► MySQL
   │
   └────────► Firebase
   │
   ▼
REST API
   │
   ▼
Flutter Mobile App
```

Dengan arsitektur tersebut, aplikasi mobile dapat berkomunikasi dengan backend melalui internet.

---

# ⚙️ Menjalankan Project Secara Lokal

## Backend

Pastikan perangkat memiliki:

- PHP
- Composer
- MySQL
- Node.js
- NPM

Clone repository:

```bash
git clone https://github.com/NovalYsf01/TA_Noval-Yusuf-Alfian.git
```

Masuk ke folder backend:

```bash
cd TA_Noval-Yusuf-Alfian/Backend
```

Install dependency:

```bash
composer install
```

Buat file environment berdasarkan konfigurasi contoh yang tersedia.

```bash
cp .env.example .env
```

Generate application key:

```bash
php artisan key:generate
```

Konfigurasikan database pada `.env`.

Contoh:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nama_database
DB_USERNAME=root
DB_PASSWORD=
```

Jalankan migration apabila diperlukan:

```bash
php artisan migrate
```

Jalankan Laravel:

```bash
php artisan serve
```

---

# 📱 Menjalankan Flutter

Pastikan Flutter SDK telah terinstal.

Cek environment:

```bash
flutter doctor
```

Masuk ke folder:

```bash
cd Mobile
```

Install dependencies:

```bash
flutter pub get
```

Pastikan perangkat Android terdeteksi:

```bash
flutter devices
```

Kemudian jalankan aplikasi:

```bash
flutter run
```

Apabila aplikasi menggunakan konfigurasi API melalui `dart-define`, sesuaikan URL backend dengan environment pengembangan yang digunakan.

---

# 🔒 Keamanan Repository

Repository publik tidak seharusnya menyimpan credential atau informasi rahasia.

File berikut tidak boleh dipublikasikan:

```text
.env
service-account.json
firebase-adminsdk*.json
database production dump
private key
API secret
server credential
```

File konfigurasi sensitif hanya disimpan pada environment development atau production masing-masing.

---

# 📈 Manfaat Sistem

Implementasi sistem diharapkan dapat memberikan beberapa manfaat:

### Untuk Warga

- Mempermudah akses informasi RT
- Mempermudah pengajuan pelayanan
- Mempermudah pemantauan status pelayanan
- Mengurangi kebutuhan untuk selalu menghubungi pengurus secara langsung
- Menyediakan media pelaporan yang lebih terstruktur

### Untuk Pengurus RT

- Membantu pengelolaan administrasi
- Mempermudah pengelolaan data warga
- Membantu pencatatan pelayanan
- Mempermudah penyampaian informasi
- Membantu pengelolaan laporan warga

---

# 🎓 Konteks Akademik

Project ini dikembangkan sebagai bagian dari **Tugas Akhir Program Studi Teknik Informatika Universitas Esa Unggul**.

Pengembangan meliputi tahapan:

1. Identifikasi permasalahan
2. Analisis kebutuhan
3. Perancangan sistem
4. Perancangan database
5. Perancangan antarmuka
6. Implementasi backend
7. Implementasi aplikasi mobile
8. Integrasi REST API
9. Pengujian sistem
10. Deployment dan evaluasi

---

# 📊 Status Project

| Komponen | Status |
|---|---|
| Aplikasi Flutter | ✅ Implemented |
| Laravel Backend | ✅ Implemented |
| REST API | ✅ Implemented |
| Filament Admin | ✅ Implemented |
| Database | ✅ Implemented |
| Authentication | ✅ Implemented |
| Role Management | ✅ Implemented |
| Pelayanan Administrasi | ✅ Implemented |
| Informasi RT | ✅ Implemented |
| Laporan Darurat | ✅ Implemented |
| Deployment Backend | ✅ Implemented |
| Push Notification | ✅ Integrated |

---

# 🖼️ Project Preview

Bagian ini nantinya dapat digunakan untuk menampilkan screenshot terbaik dari aplikasi.

Contoh struktur:

```text
Mobile Application
├── Login
├── Home
├── Informasi
├── Pelayanan
├── Status Pelayanan
├── Laporan Darurat
└── Profil

Web Administration
├── Login
├── Dashboard
├── Data Warga
├── Informasi
├── Pelayanan
└── Laporan Darurat
```

---

# 📌 Project Highlights

Beberapa bagian utama yang dikembangkan pada project:

- 📱 Mobile application menggunakan Flutter
- 💻 Web administration menggunakan Laravel + Filament
- 🔗 Integrasi melalui RESTful API
- 🗄️ Database terpusat menggunakan MySQL
- 👥 Role-based user management
- 📄 Digitalisasi pelayanan administrasi
- 📢 Pengelolaan informasi RT
- 🚨 Sistem laporan darurat
- 🔔 Integrasi Firebase Cloud Messaging
- 🌐 Backend dapat diakses melalui internet
- 🧪 Pengujian fungsi menggunakan Black Box Testing

---

# 🔮 Pengembangan Selanjutnya

Beberapa pengembangan yang dapat dilakukan di masa mendatang antara lain:

- Distribusi aplikasi melalui Google Play Store
- Pengembangan sistem untuk cakupan RW
- Peningkatan sistem notifikasi
- Peningkatan keamanan autentikasi
- Dashboard statistik yang lebih lengkap
- Pengembangan fitur komunikasi warga
- Optimasi performa aplikasi
- Peningkatan pengalaman pengguna
- Backup dan monitoring sistem secara otomatis

---

# 📖 Repository Purpose

Repository ini digunakan sebagai:

- Dokumentasi source code Tugas Akhir
- Portfolio pengembangan aplikasi
- Dokumentasi implementasi sistem
- Referensi proses pengembangan web dan mobile

Repository tidak ditujukan untuk menyimpan credential, data produksi, atau informasi pribadi pengguna.

---

# 👨‍💻 Developer

**Noval Yusuf Alfian**

Mahasiswa Teknik Informatika  
Universitas Esa Unggul

**Final Project / Tugas Akhir – 2026**

---

# 📬 Repository

Source code project tersedia pada repository:

**TA_Noval-Yusuf-Alfian**

```text
github.com/NovalYsf01/TA_Noval-Yusuf-Alfian
```

---

<p align="center">
  <b>Sistem Pelayanan Administrasi dan Informasi RT Berbasis Web dan Mobile</b>
</p>

<p align="center">
  Developed as a Final Project at Universitas Esa Unggul
</p>

<p align="center">
  Flutter • Laravel • Filament • REST API • MySQL • Firebase
</p>
