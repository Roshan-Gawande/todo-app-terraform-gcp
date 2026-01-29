#!/bin/bash
set -e

# Update and install dependencies
apt-get update -y
apt-get install -y nodejs npm git

# Create application base directory
mkdir -p /opt/application
cd /opt/application

# Clone the repository
git clone ${repo_url} todoapp
cd todoapp/app/backend

# Install application dependencies
npm install

# Create systemd service for the Node.js application
cat > /etc/systemd/system/todoapp.service << EOF
[Unit]
Description=TODO API Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/application/todoapp/app/backend
Environment="DB_HOST=${db_host}"
Environment="DB_NAME=${db_name}"
Environment="DB_USER=${db_user}"
Environment="DB_PASSWORD=${db_password}"
Environment="PORT=3000"
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl daemon-reload
systemctl enable todoapp
systemctl restart todoapp

echo "Backend deployment from GitHub complete!"
