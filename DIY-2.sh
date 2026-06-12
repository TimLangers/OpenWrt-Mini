#!/bin/bash
# File: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
set -e

echo "=== 正在执行 DIY 优化脚本 part2 ==="

# 1. 修改默认管理 IP 为 10.1.1.1
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

# 2. 移除不需要的 openhtml/opentomact 主题源码（防止编译进固件）
rm -rf feeds/luci/themes/luci-theme-opentomact 2>/dev/null
rm -rf package/feeds/luci/themes/luci-theme-opentomact 2>/dev/null

# 3. 强制设置 Argon 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# ==================== 以下为额外优化（可选，不影响核心功能）====================

# 4. 移除其他不需要的主题（减小固件体积）
# 如果只想保留 Argon，可以取消下面注释
# rm -rf feeds/luci/themes/luci-theme-bootstrap
# rm -rf feeds/luci/themes/luci-theme-material
# rm -rf feeds/luci/themes/luci-theme-openwrt-2020

# 5. 设置 Argon 主题为默认并配置一些参数（如果 argon 配置包存在）
if [ -f "package/luci-app-argon-config/Makefile" ] || [ -d "feeds/luci/applications/luci-app-argon-config" ]; then
    # 创建 uci-defaults 脚本以在首次启动时应用 Argon 设置
    mkdir -p package/base-files/files/etc/uci-defaults
    cat > package/base-files/files/etc/uci-defaults/99-argon-settings << 'EOF'
#!/bin/sh
# 设置 Argon 主题为默认
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
exit 0
EOF
    chmod +x package/base-files/files/etc/uci-defaults/99-argon-settings
    echo "✓ Argon 主题默认配置已添加"
fi

# 6. 调整默认语言为中文（如果存在中文包）
if grep -q "luci-i18n-base-zh-cn" tmp/.config-package.in 2>/dev/null; then
    sed -i 's/option lang auto/option lang zh-cn/g' package/base-files/files/etc/config/luci 2>/dev/null || true
    echo "✓ 默认语言已设置为中文"
fi

echo "=== DIY part2 脚本执行完成 ==="
