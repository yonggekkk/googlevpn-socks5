### 基于gost的局域网共享代理一键脚本，支持Socks5+Http双代理，Google VPN用户推荐使用

### 功能与Every Proxy应用一样，但在传输性能上，gost更加优秀

### Google Pixel手机先安装[Termux](https://github.com/termux/termux-app/releases)运行一键脚本

#### 一键脚本：
```
pkg upgrade -y && bash <(curl -Ls https://gh-proxy.com/https://raw.githubusercontent.com/yonggekkk/google_vpn_proxy/main/gv.sh)
```

#### 可在Termux输入命令 ```ifconfig``` 查看内网IP地址，并填写在支持Socks5或者Http的客户端上

-----------------------------------------------------

### 感谢你右上角的star🌟
[![Stargazers over time](https://starchart.cc/yonggekkk/google_vpn_proxy.svg)](https://starchart.cc/yonggekkk/google_vpn_proxy)

---------------------------------------
#### 声明：所有代码来源于Github社区与ChatGPT的整合，[gost](https://github.com/go-gost/gost/releases)、[Termux](https://github.com/termux/termux-app/releases)
