# 1. Provisioning

## Infrastructure as a Code: Terraform

### 1. Instalasi Prasyarat untuk Penyediaan Infrastruktur Server AWS menggunakan Terraform

Karena disini saya menggunakan Amazon Web Services sebagai contoh implementasi IaC menggunakan Terraform. Maka ada 3 Prasyarat yang harus dipenuhi yaitu:

> 1. Terraform CLI (1.2.0+) sudah ter-install.
>
> 2. AWS CLI sudah ter-install.
>
> 3. Akun AWS dan kredential terkait yang memberikan izin untuk membuat resources.


#### 1.1 Instalasi Terraform

Install Terraform pada node lokal dengan melihat dokumentasi pada website [Terraform](https://developer.hashicorp.com/terraform/downloads) atau menjalankan script `install_terraform.sh` yang sudah tersedia pada repositori. Berikut isi perintahnya:

```shell
#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
```

<img width="800" alt="Screenshot 2023-10-18 at 11 25 31" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/24b94cb7-e391-44cf-97d7-dbdbd19118f5">

Jalankan script-nya dengan perintah berikut:

```shell
sh install_terraform.sh
```

<img width="800" alt="Screenshot 2023-10-18 at 04 00 45" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/7562b0e6-7275-4142-885b-f90c7ce02992">

Jika instalasi telah selesai dilakukan, maka jalankan perintah berikut untuk memverifikasi bahwa Terraform sudah ter-install pada node dengan baik dan akan muncul versi yang telah ter-install. Terraform yang saya gunakan disini versi `v.1.6.1`

```shell
terraform -v
```

#### 1.2 Instalasi AWS CLI

Install AWS CLI pada node lokal dengan melihat dokumentasi pada website [AWS](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-install.html) atau menjalankan script `install_awscli.sh` yang sudah tersedia pada repositori. Berikut isi perintahnya:

```shell
#!/usr/bin/env bash

sudo apt-get install unzip -y
sudo apt-get install python3.10-venv -y
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo /usr/bin/python3.10 awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
```

<img width="800" alt="Screenshot 2023-10-18 at 11 48 35" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/b5f4500e-e490-4c0c-89a2-c8cbcc855aad">

Jalankan script-nya dengan perintah berikut:

```shell
sh install_awscli.sh
```

<img width="800" alt="Screenshot 2023-10-18 at 11 50 03" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/b7b80222-d382-4aa3-91a6-0c840b19766f">

Jika instalasi telah selesai dilakukan, maka jalankan perintah berikut untuk memverifikasi bahwa AWS CLI sudah ter-install pada node dengan baik dan akan muncul versi yang telah ter-install. AWS CLI yang saya gunakan disini versi `v.1.29.65` dan berjalan pada `Python3.10`

```shell
aws --version
```

#### 1.3 Konfigurasi Access Key

<img width="800" alt="Screenshot 2023-10-18 at 11 53 45" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/ee005e95-cb86-45c1-8354-6e24eeec3632">

Langkah pertama yang perlu dilakukan ada mengkonfigurasi Access Key-nya. Karena apa? Karena Terraform membutuhkan sebuah kunci agar memiliki akses untuk menyediakan server AWS-nya. Nah Access-Key ini berfungsi agar Terraform dikenali oleh AWS sebagai platform IaC untuk menyediakan server AWS secara otomatis menggunakan perintah yang tersedia. Oke lanjut, masuk ke Console AWS-nya. Lalu pada dashboard console-nya, klik nama profile pada ujung kanan setelah itu akan muncul menu dropdown lalu pilih `Security credentials`

<img width="800" alt="Screenshot 2023-10-18 at 12 03 14" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/ce248bfb-d94a-4440-bcad-6058c451b116">

Setelah itu scroll-down sampai menemukan opsi `Access keys`. Disini klik `Create access key`

<img width="800" alt="Screenshot 2023-10-18 at 12 02 33" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/faf3e96b-3037-425b-bb2d-809b1e5cfec8">

Lalu centang opsi dibawah `Continue to create access key` 

<img width="800" alt="Screenshot 2023-10-18 at 12 03 14" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/8b3935a5-2844-4db3-94f8-f7466ad382a4">

Setelah itu, Access keys yang sudah terbuat tadi jangan lupa untuk disimpan id `Access key` dan `Secret access key`-nya.

<img width="800" alt="Screenshot 2023-10-18 at 04 34 33" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/f82f5e03-3b57-4219-9a4d-828f86b5f637">

Pertama kita set Access Keys yang sudah kita dapatkan tadi agar Terraform memiliki akses untuk membuat Resources di AWS dengan menjalankan perintah:

```aws
aws configure
```
Dengan spesifikasi sebagai berikut:

> AWS Access Key ID: (access-key)
>
> AWS Secret Access Key: (secret-access-key)
>
> Default region name: (blank)
>
> Default output format: (blank)

Lalu saya buat folder pada home bernamakan `terraform-aws` setelah saya membuat file bernama `main.tf` lalu saya isikan script berikut:

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-southeast-1"
}

resource "aws_instance" "calvin" {
  ami           = "ami-002843b0a9e09324a"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-1b"
  associate_public_ip_address = true

  tags = {
    Name = "ec2-as1-1b-d-calvin"
  }
}
```

Setelah itu jalankan `terraform_command.sh` yang tersedia pada repositori `terraform-aws-infra` dengan isian sebagai berikut:

```shell
#!/usr/bin/env bash

terraform init
terraform plan
terraform validate
terraform apply
```

<img width="1440" alt="Screenshot 2023-10-20 at 00 51 04" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5a1a2c02-6ccd-4086-b527-1c6ea2243601">

Dapat dilihat dari gambar diatas jika server sudah terbuat. Maka, dapat dipastikan bahwa Terraform sudah berjalan dengan benar.

## Configuration Management Tools: Ansible

### 1. Instalasi Ansible


 
