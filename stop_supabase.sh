#!/bin/bash

stop_supabase() {
    source ./initialize.sh

    docker compose -p "$PROJECT_NAME-supabase" -f ./supabase-container/docker-compose.yml -f ./supabase-container/docker-compose.s3.yml down "$@"
}

stop_supabase "$@"
