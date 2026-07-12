# AWS Networking Lab

## Services Used

- VPC
- Public Subnet
- Private Subnet
- Route Tables
- Internet Gateway
- NAT Gateway
- Security Groups
- Bastion Host
- EC2

## Architecture

See architecture.png

## Network Flow

Laptop
→ Bastion Host
→ Private EC2

Private EC2
→ NAT Gateway
→ Internet

## Validation

✅ Bastion SSH Working

✅ Private EC2 Accessible

✅ Internet Access From Private EC2

✅ Direct Access To Private EC2 Blocked

## Key Learnings

- Public vs Private Subnet
- Route Tables
- Internet Gateway
- NAT Gateway
- Bastion Host Access Pattern
- Security Groups