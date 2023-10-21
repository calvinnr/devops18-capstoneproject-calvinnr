# 1. Provisioning

## Requirements

#### 1. Multipass Server

<img width="800" alt="Screenshot 2023-10-20 at 18 55 41" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/dfa99e64-b792-4883-abbb-71df32d79a9b">

#### 2. Biznet GIO NEO Lite Servers Type SS 2.2 (App Server)

<img width="800" alt="Screenshot 2023-10-18 at 03 20 02" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/b7f12c7e-99ff-43d1-ab34-2eb3a5cca16d">

#### 3. Biznet GIO NEO Lite Servers Type XS 1.1 (Gateway Server)

<img width="800" alt="Screenshot 2023-10-18 at 03 19 52" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/80db8db6-74b6-4cc3-a9cf-398098450233">


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

<img width="800" alt="Screenshot 2023-10-20 at 00 51 04" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5a1a2c02-6ccd-4086-b527-1c6ea2243601">

Dapat dilihat dari gambar diatas jika server sudah terbuat. Maka, dapat dipastikan bahwa Terraform sudah berjalan dengan benar.

## Configuration Management Tools: Ansible

### 1. Instalasi Ansible

Install Ansible pada node lokal dengan melihat dokumentasi pada website [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu) atau menjalankan script `install_ansible.sh` yang sudah tersedia pada repositori. Berikut isi perintahnya:

```shell
#!/usr/bin/env bash

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

<img width="800" alt="Screenshot 2023-10-20 at 18 50 19" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/e4439d68-696f-4578-aa54-2b4634d7a920">

Jalankan script-nya dengan perintah berikut:

```shell
sh install_ansible.sh
```

<img width="800" alt="Screenshot 2023-10-20 at 00 55 59" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/1d38c601-abb3-4233-a5f2-263fd72812e3">

Jika instalasi telah selesai dilakukan, maka jalankan perintah berikut untuk memverifikasi bahwa Ansible sudah ter-install pada node dengan baik dan akan muncul versi yang telah ter-install. Terraform yang saya gunakan disini versi `Core 2.15.5` dan berjalan pada `Python3.10`

```shell
ansible --version
```

### 2. Membuat file yang dibutuhkan untuk menjalankan Ansible-Playbook

Disini, saya membuat direktori bernamakan `ansible` lalu di dalamnya terdapat file yang berisikan Inventory, ansible.cfg, docker.yml, firewall.yml, grafana.yml, nginx.yml, node-exporter.yml, prometheus.yml, repo.yml, ssh.yml. Berikut isi script dari file file tersebut:

- Inventory

<img width="800" alt="Screenshot 2023-10-21 at 03 09 02" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/3568cabf-6978-487e-bbd9-9cf8cedd1c17">

```ansible
[appserver]
103.175.218.224

[gateway]
103.175.217.130

[all:vars]
ansible_connection=ssh
ansible_port=22
ansible_user="calvin"
ansible_python_interpreter=/usr/bin/python3.8
```

- ansible.cfg

<img width="800" alt="Screenshot 2023-10-21 at 03 09 08" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/142f311a-95b6-42a8-955e-7af89592dfd5">

```ansible
[defaults]
inventory = Inventory
private_key_file = /home/ubuntu/.ssh/id_rsa
host_key_checking  = False
timeout = 10
remote_port = 22
interpreter_python = auto_silent

[ssh_connection]
ssh_args = -o ForwardAgent=yes
```

- docker.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 04 11" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/2efe1a23-6838-4716-9fb6-657133973a70">

```ansible
---
- become: true
  hosts: all
  gather_facts: false
  tasks:
    - name: Install Aptitude
      apt:
        name: aptitude
        state: latest
        update_cache: true

    - name: Install Docker Dependencies
      apt:
        update_cache: yes
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
          - gnupg
          - python3-pip
          - python3-venv
          - python3-docker
          - python3-apt
          - lsb-release

    - name: Add Docker GPG Key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg

    - name: Add Docker Repository
      apt_repository:
        repo: deb https://download.docker.com/linux/ubuntu focal stable

    - name: Install Docker Engine
      apt:
        update_cache: true
        name:
          - docker-ce
          - docker-ce-cli
          - docker-buildx-plugin

    - name: Add User Docker Group
      user:
        name: calvin
        groups: docker
        append: yes
