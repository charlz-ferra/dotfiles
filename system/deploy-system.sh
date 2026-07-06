#!/usr/bin/env bash
# Деплой системных частей темы Redteam/Blood (GRUB + SDDM). Запуск под root (pkexec).
set -euo pipefail
BUILD="$HOME/redteam-theme-build"
TS=2026-06-07

echo "== 1. GRUB-тема =="
rm -rf /usr/share/grub/themes/redteam-blood
cp -r "$BUILD/grub/redteam-blood" /usr/share/grub/themes/redteam-blood
echo "  ✓ /usr/share/grub/themes/redteam-blood"

echo "== 2. SDDM-тема =="
rm -rf /usr/share/sddm/themes/redteam-blood
cp -r "$BUILD/sddm/redteam-blood" /usr/share/sddm/themes/redteam-blood
echo "  ✓ /usr/share/sddm/themes/redteam-blood"

echo "== 3. /etc/default/grub (бэкап + GRUB_THEME) =="
cp -a /etc/default/grub "/etc/default/grub.bak-redteam-$TS"
sed -i 's#^GRUB_THEME=.*#GRUB_THEME="/usr/share/grub/themes/redteam-blood/theme.txt"#' /etc/default/grub
grep '^GRUB_THEME' /etc/default/grub

echo "== 4. grub-mkconfig =="
grub-mkconfig -o /boot/grub/grub.cfg 2>&1 | tail -4

echo "== 5. SDDM конфиг → redteam-blood =="
cp -a /etc/sddm.conf.d/10-catppuccin.conf "/etc/sddm.conf.d/10-catppuccin.conf.bak-redteam-$TS" 2>/dev/null || true
printf '[Theme]\nCurrent=redteam-blood\n' >/etc/sddm.conf.d/10-theme.conf
printf '# отключено — заменено на 10-theme.conf (redteam-blood)\n' >/etc/sddm.conf.d/10-catppuccin.conf
echo "  ✓ активная SDDM-тема:"
cat /etc/sddm.conf.d/10-theme.conf

echo "== DONE =="
