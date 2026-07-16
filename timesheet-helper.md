---
inclusion: manual
---

# Timesheet Entry Helper

## Aturan Format

Ketika diminta generate timesheet entry, gunakan format:

```
Aktivitas: [deskripsi max 300 karakter]
Durasi: [kelipatan 30 menit: 0.5j, 1j, 1.5j, 2j, 2.5j, 3j, dst]
```

## Aturan Penulisan Aktivitas (max 300 char)

1. Mulai dengan VERB: Implementasi, Refactor, Migrasi, Buat, Perbaiki, Update, Hapus, Tulis, Konfigurasi, Investigasi, Analisis, Verifikasi, Support, Review, Testing
2. Sebutkan WHAT: nama file/class/feature/endpoint/bug yang dikerjakan
3. Sebutkan RESULT: apa yang berubah/tercapai/ditemukan
4. Format compact: gunakan singkatan umum (impl, config, env, DI, UI, API, DB, req, resp)
5. Pisahkan multi-item dengan koma atau titik koma
6. JANGAN melebihi 300 karakter — potong jika perlu

## Aturan Estimasi Waktu

- Kelipatan: 30 menit (0.5j), 1 jam, 1.5 jam, 2 jam, dst
- Config/small file change: 0.5j
- Single class creation + test: 1j
- Multi-file refactor (3-5 files): 1.5j
- Large migration (>10 files import update): 2j
- Full feature implementation (domain+data+presentation): 2.5–3j
- Complex feature + tests: 3–4j

### Estimasi per Tipe Aktivitas

| Tipe | Breakdown Sub-aktivitas | Est Range |
|------|------------------------|-----------|
| **Support cek data req (Postman/API)** | Analisis requirement + buat/update request Postman + test posting + validasi response + dokumentasi | 1–2j |
| **Bug fix (simple)** | Reproduce bug + identifikasi root cause + fix + test manual | 1–1.5j |
| **Bug fix (medium — perlu cek flow)** | Reproduce + trace flow (Cubit→UseCase→Repo→API) + identifikasi + fix + test + verify regresi | 2–3j |
| **Bug fix (complex — multi-layer)** | Reproduce + analisis log/crashlytics + trace full flow + fix multiple files + unit test + integration verify | 3–4j |
| **Cek flow / investigasi** | Baca code flow + trace data path + dokumentasi temuan | 0.5–1j |
| **Feature development** | Analisis req + impl domain+data+presentation + test | 2–4j |
| **Code review / PR review** | Baca changes + cek pattern compliance + comment feedback | 0.5–1j |

---

## Template per Tipe Aktivitas

### 1. Support Cek Data / Requirement Posting

Cocok untuk: validasi API response, tes endpoint baru, cek data req dari tim lain.

**Template:**
```
Aktivitas: Support cek data [nama_endpoint/fitur] — buat request [POST/GET] ke [url], validasi response [field yang dicek], verifikasi [hasil: match/mismatch/error], update dokumentasi Postman collection
Durasi: [1j / 1.5j / 2j]
```

**Contoh:**
```
Aktivitas: Support cek data req posting jadwal sholat — buat request GET ke aladhan.com/v1/timings, validasi response field fajr/dhuhr/asr/maghrib/isha format HH:mm, verifikasi data match dengan UI. Update Postman collection
Durasi: 1j
```

```
Aktivitas: Support cek data req registrasi user — buat POST request ke /api/auth/register, test dengan payload valid + invalid (missing field, wrong type), validasi error response code + message sesuai spec API
Durasi: 1.5j
```

```
Aktivitas: Support verifikasi data response GET /api/v2/surat — cek 114 surah terload dengan field lengkap (nomor, nama, namaLatin, jumlahAyat), bandingkan dengan expected data, report hasil ke tim backend
Durasi: 1j
```

### 2. Bug Fix

Cocok untuk: fix crash, behavior salah, data tidak tampil, error handling.

**Template (simple):**
```
Aktivitas: Fix bug [deskripsi singkat bug] — root cause: [penyebab]. Perbaiki [file/class] dengan [solusi]. Verify fix via [cara test]
Durasi: [1j / 1.5j]
```

**Template (medium — perlu cek flow):**
```
Aktivitas: Fix bug [deskripsi]. Investigasi flow [Page→Cubit→UseCase→Repo→API]. Root cause: [penyebab di layer X]. Fix di [file], tambah [handling]. Test manual + verify tidak ada regresi
Durasi: [2j / 2.5j / 3j]
```

