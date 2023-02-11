#!/bin/bash -xe
sudo apt update	
sudo apt install apache2 -y
apache2 -version
sudo systemctl status apache2

sudo chown -R $USER:$USER /var/www/html

echo """<html>
<head>
<title>PlayQ Test</title>
</head>
<body>
<h1>Hello World from PlayQ Test</h1>
</body>
</html>""" > /var/www/html/index.html




