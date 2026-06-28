#!/bin/bash
# File: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
set -e

echo "=== 正在执行 DIY 优化脚本 part1 ==="

# ==================== 确保 .config 存在（可选） ====================
if [ ! -f .config ]; then
    echo "⚠️ 未检测到 .config 文件，正在生成默认配置..."
    make defconfig
fi

# ==================== 架构检查（改为仅警告，不退出） ====================
echo "=== 检查架构配置 ==="
if grep -q "CONFIG_TARGET_x86_64=y" .config; then
    echo "✓ 架构检测通过：当前为 x86_64"
else
    echo "⚠️ 警告：.config 中未启用 x86_64，若目标平台非 x86_64 可忽略此警告"
fi

# ==================== 修复 Golang 编译路径 ====================
find feeds/packages -name "Makefile" -type f | xargs -i sed -i 's#../../lang/golang/#$(TOPDIR)/feeds/packages/lang/golang/#g' {} 2>/dev/null || true

# ==================== 优化 sing-box（如果存在） ====================
if [ -f "package/custom/sing-box/Makefile" ]; then
    sed -i '/^GO_PKG_LDFLAGS_X/a GO_PKG_VARS:=GOGC=50 CGO_ENABLED=0' package/custom/sing-box/Makefile
fi

# ==================== 防火墙与 LuCI 修复 ====================
sed -i 's/"iptables"/"iptables-nft"/g' feeds/luci/modules/luci-base/root/usr/share/rpcd/acl.d/luci-base.json 2>/dev/null || true

# ==================== uci-defaults 系统设置 ====================
mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-custom-settings << 'EOF'
#!/bin/sh
uci set network.lan.ipaddr='10.1.1.1'
uci set network.lan.netmask='255.255.255.0'
uci set system.@system[0].hostname='OpenWrt'
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'
uci commit network
uci commit system
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-custom-settings

echo "=== DIY part1 脚本执行完成 ==="
