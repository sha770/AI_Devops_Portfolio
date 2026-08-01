# AWS Secure Auto Scaling Web Application

## Project Overview

This project demonstrates a production-style AWS architecture where web traffic is handled through an Application Load Balancer (ALB) deployed in public subnets, while application servers run securely inside private subnets and are managed by an Auto Scaling Group (ASG).

The solution provides:

- High Availability
- Auto Scaling
- Self-Healing
- Secure Access Control
- Session Manager Based Administration
- Load Balancing
- Multi-AZ Deployment

---

# Problem Statement

Modern web applications require high availability, scalability, and security. Although Auto Scaling works with public EC2 instances, exposing application servers directly to the internet increases security risks and management complexity. To address this, this project uses a production-style architecture where only the Application Load Balancer is public, while all application servers run securely in private subnets.

---

# Solution Architecture

```text
                    Internet
                        |
                        |
           Application Load Balancer
            (Public Subnet A & B)
                        |
                        |
                  Target Group
                        |
      -------------------------------------
      |                                   |
      |                                   |
 Private EC2-A                      Private EC2-B
 (AZ-A)                             (AZ-B)
      |                                   |
      -------------------------------------
                    Auto Scaling Group
                           |
                     CloudWatch
                           |
                    Scaling Policy

                 Private Route Table
                           |
                      NAT Gateway
                           |
                    Internet Gateway
                           |
                        Internet
```

---

# AWS Services Used

- Amazon VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Application Load Balancer
- Target Group
- Launch Template
- Auto Scaling Group
- CloudWatch
- IAM Roles
- AWS Systems Manager (SSM)

---

# Architecture Design Decisions

## Why Public ALB?

Users must access the application from the internet.

```text
Internet
    |
 Public ALB
```

Without a public ALB:

```text
Internet
    |
Private ALB
```

Application would not be accessible publicly.

---

## Why Private EC2 Instances?

Instead of:

```text
Internet
     |
 Public EC2
```

We used:

```text
Internet
     |
 Public ALB
     |
 Private EC2
```

Benefits:

- No public IP required
- Users cannot directly reach servers
- Reduced attack surface
- Better production design
- Traffic only comes through ALB

---

## Why NAT Gateway?

Private instances still need outbound internet access.

For example:

```bash
dnf update -y
dnf install nginx -y
```

Without NAT Gateway:

```text
Private EC2
      ❌
No internet
```

User Data would fail.

With NAT Gateway:

```text
Private EC2
      |
NAT Gateway
      |
Internet
```

Outbound internet works while keeping servers private.

---

# Step 1: Create VPC

```text
Name:
Secure-ASG-VPC

CIDR:
10.0.0.0/16
```

Purpose:

Creates a logically isolated AWS network.

---

# Step 2: Create Subnets

## Public Subnet A

```text
10.0.1.0/24
```

## Public Subnet B

```text
10.0.2.0/24
```

## Private Subnet A

```text
10.0.3.0/24
```

## Private Subnet B

```text
10.0.4.0/24
```

Purpose:

Separates public-facing and backend resources.

---

# Step 3: Create Internet Gateway

Attach to VPC.

Purpose:

Provides internet access for public subnets.

---

# Step 4: Create NAT Gateway

Location:

```text
Public Subnet A
```

Attach:

```text
Elastic IP
```

Purpose:

Allows private instances to access the internet without exposing them publicly.

---

# Step 5: Configure Route Tables

## Public Route Table

```text
0.0.0.0/0 → Internet Gateway
```

Associate with:

```text
Public Subnet A
Public Subnet B
```

---

## Private Route Table

```text
0.0.0.0/0 → NAT Gateway
```

Associate with:

```text
Private Subnet A
Private Subnet B
```

---

# Step 6: Create Security Groups

## ALB Security Group

Inbound:

```text
HTTP 80
Source: Anywhere
```

Reason:

Users access website through ALB.

---

## EC2 Security Group

Inbound:

```text
HTTP 80

Source:
ALB Security Group
```

Reason:

Only ALB should communicate with web servers.

Never use:

```text
HTTP 80
Source: 0.0.0.0/0
```

for backend instances.

---

# Step 7: Create Target Group

```text
Name:
secure-asg-tg

Protocol:
HTTP

Port:
80

Health Check:
/
```

Purpose:

Logical group that receives traffic from ALB.

Initially target group can be empty.

ASG registers instances automatically.

---

# Step 8: Create Launch Template

```text
Name:
secure-asg-template
```

Configuration:

```text
AMI:
Amazon Linux 2023

Instance Type:
t3.micro

Security Group:
webserver-sg

IAM Role:
EC2-SSM-Role
```

