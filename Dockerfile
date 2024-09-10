# 基於現有的 jimmyadaro/gitlab-ci-cd 鏡像
FROM jimmyadaro/gitlab-ci-cd:latest

# 創建 APK 緩存目錄
RUN mkdir -p /etc/apk/cache

# 將本地下載的 APKINDEX 文件複製到容器的 APK 緩存目錄中
COPY APKINDEX-main.tar.gz /etc/apk/cache/APKINDEX-main.tar.gz
COPY APKINDEX-community.tar.gz /etc/apk/cache/APKINDEX-community.tar.gz

# 檢查複製後的文件是否存在
RUN echo "Checking files after COPY:" && ls -l /etc/apk/cache/

# 解壓 APKINDEX 文件到 /etc/apk/cache 中
RUN tar -xzf /etc/apk/cache/APKINDEX-main.tar.gz -C /etc/apk/cache \
    && tar -xzf /etc/apk/cache/APKINDEX-community.tar.gz -C /etc/apk/cache

# 檢查解壓後的文件是否存在
RUN echo "Checking files after extraction:" && ls -l /etc/apk/cache/

# 使用本地的 APKINDEX 文件進行 apk 更新和升級
RUN apk update --no-cache --repository /etc/apk/cache \
    && apk upgrade --no-cache --repository /etc/apk/cache

# 安裝所需的包，例如 git 和 curl
RUN apk add --no-cache git curl