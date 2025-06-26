# Flask and Express Deployment with Terraform

This project demonstrates three different deployment strategies for a Flask backend and Express frontend application using Terraform and AWS services.


## 🚀 Deployment Options

### Part 1: Single EC2 Instance

- Both Flask (port `5000`) and Express (port `3000`) run on one EC2.
- Uses user data script to install dependencies and start both apps.

```bash
cd terraform/single-ec2/
terraform init
terraform plan
terraform apply

Access:
Frontend: http://<ec2-ip>:3000
Backend: http://<ec2-ip>:5000
   ```
### Part 2: Two EC2 Instances
- Flask and Express run on separate EC2 instances
- Custom VPC and security groups allow inter-service communication

```bash
cd terraform/two-ec2s/
terraform init
terraform plan
terraform apply

Access:
Frontend: http://<frontend-ip>:3000
Backend: http://<backend-ip>:5000
   ```
### Part 2: Docker + ECS (Fargate)
- Flask and Express apps are containerized and pushed to ECR
- Uses ECS Fargate, ALB, and custom VPC.

 ```bash
docker build -t flask-backend ./backend/
docker build -t express-frontend ./frontend/

docker tag flask-backend:latest <account-id>.dkr.ecr.<region>.amazonaws.com/flask-backend:latest
docker tag express-frontend:latest <account-id>.dkr.ecr.<region>.amazonaws.com/express-frontend:latest

docker push <account-id>.dkr.ecr.<region>.amazonaws.com/flask-backend:latest
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/express-frontend:latest

cd terraform/docker-ecs/
terraform init
terraform plan
terraform apply

ALB DNS: http://<alb-dns-name>
   ```
