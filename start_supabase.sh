#!/bin/bash

start_supabase() {
    source ./initialize.sh

    docker compose -p "$PROJECT_NAME-supabase" -f ./supabase-container/docker-compose.yml -f ./supabase-container/docker-compose.s3.yml up -d
}

start_supabase "$@"
