# ALB Basics Lab

## Objective

The goal of this lab is to understand how an AWS Application Load Balancer (ALB) distributes incoming traffic across multiple EC2 instances and improves application availability.

---

## Architecture

```text
                Internet
                    │
                    ▼
          Application Load Balancer
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
      EC2-1               EC2-2
     Server 1            Server 2
```

---

## Services Used

- Amazon EC2
- Application Load Balancer (ALB)
- Target Group
- Security Groups

---

## Lab Steps

### Step 1: Launch Two EC2 Instances

Created:

- web-server-1
- web-server-2

Configured a simple web page on each server.
Ubuntu apache2 web servers using user data
---

### Step 2: Configure Security Groups

#### ALB Security Group

```text
HTTP (80) -> 0.0.0.0/0
```

#### EC2 Security Group

```text
HTTP (80) -> ALB Security Group
SSH (22) -> My IP
```

---

### Step 3: Create Target Group

Created a Target Group and registered:

- EC2-1
- EC2-2

Configured health checks on port 80.

---

### Step 4: Create Application Load Balancer

Configuration:

```text
Type: Internet Facing
Listener: HTTP 80
Target Group: Attached
```

AWS generated a DNS name for the ALB.

---

### Step 5: Verify Load Balancing

Accessed the application using the ALB DNS name and verified traffic distribution across backend instances.

---

## Traffic Flow

```text
User
  │
  ▼
ALB DNS
  │
  ▼
ALB Listener
  │
  ▼
Target Group
  │
 ┌┴┐
 ▼ ▼
EC2 Instances
```

---

## Concepts Learned

### What is a Load Balancer?

A Load Balancer distributes incoming traffic across multiple servers and helps improve application availability.

---

### What is an Application Load Balancer?

ALB operates at Layer 7 (Application Layer) and supports HTTP/HTTPS traffic.

It can route requests using:

- URL Paths
- Host Names
- HTTP Headers

---

### What is a Target Group?

A Target Group contains the backend servers that receive traffic from the ALB.

Example:

```text
Target Group
 ├── EC2-1
 └── EC2-2
```

---

### What are Health Checks?

ALB continuously checks the health of registered targets.

Healthy targets receive traffic.

Unhealthy targets are automatically removed from traffic distribution.

---

### What is an ALB DNS Name?

When an ALB is created, AWS automatically provides a DNS endpoint.

Example:

```text
my-alb-xxxx.ap-south-1.elb.amazonaws.com
```

Users access the application through this endpoint.

---

## Multi-AZ High Availability

The Application Load Balancer is deployed across multiple Availability Zones within the same AWS Region.

Example:

```text
Mumbai Region

AZ-a
 └── EC2-1

AZ-b
 └── EC2-2
```

If one Availability Zone experiences issues, ALB can continue routing traffic to healthy resources in another Availability Zone.

This improves:

- Availability
- Fault Tolerance
- Reliability

---

## What Happens If One EC2 Instance Fails?

Example:

```text
EC2-1 = Stopped / Terminated
```

Health Check Result:

```text
EC2-1 = Unhealthy
```

ALB automatically stops sending traffic to EC2-1 and forwards all traffic to EC2-2.

Result:

✅ Website remains available

✅ Users can still access the application

✅ No manual intervention required

---

## Key Takeaways

- ALB distributes traffic across multiple servers.
- Target Groups contain backend targets.
- Health Checks determine server status.
- ALB routes traffic only to healthy targets.
- ALB improves application availability.
- Multiple Availability Zones help achieve High Availability.
- Failure of a single EC2 instance does not bring down the application.

---