```

- firewall.yml

<img width="800" alt="Screenshot 2023-10-21 at 04 11 31" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/afa0e4c9-9255-4db3-85b7-ba1123e08016">

```ansible
---
- become: true
  gather_facts: false
  hosts: gateway
  tasks:
    - name: Install UFW
      apt:
        name: ufw
        update_cache: yes
        state: latest

    - name: Enable UFW
      community.general.ufw:
        state: enabled
        policy: allow

    - name: UFW Allow Rules
      community.general.ufw:
        rule: allow
        proto: tcp
        port: "{{ item }}"
      with_items:
      - 22
      - 80
      - 443
      - 3000
      - 5000
      - 5432
      - 3306
      - 9090
      - 9100
      - 8080
      - 13000
    - name: enable ufw
      community.general.ufw:
        state: reloaded
        policy: allow
```

- grafana.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 09 19" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/91b9aeab-c36f-4b91-b1db-34cad437d487">

```ansible
---
- become: true
  gather_facts: false
  hosts: appserver
  tasks:
    - name: Set Permission
      ansible.builtin.file:
        path: ~/grafana
        state: directory
        mode: "0755"

    - name: Set Up Grafana
      community.docker.docker_container:
        name: grafana
        image: grafana/grafana
        ports:
          - 13000:3000
        restart_policy: unless-stopped
        volumes:
          - ~/grafana:/var/lib/grafana
        user: root
```

- nginx.yml

<img width="800" alt="Screenshot 2023-10-21 at 05 14 51" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/f8cf2505-c412-4c52-8809-7f2d6f1527d9">
<img width="800" alt="Screenshot 2023-10-21 at 05 15 00" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/7a2421a7-71b6-4dd8-8422-fc789ce8f6a5">

```ansible
---
- become: true
  gather_facts: false
  hosts: gateway
  tasks:
    - name: Installing NGINX
      apt:
        name: nginx
        state: present

    - name: Create NGINX Reverse Proxy File
      file:
        path: /etc/nginx/sites-enabled/rproxy.conf
        state: touch

    - name: Amend NGINX Revese Proxy File
      blockinfile:
          path: /etc/nginx/sites-enabled/rproxy.conf
          marker: ""
          block: |
            server {
               server_name calvin.studentdumbways.my.id;
               location / {
               proxy_pass http://103.175.218.224:3000;
               }
            }
            server {
               server_name ne-appserver.calvin.studentdumbways.my.id;
               location / {
               proxy_pass http://103.175.218.224:9100;
               }
            }
            server {
               server_name ne-gateway.calvin.studentdumbways.my.id;
               location / {
               proxy_pass http://103.175.217.130:9100;
               }
            }
            server {
               server_name prometheus.calvin.studentdumbways.my.id;
               location / {
               proxy_pass http://103.175.218.224:9090;
               }
            }
            server {
               server_name dashboard.calvin.studentdumbways.my.id;
               location / {
               proxy_set_header Host dashboard.calvin.studentdumbways.my.id;
               proxy_pass http://103.175.218.224:13000;
               }
            }
            server {
               server_name api.calvin.studentdumbways.my.id;
               location / {
               proxy_pass http://103.175.218.224:5000;
               }
            }

    - name: Install Certbot
      community.general.snap:
        name: certbot
        classic: yes

    - name: Link Certbot
      ansible.builtin.file:
        src: /snap/bin/certbot
        dest: /usr/bin/certbot
        owner: root
        group: root
        state: link

    - name: Set certbot trust-plugin-with-root
      community.general.snap:
        name:
          - certbot
        options:
          - trust-plugin-with-root=ok

    - name: Install DNS Plugin
      community.general.snap:
        name: certbot-dns-cloudflare

    - name: Reload NGINX
      service:
        name: nginx
        state: reloaded

    - name: Make Sure NGINX is Running Properly
      service:
        name: nginx
        state: restarted
        enabled: yes
