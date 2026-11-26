# Panduan: Web Keuangan Perpulungan Stefanus (milik sendiri, online)

Hasil akhirnya: sebuah alamat web (misalnya `stefanus.netlify.app`) yang bisa dibuka siapa saja tanpa login. Hanya bendahara yang bisa mengisi data. Semuanya memakai layanan gratis.

Isi folder: `index.html` (situsnya), `setup.sql` (pembuat database), `PANDUAN.md` (ini).

## 1. Buat database di Supabase
1. Daftar di supabase.com, lalu buat **New project** (catat kata sandi database, simpan baik-baik).
2. Setelah project siap, buka **SQL Editor**, klik **New query**, tempel seluruh isi `setup.sql`, lalu **Run**. Ini membuat tabel dan aturan keamanan: semua orang boleh melihat, hanya yang login boleh mengubah.

## 2. Buat akun bendahara dan tutup pendaftaran
1. Buka **Authentication**, bagian **Users**, pilih **Add user**, isi email dan kata sandi bendahara. Centang auto confirm jika ada.
2. Buka pengaturan Authentication (**Sign In / Providers** atau **Settings**) dan **matikan "Allow new users to sign up"**. Langkah ini penting: kalau tidak dimatikan, orang lain bisa mendaftar sendiri lalu ikut mengubah data.

## 3. Ambil dua kunci
Buka **Project Settings**, bagian **API** (nama menu bisa sedikit berbeda), lalu salin:
- **Project URL**
- **anon public key** (kunci publik). Jangan pakai `service_role`, kunci itu rahasia.

Buka `index.html` dengan Notepad, lalu ganti dua baris di dekat bagian bawah:
```
var SUPABASE_URL='GANTI_DENGAN_PROJECT_URL';
var SUPABASE_KEY='GANTI_DENGAN_ANON_PUBLIC_KEY';
```
Kunci publik memang aman ditaruh di situs, karena yang membatasi akses adalah aturan keamanan dari `setup.sql`.

## 4. Pasang di internet (pilih salah satu)
- **Netlify Drop**: buka app.netlify.com/drop, seret folder berisi `index.html` ke sana. Alamat web langsung jadi, bisa diganti namanya di pengaturan situs.
- **Cloudflare Pages** atau **GitHub Pages**: unggah `index.html`, lalu aktifkan hosting.
- Mau domain sendiri (misalnya `keuanganstefanus.id`)? Belilah domain, lalu sambungkan lewat menu Domain di layanan hosting yang dipilih.

## 5. Mulai dipakai
1. Buka alamat webnya, klik **Masuk bendahara**, login dengan akun langkah 2.
2. Di Ringkasan klik **Pasang pos bawaan**, isi nama ketua, bendahara, dan saldo awal di **Pengaturan**. Totalnya mulai dari Rp 0.
3. Catat transaksi di **Buku Kas**. Umat yang membuka web akan melihat data terbaru otomatis.

## Catatan keamanan
- Jangan bagikan email dan kata sandi bendahara. Ganti kata sandi bila perlu lewat dashboard Supabase.
- Unduh cadangan JSON di menu Pengaturan secara berkala.
- Paket gratis Supabase bisa "tidur" bila tidak dipakai lama. Buka dashboardnya bila web tidak memuat data.
