# Dokumentasi Sistem Informasi Tenda

Sistem Informasi Tenda adalah sebuah platform layanan penyewaan tenda bongkar pasang yang berkedudukan di Kabupaten Buton Utara. Fokus utama kami adalah menyediakan kebutuhan tenda untuk berbagai acara, mulai dari hajatan keluarga, kegiatan pemerintahan, acara adat, hingga kegiatan sosial masyarakat.

Dengan sistem informasi yang terintegrasi, pengelolaan penyewaan dilakukan lebih cepat, transparan, dan teratur. Tidak lagi bergantung pada catatan manual, melainkan memanfaatkan database dan aplikasi berbasis digital agar semua transaksi tercatat dengan rapi.

## 🎯 Fitur Utama

- **Manajemen Inventory** - Kelola stok tenda dan perlengkapan pendukung
- **Sistem Pemesanan Online** - Proses penyewaan yang mudah dan cepat
- **Manajemen Pelanggan** - Database pelanggan yang terorganisir
- **Notifikasi** - Pengingat untuk pemesanan dan pengembalian

## 🚀 Teknologi yang Digunakan

- **Backend**: PHP, MySQL
- **Frontend**: HTML, CSS, JavaScript
- **Framework**: -
- **Server**: Apache / Server
- **Database**: MySQL Mariadb

## 📁 Struktur Direktori

```

si-tenda/
├──app/
│├── Config/
││   ├── config.php
││   ├── Database.php
││   └── Routes.php
│├── Controllers/
││   ├── Home.php
││   ├── Auth.php
││   ├── Tent.php
││   ├── Rental.php
││   └── Customer.php
│├── Models/
││   ├── UserModel.php
││   ├── TentModel.php
││   ├── RentalModel.php
││   └── CustomerModel.php
│├── Views/
││   ├── templates/
││   │   ├── header.php
││   │   ├── footer.php
││   │   └── sidebar.php
││   ├── auth/
││   ├── tent/
││   ├── rental/
││   └── customer/
│└── Database/
│├── Migrations/
│└── Seeds/
├──public/
│├── index.php
│├── assets/
││   ├── css/
││   │   ├── style.css
││   │   ├── bootstrap.min.css
││   │   └── custom.css
││   ├── js/
││   │   ├── script.js
││   │   ├── bootstrap.bundle.min.js
││   │   ├── chart.js
││   │   └── rental.js
││   └── images/
││       ├── logo.png
││       └── favicon.ico
│└── uploads/
│├── tents/
│└── customers/
├──system/
├──writable/
├──tests/
├──env
├──.gitignore
├──composer.json
├──composer.lock
└──README.md

```

## 📋 Deskripsi File Utama

### Konfigurasi
- **config.php** - Konfigurasi utama aplikasi
- **Database.php** - Konfigurasi koneksi database
- **Routes.php** - Definisi routing aplikasi

### File Entry Point
- **index.php** - File utama yang menangani semua request

### Assets
- **style.css** - Stylesheet utama untuk styling
- **script.js** - JavaScript utama untuk interaksi
- **rental.js** - JavaScript khusus modul penyewaan

### PHP Classes
- **Controllers/** - Menangani logika request dan response
- **Models/** - Menangani interaksi dengan database
- **Views/** - Template tampilan untuk user interface


## 📋 Prasyarat Sistem

- PHP 7.4 atau lebih tinggi
- MySQL 5.7 atau lebih tinggi
- PHP server

## 🔧 Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/rahman115/tenda.git
   ```
2. **Masuk ke directory project**
   ```bash
   cd tenda
   ```
3. **Setup database**
   · Buat database baru di MySQL
   · Import file SQL yang tersedia
   ```bash
   mysql -u username -p database_name < database.sql
   ```
4. **Konfigurasi environment**
- Sesuaikan setting database dan konfigurasi lainnya
5. **Jalankan aplikasi**
   ```bash
   php -S 127.0.0.1:8080
   ```

### Tabel Utama

- **users** - Data pengguna sistem
- **pekerja** - Data users melakukan kerjaan
- **kerjaan** - Data pelanggan
- **detail_kerjaan** - Data detail penyewaan
- **payments** - Data pembayaran


## 🔄 Sistem Query

### Backup Database

```bash
mysql -u root tenda > backup.sql
```

### Restore Database

```bash
mysql -u root tenda < backup.sql
```

### Query Penting

```sql
-- Mengimport database dalam mysql
SOURCE backup.sql;

-- Melihat data penyewaan aktif
SELECT * FROM rentals WHERE status = 'active';

-- Melihat tenda yang tersedia
SELECT * FROM tents WHERE status = 'available';

-- Laporan pendapatan bulanan
SELECT MONTH(created_at) as bulan, SUM(total_amount) as pendapatan 
FROM payments 
WHERE YEAR(created_at) = YEAR(CURDATE()) 
GROUP BY MONTH(created_at);
```

## 👥 Pengguna Sistem

- **Admin** - Mengelola seluruh sistem dan laporan
- **user** - Memproses pekerja
- **Pelanggan** - Melakukan pemesanan secara online

## 📞 Kontak & Support

Untuk pertanyaan dan dukungan teknis, silakan hubungi:

- **Email**: -
- **Telepon**: (+62) 
- **Alamat**: Jl. Utama No. 10, Kabupaten Buton Utara

## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file LICENSE untuk detail lebih lanjut.

## 🤝 Berkontribusi

Kami menyambut kontribusi dari komunitas. Silakan fork repository ini dan submit pull request untuk perbaikan atau fitur baru.

---

**SI Tenda** - Solusi Digital untuk Penyewaan Tenda Profesional 🏕️
