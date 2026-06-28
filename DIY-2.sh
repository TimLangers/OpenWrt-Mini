#!/bin/bash
# File: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
set -e

echo "=== 正在执行 DIY 优化脚本 part2 ==="

# 1. 修改默认管理 IP 为 10.1.1.1（只在这里改一次，part1 中删掉重复的）
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 移除不需要的 opentomact 主题源码（防止编译进固件）
rm -rf feeds/luci/themes/luci-theme-opentomact 2>/dev/null || true
rm -rf package/feeds/luci/themes/luci-theme-opentomact 2>/dev/null || true

# 3. 强制设置 Argon 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 4. 设置 Argon 为默认主题（uci-defaults）
mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-argon-default << 'EOF'
#!/bin/sh
# 设置 Argon 为默认主题（如果尚未设置）
if ! uci get luci.main.mediaurlbase >/dev/null 2>&1; then
    uci set luci.main.mediaurlbase='/luci-static/argon'
    uci commit luci
fi
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-argon-default

# ==================== 🆕 添加中文语言包 ====================
echo "CONFIG_PACKAGE_luci-i18n-base-zh-cn=y" >> .config

echo "=== DIY part2 脚本执行完成 ==="
echo "=== DIY part2 脚本执行完成 ==="
