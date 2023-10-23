# 4. Deployment

## 4.1 Application

### 1. Set Up PostgreSQL

Disini saya menggunakan [Railway](https://railway.app/) untuk mendeploy DB-nya agar terpisah dari Appserver. Disini, saya sudah membuat sebuah akun dan mendapat Trial sebesar %5 yang bebas digunakan sampai saldo yang diberikan habis. Berikut spesifikasi singkat dari PaaS Railway:

> CPU: 2 vCPU
> RAM: 512 MB
> Storage: 1 GB

Yang dimana menurut saya spek tersebut sudah cukup hanya untuk mendeploy PostgreSQL. Lanjut ke tahap Set Up

<img width="800" alt="Screenshot 2023-10-22 at 17 46 01" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/84ab68a8-71f1-4555-aec0-53f7623777a5">

Pertama, Setelah login ke dalam `Railway` langkah yang perlu dilakukan adalah menambahkan project.  Dilihat dari gambar diatas terdapat tombol `New Project` pada sisi bagian kanan lalu kita klik tombol tersebut

<img width="800" alt="Screenshot 2023-10-22 at 17 45 42" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5315c69f-5a21-4dbf-a829-a1c191ff304d">

Karena disini saya hanya ingin mendeploy PostgreSQL-nya saja maka saya memilih `Provision PostgreSQL`

<img width="800" alt="Screenshot 2023-10-22 at 17 44 00" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/04b4d0a8-7b83-49e6-ae87-b2a9f08f8737">

Jika project-nya sudah berhasil dibuat bisa dilihat dari gambar diatas bahwa project yang saya namakan `dw18-capstone-calvinnr` memiliki 1 service yaitu `PostgreSQL`

<img width="800" alt="Screenshot 2023-10-22 at 17 50 52" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/53de1b40-26cd-4e45-9fc8-05b3eca3949b">

Disini saya sudah membuat 2 environment yaitu `staging` dan `production`. Dimana setiap environment memiliki variable yang berbeda sehingga kita bisa menyesuaikan kebutuhan environment-nya pada saat men-deploy aplikasi baik di branch `staging` maupun `production`. Yang dimana setiap variable sudah saya set-up .env file-nya menyesuaikan branch/environmentnya.

### 2. Membuat Docker Image Frontend dan Backend Dumbmerch

#### 2.1 Frontend Dumbmerch Staging

Berikut `Dockerfile` yang sudah saya buat pada branch `staging` beserta isinya sebagai berikut:

```docker
FROM node:16 AS build-env
COPY . /app
COPY package*.json /app
WORKDIR /app
RUN npm install

FROM node:10.24.1-alpine3.11
COPY --from=build-env /app /app
WORKDIR /app
EXPOSE 3000
CMD ["npm", "start"]
```

<img width="800" alt="Screenshot 2023-10-23 at 00 47 46" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/a6a308e7-8c6a-43a9-816a-d95feed0477b">

Setelah itu saya build image-nya dengan menjalankan perintah:

```docker
docker build -t calvinnr/fe-dumbmerch:6.0 .
```

<img width="800" alt="Screenshot 2023-10-23 at 00 52 48" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/b178db74-bd80-4497-88f6-ec892cd67b12">

Lalu cek hasil image yang sudah di build dengan menjalankan perintah:

```docker
docker images
```

#### 2.2 Backend Dumbmerch Staging

Berikut `Dockerfile` yang sudah saya buat pada branch `staging` beserta isinya sebagai berikut:

```docker
FROM golang:1.21.2-alpine3.18
WORKDIR /app
COPY . /app
RUN go mod download
RUN go build -o /be
ENTRYPOINT ["/be"]
```

<img width="800" alt="Screenshot 2023-10-23 at 00 58 58" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/166a25a6-79ca-439d-a9d1-940ab9b3393c">

Setelah itu saya build image-nya dengan menjalankan perintah:

```docker
docker build -t calvinnr/be-dumbmerch:6.0 .
```

<img width="800" alt="Screenshot 2023-10-23 at 00 59 23" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/3ce5a7d1-24d2-4b9c-afcc-51a171a0a3ac">

Lalu cek hasil image yang sudah di build dengan menjalankan perintah:

```docker
docker images
```

#### 2.3 Deploy Aplikasi Frontend & Backend Dumbmerch Staging

Berikut `docker-compose.yml` yang sudah saya buat untuk membuat dan menjalankan multi kontainer beserta isinya sebagai berikut:

```docker
version: "3.8"
services:
   backend:
    image: calvinnr/be-dumbmerch:6.0
    container_name: be-dumbmerch
    stdin_open: true
    restart: unless-stopped
    ports:
      - 5000:5000
   frontend:
    image: calvinnr/fe-dumbmerch:6.0
    container_name: fe-dumbmerch
    stdin_open: true
    restart: unless-stopped
    ports:
      - 3000:3000
```

<img width="800" alt="Screenshot 2023-10-23 at 01 02 05" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/a71fb6ba-c6da-4848-bd5b-bb0bb2bac8b6">

Lalu jalankan perintah berikut untuk menjalankan file script `docker-compose.yml` yang sudah dibuat:

```docker
docker compose up -d
```

Berikut hasil deploy aplikasi Frontend dan Backend Dumbmerch dan sudah ter-integrasi dengan PostgreSQL

<img width="800" alt="Screenshot 2023-10-23 at 01 04 31" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/ecebd3b0-3fc0-4665-8203-076a4b1558da">

<img width="800" alt="Screenshot 2023-10-23 at 01 04 58" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5560b032-0781-4b01-bdc5-8e006b270b15">

<img width="800" alt="Screenshot 2023-10-23 at 01 05 21" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/fed3ed40-d122-454f-a128-987ab5aac630">

#### 2.4 Frontend Dumbmerch Production

Berikut `Dockerfile` yang sudah saya buat pada branch `production` beserta isinya sebagai berikut:

```docker
FROM node:16 AS build-env
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN npm install -g serve
COPY . /app
RUN npm run build --production

FROM node:16.20.2-alpine3.18
COPY --from=build-env /app /app
WORKDIR /app
EXPOSE 3000
CMD npx serve -s build
```

<img width="1440" alt="Screenshot 2023-10-23 at 01 21 14" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/7330b3e2-1fbc-4631-86c4-03bef816dcd0">

Setelah itu saya build image-nya dengan menjalankan perintah:

```docker
docker build -t calvinnr/fe-dumbmerch:7.0 .
```

<img width="1440" alt="Screenshot 2023-10-23 at 01 21 57" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/706d0d32-2e58-44d7-ae91-1d50bcc74043">

Lalu cek hasil image yang sudah di build dengan menjalankan perintah:

```docker
docker images
```

#### 2.5 Backend Dumbmerch Production

Berikut `Dockerfile` yang sudah saya buat pada branch `production` beserta isinya sebagai berikut:

```docker
FROM golang:1.21.2-alpine3.18
WORKDIR /app
COPY . /app
RUN go mod download
RUN go build -o /be
ENTRYPOINT ["/be"]
```

<img width="800" alt="Screenshot 2023-10-23 at 03 37 27" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/6c48061d-5807-4d31-b756-36f90ba5caac">

Setelah itu saya build image-nya dengan menjalankan perintah:

```docker
docker build -t calvinnr/be-dumbmerch:7.0 .
```

<img width="800" alt="Screenshot 2023-10-23 at 03 38 18" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/bff1cafc-441f-4620-b651-e20ca38b09db">

Lalu cek hasil image yang sudah di build dengan menjalankan perintah:

```docker
docker images
```

#### 2.6 Deploy Aplikasi Frontend & Backend Dumbmerch Production

Berikut `docker-compose.yml` yang sudah saya buat untuk membuat dan menjalankan multi kontainer beserta isinya sebagai berikut:

```docker
version: "3.8"
services:
   backend:
    image: calvinnr/be-dumbmerch:7.0
    container_name: be-dumbmerch
    stdin_open: true
    restart: unless-stopped
    ports:
      - 5000:5000
   frontend:
    image: calvinnr/fe-dumbmerch:7.0
    container_name: fe-dumbmerch
    stdin_open: true
    restart: unless-stopped
    ports:
      - 3000:3000
```

<img width="800" alt="Screenshot 2023-10-23 at 01 02 05" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/a71fb6ba-c6da-4848-bd5b-bb0bb2bac8b6">

Lalu jalankan perintah berikut untuk menjalankan file script `docker-compose.yml` yang sudah dibuat:

```docker
docker compose up -d
```

Berikut hasil deploy aplikasi Frontend dan Backend Dumbmerch dan sudah ter-integrasi dengan PostgreSQL

<img width="800" alt="Screenshot 2023-10-23 at 01 04 31" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/ecebd3b0-3fc0-4665-8203-076a4b1558da">

<img width="800" alt="Screenshot 2023-10-23 at 01 04 58" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/5560b032-0781-4b01-bdc5-8e006b270b15">

<img width="800" alt="Screenshot 2023-10-23 at 01 05 21" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/fed3ed40-d122-454f-a128-987ab5aac630">

## 4.2 CI/CD

### 1. Set Up Pipeline Frontend Dumbmerch Staging

Berikut `.gitlab-ci.yml` yang sudah saya buat pada branch `staging` beserta isinya sebagai berikut:

```gitlab
stages:
  - pull
  - build
  - test

repo:pull:
  stage: pull
  before_script:
    - command -v ssh-agent >/dev/null || ( apk add --update openssh )
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$SSH_HOST "docker compose down && cd $DIRECTORY && git checkout $BRANCH1 && git pull && exit"

docker:image:
  stage: build
  image: docker:1.11
  services:
    - docker:dind
  script:
    - export DOCKER_HOST=tcp://docker:2375/
    - docker build -t $USER_DOCKER/$REPOSITORY:8.0 .
    - docker login -u $USER_DOCKER -p $PASS_DOCKER
    - docker push $USER_DOCKER/$REPOSITORY:8.0

docker:deploy:
  stage: test
  before_script:
    - command -v ssh-agent >/dev/null || ( apk add --update openssh )
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$SSH_HOST "cd $REPOSITORY && git checkout $BRANCH1 && docker compose up -d"
```

<img width="800" alt="Screenshot 2023-10-23 at 11 14 21" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/b44962b9-226f-4dcd-8cb7-f68d5ef132c5">

Pipeline sudah berjalan dengan baik dan semua job sukses pada aplikasi Frontend Dumbmerch Staging

### 2. Set Up Pipeline Backend Dumbmerch Staging

Berikut `.gitlab-ci.yml` yang sudah saya buat pada branch `staging` beserta isinya sebagai berikut:

```gitlab
stages:
  - pull
  - build
  - test

repo:pull:
  stage: pull
  before_script:
    - command -v ssh-agent >/dev/null || ( apk add --update openssh )
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$SSH_HOST "docker compose down && cd $DIRECTORY && git checkout $BRANCH1 && git pull && exit"

docker:image:
  stage: build
  image: docker:1.11
  services:
    - docker:dind
  script:
    - export DOCKER_HOST=tcp://docker:2375/
    - docker build -t $USER_DOCKER/$REPOSITORY:8.0 .
    - docker login -u $USER_DOCKER -p $PASS_DOCKER
    - docker push $USER_DOCKER/$REPOSITORY:8.0

docker:deploy:
  stage: test
  before_script:
    - command -v ssh-agent >/dev/null || ( apk add --update openssh )
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$SSH_HOST "cd $REPOSITORY && git checkout $BRANCH1 && docker compose up -d"
```

### 3. Set Up Pipeline Frontend Dumbmerch Production

Berikut `.gitlab-ci.yml` yang sudah saya buat pada branch `production` beserta isinya sebagai berikut:

```gitlab
stages:
  - pull
  - build
  - test

repo:pull:
  stage: pull
  before_script:
    - command -v ssh-agent >/dev/null || ( apk add --update openssh )
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$SSH_HOST "docker compose down && cd $DIRECTORY && git checkout $BRANCH2 && git pull && exit"

docker:image:
  stage: build
  image: docker:1.11
  services:
    - docker:dind
  script:
    - export DOCKER_HOST=tcp://docker:2375/
    - docker build -t $USER_DOCKER/$REPOSITORY:9.0 .
    - docker login -u $USER_DOCKER -p $PASS_DOCKER
    - docker push $USER_DOCKER/$REPOSITORY:9.0

docker:deploy:
  stage: test
  before_script:
    - command -v ssh-agent >/dev/null || ( apk add --update openssh )
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$SSH_HOST "cd $REPOSITORY && git checkout $BRANCH2 && docker compose up -d"
```

<img width="800" alt="Screenshot 2023-10-23 at 12 02 52" src="https://github.com/calvinnr/devops18-capstoneproject-calvinnr/assets/101310300/41400351-52f4-4caf-acfb-0b9a5793836f">

Pipeline sudah berjalan dengan baik dan semua job sukses pada aplikasi Backend Dumbmerch Staging
