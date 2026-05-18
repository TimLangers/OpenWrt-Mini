#!/bin/bash
# DIY-1 此脚本功能：添加外部插件与主题（精简最新版）
# =======================================================================================================================

# 1. 彻底清理旧的、失效的、不需要的源（防 feeds update 报错）
sed -i '/helloworld/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 2. 添加 PowerOff 关机插件
git clone https://github.com/WukongMaster/luci-app-poweroff.git package/luci-app-poweroff

# 3. 添加最新版 Argon 主题及配置插件 (覆盖源码自带的老版本)
rm -rf package/feeds/luci/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# 4. 添加 OpenClash 插件 (主流稳定源)
sed -i '$a\src-git openclash https://github.com/vernesong/OpenClash.git;master' ./feeds.conf.default

# 5. 拉取最新的 PassWall 核心源 (替代已关闭的 xiaorouji 仓库)
# 使用社区维护、每日同步更新的 openwrt-passwall 最新 master 分支
echo "src-git passwall https://github.com/immortalwrt/openwrt-passwall.git;master" >> feeds.conf.default
echo "src-git passwall_packages https://github.com/immortalwrt/openwrt-passwall-packages.git;master" >> feeds.conf.default
