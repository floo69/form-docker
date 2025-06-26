#!/bin/bash
sleep 10

apt update -y
apt install -y python3 python3-pip python3-venv

cd /home/ubuntu/app/backend

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate

cat << 'EOF' > /etc/systemd/system/flask-app.service
[Unit]
Description=Flask Backend
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/app/backend
ExecStart=/home/ubuntu/app/backend/venv/bin/python3 app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable flask-app
systemctl start flask-app
