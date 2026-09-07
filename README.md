# Sistem Pelayanan Administrasi dan Informasi RT Berbasis Web dan Mobile

> **Proyek Tugas Akhir – Teknik Informatika, Universitas Esa Unggul**

Sistem Pelayanan Administrasi dan Informasi RT merupakan aplikasi berbasis **web dan mobile** yang dikembangkan untuk membantu digitalisasi pelayanan administrasi, penyampaian informasi, dan komunikasi antara warga dengan pengurus RT.

Sistem terdiri dari aplikasi mobile untuk warga dan dashboard web untuk pengurus RT yang saling terintegrasi melalui **REST API**.

---

## Tentang Proyek

Proyek ini dikembangkan sebagai bagian dari Tugas Akhir untuk membantu meningkatkan efektivitas pelayanan administrasi di lingkungan RT.

Aplikasi mobile memungkinkan warga untuk memperoleh informasi, melakukan pengajuan pelayanan administrasi, memantau status pelayanan, serta menyampaikan laporan darurat.

Pengurus RT dapat melakukan pengelolaan data dan pelayanan melalui dashboard berbasis web.

---

## Teknologi yang Digunakan

### Mobile
- Flutter
- Dart

### Backend & Web
- Laravel
- PHP
- Filament
- REST API

### Database
- MySQL

### Notification
- Firebase Cloud Messaging (FCM)

### Infrastruktur
- VPS / Linux Server
- Nginx
- HTTPS
- Git
- GitHub

---

## Fitur Aplikasi Mobile Warga

- Autentikasi pengguna
- Informasi dan pengumuman RT
- Pengajuan pelayanan administrasi
- Pemantauan status pelayanan
- Riwayat pelayanan
- Laporan darurat
- Informasi nomor penting
- Profil pengguna
- Notifikasi

---

## Fitur Web Admin / Pengurus RT

- Dashboard administrasi
- Pengelolaan data warga
- Pengelolaan informasi dan pengumuman
- Pengelolaan pelayanan administrasi
- Pemrosesan pengajuan warga
- Perubahan status pelayanan
- Pengelolaan laporan darurat
- Pengelolaan pengguna
- Pengelolaan role dan hak akses

---

## Pengguna Sistem

### Warga

Warga menggunakan aplikasi mobile untuk:

- Melihat informasi RT
- Mengajukan pelayanan administrasi
- Melihat riwayat pelayanan
- Memantau status pelayanan
- Menyampaikan laporan darurat
- Mengakses informasi nomor penting
- Menerima notifikasi

### Ketua RT

Ketua RT menggunakan dashboard berbasis web untuk:

- Mengelola informasi
- Mengelola data warga
- Memproses pelayanan administrasi
- Mengubah status pelayanan
- Mengelola laporan darurat
- Mengelola aktivitas administrasi RT

### Super Admin

Super Admin memiliki hak akses untuk melakukan pengelolaan sistem dan pengguna dengan cakupan yang lebih luas.

---

## Arsitektur Sistem

Sistem menerapkan arsitektur **client-server**.

```text
┌───────────────────────┐
│   Flutter Mobile App  │
│        (Warga)        │
└───────────┬───────────┘
            │
            │ HTTPS / REST API
            ▼
┌───────────────────────┐
│    Laravel Backend    │
│       REST API        │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│         MySQL         │
│       Database        │
└───────────────────────┘

            ▲
            │
┌───────────┴───────────┐
│ Laravel + Filament    │
│ Web Admin / Pengurus  │
└───────────────────────┘
