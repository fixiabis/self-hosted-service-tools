#!/bin/bash

load_env() {
    if [ -z "$PROJECT_NAME" ]; then
        if [ -f .env ]; then
            echo "📦 載入 .env 設定"
            set -a
            source .env
            set +a
        else
            echo "❌ 找不到 .env 檔案，且未設定 PROJECT_NAME，無法繼續"
            exit 1
        fi
    fi

    if [ -z "$PROJECT_NAME" ]; then
        echo "❌ .env 裡沒有設定 PROJECT_NAME，無法繼續"
        exit 1
    fi

    echo "ℹ️ 使用 PROJECT_NAME=$PROJECT_NAME"

    if [ -z "$NETWORK_NAME" ]; then
        NETWORK_NAME="${PROJECT_NAME}-network"
        echo "❗ 未設定 NETWORK_NAME，將使用預設格式：<PROJECT_NAME>-network"
        echo "ℹ️ 使用 NETWORK_NAME=$NETWORK_NAME"
    else
        echo "ℹ️ 使用 NETWORK_NAME=$NETWORK_NAME"
    fi
}

create_docker_network_if_needed() {
    if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
        echo "✅ Network '$NETWORK_NAME' 已存在"
    else
        echo "🔧 建立 network '$NETWORK_NAME'"
        docker network create "$NETWORK_NAME"
    fi
}

load_env
create_docker_network_if_needed