User Data:

```text
Stored separately in scripts/user-data.sh
```

Purpose:

The Launch Template serves as a reusable blueprint for EC2 instances launched by the Auto Scaling Group.

It contains:

- AMI
- Instance Type
- Security Groups
- IAM Role
- User Data
- Storage Configuration

Whenever Auto Scaling launches a new instance, it automatically uses the latest Launch Template version.

---

# Step 9: Create Application Load Balancer

```text
Name:
secure-asg-alb

Scheme:
Internet Facing
```

Subnets:

```text
Public Subnet A
Public Subnet B
```

Attach:

```text
secure-asg-tg
```

Purpose:

Distributes traffic among healthy instances.

---

# Step 10: Create Auto Scaling Group

```text
Name:
secure-webapp-asg
```

Select:

```text
Launch Template:
secure-asg-template
```

Subnets:

```text
Private Subnet A
Private Subnet B
```

Attach:

```text
secure-asg-tg
```

---

# Auto Scaling Options Explained - Learning file

## Availability Zone Distribution

### Balanced Best Effort ✅ (Selected)

Meaning:

AWS tries to distribute instances across AZs but prioritizes successful launches.

Example:

```text
AZ-A = 2

AZ-B = 1
```

Possible.

Reason chosen:

- Most practical
- Avoids capacity issues
- Better for learning projects

---

### Balanced Only

AWS tries strict balancing.

Example:

```text
AZ-A = 1

AZ-B = 1
```

If one AZ lacks capacity AWS may wait.

---

### Capacity Reservation Options

Selected:

```text
Default
```

Reason:

Standard AWS behavior.

Other options are mostly enterprise-specific.

---

# Capacity Configuration

Selected:

```text
Minimum Capacity = 2

Desired Capacity = 2

Maximum Capacity = 4
```

Explanation:

## Minimum

```text
2
```

ASG never goes below 2.

---

## Desired

```text
2
```

ASG tries maintaining 2 instances.

---

## Maximum

```text
4
```

ASG never launches more than 4.

---

# Step 11: Configure Scaling Policy

Policy:

```text
Target Tracking
```

Metric:

```text
Average CPU Utilization
```

Target Value:

```text
50%
```

Meaning:

```text
CPU > 50%
→ Scale Out

CPU < 50%
→ Scale In
```

---

# CloudWatch Validation

## Check CPU Metrics

```text
EC2
→ Instance
→ Monitoring
```

Observe:

```text
CPU Utilization
```

---

## Check Scaling Alarms

```text
CloudWatch
→ Alarms
```

Look for:

```text
TargetTracking*
```

---

## Check Scaling Activity

```text
Auto Scaling Groups
→ Activity
```

Expected messages:

```text
Launching a new EC2 instance
```

or

```text
Terminating EC2 instance
```

---

# Validation Performed

## Load Balancing Validation

Open:

```text
http://ALB-DNS
```

Refresh multiple times.

Hostname may change.

---

## Target Group Validation

```text
Targets

Healthy
Healthy
```

---

## Self-Healing Validation

Terminate one instance.

Expected:

```text
ASG detects failure

↓

New instance created
```

---

## Scale-Out Validation

Generate load.

Expected:

```text
2
↓
3
```

instances.

---

## Scale-In Validation

Remove load.

Expected:

```text
3
↓
2
```

instances.

---

# SSM Configuration

## Create IAM Role

Attach:

```text
AmazonSSMManagedInstanceCore
```

Role:

```text
EC2-SSM-Role
```

---

## Attach Role In Launch Template

Launch Template:

```text
Advanced Details
→ IAM Instance Profile
→ EC2-SSM-Role
```

---

## Connect

```text
EC2
→ Connect
→ Session Manager
```

Benefits:

- No Bastion Host
- No SSH Keys
- No Public IP
- More Secure

---

# Cleanup Sequence (Important)

Delete resources in this order:

```text
1. Auto Scaling Group

2. Launch Template

3. Load Balancer

4. Target Group

5. NAT Gateway

6. Release Elastic IP

7. Security Groups

8. Route Tables

9. Subnets

10. Internet Gateway

11. VPC
```

⚠️ Most expensive forgotten resource:

```text
NAT Gateway
```

Delete NAT Gateway and release Elastic IP after project completion.

---

# Project Outcome

Successfully built a secure, highly available, scalable, and self-healing web application architecture on AWS using private EC2 instances, a public Application Load Balancer, Auto Scaling Groups, CloudWatch monitoring, NAT Gateway connectivity, and Systems Manager based administration.

This architecture demonstrates how modern production environments separate the traffic layer from the compute layer while maintaining security, scalability, and operational efficiency.