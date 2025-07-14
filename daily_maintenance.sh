#!/bin/bash


# Save output to a temp file
REPORT_FILE="/tmp/maintenance_report_$(date '+%Y-%m-%d').txt"


# Ensure root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi



{
  echo "<----------Daily Linux Maintenance Report---------->"
  echo ""
  echo "Date: $(date '+%Y-%m-%d')"
  echo ""


  # Update and upgrade the system
  echo "Updating System..."
  if DEBIAN_FRONTEND=noninteractive sudo apt-get update -y && sudo apt-get upgrade -y; then
    echo "System updated successfully."
  else
    echo "System update failed!" 
  fi
  echo ""


  # Check disk usage
  echo "Checking Disk Usage..."
  USAGE=$(df --output=pcent / | tail -1 | tr -dc '0-9')
  echo "Disk Usage: $USAGE%"

  if [ "$USAGE" -gt 70 ]; then
    echo "Disk space above 70%! Free up space."
  fi
  echo ""


  # Clean up old logs
  echo "Cleaning up logs..."
  sudo find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;
  echo "Logs cleaned."
  echo ""


  # Reload daemon
  echo "Refreshing systemd..."
  systemctl daemon-reexec
  echo "Done."
  echo ""


  # Backup /etc directory
  echo "Backing up /etc..."
  mkdir -p /backups
  tar -czf /backups/etc_backup_$(date '+%Y-%m-%d').tar.gz -C / etc
  echo "Backups saved to /backups/"
  echo ""


  #Cleaning old backups
  echo "Cleaning old backups (older than 7 days)..."
  find /backups -type f -name "etc_backup_*.tar.gz" -mtime +7 -delete
  echo "Old backups removed."
  echo ""


  echo "<------------------Maintenance Complete------------------>"

} | tee "$REPORT_FILE"


# To check if Report file is created or not
if [ ! -s "$REPORT_FILE" ]; then
  echo "Error: Report file is empty or not created: $REPORT_FILE"
  exit 1
fi



# Send the report via  email
echo "Subject: Daily Linux Maintenance Report - $(date '+%Y-%m-%d')" | cat - "$REPORT_FILE" | msmtp royabdullah908@gmail.com 


chmod +x daily_maintenance.sh


# Add crontab if not present
if ! (crontab -l 2>/dev/null | grep -Fq "/home/roy07/daily_maintenance.sh"); then
  (crontab -l; echo "0 9 * * * /home/roy07/daily_maintenance.sh") | crontab -e
  echo "Crontab entry added."
else
  echo "Crontab entry already exists."
fi
echo ""

  echo "Maintenance script completed and report sent to email."
