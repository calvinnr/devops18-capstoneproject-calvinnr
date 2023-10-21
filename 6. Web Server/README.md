# 6. Web Server

## 1. Set Up Domain

<img width="800" alt="Screenshot 2023-10-22 at 03 47 32" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/19ac5024-198b-48eb-9987-5ae1bd8a3aed">

DNS Point Address:

> 103.175.217.130 (Gateway Server)

List domain:

> calvin.studentdumbways.my.id
>
> api.calvin.studentdumbways.my.id
>
> dashboard.calvin.studentdumbways.my.id
>
> prometheus.calvin.studentdumbways.my.id
>
> ne-appserver.calvin.studentdumbways.my.id
>
> ne-gateway.calvin.studentdumbways.my.id

## 2. SSL Certbot menggunakan Wildcard

<img width="800" alt="Screenshot 2023-10-22 at 04 17 04" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5891ea7c-9747-4d71-ac73-a3721da612de">

<img width="800" alt="Screenshot 2023-10-22 at 01 35 12" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/4eaee571-d600-41ad-b43b-afb45c2819cb">

Jalankan perintah seperti dibawah ini:

```certbot
sudo certbot certonly --manual --preferred-challenges=dns --email youremail@gmail.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.calvin.studentdumbways.my.id -d calvin.studentdumbways.my.id
```

## 3. SSL Certbot menggunakan Certbot NGINX (Alternatif)

<img width="800" alt="Screenshot 2023-10-22 at 04 13 54" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/98796800-630b-4b25-b226-603bce51f031">

> Pastikan package python3-certbot-nginx sudah ter-install pada server

Jalankan perintah berikut untuk meng-install & memasang sertifikat pada domain yang terdaftar pada reverse proxy:

```shell
sudo certbot --nginx
```

Lalu ikuti prosedur yang ada hingga sertifikat ter-install & terpasang pada semua domain.

<img width="800" alt="Screenshot 2023-10-22 at 04 22 45" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/da53e593-3caa-47f0-8a69-1ceeff9d2eff">

Berikut contoh pada domain `calvin.studentdumbways.my.id` bahwa sertifikat SSL sudah ter-install dan terpasang pada domain tersebut.

## 4. Automasi Pembaruan Sertifikat SSL menggunakan Cronjob

<img width="800" alt="Screenshot 2023-10-22 at 04 05 49" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5bb8854d-56dd-4438-8ec7-1f8d95f8b2f2">

<sup>Direktori Cronjob: /etc/cron.d/certbot</sup>

Berikut script yang saya tambahkan pada baris baru/terakhir di dalam file `certbot`

```cronjob
0 0 1 * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(43200))' && certbot -q renew
```

Penjelasan untuk aturan cron di atas:

- 0: Menit ketika tugas dijadwalkan, di sini, diatur pada menit ke-0.
- 0: Jam ketika tugas dijadwalkan, diatur pada jam 12:00 AM (sebagai contoh, pada awal bulan).
- 1: Hari dalam sebulan ketika tugas dijadwalkan, diatur untuk 1st setiap bulan.
- *: Setiap bulan dalam setahun, menunjukkan bahwa tugas akan dijalankan setiap bulan.
- *: Setiap hari dalam seminggu, menunjukkan bahwa tugas akan dijalankan setiap hari dalam seminggu.
- root: Ini menunjukkan bahwa tugas ini akan dijalankan oleh pengguna root.
- test -x /usr/bin/certbot -a \! -d /run/systemd/system: Ini adalah kondisi yang diperiksa sebelum menjalankan perintah berikutnya. Ini memeriksa apakah /usr/bin/certbot ada dan dapat dijalankan, dan apakah /run/systemd/system bukanlah direktori.
- perl -e 'sleep int(rand(43200))': Ini adalah perintah untuk menunda eksekusi selama waktu yang dipilih secara acak antara 0 dan 43200 detik (12 jam). Ini membantu dalam menghindari penjadwalan ulang bersama dengan skrip lain yang mungkin dijalankan pada waktu yang sama.
- certbot -q renew: Ini adalah perintah aktual yang akan dijalankan. Ini memperbarui sertifikat SSL dengan Certbot dengan opsi -q yang menonaktifkan sebagian besar pesan.
<br>
Dengan aturan cron ini, script akan dijalankan pada awal setiap bulan pukul 12:00 AM, memastikan bahwa sertifikat SSL diperbarui hanya sekali sebulan namun dengan penundaan acak hingga 12 jam untuk mencegah penjadwalan ulang bersamaan dengan skrip lain yang mungkin dijalankan pada waktu yang sama.




