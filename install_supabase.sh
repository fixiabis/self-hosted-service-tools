#!/bin/bash

install_supabase() {
    source ./initialize.sh

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

install_supabase "$@"
