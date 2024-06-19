#!/bin/bash
# Update package lists and install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Set up the directory structure
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a fake HTML file to test the Nginx configuration
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html

# Create a symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Set ownership of the /data/ folder to the ubuntu user AND group
sudo chown -R ubuntu:ubuntu /data/

# Update the Nginx configuration to serve the content of /data/web_static/current/
# Replace the default configuration with the following lines
sudo tee /etc/nginx/sites-available/default > /dev/null << EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }
}
EOL

# Restart Nginx to apply the changes
sudo systemctl restart nginx
