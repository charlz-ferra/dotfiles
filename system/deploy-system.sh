#!/usr/bin/env bash
# Деплой системных частей темы Redteam/Blood (GRUB + SDDM). Запуск под root (sudo/pkexec).
# Источники берутся из самого репо (system/grub, system/sddm) — отдельная build-папка не нужна.
set -euo pipefail
BUILD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y-%m-%d)"

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
if grep -q '^GRUB_THEME=' /etc/default/grub; then
	sed -i 's#^GRUB_THEME=.*#GRUB_THEME="/usr/share/grub/themes/redteam-blood/theme.txt"#' /etc/default/grub
else
	printf '\nGRUB_THEME="/usr/share/grub/themes/redteam-blood/theme.txt"\n' >>/etc/default/grub
fi
grep '^GRUB_THEME' /etc/default/grub

echo "== 4. grub-mkconfig =="
grub-mkconfig -o /boot/grub/grub.cfg 2>&1 | tail -4

echo "== 5. SDDM конфиг → redteam-blood =="
mkdir -p /etc/sddm.conf.d
cp -a /etc/sddm.conf.d/10-catppuccin.conf "/etc/sddm.conf.d/10-catppuccin.conf.bak-redteam-$TS" 2>/dev/null || true
printf '[Theme]\nCurrent=redteam-blood\n' >/etc/sddm.conf.d/10-theme.conf
printf '# отключено — заменено на 10-theme.conf (redteam-blood)\n' >/etc/sddm.conf.d/10-catppuccin.conf
echo "  ✓ активная SDDM-тема:"
cat /etc/sddm.conf.d/10-theme.conf

echo "== DONE =="
