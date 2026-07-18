# Learnings H

## VPC

Logical private network in AWS.

## Public Subnet

Route:

0.0.0.0/0 → IGW

Resources can reach internet directly.

## Private Subnet

Route:

0.0.0.0/0 → NAT Gateway

No direct inbound internet access.

## Internet Gateway

Connects VPC to Internet.

## NAT Gateway

Allows outbound internet access from private resources.

## Bastion Host

Used as a jump server.

Laptop
→ Bastion
→ Private EC2

## Route Tables

Determine where network traffic goes.