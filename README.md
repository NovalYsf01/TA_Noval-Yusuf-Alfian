# Sistem Pelayanan Administrasi dan Informasi RT Berbasis Web dan Mobile

Proyek Tugas Akhir yang dikembangkan untuk membantu proses pelayanan administrasi, penyampaian informasi, dan komunikasi antara warga dengan pengurus RT melalui aplikasi mobile dan sistem administrasi berbasis web.

## Tentang Proyek

Sistem ini dirancang untuk mendukung digitalisasi pelayanan di lingkungan RT dengan menyediakan aplikasi mobile bagi warga dan dashboard berbasis web bagi pengurus RT.

Aplikasi mobile digunakan oleh warga untuk memperoleh informasi, mengajukan pelayanan administrasi, memantau status pelayanan, dan menyampaikan laporan darurat.

Sementara itu, pengurus RT menggunakan dashboard web untuk mengelola data warga, informasi RT, pelayanan administrasi, laporan darurat, serta aktivitas sistem.

## Fitur Utama

### Aplikasi Mobile Warga

- Autentikasi pengguna
- Informasi dan pengumuman RT
- Pengajuan pelayanan administrasi
- Pemantauan status pelayanan
- Riwayat pelayanan
- Laporan darurat
- Informasi nomor penting
- Profil pengguna
- Notifikasi

### Web Admin / Pengurus RT

- Dashboard pengelolaan
- Manajemen data warga
- Manajemen informasi dan pengumuman
- Pengelolaan pelayanan administrasi
- Pemantauan status pelayanan
- Pengelolaan laporan darurat
- Manajemen pengguna
- Pengelolaan data sistem

## Teknologi yang Digunakan

### Mobile
- Flutter
- Dart

### Backend & Web
- Laravel
- Filament
- REST API

### Database
- MySQL

### Notification
- Firebase Cloud Messaging (FCM)

## Arsitektur Sistem

```text
┌─────────────────────┐
│   Aplikasi Flutter  │
│       (Warga)       │
└──────────┬──────────┘
           │
           │ REST API
           ▼
┌─────────────────────┐
│       Laravel       │
│      Backend API    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│        MySQL        │
│      Database       │
└─────────────────────┘

           ▲
           │
┌──────────┴──────────┐
│ Laravel + Filament  │
│   Web Pengurus RT   │
└─────────────────────┘