```

- node-exporter.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 07 02" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/be037609-d7cd-49c2-aee9-88946232a84a">

```ansible
---
- become: true
  gather_facts: false
  hosts: all
  tasks:
    - name: Install Node-Exporter
      community.docker.docker_container:
        name: node-exporter
        image: prom/node-exporter
        ports:
          - 9100:9100
        restart_policy: unless-stopped
```

- prometheus.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 32 52" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/e4b34960-f89e-45ab-affc-aaf3a9249f03">

```ansible
---
- become: true
  gather_facts: false
  hosts: appserver
  tasks:
    - name: Create Prometheus.yml
      copy:
        dest: /home/calvin/prometheus.yml
        content: |
          scrape_configs:
            - job_name: capstone
              scrape_interval: 5s
              static_configs:
              - targets:
                - ne-appserver.calvin.studentdumbways.my.id
                - ne-gateway.calvin.studentdumbways.my.id

    - name: Running Prometheus on Top Docker
      community.docker.docker_container:
        name: prometheus
        image: prom/prometheus
        ports:
          - 9090:9090
        restart_policy: unless-stopped
        volumes:
          - /home/calvin/prometheus.yml:/etc/prometheus/prometheus.yml
```

- repo.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 52 13" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/0a3c4f3a-1ba8-4461-9d45-a511c72b90e6">

```ansible
---
- hosts: appserver
  gather_facts: no

  tasks:
    - name: Clone Frontend Repository
      git:
        clone: yes
        repo: git@gitlab.com:calvinnr/fe-dumbmerch.git
        version: master
        dest: /home/calvin/fe-dumbmerch
        accept_hostkey: yes
        key_file: /home/calvin/.ssh/id_rsa
      become: yes

    - name: Clone Backend Repository
      git:
        clone: yes
        repo: git@gitlab.com:calvinnr/be-dumbmerch.git
        version: master
        dest: /home/calvin/be-dumbmerch
        accept_hostkey: yes
        key_file: /home/calvin/.ssh/id_rsa
      become: yes
```

- ssh.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 40 14" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/81ea4404-1c3c-41bf-8f96-4c88d454e36a">

```ansible
---
- become: true
  gather_facts: false
  hosts: all
  tasks:
    - name: Copy SSH Private Keys
      copy:
        src: /home/ubuntu/.ssh/id_rsa
        dest: /home/calvin/.ssh

    - name: Copy SSH Pubic Keys
      copy:
        src: /home/ubuntu/.ssh/id_rsa.pub
        dest: /home/calvin/.ssh
```

### 3. Hasil Ansible-Playbook

- docker.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 05 15" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/65a6ee5a-0de0-4039-906f-ce01b7d386a4">

- firewall.yml

<img width="800" alt="Screenshot 2023-10-21 at 04 11 23" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/918d7b94-2808-46a0-b62a-c836b8553969">

- grafana.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 11 40" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/0733084b-549d-4e81-8140-c24095096461">

- nginx.yml

<img width="800" alt="Screenshot 2023-10-21 at 05 14 38" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/88a06418-564e-4d05-a06b-943287a7fd50">

- node-exporter.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 06 50" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/41b55aaf-499b-4852-8c88-33374767b110">

- prometheus.yml
  
<img width="800" alt="Screenshot 2023-10-21 at 03 32 46" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/16bfe4a1-6836-47dc-aaf3-9fce8c808c5a">

- repo.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 53 32" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/d074ea64-15e0-4fff-8107-e2cd88b0c6b9">

- ssh.yml

<img width="800" alt="Screenshot 2023-10-21 at 03 40 08" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/4d9d7b5f-12c9-4e5a-878f-d0daad894920">
