#!/bin/bash

sleep 10

apt update -y
apt install -y python3 python3-pip python3-venv curl nodejs npm

cd /home/ubuntu/app/backend

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

nohup python3 app.py > /home/ubuntu/flask.log 2>&1 &

deactivate

cd /home/ubuntu/app/frontend
npm install

nohup node app.js > /home/ubuntu/express.log 2>&1 &
