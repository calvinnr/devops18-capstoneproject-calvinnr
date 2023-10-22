# 5. Monitoring

## 1. Target Prometheus

<img width="800" alt="Screenshot 2023-10-22 at 04 36 56" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/75543559-a9ce-4d13-8988-9f544a15dfb6">

Berikut gambaran dari 2 node-exporter yang sudah terpasang pada 2 server yaitu `appserver` dan `gateway` dengan nama job `capstone` dan sudah ter-integrasi dengan Prometheus yang nanti kita butuhkan untuk Query pada Grafana

## 2. Konfigurasi Grafana

<img width="800" alt="Screenshot 2023-10-22 at 12 25 05" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5182dfc5-abbf-4e13-b5f8-45967442c204">

Pada tampilan utama Dashboard Grafana, Disini klik pada `DATA SOURCES / ADD YOUR FIRST DATA SOURCES`

<img width="800" alt="Screenshot 2023-10-22 at 12 27 17" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/835f867a-06cd-42ee-8e1f-b4c04bb7d942">

Setelah itu, pilih `Prometheus`

<img width="800" alt="Screenshot 2023-10-22 at 12 29 01" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/981e293e-8ca0-4152-bbc6-1c1bb64a34f3">
<img width="800" alt="Screenshot 2023-10-22 at 12 29 23" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/c3602c43-15e6-4877-a255-adda9364bf51">
<img width="800" alt="Screenshot 2023-10-22 at 12 30 15" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/950b4735-07eb-460c-847f-b418aeff0200">

Berikut beberapa konfigurasi yang saya ubah agar Data Source dari Prometheus dapat terbaca:

> Name: Prometheus
>
> Prometheus server URL: https://prometheus.calvin.studentdumbways.my.id
>
> Scrape interval: 5s
>
> Query timeout: 60s
>
> Default editor: Code
>
> Prometheus type: Prometheus

Lalu klik `Save & Test`

<img width="800" alt="Screenshot 2023-10-22 at 12 39 28" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/f4e4c8b0-57cd-4758-af04-3721a0337a6b">

Pada tampilan awal, ketikan `cmd+k` untuk masuk ke mode pencarian lalu ketikan pada tab search `Import dashboard` setelah itu klik pada hasil yang muncul

<img width="800" alt="Screenshot 2023-10-22 at 12 41 58" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/66537071-8487-48d8-b103-59fd0806a642">

Lalu saya klik `Upload dashboard JSON file` dengan catatan sudah mendownload pada node template yang ingin digunakan

<img width="802" alt="Screenshot 2023-10-22 at 12 43 47" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/7ee6d9c0-9500-4f30-a73a-6361e600f3bb">

Disini saya menggunakan `node-exporter-full.json`

<img width="800" alt="Screenshot 2023-10-22 at 12 45 07" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/4c22f3de-6120-4549-bda7-79d206def2a7">

Berikut beberapa konfigurasi yang saya ubah agar Data Source dari Prometheus dapat terbaca:

> Name: Capstone Dashboard
>
> Data Sources: Prometheus

Setelah itu klik `Import`

<img width="800" alt="Screenshot 2023-10-22 at 12 50 07" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/79ab5114-6d80-449a-a6a1-2dd073cc2abc">
<br>
<sup>appserver</sup>
<br>
<br>
<img width="800" alt="Screenshot 2023-10-22 at 12 50 17" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/b0cdd8b9-c175-4822-8fec-f415c76388df">
<br>
<sup>gateway</sup>
<br>

Berikut hasil dari tampilan dashboard pada masing-masing host, Terdapat `CPU Usage,` `Memory Usage,` `Disk Usage,` dan `Network Usage`

## 3. Konfigurasi Alert Manager Grafana

<img width="800" alt="Screenshot 2023-10-22 at 13 09 10" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/3d2ba445-ce65-47ec-a940-c5716a242a9a">

Pada tampilan awal dashboard, klik pada `toggle menu` pada kiri atas, lalu setelah muncul dropdown, klik pada `Alerting`

<img width="800" alt="Screenshot 2023-10-22 at 13 11 37" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/1691a9d6-e12f-40ce-b376-3d9747a8cd98">

Pada side bar menu, Klik pada `Contact points` lalu klik pada `Add contact point`

<img width="800" alt="Screenshot 2023-10-22 at 13 13 20" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/30ddda34-66f5-48db-bfff-c3caea42c80a">

Karena saya disini menggunakan `Discord` sebagai media untuk reporting alert-nya, maka berikut beberapa konfigurasi yang saya ubah:

> Name: Discord Notifier
>
> Integration: Discord
>
> Webhook URL: yourwebhookurl

<img width="800" alt="Screenshot 2023-10-22 at 14 30 57" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/002a4897-97b4-4431-9149-c8d723a8498a">

Berikut `Alert Rules` yang telah di buat untuk `CPU Usage,` `Memory Usage,` `Disk Usage,` dan `Network Usage`
