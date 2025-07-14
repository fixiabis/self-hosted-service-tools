# self hosted service tools

可以快速各種服務的基礎環境，請確保已安裝 docker

假設專案名稱是 your-project，你可以使用以下腳本，完成初始的設定:

```sh
PROJECT_NAME=your-project
git clone https://github.com/fixiabis/self-hosted-service-tools.git $PROJECT_NAME
cd $PROJECT_NAME
echo "PROJECT_NAME=$PROJECT_NAME" >> .env
```

接著，依照你的需要安裝服務：

**Supabase**

```sh
sh ./install_supabase.sh
```

**N8N**

```sh
sh ./install_n8n.sh
```
