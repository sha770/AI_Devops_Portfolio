#!/bin/bash

# Update package repository and installed packages
dnf update -y

# Install Nginx web server
dnf install nginx -y

# Enable Nginx service at boot
systemctl enable nginx

# Start Nginx service
systemctl start nginx

# Fetch hostname of current EC2 instance
HOSTNAME=$(hostname)

# Fetch private IP address of current EC2 instance
PRIVATE_IP=$(hostname -I | awk '{print $1}')

# Create custom web page
cat > /usr/share/nginx/html/index.html <<EOF
<html>
<head>
    <title>Secure Auto Scaling Web Application</title>
</head>
<body style="font-family:Arial;text-align:center;margin-top:50px;">
    <h1>AWS Secure Auto Scaling Web Application</h1>
    <h2>Hostname: $HOSTNAME</h2>
    <h3>Private IP: $PRIVATE_IP</h3>
    <p>Served through Application Load Balancer</p>
</body>
</html>
EOF

# Restart Nginx to ensure latest content is served
systemctl restart nginx