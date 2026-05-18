#!/bin/bash
# DIY-2.sh - 克隆额外插件 & 修改固件参数

set -e  # 遇到错误即退出

# ======================= 1. 克隆额外插件 =======================
git clone --depth 1 https://github.com/WukongMaster/luci-app-poweroff.git package/luci-app-poweroff

rm -rf package/feeds/luci/luci-theme-argon
git clone --depth 1 -b master https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# ======================= 2. 修改固件参数 =======================
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 删除默认密码（如果文件存在）
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings 2>/dev/null || true

# 修改默认主题为 argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile 2>/dev/null || true

# 修改时间格式
find package/lean/autocore/files/ -type f -name "index.htm" -exec sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' {} \; 2>/dev/null || true

# 添加编译日期
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(BUILD_DATE_PREFIX)-/g' ./include/image.mk
sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX := $(shell date +'%F')' ./include/image.mk

# 修复 CPU 显示
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore 2>/dev/null || true
