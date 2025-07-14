#!/bin/bash

start_n8n() {
    source ./initialize.sh

    docker compose -p "$PROJECT_NAME-n8n" -f ./n8n-container/docker-compose.yml up -d
}

start_n8n "$@"
