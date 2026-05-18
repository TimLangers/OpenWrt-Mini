#!/bin/bash
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 1. 强力克隆 OpenClash 官方最新主分支源码
git clone -b master https://github.com/vernesong/OpenClash.git package/luci-app-openclash

# 2. 克隆 jerrykuku 的 Argon 最新精美主题及配置后台源码
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
