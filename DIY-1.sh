#!/bin/bash
# DIY-1.sh - 配置第三方 feeds 源（追加模式）

FEEDS_FILE="feeds.conf.default"

# 1. 备份原文件（可选）
cp $FEEDS_FILE ${FEEDS_FILE}.bak

# 2. 清理可能存在的重复或冲突条目（精确删除）
sed -i '/openclash/d' $FEEDS_FILE
sed -i '/passwall[^_]/d' $FEEDS_FILE   # 删除 passwall 源（非 passwall_packages）

# 3. 添加新源（如果尚未存在）
grep -q "openclash" $FEEDS_FILE || echo "src-git openclash https://github.com/vernesong/OpenClash.git;dev" >> $FEEDS_FILE
grep -q "passwall https://" $FEEDS_FILE || echo "src-git passwall https://github.com/immortalwrt/openwrt-passwall.git;master" >> $FEEDS_FILE
grep -q "passwall_packages" $FEEDS_FILE || echo "src-git passwall_packages https://github.com/immortalwrt/openwrt-passwall-packages.git;master" >> $FEEDS_FILE
