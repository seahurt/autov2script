#!/bin/bash

if [[ -z $1 ]];then
  echo "Usage: $0 <uuid> <port>"
  exit 1
fi

uuid=$1
port=$2

cd
wget https://github.com/v2fly/v2ray-core/releases/download/v4.31.0/v2ray-linux-64.zip \
&& mkdir v2ray && mv v2ray-linux-64.zip v2ray && cd v2ray \
&& unzip v2ray-linux-64.zip \
&& sudo mv v2ray v2ctl *.dat /usr/local/bin \
&& sudo mkdir -p /usr/local/etc/v2ray

cat > config.json <<- 'EOF'
{
  "inbounds": [
    {
      "port": uuport, // 服务器监听端口
      "protocol": "vmess",    // 主传入协议
      "settings": {
        "clients": [
          {
            "id": "uuid",  // 用户 ID，客户端与>服务器必须相同
            "alterId": 64
          }
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",  // 主传出协议
      "settings": {}
    }
  ]
}
EOF

sed -i "s/uuid/$uuid/" config.json \
&& sed -i "s/uuport/$port/" config.json \
&& sudo mv *.json /usr/local/etc/v2ray \
&& sudo mv systemd/system/* /etc/systemd/system \
&& sudo systemctl daemon-reload \
&& sudo systemctl start v2ray \
&& sudo firewall-cmd --add-port=$port/tcp --permanent \
&& sudo firewall-cmd --reload 


