#!/bin/bash

rm .env

echo "NordVPN Access Token:"

read token

echo "Getting Nordvpn Private Key..."

output=$(docker run --rm --cap-add=NET_ADMIN -e TOKEN=$token ghcr.io/bubuntux/nordvpn:get_private_key)


private_key=$(echo "$output" | grep -o 'Private Key: .*' | awk '{print $3}')

echo "PRIVATE_KEY=$private_key" >> .env

echo "TIMEZONE=America/New_York" >> .env

echo "ROOT_DIR=." >> .env


# Make users and group
sudo useradd sonarr -u 13001
sudo useradd radarr -u 13002
sudo useradd prowlarr -u 13006
sudo useradd qbittorrent -u 13007
sudo groupadd mediacenter -g 13000
sudo usermod -a -G mediacenter sonarr
sudo usermod -a -G mediacenter radarr
sudo usermod -a -G mediacenter prowlarr
sudo usermod -a -G mediacenter qbittorrent

# Directories
sudo mkdir -pv docker/{sonarr,radarr,prowlarr,qbittorrent,plex}-config
sudo mkdir -pv data/{torrents,media}/{tv,movies}

# Permissions
sudo chmod -R 775 data/
sudo chown -R $(id -u):mediacenter data/
sudo chown -R sonarr:mediacenter docker/sonarr-config
sudo chown -R radarr:mediacenter docker/radarr-config
sudo chown -R prowlarr:mediacenter docker/prowlarr-config
sudo chown -R qbittorrent:mediacenter docker/qbittorrent-config

echo "UID=$(id -u)" >> .env

docker compose up -d