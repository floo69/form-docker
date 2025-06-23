# Project CI/CD Deployment with Jenkins

This document provides a step-by-step guide to setting up a CI/CD pipeline on Jenkins for a full-stack application (Flask backend and Express frontend) deployed on a single EC2 instance, using PM2 to manage live processes.

## EC2 Instance Setup

1. Launch an **Ubuntu** EC2 instance.
2. Open inbound ports:

   * **22 (SSH)**
   * **8080 (Jenkins)**
   * **3000 (Express)**
   * **5000 (Flask)**
3. SSH into the instance:

   ```bash
   ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>
   ```

---

## Jenkins Installation & Configuration

1. Install Java & Jenkins:

   ```bash
   sudo apt update
   sudo apt install openjdk-11-jdk -y
   wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
   sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
   sudo apt update
   sudo apt install jenkins -y
   sudo systemctl start jenkins
   sudo systemctl enable jenkins
   ```
2. Access Jenkins: `http://<EC2_PUBLIC_IP>:8080`
3. Unlock using admin password from `/var/lib/jenkins/secrets/initialAdminPassword`.
4. Install recommended plugins: Git, Pipeline, Credentials, PM2 plugin (if available), NodeJS plugin, Python plugin.

---

## Tool Installations on EC2

Install necessary runtimes & tools:

```bash
# Node.js & npm
echo 'deb https://deb.nodesource.com/node_18.x $(lsb_release -sc) main' | sudo tee /etc/apt/sources.list.d/nodesource.list
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
sudo apt update
sudo apt install nodejs -y
sudo npm install -g pm2

# Python & pip
sudo apt install python3 python3-pip python3-venv -y

# Git
sudo apt install git -y
```

Ensure Jenkins user has Docker if needed, and PM2 in PATH.

---

## Securing Credentials

1. In Jenkins Dashboard → **Manage Jenkins** → **Credentials** → **Global** → **Add Credentials**.
2. **Kind:** Secret text
3. **ID:** `MONGODB_URI`
4. **Secret:** `<your MongoDB Atlas connection string>`
5. Bind this credential in the **flask-pipeline** job under **Build Environment** → **Use secret text(s)** → Variable `MONGODB_URI`, Credentials `MONGODB_URI`.

---

## Backend (Flask) Pipeline

**Jenkinsfile** (located at `backend/Jenkinsfile`):

```groovy
pipeline {
  agent any
  environment {
    MONGODB_URI = credentials('MONGODB_URI')
  }
  stages {
    stage('Install Python Deps') {
      steps {
        dir('backend') {
          sh '''
            python3 -m venv venv
            . venv/bin/activate
            pip install -r requirements.txt
          '''
        }
      }
    }
    stage('Create .env File') {
      steps {
        dir('backend') {
          writeFile file: '.env', text: """
MONGODB_URI=${MONGODB_URI}
"""
        }
      }
    }
    stage('Run Flask') {
      steps {
        sh '''
          cd backend
          pm2 restart flask-app || pm2 start venv/bin/python app.py --name flask-app
        '''
      }
    }
  }
}
```

**Flask `app.py`** must use:

```python
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

---

## Frontend (Express) Pipeline

**Jenkinsfile** (located at `frontend/Jenkinsfile`):

```groovy
pipeline {
  agent any

  stages {
    stage('Clone') {
      steps {
        git branch: 'main', url: 'https://github.com/floo69/form-docker.git'
      }
    }
    stage('Install Dependencies') {
      steps {
        dir('frontend') {
          sh 'npm install'
        }
      }
    }
    stage('Run Express App') {
      steps {
        dir('frontend') {
          sh 'pm2 restart express-app || pm2 start app.js --name express-app'
        }
      }
    }
  }
}
```

**Express `app.js`** must include:

```js
const path = require('path');
app.set('views', path.join(__dirname, 'views'));
app.listen(3000, '0.0.0.0', () => console.log('Running'));
```

---

## GitHub Webhook Configuration

1. On GitHub repo → **Settings** → **Webhooks** → **Add webhook**.
2. **Payload URL:** `http://<EC2_IP>:8080/github-webhook/`
3. **Content type:** `application/json`
4. **Event:** Just the push event.
5. In each job → **Build Triggers** → enable **GitHub hook trigger for GITScm polling**.

---

## Security Group Settings

Inbound Rules Required:

* SSH (22) → `0.0.0.0/0`
* HTTP (8080) → `0.0.0.0/0` (for Jenkins UI)
* Custom TCP (3000) → `0.0.0.0/0` (Express)
* Custom TCP (5000) → `0.0.0.0/0` (Flask)

---

## Verification

1. SSH into EC2:

   ```bash
   sudo su - jenkins -s /bin/bash
   pm2 list
   ```
2. Browse:

   * Express → `http://<EC2_IP>:3000`
   * Flask   → `http://<EC2_IP>:5000`

