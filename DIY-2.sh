#!/bin/bash
# DIY-2.sh for 官方 OpenWrt 25.12 (OK2 完整版)
set -e

# ======================= 1. 克隆额外插件 =======================
git clone --depth 1 https://github.com/WukongMaster/luci-app-poweroff.git package/luci-app-poweroff

# Argon 主题及配置
rm -rf package/feeds/luci/luci-theme-argon
git clone --depth 1 -b master https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# ======================= 2. 修改固件参数（官方兼容版） =======================
# 修改管理 IP
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 删除 root 默认密码（官方无此文件，安全跳过）
if [ -f package/lean/default-settings/files/zzz-default-settings ]; then
    sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings
fi

# 修改默认主题为 argon（如果 feeds/luci/collections/luci/Makefile 存在）
if [ -f feeds/luci/collections/luci/Makefile ]; then
    sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
fi

# 修改时间格式（官方无 autocore，跳过）
find package/lean/autocore/files/ -type f -name "index.htm" -exec sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' {} \; 2>/dev/null || true

# 添加编译日期（官方支持）
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(BUILD_DATE_PREFIX)-/g' ./include/image.mk
if ! grep -q "BUILD_DATE_PREFIX" ./include/image.mk; then
    sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX := $(shell date +'%F')' ./include/image.mk
fi

# 修复 CPU 显示（官方无此文件，跳过）
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore 2>/dev/null || true
