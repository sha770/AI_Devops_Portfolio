# AWS Networking Lab - Secure Public & Private Network Architecture

## Project Overview

In this project, I designed and implemented a secure AWS networking architecture to understand how resources communicate within a VPC and how private resources can remain isolated from direct internet access while still being able to access external services.

The main objective was to create a network where an administrator can securely access internal servers using a Bastion Host while keeping application servers protected inside a private subnet.

To achieve this, I created a custom VPC, configured public and private subnets, associated route tables, attached an Internet Gateway, deployed a NAT Gateway, configured Security Groups, and launched EC2 instances in separate network segments.

This project helped me understand the complete networking flow from Internet → Public Resources → Private Resources and how AWS networking components work together.

---

## What I Built

### VPC

Created a custom Virtual Private Cloud (VPC):

```text
10.0.0.0/16
```

The VPC acts as an isolated network boundary where all networking resources were deployed.

---

### Public Subnet

Created a public subnet:

```text
10.0.1.0/24
```

Resources deployed:

```text
Bastion Host
NAT Gateway
```

The public subnet was configured to communicate directly with the Internet using an Internet Gateway.

---

### Private Subnet

Created a private subnet:

```text
10.0.2.0/24
```

Resources deployed:

```text
Private EC2 Application Server
```

No public IP was assigned to the private instance.

This ensured that the server was not directly reachable from the Internet.

---

### Internet Gateway

Attached an Internet Gateway to the VPC.

Purpose:

```text
VPC
↔
Internet
```

The Internet Gateway enabled public subnet resources to communicate with the Internet.

---

### Route Tables

#### Public Route Table

Configured:

```text
0.0.0.0/0 → Internet Gateway
```

Associated with:

```text
Public Subnet
```

This allowed Bastion Host and NAT Gateway to access the Internet.

---

#### Private Route Table

Configured:

```text
0.0.0.0/0 → NAT Gateway
```

Associated with:

```text
Private Subnet
```

This allowed the private EC2 instance to access the Internet indirectly.

---

### NAT Gateway

Deployed a NAT Gateway in the public subnet and associated an Elastic IP with it.

Purpose:

```text
Private EC2
    ↓
NAT Gateway
    ↓
Internet
```

This enabled outbound internet access for the private EC2 while preventing direct inbound connections.

---

### Security Groups

#### Bastion Security Group

Allowed:

```text
SSH (22)
Source = My Public IP
```

Only my system could access the Bastion Host.

---

#### Private EC2 Security Group

Allowed:

```text
SSH (22)
Source = Bastion Security Group
```

Only the Bastion Host could connect to the private server.

---

## Traffic Flow

### Administrator Access Flow

To securely access the private server:

```text
Laptop
   │
   ▼
Bastion Host
(Public Subnet)
   │
   ▼
Private EC2
(Private Subnet)
```

The private server did not have a public IP address, ensuring it remained inaccessible from the Internet.

---

### Internet Access Flow

The private EC2 required outbound internet access for updates and package downloads.

Traffic flow:

```text
Private EC2
     │
     ▼
NAT Gateway
     │
     ▼
Internet Gateway
     │
     ▼
Internet
```

This provided:

✅ Internet access from Private EC2

✅ Software/package download capability

✅ Improved security

❌ No direct inbound Internet access

---

## Validation Performed

### Validation 1

Connected successfully:

```text
Laptop
→ Bastion Host
```

Result:

✅ Successful

---

### Validation 2

Access attempted:

```text
Bastion Host
→ Private EC2
```

Result:

✅ Successful

---

### Validation 3

Verified internet access from private EC2 through the NAT Gateway.

Result:

✅ Successful

---

### Validation 4

Attempted direct access:

```text
Laptop
→ Private EC2
```

Result:

❌ Blocked (Expected Behaviour)

---

## Key Learnings

Through this project, I gained hands-on understanding of:

- AWS VPC Architecture
- Public vs Private Subnets
- Internet Gateway Configuration
- NAT Gateway Configuration
- Route Table Associations
- Security Group Rules
- Bastion Host Architecture
- Secure EC2 Deployment
- AWS Network Traffic Flow
- Private Resource Isolation
- Outbound Internet Access for Private Resources

---

