# Learning Notes - AWS Secure Auto Scaling Web Application

## What I Learned From This Project

This project helped me understand how production-style AWS applications are designed for security, availability, scalability, and operational efficiency.

---

# Public vs Private Architecture

## Beginner Architecture

```text
Internet
    |
 Public EC2
```

Advantages:

- Easy setup
- Quick testing
- No NAT Gateway required

Disadvantages:

- Public exposure
- Larger attack surface
- Direct SSH access required
- Not ideal for enterprise workloads

---

## Production Architecture

```text
Internet
     |
 Public ALB
     |
 Private EC2
```

Advantages:

- No public IP on application servers
- Reduced attack surface
- Better security posture
- Enterprise-friendly design
- Easier centralized traffic control

---

# Why ALB Is Public

The Application Load Balancer receives internet traffic.

```text
Internet
     |
 Public ALB
```

Users need internet access to the application.

Therefore the ALB must be internet-facing.

---

# Why EC2 Is Private

Application servers should not be directly accessible from the internet.

Traffic path:

```text
Internet
     |
 ALB
     |
 EC2
```

This ensures all traffic is routed through the load balancer.

---

# Why NAT Gateway Is Required

Private EC2 instances still need outbound internet access.

Examples:

```bash
dnf update -y
dnf install nginx -y
```

Without NAT Gateway:

```text
Private EC2
      ❌
 No Internet Access
```

With NAT Gateway:

```text
Private EC2
      |
 NAT Gateway
      |
  Internet
```

The EC2 instance can download packages while remaining private.

---

# Launch Template

## What Is A Launch Template?

A Launch Template is a blueprint used by Auto Scaling Groups to create EC2 instances.

Instead of manually creating servers every time, AWS can automatically launch preconfigured instances.

A Launch Template contains:

- AMI
- Instance Type
- Security Groups
- IAM Role
- Storage Configuration
- User Data

---

# Launch Template Creation

```text
EC2
→ Launch Templates
→ Create Launch Template
```

Configuration Used:

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

User data stored separately in:

```text
scripts/user-data.sh
```

---

# Target Group

## Why Was Target Group Created Before EC2?

A Target Group can initially exist without registered instances.

Example:

```text
Target Group
    |
No Targets Yet
```

When Auto Scaling launches EC2 instances, AWS automatically registers them.

---

# Availability Zone Distribution

## Balanced Best Effort (Selected)

This option attempts to distribute instances across multiple Availability Zones while prioritizing successful launches.

Example:

```text
AZ-A = 2

AZ-B = 1
```

Possible and valid.

Reason selected:

- Better capacity handling
- Avoids launch failures
- Recommended for most environments

---

## Balanced Only

AWS tries to keep equal distribution.

Example:

```text
AZ-A = 1

AZ-B = 1
```

If one AZ has low capacity, launching may become more restrictive.

---

# Capacity Reservation Options

## Default (Selected)

AWS uses normal On-Demand capacity behavior.

Best option for learning projects.

---

# ASG Capacity Settings

## Minimum Capacity

```text
Minimum = 2
```

ASG never goes below two instances.

---

## Desired Capacity

```text
Desired = 2
```

ASG continuously attempts to maintain two instances.

---

## Maximum Capacity

```text
Maximum = 4
```

ASG never launches more than four instances.

---

# Auto Scaling Policy

## Target Tracking Policy

Metric Used:

```text
Average CPU Utilization
```

Target:

```text
50%
```

Behavior:

```text
CPU > 50%
```

Scale Out:

```text
2 → 3 → 4
```

---

```text
CPU < 50%
```

Scale In:

```text
4 → 3 → 2
```

---

# Self-Healing

## What Is Self-Healing?

When an instance fails or is terminated:

```text
Instance Terminated
      |
      v
ASG Detects Failure
      |
      v
Launches New Instance
```

Application availability is maintained automatically.

---

# Session Manager (SSM)

## Why SSM Instead Of SSH?

Traditional SSH:

```text
Open Port 22
Manage Keys
Public Access Considerations
```

