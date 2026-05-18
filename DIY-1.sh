#!/bin/bash
# DIY-1.sh for OK1.config (精简版)
# 功能：清理可能过时的第三方源，避免 feeds update 报错

FEEDS_FILE="feeds.conf.default"

# 1. 注释掉或删除已知可能出错的源（精确匹配行）
sed -i '/helloworld/s/^/#/' $FEEDS_FILE
sed -i '/passwall/s/^/#/' $FEEDS_FILE
sed -i '/openclash/s/^/#/' $FEEDS_FILE

# 2. 不添加任何第三方源（OK1 不需要）
