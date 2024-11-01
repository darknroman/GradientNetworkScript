import random
import string
import yaml
import os
import subprocess

list_tmp = ["ip:端口", "ip:端口", "ip:端口", "ip:端口"]
print("代理需要socks5类型")
print(f"格式:{list_tmp}")
list_ip = input("输入你的代理: ").split(",")
password = input("设置密码: ")


def generate_random_string(length=12):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))


while True:
    try:
        PROXY_COUNT = int(input("请输入需要生成的数量："))
        if PROXY_COUNT <= 0:
            raise ValueError("数量必须为正整数。")
        break
    except ValueError as e:
        print(e)

services = {}

for i in range(PROXY_COUNT):
    service_name = f"selenium_{i + 1}_{generate_random_string()}"
    services[service_name] = {
        "image": "kasmweb/ubuntu-bionic-desktop:1.10.0-rolling",
        "ports": [
            f"{6900 + i}:6901"
        ],
        "shm_size": "2g",
        "dns": ["1.1.1.1"],
        "environment": {
            "VNC_PW": password,
            "ALL_PROXY": f"socks5://{list_ip[i % len(list_ip)]}",
            "no_proxy": "localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"
        }
    }

docker_compose_content = {
    "version": "3",
    "services": services
}

file_path = os.path.join(os.getcwd(), "docker-compose.yml")
with open(file_path, "w") as file:
    yaml.dump(docker_compose_content, file, default_flow_style=False, sort_keys=False)

print(f"已生成 {file_path} 文件，可以使用 docker-compose 启动容器")

# 执行 docker-compose up -d
try:
    subprocess.run(["docker-compose", "up", "-d"], check=True)
    print("容器已成功启动")
    print("作者推特: @Norman52521314")
except subprocess.CalledProcessError as e:
    print("启动容器时出错:", e)
    print("作者推特: @Norman52521314")
