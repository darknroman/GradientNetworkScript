#!/bin/bash

# 检查操作系统类型
OS_TYPE=$(cat /etc/*release | grep -E '^ID=' | cut -d'=' -f2 | tr -d '"')

install_docker() {
    if [[ "$OS_TYPE" == "ubuntu" ]]; then
        echo "检测到 Ubuntu 系统，正在安装 Docker..."
        # 更新包索引
        sudo apt update
        # 安装必要的工具
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        # 添加 Docker 官方 GPG 密钥
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        # 添加 Docker 仓库
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        # 再次更新包索引
        sudo apt update
        # 安装 Docker
        sudo apt install -y docker-ce
    elif [[ "$OS_TYPE" == "centos" ]]; then
        echo "检测到 CentOS 7 系统，正在安装 Docker..."
        # 安装必要的工具
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        # 设置 Docker 仓库
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        # 安装 Docker
        sudo yum install -y docker-ce
    else
        echo "不支持的操作系统: $OS_TYPE"
        exit 1
    fi

    # 启动 Docker 并设置开机自启
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker 安装完成，并已设置为开机自启."
}

install_docker_compose() {
    echo "正在安装 Docker Compose..."
    # 获取最新版本号
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 2)
    # 下载 Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # 赋予执行权限
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose 安装完成，版本: $(docker-compose --version)"
    echo "作者推特: @Norman52521314"
}

install_python() {
    echo "正在安装 Python 3 和 pip3..."
    if [[ "$OS_TYPE" == "ubuntu" ]]; then
        sudo apt update
        sudo apt install -y python3 python3-pip
    elif [[ "$OS_TYPE" == "centos" ]]; then
        sudo yum install -y python3 python3-pip
    else
        echo "不支持的操作系统: $OS_TYPE"
        exit 1
    fi

    echo "Python 3 和 pip3 安装完成."
}

install_yaml_module() {
    echo "正在安装 PyYAML 模块..."
    pip3 install pyyaml
    echo "PyYAML 模块安装完成."
}

download_config_script() {
    echo "正在下载 config.py..."
    curl -O https://raw.githubusercontent.com/darknroman/GradientNetworkScript/main/config.py
    echo "config.py 下载完成."
}

# 安装 Docker
install_docker

# 安装 Docker Compose
install_docker_compose

# 安装 Python 和 pip3
install_python

# 安装 PyYAML 模块
install_yaml_module

# 下载 config.py
download_config_script
