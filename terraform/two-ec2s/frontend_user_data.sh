#!/bin/bash
sleep 10

apt update -y
apt install -y curl nodejs npm

cd /home/ubuntu/app/frontend
npm install

cat << 'EOF' > /etc/systemd/system/express-app.service
[Unit]
Description=Express Frontend
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/app/frontend
ExecStart=/usr/bin/node /home/ubuntu/app/frontend/app.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable express-app
systemctl start express-app
