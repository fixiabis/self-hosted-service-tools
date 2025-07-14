# self hosted service tools

## 初始化專案

可以快速各種服務的基礎環境，請確保已安裝 docker

假設專案名稱是 your-project，你可以使用以下腳本，完成初始的設定:

```sh
PROJECT_NAME=your-project
git clone https://github.com/fixiabis/self-hosted-service-tools.git $PROJECT_NAME
cd $PROJECT_NAME
echo "PROJECT_NAME=$PROJECT_NAME" >> .env
```

接著，依照你的需要安裝服務：

## 安裝與設定 Supabase

1. 在專案目錄下面執行以下腳本，安裝 supabase 服務：
    ```sh
    sh ./setup_supabase.sh
    ```
2. 接著到 `supabase-container` 資料夾中，調整 `.env` 檔案（後台帳號密碼、資料庫密碼等）
3. 在專案目錄下面執行以下腳本，啟動 supabase 服務：
    ```sh
    sh ./setup_supabase.sh
    ```
4. 如果要關閉，可以在專案目錄下面執行以下腳本，停止 supabase 服務：
    ```sh
    sh ./stop_supabase.sh
    ```

## 安裝與設定 N8N

1. 在專案目錄下面執行以下腳本，安裝 n8n 服務：
    ```sh
    sh ./setup_n8n.sh
    ```
2. 接著到 `n8n-container` 資料夾中，調整 `.env` 檔案（後台帳號密碼、資料庫密碼等）
3. 在專案目錄下面執行以下腳本，啟動 n8n 服務：
    ```sh
    sh ./setup_n8n.sh
    ```
4. 如果要關閉，可以在專案目錄下面執行以下腳本，停止 n8n 服務：
    ```sh
    sh ./stop_n8n.sh
    ```
