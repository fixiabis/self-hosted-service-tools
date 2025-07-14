#!/bin/bash

stop_n8n() {
    source ./initialize.sh

    docker compose -p "$PROJECT_NAME-n8n" -f ./n8n-container/docker-compose.yml down "$@"
}

stop_n8n "$@"