**Template (complex):**
```
Aktivitas: Fix bug [deskripsi]. Analisis Crashlytics log + reproduce. Trace flow [full path]. Root cause: [detail]. Fix di [file1, file2, file3]. Tambah unit test untuk cover case. Verify di device
Durasi: [3j / 3.5j / 4j]
```

**Contoh:**
```
Aktivitas: Fix bug jadwal sholat tidak tampil saat GPS off — trace flow JadwalSholatPage→PageCubit→Geolocator. Root cause: GPS null tidak emit error state. Fix: tambah locationError state + retry. Test manual GPS on/off
Durasi: 2.5j
```

```
Aktivitas: Fix bug crash di DetailSurahPage saat deep link invalid — root cause: int.parse throw FormatException. Fix: ganti int.tryParse + redirect /home jika null. Tambah log error via CrashReporter
Durasi: 1j
```

```
Aktivitas: Fix bug bookmark duplicate insert — trace flow DetailSurahPageCubit→DatabaseHelper.insertOrUpdateBookmark(). Root cause: primary key check gagal di SQLite. Fix: tambah UNIQUE constraint + ON CONFLICT REPLACE
Durasi: 1.5j
```

### 3. Cek Flow / Investigasi

Cocok untuk: understand existing code sebelum fix, analisis impact perubahan.

**Template:**
```
Aktivitas: Investigasi flow [fitur/bug] — trace [start point] → [end point], identifikasi [temuan/bottleneck/root cause]. Dokumentasi hasil analisis untuk [tujuan: fix/refactor/planning]
Durasi: [0.5j / 1j / 1.5j]
```

**Contoh:**
```
Aktivitas: Investigasi flow notifikasi adzan — trace dari JadwalSholatPageCubit.toggleNotification() → NotificationService → FlutterLocalNotifications. Identifikasi: scheduling timezone issue. Dokumentasi untuk bug fix
Durasi: 1j
```

```
Aktivitas: Analisis flow error handling API layer — trace RemoteDatasourceImpl → RemoteRepositoryImpl → Cubit. Temuan: DioException di-catch di repo (seharusnya datasource). Dokumentasi rencana refactor
Durasi: 0.5j
```

### 4. Feature Development

**Template:**
```
Aktivitas: Impl fitur [nama] — buat [domain: entity/usecase/repo] + [data: model/datasource/repo_impl] + [presentation: cubit/state/page]. Register DI. Tulis [N] unit tests. Verify UI behavior
Durasi: [2j / 2.5j / 3j / 4j]
```

### 5. Refactoring / Architecture Task

**Template:**
```
Aktivitas: Refactor [apa] — [dari kondisi lama] → [ke kondisi baru]. Update [N] files affected. Verify [test/analyze] pass tanpa regresi
Durasi: [1j / 1.5j / 2j]
```

---

## Cara Pakai

User cukup bilang salah satu:

**Untuk task yang sudah direncanakan:**
- "generate timesheet task 1-4"
- "saya selesai task 26, buatkan entry"

**Untuk support/bug fix/investigasi ad-hoc:**
- "hari ini saya support cek data API registrasi, fix bug GPS, dan investigasi flow notifikasi"
- "buatkan timesheet: fix bug bookmark crash + cek flow surah detail"
- "tadi saya debug error jadwal sholat 2 jam, lalu fix 1 jam"

**AI akan:**
1. Tanya detail jika kurang jelas (endpoint apa? bug apa? flow mana?)
2. Generate entry ≤300 char + durasi kelipatan 30m
3. Breakdown jika 1 hari ada multiple aktivitas

---

## Contoh Output Hari Kerja Penuh
     
User: "hari ini saya support cek data posting user, fix bug GPS tidak tampil, sama cek flow detail surah"

Output:
```
Entry 1:
Aktivitas: Support cek data req POST /api/users — validasi payload (name, email, phone), test response success + error cases (400 missing field, 409 duplicate). Update Postman collection + share hasil ke tim
Durasi: 1.5j

Entry 2:
Aktivitas: Fix bug jadwal sholat tidak tampil saat GPS mati — trace JadwalSholatPageCubit.init(). Root cause: position null langsung emit loaded state kosong tanpa error. Fix: tambah locationError state + UI retry button
Durasi: 2.5j

Entry 3:
Aktivitas: Investigasi flow detail surah — trace dari HomeCubit.getDetailSurah() → go_router push → DetailSurahPage → DetailSurahCubit.getPosts() → UseCase → Repository → API. Dokumentasi data flow untuk planning refactor
Durasi: 1j

Total hari ini: 5j
```
