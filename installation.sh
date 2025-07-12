#!/bin/bash

PROJECT_NAME="${PROJECT_NAME:-snap-stack}"
NETWORK_NAME="${PROJECT_NAME}-network"

install_supabase() {
    git clone --filter=blob:none --no-checkout --branch master --single-branch https://github.com/supabase/supabase supabase-hosting-source

    cd supabase-hosting-source

    git sparse-checkout init --cone

    git sparse-checkout set docker

    git checkout

    cd ..

    mkdir supabase-container

    cp -rf supabase-hosting-source/docker/* supabase-container

    cp supabase-hosting-source/docker/.env.example supabase-container/.env

    echo "\\nnetworks:\\n  $NETWORK_NAME:\\n    external: true\\n    name: $NETWORK_NAME" >>supabase-container/docker-compose.yml

    echo "\\nnetworks:\\n  $NETWORK_NAME:\\n    external: true\\n    name: $NETWORK_NAME" >>supabase-container/docker-compose.s3.yml

    sed -i.bak "/^    image:/i\\
    networks: ['$NETWORK_NAME']
" supabase-container/docker-compose.yml

    sed -i.bak "/^    image:/i\\
    networks: ['$NETWORK_NAME']
" supabase-container/docker-compose.s3.yml

    docker compose -f ./supabase-container/docker-compose.yml -f ./supabase-container/docker-compose.s3.yml pull

    docker compose -p "$PROJECT_NAME-supabase" -f ./supabase-container/docker-compose.yml -f ./supabase-container/docker-compose.s3.yml up -d
}

install_n8n() {
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

main() {
    docker network create "$NETWORK_NAME" >/dev/null || true
    install_supabase
    install_n8n
}

main
