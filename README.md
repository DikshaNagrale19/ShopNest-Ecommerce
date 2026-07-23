# 🛍️ ShopNest — PHP E-Commerce Platform

> A full-featured, modern e-commerce web application built with PHP 8.2, MySQL 8, and Bootstrap 5.3.
> Includes a complete customer-facing storefront, a powerful admin panel, Docker support, and a
> GitHub Actions CI/CD pipeline using Composer and PHP-native tools.

[![CI/CD Pipeline](https://github.com/Vaibhavmungal/ShopNest-Ecommerce/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/Vaibhavmungal/ShopNest-Ecommerce/actions/workflows/ci-cd.yml)
[![PHP](https://img.shields.io/badge/PHP-8.2-777BB4?logo=php&logoColor=white)](https://www.php.net/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Composer](https://img.shields.io/badge/Composer-2.x-885630?logo=composer&logoColor=white)](https://getcomposer.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e.svg)](LICENSE)

---

## 📋 Table of Contents

- [Prerequisites & Service Installation (Linux)](#-prerequisites--service-installation-linux)
  - [Git](#1--git)
  - [PHP 8.2](#2--php-82--required-extensions)
  - [MySQL 8.0](#3--mysql-80)
  - [Apache 2.4](#4--apache-24)
  - [Composer 2.x](#5--composer-2x)
  - [Docker & Docker Compose](#6--docker--docker-compose)
  - [Jenkins](#7--jenkins-self-hosted-cicd)
- [Features](#-features)
- [Tech Stack & Versions](#️-tech-stack--versions)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Option A — Local (XAMPP)](#option-a--local-xampp)
  - [Option B — Docker Compose](#option-b--docker-compose)
- [Environment Variables](#-environment-variables)
- [CI/CD Pipeline](#-cicd-pipeline)
  - [How the Pipeline Works](#how-the-pipeline-works)
  - [Setting Up the Workflow](#setting-up-the-workflow)
  - [Running Checks Locally](#running-checks-locally)
- [Admin Access](#-admin-access)
- [Key Pages](#-key-pages)
- [Contributing](#-contributing)
- [License](#-license)
- [Author](#-author)

---

## 📥 Prerequisites & Service Installation (Linux)

> All CI/CD platforms — **GitHub Actions**, **Jenkins**, **GitLab CI**, **CircleCI**, **Docker**
> — run on **Linux (Ubuntu/Debian)**. Use these commands to set up your CI/CD server or agent.

---

### 1. 🔧 Git

```bash
sudo apt update
sudo apt install -y git

# Verify
git --version
# git version 2.x.x
```

---

### 2. 🐘 PHP 8.2 + Required Extensions

```bash
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

sudo apt install -y \
  php8.2 \
  php8.2-cli \
  php8.2-mysql \
  php8.2-gd \
  php8.2-zip \
  php8.2-mbstring \
  php8.2-xml \
  php8.2-curl \
  php8.2-opcache \
  php8.2-mysqli

# Verify
php --version
# PHP 8.2.x
```

---

### 3. 🐬 MySQL 8.0

```bash
sudo apt update
sudo apt install -y mysql-server

sudo systemctl start mysql
sudo systemctl enable mysql

# Secure the installation (set root password, remove test DBs)
sudo mysql_secure_installation

# Import the project schema
mysql -u root -p < database/ecommerce.sql

# Verify
mysql --version
# mysql  Ver 8.0.x
```

---

### 4. 🌐 Apache 2.4

```bash
sudo apt update
sudo apt install -y apache2

# Enable URL rewriting (needed for .htaccess)
sudo a2enmod rewrite
sudo systemctl restart apache2
sudo systemctl enable apache2

# Set correct permissions for web root
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Verify
apache2 -v
# Server version: Apache/2.4.x
```

---

### 5. 📦 Composer 2.x

```bash
# Download and install Composer globally
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Install project PHP dependencies
composer install

# Verify
composer --version
# Composer version 2.x.x
```

---

### 6. 🐳 Docker & Docker Compose

> Required to run the containerised stack (`app` + `db` + `phpmyadmin`).

```bash
# Install dependencies
sudo apt update
sudo apt install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine + Compose plugin
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# Allow running Docker without sudo
sudo usermod -aG docker $USER
newgrp docker

# Start and enable Docker on boot
sudo systemctl start docker
sudo systemctl enable docker

# Verify
docker --version          # Docker version 24.x.x
docker compose version    # Docker Compose version v2.x.x
```

---

### 7. 🏗️ Jenkins (Self-hosted CI/CD)

> Install Jenkins on your Linux server to run pipelines locally or on-premise.

```bash
# Install Java (Jenkins requires JDK 17+)
sudo apt update
sudo apt install -y openjdk-17-jdk

java -version
# openjdk version "17.x.x"

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install -y jenkins

# Start and enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get the initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Access Jenkins at:  http://<your-server-ip>:8080
```

---

### 8. ✅ Verify All Services

Run this on your CI/CD server to confirm everything is installed:

```bash
git --version            # git version 2.x.x
php --version            # PHP 8.2.x
mysql --version          # mysql  Ver 8.0.x
apache2 -v               # Server version: Apache/2.4.x
composer --version       # Composer version 2.x.x
docker --version         # Docker version 24.x.x
docker compose version   # Docker Compose version v2.x.x
java -version            # openjdk version "17.x.x"  (for Jenkins)
```

---

## ✨ Features

### 🛒 Customer Side
- **Homepage** — Hero section, featured products, categories, new arrivals, promo banner & testimonials
- **Product Listing** — Filter by category, price range, featured & sale; sort by newest / price / rating / A–Z
- **Product Detail** — Image gallery, star ratings, reviews, stock status, quantity stepper
- **Shopping Cart** — Add/remove items, quantity update, tax & shipping calculation
- **Wishlist** — Save products for later
- **Checkout** — Address form, payment method selection
- **User Auth** — Register, Login, Profile management
- **Search** — Live autocomplete search with suggestions

### 🔧 Admin Panel
- **Dashboard** — Revenue, orders, customers & product stats with animated counters
- **Products** — Add, edit, delete products with image upload
- **Categories** — Manage product categories with slugs and sort order
- **Orders** — View and update order statuses
- **Customers** — Customer list with order history
- **Inventory** — Stock management and low-stock alerts
- **Reports** — Sales reports and analytics

---

## 🛠️ Tech Stack & Versions

| Layer | Technology | Version |
|-------|-----------|---------|
| **Backend** | PHP (procedural + PDO) | **8.2** |
| **Database** | MySQL | **8.0** |
| **Web Server** | Apache (mod_rewrite) | **2.4** |
| **Frontend** | HTML5 + Vanilla JS | — |
| **CSS Framework** | Bootstrap | **5.3** |
| **Icons** | Bootstrap Icons | **1.x** |
| **Fonts** | Google Fonts (Outfit, Inter) | — |
| **Dependency Manager** | Composer | **2.x** |
| **Containerization** | Docker + Docker Compose | **v2+** |
| **CI/CD Platform** | GitHub Actions | — |

### PHP Dev Tool Versions (composer.json)

| Tool | Package | Version |
|------|---------|---------|
| Unit Testing | `phpunit/phpunit` | **^11.0** |
| Code Style | `squizlabs/php_codesniffer` | **^3.9** |
| Static Analysis | `phpstan/phpstan` | **^1.11** |

> **Note:** These tools are `require-dev` only — they are **not** installed in production deployments.

---

## 📁 Project Structure

```
aws-ecommerce/
├── .github/
│   └── workflows/
│       └── ci-cd.yml        # GitHub Actions CI/CD pipeline
├── admin/                   # Admin panel pages
│   ├── categories/
│   ├── customers/
│   ├── inventory/
│   ├── orders/
│   ├── products/
│   ├── reports/
│   ├── includes/
│   ├── index.php            # Admin dashboard
│   └── login.php
├── api/                     # AJAX endpoints (cart, wishlist, search)
├── assets/
│   ├── css/                 # Stylesheets
│   ├── js/                  # main.js — cart, wishlist, search, filters
│   └── images/
├── config/
│   ├── database.php         # PDO connection
│   └── constants.php        # App constants
├── customer/                # Customer pages (cart, checkout, profile)
├── database/                # SQL schema & seeds
├── docker/
│   └── php.ini              # Custom PHP config (limits, timezone, opcache)
├── includes/                # Shared PHP (header, footer, functions)
├── products/                # Product listing & detail pages
├── tools/                   # CLI utilities (setup, hash generator)
├── uploads/                 # Uploaded product images (gitignored)
├── logs/                    # PHP error logs (gitignored)
├── composer.json            # PHP dependency manager config
├── composer.lock            # Locked dependency versions (committed)
├── phpstan.neon             # PHPStan static analysis config
├── Dockerfile               # Docker image definition (PHP 8.2 + Apache)
├── docker-compose.yml       # Multi-container setup (app + db + phpmyadmin)
├── .env                     # Environment config (NOT committed)
├── .env.example             # Environment template
└── index.php                # Homepage
```

---

## 🚀 Getting Started

### Option A — Local (XAMPP)

**Prerequisites:**
- [XAMPP](https://www.apachefriends.org/) with **PHP 8.2+** and **MySQL 8.0+**
- [Composer](https://getcomposer.org/download/) installed globally

**1. Clone the repository**
```bash
git clone https://github.com/Vaibhavmungal/ShopNest-Ecommerce.git
cd ShopNest-Ecommerce
```

**2. Install PHP dependencies**
```bash
composer install
```

**3. Move to the XAMPP web root**
```
Place the folder at: xampp/htdocs/aws-ecommerce
```

**4. Import the database schema**
```bash
mysql -u root -p < database/ecommerce.sql
```

**5. Configure your environment**
```bash
cp .env.example .env
# Edit .env with your database credentials
```

**6. Open in browser**
```
http://localhost/aws-ecommerce
```

---

### Option B — Docker Compose

**Prerequisites:**
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Docker Engine **v24+** / Compose **v2+**)

**1. Clone the repository**
```bash
git clone https://github.com/Vaibhavmungal/ShopNest-Ecommerce.git
cd ShopNest-Ecommerce
```

**2. Configure your environment**
```bash
cp .env.example .env
# Edit .env as needed
```

**3. Start all services**
```bash
docker compose up -d --build
```

This starts **3 containers**:

| Container | Image | URL |
|-----------|-------|-----|
| `shopnest_app` | Custom PHP 8.2 + Apache | `http://localhost:8080` |
| `shopnest_db` | `mysql:8.0` | `localhost:3307` |
| `shopnest_pma` | `phpmyadmin:latest` | `http://localhost:8081` |

**4. View logs**
```bash
docker compose logs -f app
```

**5. Stop all services**
```bash
docker compose down
```

**6. Stop and wipe all data (full reset)**
```bash
docker compose down -v
```

---

## 🔐 Environment Variables

Copy `.env.example` to `.env` and fill in your values:

```env
# --- Database ---
DB_HOST=localhost          # Use "db" when running with Docker Compose
DB_PORT=3306
DB_USER=shopnest
DB_PASS=shopnest_pass
DB_NAME=aws_ecommerce

# --- Application ---
APP_NAME=ShopNest
APP_URL=http://localhost/aws-ecommerce   # http://localhost:8080 for Docker
APP_ENV=development        # development | production
APP_DEBUG=true             # set to false in production
```

> **⚠️ Never commit your `.env` file.** It is already listed in `.gitignore`.

---

## ⚙️ CI/CD Pipeline

This project uses **GitHub Actions** with **PHP-native tools** — no Java or Maven required.
The pipeline runs automatically on every `push` or `pull_request` to `main` / `master`.

### How the Pipeline Works

```
Push / PR ──► GitHub Actions Runner (ubuntu-latest)
                │
                ├── JOB 1: lint-and-quality  (runs on every push & PR)
                │    │
                │    ├── 1. Checkout code
                │    ├── 2. Setup PHP 8.2 + extensions
                │    ├── 3. Validate composer.json
                │    ├── 4. Cache vendor/ folder
                │    ├── 5. composer install (dev dependencies)
                │    ├── 6. php -l           → syntax check all .php files
                │    ├── 7. phpcs            → PSR-12 code style check
                │    └── 8. phpstan          → static analysis (level 5)
                │
                └── JOB 2: package  (runs only on push to main/master)
                     │
                     ├── 1. Checkout code
                     ├── 2. Setup PHP 8.2
                     ├── 3. composer install --no-dev (production only)
                     ├── 4. Create deployment ZIP (excludes .git, uploads, .env…)
                     └── 5. Upload ZIP as GitHub Actions artifact (14-day retention)
```

---

### Setting Up the Workflow

The workflow file is already at `.github/workflows/ci-cd.yml`. Follow these steps:

**Step 1 — Push your code to GitHub**
```bash
git add .
git commit -m "feat: add CI/CD pipeline and Composer config"
git push origin main
```

**Step 2 — Verify the pipeline runs**
1. Open your repository on GitHub.
2. Click the **Actions** tab.
3. You will see **"ShopNest CI/CD Pipeline"** with two jobs.
4. Click any run to see step-by-step logs.

**Step 3 — Download the deployment package**
1. Open a successful workflow run.
2. Scroll to **Artifacts** at the bottom.
3. Download `shopnest-deployment-<sha>` — this is your production-ready `.zip`.

**Step 4 — (Optional) Add secrets for auto-deployment**

Go to **Settings → Secrets and variables → Actions → New repository secret** and add:

| Secret Name | Description |
|-------------|-------------|
| `SSH_HOST` | Your server IP or hostname |
| `SSH_USER` | SSH username |
| `SSH_PRIVATE_KEY` | Your private key for SSH access |
| `AWS_ACCESS_KEY_ID` | AWS key (if using S3 for uploads) |
| `AWS_SECRET_ACCESS_KEY` | AWS secret |

Then extend the `package` job in `ci-cd.yml` with an `scp` or `rsync` step using these secrets.

---

### Running Checks Locally

**Prerequisites:**
- PHP 8.2 in your `PATH`
- [Composer](https://getcomposer.org/download/) installed

**Install all dependencies:**
```bash
composer install
```

**Run individual checks:**
```bash
# 1. PHP Syntax check — finds parse errors in all .php files
composer lint

# 2. PSR-12 Code style check
composer phpcs

# 3. Static analysis (catches bugs without running code)
composer phpstan

# 4. Run all checks at once
composer check
```

**What each tool does:**

| Tool | Command | What it catches |
|------|---------|----------------|
| `php -l` | `composer lint` | PHP parse/syntax errors |
| PHP_CodeSniffer | `composer phpcs` | Code style violations (PSR-12) |
| PHPStan | `composer phpstan` | Type errors, undefined variables, dead code |

---

## 🔐 Admin Access

Default admin credentials (change after first login):

```
URL:      http://localhost/aws-ecommerce/admin/login.php
          http://localhost:8080/admin/login.php  (Docker)
Email:    admin@shopnest.com
Password: (set in DB during setup)
```

---

## 📦 Key Pages

| Route | Description |
|-------|-------------|
| `/` | Homepage |
| `/products/index.php` | Product listing with filters |
| `/products/detail.php?slug=...` | Product detail |
| `/customer/cart.php` | Shopping cart |
| `/customer/checkout.php` | Checkout |
| `/customer/wishlist.php` | Wishlist |
| `/admin/` | Admin dashboard |
| `/admin/products/` | Product management |
| `/admin/orders/` | Order management |
| `/admin/login.php` | Admin login |

---

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

> The CI/CD pipeline will automatically run syntax checks, code style checks, and static analysis on your PR.

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 👤 Author

**Vaibhav Mungal**

- GitHub: [@Vaibhavmungal](https://github.com/Vaibhavmungal)

---

<div align="center">
  Made with ❤️ using PHP &amp; Bootstrap
</div>
