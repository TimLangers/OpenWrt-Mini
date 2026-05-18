#!/bin/bash
# DIY-1 for OK2.config (完整版)
# 功能：添加第三方 feeds 源

FEEDS_FILE="feeds.conf.default"

# 清理可能冲突的旧条目
sed -i '/helloworld/d' $FEEDS_FILE
sed -i '/passwall/d' $FEEDS_FILE
sed -i '/openclash/d' $FEEDS_FILE

# 添加 OpenClash 源（dev 分支）
echo "src-git openclash https://github.com/vernesong/OpenClash.git;dev" >> $FEEDS_FILE

# 添加 PassWall 及其依赖包源（immortalwrt 维护）
echo "src-git passwall https://github.com/immortalwrt/openwrt-passwall.git;master" >> $FEEDS_FILE
echo "src-git passwall_packages https://github.com/immortalwrt/openwrt-passwall-packages.git;master" >> $FEEDS_FILE
