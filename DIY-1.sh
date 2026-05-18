#!/bin/bash
# DIY-2.sh for OK1.config (精简版) - 管理地址改为 10.1.1.1

set -e

# ======================= 固件参数修改 =======================
# 修改默认管理 IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 删除 root 默认密码
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings 2>/dev/null || true

# 修改时间格式
find package/lean/autocore/files/ -type f -name "index.htm" -exec sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' {} \; 2>/dev/null || true

# 添加编译日期到固件文件名
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(BUILD_DATE_PREFIX)-/g' ./include/image.mk
sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX := $(shell date +'%F')' ./include/image.mk

# 修复 x86 状态页 CPU 显示
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore 2>/dev/null || true
