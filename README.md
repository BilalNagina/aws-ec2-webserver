# 🚀 AWS EC2 Web Server — Terraform + VPC + User Data

A fully automated, production-style EC2 web server stack built entirely with Terraform — without opening the AWS console.

This project deploys a modern cloud compute environment with:

* 🖥 **EC2 instance provisioning** (Amazon Linux 2 / Ubuntu)
* 🌐 **Custom VPC + Subnet + Internet Gateway**
* 🔐 **Security Groups** with HTTP + SSH rules
* ⚡ **User Data automation** (Nginx installation)
* 🧩 **Module-based Terraform structure**
* 🔑 **SSH key pair** for secure access

Perfect for learning AWS compute fundamentals, practicing Terraform, or building backend infrastructure for DevOps projects.

---

## 📂 LAYER 1 — Terraform Project Structure

A clean module-based layout that mirrors real-world Terraform architecture.

```text
aws-ec2-webserver/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
├── modules/
│   ├── ec2/            # EC2 + Security Group + Key Pair + User Data
│   └── network/        # VPC + Subnet + IGW + Route Tables
│
└── userdata/
    └── install.sh      # Web server bootstrap script
```

### Why this layout?
* **`modules/`** keeps compute and networking independent and reusable.
* **`userdata/`** stores scripts executed on first boot.
* **Root folder** simply wires modules together, keeping the project clean, readable, and scalable.

---

## 🌩 LAYER 2 — AWS Architecture Overview

This project builds a secure EC2 web server running inside your own VPC. User Data automatically installs a web server, and security groups control access.

### ✔ 1. Custom VPC
A dedicated virtual network that includes:
* VPC CIDR block
* Public subnet
* Route table
* Internet gateway
* Public IP assignment on launch

### ✔ 2. EC2 Instance
A fully configured compute instance with:
* Amazon Linux 2 (or Ubuntu)
* User Data boot script
* Automatic Nginx installation
* Public IP for testing

### ✔ 3. Security Group
Tightly controlled inbound access:
* **HTTP (80)** → open to world
* **SSH (22)** → customizable CIDR (your IP recommended)

**Outbound:**
* Allow all (default, required for updates)

### ✔ 4. User Data Automation
The boot script installs and starts Nginx automatically and places a sample landing page inside the web root.

### ✔ 5. Key Pair
Used for:
* Secure SSH login
* No passwords
* *Optional:* Created automatically through Terraform

---

## ⚙ LAYER 3 — Deployment Workflow

Follow this exact flow to deploy, test, and destroy the EC2 environment.

### 📦 1. Install AWS CLI, Terraform, Git
*(Windows PowerShell with Chocolatey)*

```powershell
choco install terraform -y
choco install awscli -y
choco install git -y
```

**Verify:**
```bash
terraform -version
aws --version
git --version
```

### 🔑 2. Configure AWS Credentials

```bash
aws configure
```
* **Access Key:** [Your Key]
* **Secret Key:** [Your Secret]
* **Region:** `ap-south-1`
* **Output:** `json`

**Confirm identity:**
```bash
aws sts get-caller-identity
```

### 📁 3. Open the Project

```bash
cd C:\Users\Bilal\aws-ec2-webserver
# (Or wherever you saved it.)
```

### 🧩 4. Create `terraform.tfvars`

```hcl
region               = "ap-south-1"
availability_zone    = "ap-south-1a"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
instance_type        = "t3.micro"
key_name             = "ec2-key"
ssh_cidr             = "YOUR_IP/32"   # recommended
```

### 🔧 5. Initialize Terraform

```bash
terraform init
```

### 🧪 6. Validate the Configuration

```bash
terraform fmt -recursive
terraform validate
```

### 📘 7. Create a Plan

```bash
terraform plan -out=tfplan -input=false
```
*Review resources: VPC, Subnet, IGW, Route table, EC2, Security group, Key pair.*

### 🚀 8. Apply the Infrastructure

```bash
terraform apply "tfplan"
```
*Terraform will output the public IP.*

### 🌐 9. Access the Web Server

**Browser:**
`http://<public-ip>`

**SSH into instance:**
```bash
ssh -i id_rsa ec2-user@<public-ip>
```
*You should see the Nginx web page served from the instance.*

### 🧹 10. Destroy Infrastructure
When you're done:

```bash
terraform destroy
```

---

## 💰 Cost Notes
This setup stays within AWS Free Tier:
* **EC2 t2.micro/t3.micro:** Free 750 hours/month
* **1 subnet, 1 VPC:** Free
* **Elastic IP:** Free while instance is running
* *Tip: Avoid leaving unused EC2 instances running.*

## 🛡 Security
* Security Group restricts SSH
* No passwords stored
* No secrets committed to repo
* Key pairs handled safely
* VPC isolates the compute plane

## 📘 Tech Stack
* Terraform
* AWS EC2
* AWS VPC / Subnets
* User Data (bash)
* AWS CLI

## 🤝 Contributing
Feel free to open issues or create pull requests to improve the documentation or structure.