Session Manager:

```text
No Public IP
No SSH Keys
No Bastion Host
Browser-Based Access
```

More secure and operationally simpler.

---

# SSM Configuration

## Step 1

Create IAM Role

```text
IAM
→ Create Role
→ EC2
```

Attach:

```text
AmazonSSMManagedInstanceCore
```

---

## Step 2

Attach IAM Role to Launch Template

```text
Launch Template
→ IAM Instance Profile
→ EC2-SSM-Role
```

---

## Step 3

Update ASG To Latest Launch Template Version

```text
ASG
→ Edit
→ Latest Version
```

---

## Step 4

Launch New Instance

Auto Scaling uses the updated template automatically.

---

## Step 5

Connect

```text
EC2
→ Connect
→ Session Manager
```

---

# CloudWatch Validation

## CPU Monitoring

```text
EC2
→ Monitoring
```

Observe:

```text
CPU Utilization
```

---

## Scaling Validation

```text
ASG
→ Activity
```

Look for:

```text
Launching new EC2 instance
```

and

```text
Terminating EC2 instance
```

events.

---

# Troubleshooting I Learned

## Issue

Hostname changes not appearing.

### Cause

Existing instances were launched from an older Launch Template version.

### Fix

Create new Launch Template version and update ASG.

---

## Issue

Target Group showing Unhealthy.

### Possible Causes

- Nginx not installed
- User Data failed
- Security Group issue
- NAT Gateway routing issue
- Health Check path mismatch

---

## Issue

Instance launched in same Availability Zone.

### Explanation

Balanced Best Effort does not enforce strict AZ equality.

AWS may launch instances in the AZ where sufficient capacity is available.

---

# Questions--

### Why Use Private EC2 Instances?

To reduce attack surface and prevent direct internet access.

---

### Why Use NAT Gateway?

To allow private instances outbound internet access without exposing them publicly.

---

### Why Use Launch Templates?

To standardize and automate instance creation.

---

### Why Use Auto Scaling Groups?

To provide both elasticity and self-healing.

---

### Why Use Session Manager Instead Of SSH?

To manage instances securely without exposing SSH access or maintaining key pairs.

---

# Why Was Bash Used In User Data?

## Question

Why was Bash used for EC2 User Data instead of Python or JavaScript?

## Answer

EC2 User Data is commonly used to perform operating system level initialization tasks when an instance launches.

Examples:

- Installing packages
- Updating the operating system
- Starting services
- Creating files
- Configuring applications

Linux instances natively understand Bash scripts, making them the simplest and most reliable option for bootstrapping servers.

Example:

```bash
#!/bin/bash

dnf update -y
dnf install nginx -y
systemctl start nginx
```

---

## Can Python Be Used?

Yes.

Example:

```bash
#!/bin/bash

python3 script.py
```

However:

- Python must be available on the instance
- Additional runtime dependencies may be required
- More overhead compared to Bash

Python is generally preferred for:

- AWS Automation
- Lambda Functions
- Infrastructure Automation
- AIOps Scripts
- Monitoring Tools

---

## Can JavaScript Be Used?

Yes.

Example:

```bash
#!/bin/bash

node app.js
```

However:

- Node.js must be installed first
- Additional setup is required

JavaScript is typically used for:

- Web Applications
- APIs
- Backend Services
- Frontend Development

---

## Why Was Bash Chosen For This Project?

This project required:

- Updating the operating system
- Installing Nginx
- Starting services
- Generating a web page during instance startup

These are operating system level tasks, making Bash the most suitable choice.

Therefore Bash was selected because it is:

- Native to Linux
- Lightweight
- Fast
- Reliable
- Industry standard for EC2 User Data scripts

### Interview Answer

User Data was implemented using Bash because it executes directly during Linux instance bootstrapping and is the standard approach for package installation, service configuration, and operating system initialization tasks. Python or JavaScript could also be used, but they introduce additional runtime dependencies and are generally better suited for application or automation logic rather than initial server provisioning.