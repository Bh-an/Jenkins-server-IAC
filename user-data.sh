#!/bin/bash
sudo apt-get update

cd /etc/nginx/sites-available/
sudo rm -rf default
sudo touch default
cat > /etc/nginx/sites-available/default <<EOF
upstream jenkins {
    server 127.0.0.1:8080 fail_timeout=0;
}

server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name jenkins.rajmehta.live;

        location / {
                proxy_set_header        Host \$host:\$server_port;
                proxy_set_header        X-Real-IP \$remote_addr;
                proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto \$scheme; 
                proxy_set_header        Upgrade \$http_upgrade;
                proxy_set_header        Connection "upgrade";
                proxy_pass              http://jenkins;
        }
}
EOF
cd
sudo nginx -t
sudo systemctl restart nginx
sudo certbot --nginx -d jenkins.rajmehta.live -m rajmehta53@live.com -n --agree-tos