#!/bin/bash
set -e

echo "$0 is running..."

echo "making dir..."
cd $HOME
cd Desktop
mkdir tools
cd tools

# スクリプトをrootユーザーで実行しているか確認
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# インストールするAPTパッケージリスト
TOOLS=(
    "curl"
    "vim"
    "htop"
    "gobuster"
    "seclists"
    "ligolo-ng"
    "bloodhound"
    "default-jdk"
    "sherlock"
    "p7zip-full"
    "masscan"
    "feroxbuster"
)

# Gitからインストールするツールのリポジトリリスト (リポジトリURLとディレクトリ名のペア)
GIT_REPOS=(
    # "https://github.com/someuser/sometool.git sometool"
    # "https://github.com/anotheruser/anothertool.git anothertool"
    https://github.com/peass-ng/PEASS-ng PEASS-ng
    https://github.com/diegocr/netcat.git netcat
    https://github.com/tomnomnom/waybackurls waybackurls
)

# パッケージの更新
echo "Updating package list..."
apt update -y
apt upgrade -y

# APTツールのインストール
for tool in "${TOOLS[@]}"; do
    echo "Installing $tool..."
    if apt install -y "$tool"; then
        echo "$tool installed successfully."
    else
        echo "Failed to install $tool."
    fi
done

cd tools
# Gitツールのインストール
for repo in "${GIT_REPOS[@]}"; do
    # リポジトリURLとディレクトリ名を分離
    REPO_URL=$(echo "$repo" | awk '{print $1}')
    DIR_NAME=$(echo "$repo" | awk '{print $2}')

    echo "Cloning $REPO_URL into $DIR_NAME..."

    # リポジトリのクローン
    if git clone "$REPO_URL" "$DIR_NAME"; then
        echo "$DIR_NAME cloned successfully."

        # ビルドやインストールの処理（例としてmakeを使用）
        cd "$DIR_NAME" || exit
        if [ -f "Makefile" ]; then
            echo "Building $DIR_NAME..."
            make && make install
        else
            echo "No Makefile found for $DIR_NAME, skipping build."
        fi
        cd ..

    else
        echo "Failed to clone $REPO_URL."
    fi
done

echo "Installation of all tools completed."
