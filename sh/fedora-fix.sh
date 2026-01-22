#!/bin/bash

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then 
  echo "请使用 sudo 运行此脚本: sudo $0"
  exit 1
fi

# 获取无线网卡名称 (默认为 wlp1s0，如果不存在则尝试自动获取)
WIFI_DEV=$(ip link show | grep 'wlp' | awk -F': ' '{print $2}' | head -n 1)
WIFI_DEV=${WIFI_DEV:-wlp1s0}

show_menu() {
    echo "================================================="
    echo "       Fedora 网络与系统自动化修复工具           "
    echo "================================================="
    echo "1) 标准软件重置 (清理 NetworkManager 状态与 DNS)"
    echo "2) 驱动与硬件重构 (针对 ath11k 延迟/丢包)"
    echo "3) 系统自检修复 (处理紧急模式/SELinux 权限)"
    echo "4) 性能锁定优化 (永久禁用省电模式/IPv6)"
    echo "5) 执行全部修复 (按顺序执行 1-3)"
    echo "q) 退出"
    echo "================================================="
    printf "请选择操作 [1-5/q]: "
}

# 方案 1: 标准软件重置
fix_nm() {
    echo "正在重置 NetworkManager..."
    systemctl stop NetworkManager
    rm -f /var/lib/NetworkManager/NetworkManager.state
    resolvectl flush-caches
    echo "是否要删除所有已保存的 Wi-Fi 密码？(y/N)"
    read -r confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        rm -rf /etc/NetworkManager/system-connections/*
        echo "已清理所有 Wi-Fi 连接配置。"
    fi
    systemctl start NetworkManager
    nmcli networking off && nmcli networking on
    echo "软件重置完成。"
}

# 方案 2: 驱动与硬件同步
fix_driver() {
    echo "正在重置驱动模块 ath11k_pci..."
    modprobe -r ath11k_pci 2>/dev/null
    sleep 1
    modprobe ath11k_pci
    echo "正在关闭网卡电源管理 ($WIFI_DEV)..."
    iw dev "$WIFI_DEV" set power_save off 2>/dev/null
    echo "驱动重载完成。"
    echo "提示：如果仍有 400ms+ 延迟，请手动执行【物理冷启动】：关机 -> 拔电 -> 长按电源键 20s。"
}

# 方案 3: 系统级修复
fix_system() {
    echo "正在设置修复标记..."
    # 解锁 Root (如果尚未设置密码)
    echo "建议重置 Root 密码以防控制台锁定:"
    passwd root
    # 磁盘自检标记
    touch /forcefsck
    # SELinux 标签重置
    touch /.autorelabel
    echo "修复标记已创建。下次重启时，系统将自动进行磁盘自检和权限修复，耗时较长请耐心等待。"
}

# 方案 4: 性能锁定
lock_performance() {
    echo "正在写入永久优化配置..."
    # 禁用 NM 省电
    mkdir -p /etc/NetworkManager/conf.d/
    echo -e "[connection]\nwifi.powersave = 2" > /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
    # 禁用 IPv6
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    echo "性能锁定完成。"
}

while true; do
    show_menu
    read -r choice
    case $choice in
        1) fix_nm ;;
        2) fix_driver ;;
        3) fix_system ;;
        4) lock_performance ;;
        5) fix_nm; fix_driver; fix_system ;;
        q) exit 0 ;;
        *) echo "无效选项，请重试。" ;;
    esac
    echo -e "\n操作结束，按任意键继续..."
    read -n 1
done