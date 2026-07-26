#!/bin/bash

dnf update -y
dnf install httpd -y

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Web Server 1</title>
    <style>
        body {
            background: linear-gradient(135deg, #2193b0, #6dd5ed);
            font-family: Arial, sans-serif;
            text-align: center;
            color: white;
            margin-top: 100px;
        }

        .card {
            background: rgba(255,255,255,0.15);
            padding: 30px;
            border-radius: 12px;
            width: 60%;
            margin: auto;
        }

        h1 {
            font-size: 45px;
        }

        p {
            font-size: 22px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>Web Server 1</h1>
        <p>Response coming from EC2 Instance 1</p>
        <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
    </div>
</body>
</html>
EOF

systemctl enable httpd
systemctl start httpd