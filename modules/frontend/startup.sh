#!/bin/bash
set -e

# Update and install NGINX and Git
apt-get update -y
apt-get install -y nginx git

# Remove default nginx site
rm -f /etc/nginx/sites-enabled/default

# Create application base directory
mkdir -p /opt/application
cd /opt/application

# Clone the repository
git clone ${repo_url} todoapp

# Create web root
mkdir -p /var/www/todoapp
cp -r todoapp/app/frontend/* /var/www/todoapp/

# In app.js (or wherever URL is configured), we need to ensure it uses the proxy
# If app.js was already updated to use '/api', it's fine.
# If it uses the injected backend_ip, we can still sed it.
# Assuming we want it to be robust:
sed -i "s|const API_URL = .*|const API_URL = '/api';|g" /var/www/todoapp/app.js

# Configure NGINX
cat > /etc/nginx/sites-available/todoapp << NGINX_EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/todoapp;
    index index.html;
    server_name _;
    location / {
        try_files \$uri \$uri/ =404;
    }
    location /api/ {
        proxy_pass http://${backend_ip}:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
NGINX_EOF

# Enable site
ln -sf /etc/nginx/sites-available/todoapp /etc/nginx/sites-enabled/

# Test and restart NGINX
nginx -t
systemctl restart nginx
systemctl enable nginx

echo "Frontend deployment from GitHub complete!"
