#!/bin/bash

SUPABASE_CONTAINER_NAME="${SUPABASE_CONTAINER_NAME:-supabase-container}"
N8N_CONTAINER_NAME="${N8N_CONTAINER_NAME:-n8n-container}"
NETWORK_NAME="${NETWORK_NAME:-snap-stack-shared}"
PROJECT_PREFIX="${PROJECT_PREFIX:-snap-stack}"

install_supabase() {
    git clone --filter=blob:none --no-checkout --branch master --single-branch https://github.com/supabase/supabase supabase-hosting-source

    cd supabase-hosting-source

    git sparse-checkout init --cone

    git sparse-checkout set docker

    git checkout

    cd ..

    mkdir "$SUPABASE_CONTAINER_NAME"

    cp -rf supabase-hosting-source/docker/* "$SUPABASE_CONTAINER_NAME"

    cp supabase-hosting-source/docker/.env.example "$SUPABASE_CONTAINER_NAME/.env"

    cd "$SUPABASE_CONTAINER_NAME"

    echo "\\nnetworks:\\n  $NETWORK_NAME:\\n    external: true\\n    name: $NETWORK_NAME" >>docker-compose.yml

    sed -i.bak "/^    container_name:/i\\
    networks: ['$NETWORK_NAME']
" docker-compose.yml

    docker compose pull

    docker compose -p "$PROJECT_PREFIX-supabase" up -d

    cd ..
}

install_n8n() {
    git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git "$N8N_CONTAINER_NAME"

    cd "$N8N_CONTAINER_NAME"

    cp .env.example .env

    mkdir -p volumes

    sed -i.bak 's|- postgres_storage:|- ./volumes/postgres_storage:|g' docker-compose.yml

    sed -i.bak 's|- n8n_storage:|- ./volumes/n8n_storage:|g' docker-compose.yml

    sed -i.bak 's|- qdrant_storage:|- ./volumes/qdrant_storage:|g' docker-compose.yml

    sed -i.bak 's|- ollama_storage:|- ./volumes/ollama_storage:|g' docker-compose.yml

    sed -i.bak "/^networks:/a\\
  $NETWORK_NAME:\\
    external: true\\
    name: $NETWORK_NAME
" docker-compose.yml

    sed -i.bak "s|  networks: \\['demo'\\]|  networks: ['demo', '$NETWORK_NAME']|g" docker-compose.yml

    docker compose -p "$PROJECT_PREFIX-n8n" up -d

    cd ..
}

main() {
    docker network create "$NETWORK_NAME" >/dev/null || true
    install_supabase
    install_n8n
}

main
