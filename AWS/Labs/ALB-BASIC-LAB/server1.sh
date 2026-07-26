#!/bin/bash

apt update -y
apt install apache2 -y

systemctl enable apache2
systemctl start apache2

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Server 1</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }

        h1 {
            color: navy;
            font-size: 50px;
        }

        p {
            font-size: 24px;
        }
    </style>
</head>
<body>
    <h1>Server 1</h1>
    <p>Response coming from EC2 Instance 1</p>
</body>
</html>
EOF