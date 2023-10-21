# 3. Server Management

## 1. Membuat SSH Config

<img width="800" alt="Screenshot 2023-10-22 at 02 52 08" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/f02cd62b-c0e9-433c-b205-539003f11a33">

Dibawah ini terdapat isi dari file konfigurasi SSH Config untuk memudahkan login ke server atau dapat langsung ambil contoh file-nya yang terdapat pada repositori:

```shell
host aws
   Hostname 13.229.49.115
   User ubuntu
   IdentityFile ~/.ssh/id_rsa
   ServerAliveInterval 300
   ServerAliveCountMax 10

host app
   Hostname 103.175.218.224
   User calvin
   IdentityFile ~/.ssh/id_rsa
   ServerAliveInterval 300
   ServerAliveCountMax 10
   ProxyCommand ssh gateway -W %h:%p

host gateway
   Hostname 103.175.217.130
   User calvin
   IdentityFile ~/.ssh/id_rsa
   ServerAliveInterval 300
   ServerAliveCountMax 10
```

## 2. UFW Allow Ports List

<img width="800" alt="Screenshot 2023-10-21 at 04 37 07" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/3d284ea0-dee4-49aa-877a-8dde23341c54">

Berikut Port Port Protokol yang sudah di Allow oleh UFW:

> 22 (SSH)
>
> 80 (HTTP)
>
> 443 (HTTPS)
>
> 3000 (NodeJS)
>
> 5000 (API Backend)
>
> 5432 (PostgreSQL)
>
> 3306 (MySQL)
>
> 9090 (Prometheus)
>
> 9100 (Node-Exporter)
>
> 13000 (Grafana)
>
> 8080 (HTTP)

