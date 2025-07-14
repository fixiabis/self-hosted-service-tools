#!/bin/bash

install_n8n() {
    source ./initialize.sh

    git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git n8n-hosting-source

    mkdir -p n8n-container

    cp -rf n8n-hosting-source/* n8n-container

    cp n8n-hosting-source/.env.example n8n-container/.env

    mkdir -p n8n-container/volumes

    sed -i.bak 's|- postgres_storage:|- ./volumes/postgres_storage:|g' n8n-container/docker-compose.yml

    sed -i.bak 's|- n8n_storage:|- ./volumes/n8n_storage:|g' n8n-container/docker-compose.yml

    sed -i.bak 's|- qdrant_storage:|- ./volumes/qdrant_storage:|g' n8n-container/docker-compose.yml

    sed -i.bak 's|- ollama_storage:|- ./volumes/ollama_storage:|g' n8n-container/docker-compose.yml

    sed -i.bak "/^networks:/a\\
  $NETWORK_NAME:\\
    external: true\\
    name: $NETWORK_NAME
" n8n-container/docker-compose.yml

    sed -i.bak "s|  networks: \\['demo'\\]|  networks: ['demo', '$NETWORK_NAME']|g" n8n-container/docker-compose.yml

    docker compose -p "$PROJECT_NAME-n8n" -f ./n8n-container/docker-compose.yml up -d
}

install_n8n "$@"
