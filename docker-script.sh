#!/bin/bash
# Update and upgrade the system
sudo apt-get update -y
sudo apt-get upgrade -y
# Install Docker
sudo apt install docker.io -y
# Start and enable the Docker service
sudo systemctl start docker
sudo systemctl enable docker
# Add the current user to the Docker group
sudo usermod -aG docker ubuntu