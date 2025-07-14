# 🛠️ Daily Linux Maintenance Report - Automation Script

Welcome to my first step toward becoming a DevSecOps engineer! This repository contains a fully automated Bash script that performs essential daily maintenance tasks on a Linux system, schedules them via `cron`, and sends the report straight to your email inbox every morning.

---

## 📌 Features

✅ System update and upgrade  
✅ Disk usage check with threshold alert  
✅ Log cleanup (`/var/log/*.log`)  
✅ `/etc` directory backup with automatic 7-day cleanup  
✅ Systemd refresh (`daemon-reexec`)  
✅ Sends detailed daily report via email using `msmtp`  
✅ Runs automatically every day at **9:00 AM** via `cron`

---

## 🚀 How It Works

1. The script runs every morning using a crontab entry.
2. It collects system status info and performs cleanup & backups.
3. A detailed maintenance report is generated and emailed to the configured address.
4. Old backups are automatically deleted after 7 days.

---

## ⚙️ Setup Instructions

### 1. Clone this repo
git clone https://github.com/roay-abdullah/daily-linux-maintenance.git
cd daily-linux-maintenance

### 2. Make the script executable
chmod +x daily_maintenance.sh

### 3. Configure email using msmtp
sudo apt install msmtp msmtp-mta
nano ~/.msmtprc

## Sample Gmail config:

defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

account gmail
host smtp.gmail.com
port 587
from your_email@gmail.com
user your_email@gmail.com
password your_app_password

account default : gmail

🔐 Use app password, not your main Gmail password.

# Then test:
echo "Test email body" | msmtp your_email@gmail.com


### 4. Schedule the script with cron
crontab -e
0 9 * * * /full/path/to/daily_maintenance.sh


📬 Contact
📧 Email: royabdullah908@gmail.com
💼 LinkedIn: Roay Muhammad Abdullah


📄 License
This project is licensed under the MIT License.



