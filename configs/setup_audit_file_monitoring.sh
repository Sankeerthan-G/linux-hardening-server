#!/bin/bash

# === Configuration ===
WATCHED_FILE="/home/sandev/linux-hardening-server/scripts/setup_fail2ban.sh"
AUDIT_RULE="-w $WATCHED_FILE -p war -k file_monitor"
ALERT_SCRIPT="/home/sandev/linux-hardening-server/scripts/check_file_access.sh"
CRON_JOB="* * * * * bash $ALERT_SCRIPT"

echo "🔒 Enabling auditd..."
sudo apt update
sudo apt install -y auditd

echo "✅ Starting auditd service..."
sudo systemctl enable auditd
sudo systemctl start auditd

echo "🛠 Adding audit rule for $WATCHED_FILE..."
sudo auditctl $AUDIT_RULE

echo "📄 Creating alert script at $ALERT_SCRIPT..."
cat <<EOF | sudo tee $ALERT_SCRIPT > /dev/null
#!/bin/bash
# Check /var/log/audit/audit.log for access to $WATCHED_FILE in the last minute

EMAIL="sankeerthan.004@gmail.com"
WATCHED_FILE="$WATCHED_FILE"
LOG_FILE="/var/log/audit/audit.log"
KEYWORD="file_monitor"

# Check if the file was accessed in the last minute
if sudo ausearch -k file_monitor --start recent -i | grep "$WATCHED_FILE"; then
    echo "⚠️ ALERT: $WATCHED_FILE was accessed!" | mail -s "Audit Alert: File Accessed" \$EMAIL
fi
EOF

sudo chmod +x $ALERT_SCRIPT

echo "⏱ Adding cron job to check every minute..."
# Prevent duplicate cron entries
(crontab -l 2>/dev/null | grep -v "$ALERT_SCRIPT"; echo "$CRON_JOB") | crontab -

echo "✅ Audit monitoring setup complete!"

