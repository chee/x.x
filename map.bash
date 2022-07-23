#!/bin/bash
root="$HOME/x.x"
name="$1"
port="$2"

>"$root/$name.nginx" cat <<nginxconf
server {
  default_type text/plain;

  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name $name.x.x;

  ssl_certificate      $root/x.x.crt;
  ssl_certificate_key $root/x.x.key;

  location / {
    proxy_pass http://127.0.0.1:$port/;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    client_max_body_size 100m;
  }
}

server {
  default_type text/plain;

  listen 80;
  listen [::]:80;
  server_name $name.x.x;

  location / {
    proxy_pass http://127.0.0.1:$port/;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    client_max_body_size 100m;
  }
}
nginxconf

sudo nginx -s reload
open "https://$name.x.x"
# ln -s "$root/$name.nginx" "$root/port"
