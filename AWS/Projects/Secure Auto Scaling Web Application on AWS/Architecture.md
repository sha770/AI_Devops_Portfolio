# Architecture Diagram

The following architecture represents a production-style secure web application deployment on AWS.

Architecture.png

---

## Architecture Flow

```text
Internet Users
        |
        |
Application Load Balancer
(Public Subnets)
        |
        |
Target Group
        |
 -------------------------
 |                       |
 |                       |
EC2 Instance A      EC2 Instance B
Private Subnet A    Private Subnet B
        |
        |
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

Session Manager
        |
   EC2 Instances
```

---

## Traffic Flow

```text
Internet Users
      ↓
Application Load Balancer
      ↓
Target Group
      ↓
Private EC2 Instances
```

All incoming application traffic is routed through the Application Load Balancer.

The EC2 instances are deployed in private subnets and are not directly accessible from the internet.

---

## Administrative Access

```text
Administrator
      ↓
Session Manager
      ↓
Private EC2 Instances
```

No public IP addresses or public SSH access are required.

---

## Outbound Internet Connectivity

```text
Private EC2
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```

Private instances can download updates and packages while remaining isolated from direct internet access.

---

## Key Architecture Features

- High Availability
- Multi-AZ Deployment
- Auto Scaling
- Self-Healing
- Public ALB
- Private EC2
- Session Manager Access
- CloudWatch Monitoring
- Secure Network Segmentation