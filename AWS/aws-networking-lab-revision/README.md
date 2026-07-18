# AWS Networking Lab (AWS-Secure-Public-Private-Network-Architecture)

## Overview

Built a secure AWS networking architecture to understand how public and private resources communicate within a VPC.

The project includes a custom VPC, public and private subnets, route tables, Internet Gateway, NAT Gateway, Bastion Host, and EC2 instances.

The goal was to allow secure administrative access to a private EC2 instance while preventing direct internet access to internal resources.

---

## Components Used

- VPC (10.0.0.0/16)
- Public Subnet (10.0.1.0/24)
- Private Subnet (10.0.2.0/24)
- Internet Gateway (IGW)
- NAT Gateway
- Security Groups
- Route Tables
- Bastion Host
- Private EC2 Instance

---

## Network Flow

### Administrative Access

```text
Laptop
   ↓
Bastion Host
   ↓
Private EC2
```

The private EC2 does not have a public IP and can only be accessed through the Bastion Host.

### Internet Access

```text
Private EC2
   ↓
NAT Gateway
   ↓
Internet Gateway
   ↓
Internet
```

The private EC2 can access the internet for updates and downloads while remaining inaccessible from the public internet.

---

## Architecture Diagram

![Architecture Diagram](Acrhitecture.png)

---

## Validation

✅ Bastion Host deployed in Public Subnet  
✅ Private EC2 deployed in Private Subnet  
✅ Route Tables configured  
✅ Internet Gateway configured  
✅ NAT Gateway configured  
✅ Private EC2 internet access verified  
✅ Direct public access to Private EC2 restricted  

---

## Outcome

Successfully implemented a secure AWS VPC architecture demonstrating controlled access to private resources through a Bastion Host and outbound internet connectivity through a NAT Gateway.
