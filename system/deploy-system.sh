#!/usr/bin/env bash
# Деплой системных частей темы MonoBlack (GRUB + SDDM). Запуск под root (sudo/pkexec).
# Источники берутся из самого репо (system/grub, system/sddm) — отдельная build-папка не нужна.
set -euo pipefail
BUILD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y-%m-%d)"

echo "== 1. GRUB-тема =="
rm -rf /usr/share/grub/themes/monoblack
cp -r "$BUILD/grub/monoblack" /usr/share/grub/themes/monoblack
echo "  ✓ /usr/share/grub/themes/monoblack"

echo "== 2. SDDM-тема =="
rm -rf /usr/share/sddm/themes/monoblack
cp -r "$BUILD/sddm/monoblack" /usr/share/sddm/themes/monoblack
echo "  ✓ /usr/share/sddm/themes/monoblack"

echo "== 3. /etc/default/grub (бэкап + GRUB_THEME) =="
cp -a /etc/default/grub "/etc/default/grub.bak-monoblack-$TS"
if grep -q '^GRUB_THEME=' /etc/default/grub; then
	sed -i 's#^GRUB_THEME=.*#GRUB_THEME="/usr/share/grub/themes/monoblack/theme.txt"#' /etc/default/grub
else
	printf '\nGRUB_THEME="/usr/share/grub/themes/monoblack/theme.txt"\n' >>/etc/default/grub
fi
grep '^GRUB_THEME' /etc/default/grub

echo "== 4. grub-mkconfig =="
grub-mkconfig -o /boot/grub/grub.cfg 2>&1 | tail -4

echo "== 5. SDDM конфиг → monoblack =="
mkdir -p /etc/sddm.conf.d
cp -a /etc/sddm.conf.d/10-catppuccin.conf "/etc/sddm.conf.d/10-catppuccin.conf.bak-monoblack-$TS" 2>/dev/null || true
printf '[Theme]\nCurrent=monoblack\n' >/etc/sddm.conf.d/10-theme.conf
printf '# отключено — заменено на 10-theme.conf (monoblack)\n' >/etc/sddm.conf.d/10-catppuccin.conf
echo "  ✓ активная SDDM-тема:"
cat /etc/sddm.conf.d/10-theme.conf

echo "== DONE =="
