#!/bin/bash
gvinstall(){
pkg install -y screen
if [ ! -e gost ]; then
echo "下载中……"
curl -L -o gost_3.0.0_linux_arm64.tar.gz -# --retry 2 --insecure https://raw.githubusercontent.com/yonggekkk/google_vpn_proxy/main/gost_3.0.0_linux_arm64.tar.gz
tar zxvf gost_3.0.0_linux_arm64.tar.gz
fi
if [ ! -e gost ]; then
echo "当前网络无法链接Github，切换中转下载"
curl -L -o gost_3.0.0_linux_arm64.tar.gz -# --retry 2 --insecure https://gh-proxy.com/https://raw.githubusercontent.com/yonggekkk/google_vpn_proxy/main/gost_3.0.0_linux_arm64.tar.gz
tar zxvf gost_3.0.0_linux_arm64.tar.gz
fi
if [ ! -e gost ]; then
echo "下载失败，请在代理环境下运行脚本" && exit
fi
rm -f gost_3.0.0_linux_arm64.tar.gz README* LICENSE* config.yaml
read -p "设置 Socks5 端口（回车跳过为10000-65535之间的随机端口）：" socks_port
if [ -z "$socks_port" ]; then
socks_port=$(shuf -i 10000-65535 -n 1)
fi
read -p "设置 Http 端口（回车跳过为10000-65535之间的随机端口）：" http_port
if [ -z "$http_port" ]; then
http_port=$(shuf -i 10000-65535 -n 1)
fi
echo "你设置的 Socks5 端口：$socks_port 和 Http 端口：$http_port" && sleep 2
echo 'services:' >> config.yaml
echo '  - name: service-socks5' >> config.yaml
echo "    addr: \":$socks_port\"" >> config.yaml
echo '    resolver: resolver-0' >> config.yaml
echo '    handler:' >> config.yaml
echo '      type: socks5' >> config.yaml
echo '      metadata:' >> config.yaml
echo '        udp: true' >> config.yaml
echo '        udpbuffersize: 4096' >> config.yaml
echo '    listener:' >> config.yaml
echo '      type: tcp' >> config.yaml
echo '  - name: service-http' >> config.yaml
echo "    addr: \":$http_port\"" >> config.yaml
echo '    resolver: resolver-0' >> config.yaml
echo '    handler:' >> config.yaml
echo '      type: http' >> config.yaml
echo '      metadata:' >> config.yaml
echo '        udp: true' >> config.yaml
echo '        udpbuffersize: 4096' >> config.yaml
echo '    listener:' >> config.yaml
echo '      type: tcp' >> config.yaml
echo 'resolvers:' >> config.yaml
echo '  - name: resolver-0' >> config.yaml
echo '    nameservers:' >> config.yaml
echo '      - addr: tls://1.1.1.1:853' >> config.yaml
echo '        prefer: ipv4' >> config.yaml
echo '        ttl: 5m0s' >> config.yaml
echo '        async: true' >> config.yaml
echo '      - addr: tls://1.0.0.1:853' >> config.yaml
echo '        prefer: ipv4' >> config.yaml
echo '        ttl: 5m0s' >> config.yaml
echo '        async: true' >> config.yaml
cd /data/data/com.termux/files/usr/etc/profile.d
echo '#!/data/data/com.termux/files/usr/bin/bash' >> gost.sh
echo 'screen -wipe' >> gost.sh
echo "screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill" >> gost.sh
echo "screen -dmS myscreen bash -c './gost -C config.yaml'" >> gost.sh
chmod +x gost.sh
echo "安装完毕" 
echo
echo "快捷方式：bash gv.sh  可查看Socks5端口与Http端口"
echo "退出脚本运行：exit"
sleep 2
exit
}
uninstall(){
screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill
rm -f gost config.yaml
echo "卸载完毕"
}
show_menu(){
curl -sSL https://raw.githubusercontent.com/yonggekkk/google_vpn_proxy/main/gv.sh -o gv.sh && chmod +x gv.sh
clear
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
echo "甬哥Github项目  ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
echo "Google_VPN局域网共享代理：Socks5+Http双代理一键脚本"
echo "快捷方式：bash gv.sh  可查看Socks5端口与Http端口"
echo "退出脚本运行：exit"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
echo " 1. 重置安装"
echo " 2. 删除卸载"
echo " 0. 退出"
echo "------------------------------------------------"
if [[ -e config.yaml ]]; then
echo "当前使用的Socks5端口：$(cat config.yaml 2>/dev/null | grep 'service-socks5' -A 2 | grep 'addr' | awk -F':' '{print $3}' | tr -d '\"')" 
echo "当前使用的Http端口：$(cat config.yaml 2>/dev/null | grep 'service-http' -A 2 | grep 'addr' | awk -F':' '{print $3}' | tr -d '\"')"
else
echo "未安装，请选择 1 进行安装"
fi
echo "------------------------------------------------"
read -p "请输入数字:" Input
case "$Input" in     
 1 ) gvinstall;;
 2 ) uninstall;;
 * ) exit 
esac
}
show_menu
