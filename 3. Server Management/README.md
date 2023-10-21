# 3. Server Management

## 1. Membuat SSH Config

<img width="800" alt="Screenshot 2023-10-22 at 01 35 12" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/0ed133c8-8956-4e7f-8ae3-3d80fd337ea9">

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
