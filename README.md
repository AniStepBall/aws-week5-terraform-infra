# AWS Week 5 - Infrasturture as Code with Terraform

## Objective
The aim of this week is to provide a complete AWS networking and computing using Terraform to remove the use of manual clicking for reproducible infrastructure

---

## Architecture

![Architecture Diagram](./diagram/week5-architecture.png)

---

## Resource Provisioned

| Resoure | Name | Description |
|---|---|---|
| VPC | week5-vpc | Isolated network, 10.0.0.0/16 |
| Internet Gateway | femi-week5-igw | Public internet access |
| Public Subnet A | week5-public-a | ca-central-1a, auto-assigns public IP |
| Public Subnet B | week5-public-b | ca-central-1b |
| Private Subnet A | week5-private-a | ca-central-1a, no direct internet |
| Private Subnet B | week5-private-b | ca-central-1b, no direct internet |
| Route Table | week5-public-rt | Routes 0.0.0.0/0 to IGW |
| Security Group | week5-web-sg | HTTP open, SSH restricted to owner IP |
| EC2 Instance | week5-web | Amazon Linux 2023, t3.micro, nginx |

---

## Why Terraform Instead of the Console

- Is repeatable every time compared to AWS Console manual which can lead to error
- Has version controlled with Git compared to AWS no history of change
- The written code is the documentation vs the Console diffculty with sharing with a group/team
- Has `terraform destroy` which removes everything. Removing in the AWS console is very tedious an can lead to errors

---

## How to Run

### Prerequisites
- Terraform installed (`terraform -version`)
- AWS CLI configured (`aws sts get-caller-identity`)

### Deploy
```bash
# 1. Clone the repo
git clone https://github.com/AniStepBall/aws-week5-terraform-infra.git
cd aws-week5-terraform-infra

# 2. Create your tfvars (never committed — see .gitignore)
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 3. Initialise
terraform init

# 4. Preview changes
terraform plan

# 5. Deploy
terraform apply
```

After apply completes, the EC2 public IP is printed automatically:

Outputs:
> `instance_public_ip = "xx.xx.xx.xx"`

Open that IP in your browser to confirm the nginx page loads.

### Destroy
```bash
terraform destroy
```
All resources are removed in the correct dependency order automatically.

---

## Inputs

| Variable | Description | Default |
|---|---|---|
| `aws_region` | AWS region to deploy into | `ca-central-1` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `allowed_ssh_cidr` | Your IP for SSH access (no default — entered at runtime) | — |

---

## Outputs

| Output | Description |
|---|---|
| `instance_public_ip` | Public IP of the EC2 instance |

---

## Cost Notes
Private subnet egress via NAT Gateway omitted in this version to control cost.
In production, a NAT Gateway in each public subnet would be added with a corresponding private route table pointing 0.0.0.0/0 to it.

---

## Screenshots

### terraform apply output
![apply](./screenshots/terraform-apply.png)

### AWS Console — VPC created by Terraform
![vpc](./screenshots/aws-console-vpc.png)

### Browser — nginx page served from Terraform output IP
![browser](./screenshots/nginx-browser.png)

### terraform destroy output
![destroy](./screenshots/terraform-destroy.png)
> Enter the `screenshots` directory to see the full destroy sequence
---

## Repository Structure
```
aws-week5-terraform-infra/
├── providers.tf
├── variables.tf
├── terraform.tfvars.example  # Safe placeholder for collaborators
├── network.tf
├── security.tf
├── compute.tf
├── outputs.tf
├── .gitignore
├── diagrams/
├── screenshots/
└── README.md
```
