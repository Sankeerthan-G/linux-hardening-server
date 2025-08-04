#!/bin/bash

echo "🔐 Installing Fail2Ban..."
sudo apt update && sudo apt install -y fail2ban

echo "🛠 Creating jail.local config..."
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 600
findtime = 600
maxretry = 3
backend = systemd
destemail = root@localhost
sender = fail2ban@yourserver.com
action = %(action_mwl)s

[sshd]
enabled = true
EOF

echo "🔁 Restarting Fail2Ban..."
sudo systemctl restart fail2ban

echo "✅ Fail2Ban status:"
sudo fail2ban-client status

