#!/bin/bash
# 此脚本功能：配置软件源 (Feeds)
# =======================================================================================

# 1. 清理可能冲突的旧源
sed -i '/helloworld/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default
sed -i '/openclash/d' feeds.conf.default

# 2. 添加 OpenClash (dev 分支)
echo "src-git openclash https://github.com/vernesong/OpenClash.git;dev" >> feeds.conf.default

# 3. 添加最新版 PassWall (方法1) —— 使用 Openwrt-Passwall 仓库
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default
