#!/bin/bash

apt update -y
apt install apache2 -y

systemctl enable apache2
systemctl start apache2

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Server 2</title>
    <style>
        body {
            background-color: lightgreen;
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }

        h1 {
            color: darkgreen;
            font-size: 50px;
        }

        p {
            font-size: 24px;
        }
    </style>
</head>
<body>
    <h1>Server 2</h1>
    <p>Response coming from EC2 Instance 2</p>
</body>
</html>
EOF