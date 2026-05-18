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
修改后的 diy-part2.sh
bash
#!/bin/bash
# 此脚本功能：定制固件与克隆插件（含 PassWall 强制更新）
# =======================================================================================

# --- 1. 强制更新 PassWall 到最新代码 (方法2) ---
# 注意：此操作必须在 ./scripts/feeds install -a 之后执行

# 移除 feeds 中自带的核心库（避免版本冲突）
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls,haproxy}

# 克隆最新依赖库到 package/ （将覆盖 feeds 版本）
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/passwall-packages

# 移除 feeds 中自带的旧版 luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall

# 克隆最新版 PassWall LuCI 到 package/
git clone --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall-luci

# --- 2. 其他插件克隆 ---
git clone --depth 1 https://github.com/esirplayground/luci-app-poweroff.git package/luci-app-poweroff

rm -rf package/feeds/luci/luci-theme-argon
git clone --depth 1 -b master https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# --- 3. 固件参数修改 (保留你原来的所有 sed 命令) ---
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.12/g' ./target/linux/x86/Makefile
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
find package/lean/autocore/files/ -type f -name "index.htm" -exec sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' {} \;
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(BUILD_DATE_PREFIX)-/g' ./include/image.mk
sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX := $(shell date +'%F')' ./include/image.mk
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore
