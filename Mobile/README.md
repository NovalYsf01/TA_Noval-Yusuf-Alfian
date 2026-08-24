# WARGA 20 – Flutter Mobile

Aplikasi mobile warga untuk sistem pelayanan masyarakat RT 20.

---

## Project

Flutter Mobile Warga 20 – antarmuka mobile bagi warga RT untuk mengakses layanan administrasi, informasi RT, laporan darurat, dan nomor penting.

---

## Scope Mobile

| Kode | Fitur |
|------|-------|
| M-01 | Splash Screen |
| M-02 | Login |
| M-03 | Beranda |
| M-04 | Informasi RT |
| M-05 | Detail Informasi |
| M-06 | Pelayanan (landing) |
| M-07 | Ajukan Pelayanan |
| M-08 | Riwayat / Status Pengajuan |
| M-09 | Detail Pengajuan |
| M-10 | Laporan Darurat |
| M-11 | Nomor Penting |
| M-12 | Profil |

**Di luar scope mobile:**
- Web admin / Web Ketua RT
- Backend Laravel
- Database MySQL
- REST API server
- FCM backend push notification

---

## Business Rules

- **1 rumah = 1 akun** – tidak ada registrasi mandiri oleh warga
- Akun dibuat oleh Ketua RT melalui web admin
- Warga hanya dapat melihat data miliknya sendiri

---

## Status Pelayanan

Hanya empat status yang valid:

| Status | API Value | Keterangan |
|--------|-----------|------------|
| Menunggu Verifikasi | `menunggu_verifikasi` | Pengajuan baru masuk |
| Diproses | `diproses` | Admin sedang memproses |
| Ditolak | `ditolak` | Pengajuan ditolak oleh admin |
| Selesai | `selesai` | Selesai, dokumen tersedia |

---

## Mock Services (Development)

Seluruh service saat ini menggunakan mock implementation dengan **singleton pattern** agar state konsisten di seluruh screen.

| Service | File | Status |
|---------|------|--------|
| AuthService | `lib/services/auth_service.dart` | Mock ✅ |
| ProfileService | `lib/services/profile_service.dart` | Mock ✅ |
| PelayananService | `lib/services/pelayanan_service.dart` | Mock ✅ |
| InformasiService | `lib/services/informasi_service.dart` | Mock ✅ |
| LaporanDaruratService | `lib/services/laporan_darurat_service.dart` | Mock ✅ |
| NomorPentingService | `lib/services/nomor_penting_service.dart` | Mock ✅ |

**Mock credentials:** `warga01` / `123456`

Untuk mengaktifkan API real: set `AppConfig.useMockData = false` di `lib/core/constants/app_config.dart`

---

## API Integration

Base URL dikonfigurasi di `lib/core/constants/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://localhost:8000/api/v1';
```

> **Untuk developer integration:** Ganti URL ini dengan alamat server Laravel yang sebenarnya. Jangan hardcode URL di masing-masing file.

### Expected Endpoints

```
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
GET    /api/v1/auth/me

GET    /api/v1/profile
PATCH  /api/v1/profile

GET    /api/v1/informasi
GET    /api/v1/informasi/{id}

GET    /api/v1/pelayanan
POST   /api/v1/pelayanan          (multipart/form-data untuk attachment)
GET    /api/v1/pelayanan/{id}

POST   /api/v1/laporan-darurat
GET    /api/v1/laporan-darurat/{id}

GET    /api/v1/nomor-penting

POST   /api/v1/device-token       (FCM – TODO)
DELETE /api/v1/device-token       (FCM – TODO)
```

### Authentication

Semua endpoint (kecuali login) menggunakan Bearer Token:

```
Authorization: Bearer <token>
```

Token disimpan di `FlutterSecureStorage` dengan key `AppConfig.tokenKey`.

### Attachment Upload

Form pengajuan menyiapkan path file lokal. Saat API tersedia, kirim sebagai `multipart/form-data` ke `POST /api/v1/pelayanan`.

Format yang diterima: **PDF, JPG, JPEG, PNG** – maks. **5 MB** (sudah divalidasi di Flutter).

### Dokumen Hasil PDF

Field `result_document` pada response pengajuan adalah URL dokumen PDF.
URL mungkin berupa **signed URL** atau route **authenticated** dari Laravel.
Developer backend perlu memastikan URL dapat diakses dengan token auth yang valid.

---

## Firebase / FCM

**Status: TODO – Belum diintegrasikan**

Mobile perlu menerima push notification untuk:
- Perubahan status pelayanan (diproses, ditolak, selesai)
- Konfirmasi laporan darurat diterima

### Yang dibutuhkan dari tim backend/integration:

1. **Firebase project** – buat project di Firebase Console
2. **`google-services.json`** – letakkan di `android/app/`
3. **Packages Flutter:**
   ```yaml
   firebase_core: ^latest
   firebase_messaging: ^latest
   ```
4. **Integrasi device token:**
   - Setelah login, kirim device token ke `POST /api/v1/device-token`
   - Saat logout, hapus token via `DELETE /api/v1/device-token`
5. **Backend:** Laravel mengirim push notification ke device token warga saat status berubah

> **JANGAN** tambahkan `google-services.json` palsu atau credential Firebase palsu.

---

## Running (Development)

```bash
# Install dependencies
flutter pub get

# Jalankan di emulator/device
flutter run

# Build APK debug (jika diperlukan)
flutter build apk --debug
```

## Code Quality

```bash
# Analisis static
flutter analyze

# Jalankan tests
flutter test
```

---

## Struktur Project

```
lib/
├── core/
│   ├── constants/       # app_colors, app_config, app_strings
│   ├── theme/           # AppTheme
│   ├── utils/           # date_format_utils, view_state
│   └── widgets/         # app_button, app_text_field, section_header
├── models/              # UserModel, PengajuanPelayananModel, dll
├── navigation/          # MainNavigation (BottomNav 4 tab)
├── screens/
│   ├── auth/            # splash_screen, login_screen
│   ├── home/            # home_screen
│   ├── informasi/       # informasi_screen, detail_informasi_screen
│   ├── pelayanan/       # pelayanan_screen, ajukan, riwayat, detail
│   ├── emergency/       # emergency_screen
│   ├── nomor_penting/   # nomor_penting_screen
│   └── profile/         # profile_screen
└── services/            # auth, profile, pelayanan, informasi, dll
```

---

## Catatan Handoff untuk Developer Integration

1. Set `AppConfig.useMockData = false`
2. Implementasikan `ApiAuthService`, `ApiProfileService`, `ApiPelayananService`, dst.
3. Register implementasi di factory constructor masing-masing service
4. Tambahkan `google-services.json` dan integrasi FCM
5. Pastikan endpoint Laravel mengembalikan format JSON sesuai `fromJson` di masing-masing model
6. Test end-to-end flow: Login → Pengajuan → Status → Logout

---

*Flutter Mobile Warga 20 – Siap untuk integrasi API*
