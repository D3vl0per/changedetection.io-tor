# Changedetection.io - Tor

## Setup
1. `docker-compose pull`
2. `docker-compose build`
3. `echo "CONTROL_PASSWORD=$(openssl rand -hex 64)" > .env`
4. `docker-compose up -d`
5. Adjust the global fetch method and the "Wait seconds before extracting text" setting