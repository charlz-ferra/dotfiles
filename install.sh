#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  install.sh — deploys dotfiles onto a machine
#  Copies configs from the repo into the system, backing up
#  anything it overwrites (timestamped .bak).
#  Usage:  ./install.sh
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"
CODE_USER="$HOME/.config/Code/User"

# Copy a file, backing up the existing one
link() {
	local src="$1" dst="$2"
	mkdir -p "$(dirname "$dst")"
	if [ -e "$dst" ]; then
		cp -a "$dst" "$dst.bak-$TS"
		echo "  backup: $dst → $dst.bak-$TS"
	fi
	cp -v "$src" "$dst"
}

echo "═══ Deploying dotfiles from $DOT ═══"

echo "── fish ──"
link "$DOT/fish/config.fish" "$HOME/.config/fish/config.fish"
mkdir -p "$HOME/.config/fish/functions"
cp -v "$DOT"/fish/functions/*.fish "$HOME/.config/fish/functions/" 2>/dev/null || true

echo "── starship ──"
link "$DOT/starship/starship.toml" "$HOME/.config/starship.toml"

echo "── Ghostty ──"
[ -f "$DOT/ghostty/config" ] && link "$DOT/ghostty/config" "$HOME/.config/ghostty/config" || true

echo "── git ──"
echo "  ⚠️  git/gitconfig ships with PLACEHOLDER identity — edit [user] first!"
link "$DOT/git/gitconfig" "$HOME/.gitconfig"
link "$DOT/git/ignore" "$HOME/.config/git/ignore"

echo "── VS Code ──"
link "$DOT/vscode/settings.json" "$CODE_USER/settings.json"
link "$DOT/vscode/keybindings.json" "$CODE_USER/keybindings.json"
mkdir -p "$CODE_USER/snippets"
cp -v "$DOT"/vscode/snippets/*.code-snippets "$CODE_USER/snippets/" 2>/dev/null || true

echo "── VS Code extensions ──"
if command -v code >/dev/null 2>&1; then
	while read -r ext; do
		[ -z "$ext" ] && continue || true
		echo "  installing $ext"
		code --install-extension "$ext" --force >/dev/null 2>&1 || echo "  ⚠️ failed: $ext"
	done <"$DOT/vscode/extensions.txt"
else
	echo "  ⚠️ 'code' not found — skipping extensions"
fi

echo "── Themes (Ember Blackout / Redteam-Blood) ──"
mkdir -p "$HOME/.local/share/color-schemes" "$HOME/.local/share/konsole" "$HOME/.config/alacritty" "$HOME/.local/bin" "$HOME/.local/share/wallpapers"
for c in "$DOT"/theme/color-schemes/*.colors; do
	[ -f "$c" ] && link "$c" "$HOME/.local/share/color-schemes/$(basename "$c")" || true
done
[ -f "$DOT/theme/konsole/RedteamBlood.profile" ] && link "$DOT/theme/konsole/RedteamBlood.profile" "$HOME/.local/share/konsole/RedteamBlood.profile" || true
[ -f "$DOT/theme/konsole/RedteamBlood.colorscheme" ] && link "$DOT/theme/konsole/RedteamBlood.colorscheme" "$HOME/.local/share/konsole/RedteamBlood.colorscheme" || true
[ -f "$DOT/theme/alacritty.toml" ] && link "$DOT/theme/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml" || true
[ -f "$DOT/theme/gtk/gtk3-settings.ini" ] && link "$DOT/theme/gtk/gtk3-settings.ini" "$HOME/.config/gtk-3.0/settings.ini" || true
[ -f "$DOT/theme/gtk/gtk4-settings.ini" ] && link "$DOT/theme/gtk/gtk4-settings.ini" "$HOME/.config/gtk-4.0/settings.ini" || true
[ -f "$DOT/theme/gtk/gtk3.css" ] && link "$DOT/theme/gtk/gtk3.css" "$HOME/.config/gtk-3.0/gtk.css" || true
[ -f "$DOT/theme/gtk/gtk4.css" ] && link "$DOT/theme/gtk/gtk4.css" "$HOME/.config/gtk-4.0/gtk.css" || true
for w in "$DOT"/theme/wallpapers/*.png; do
	[ -f "$w" ] && cp -v "$w" "$HOME/.local/share/wallpapers/" || true
done
[ -f "$DOT/theme/accent" ] && {
	link "$DOT/theme/accent" "$HOME/.local/bin/accent"
	chmod +x "$HOME/.local/bin/accent"
} || true

echo "── Icon override: char-white (breeze-dark fallback, fixes '?' icons) ──"
if [ -d "$DOT/theme/icons/char-white" ]; then
	mkdir -p "$HOME/.local/share/icons/char-white"
	cp -r "$DOT/theme/icons/char-white/." "$HOME/.local/share/icons/char-white/"
	command -v gtk-update-icon-cache >/dev/null && gtk-update-icon-cache -f "$HOME/.local/share/icons/char-white" 2>/dev/null || true
fi

echo "── KDE Global Theme: Redteam-Blood ──"
[ -d "$DOT/kde/look-and-feel/Redteam-Blood" ] && {
	mkdir -p "$HOME/.local/share/plasma/look-and-feel"
	cp -r "$DOT/kde/look-and-feel/Redteam-Blood" "$HOME/.local/share/plasma/look-and-feel/"
	echo "  ✓ L&F installed (apply: plasma-apply-lookandfeel -a Redteam-Blood)"
} || true

echo "── KDE / Qt ──"
mkdir -p "$HOME/.config/Kvantum"
for k in kdeglobals kwinrc kcminputrc ksplashrc kscreenlockerrc; do
	[ -f "$DOT/kde/$k" ] && link "$DOT/kde/$k" "$HOME/.config/$k" || true
done
[ -f "$DOT/kvantum/kvantum.kvconfig" ] && link "$DOT/kvantum/kvantum.kvconfig" "$HOME/.config/Kvantum/kvantum.kvconfig" || true

echo "── Zen Browser (hardened user.js + userChrome theme) ──"
# active profile = "Default (release)", NOT the first alphabetically
ZP="$(ls -d "$HOME"/.config/zen/*"Default (release)"/ 2>/dev/null | head -1 || true)"
[ -z "$ZP" ] && ZP="$(ls -d "$HOME"/.config/zen/*.Default*/ 2>/dev/null | head -1)" || true
[ -n "$ZP" ] && [ -f "$DOT/zen/user.js" ] && link "$DOT/zen/user.js" "$ZP/user.js" || true
[ -n "$ZP" ] && [ -f "$DOT/zen/userChrome.css" ] && link "$DOT/zen/userChrome.css" "$ZP/chrome/userChrome.css" || true

echo "── Misc (btop / fastfetch / vesktop theme) ──"
mkdir -p "$HOME/.config/btop/themes" "$HOME/.config/fastfetch" "$HOME/.config/vesktop/themes"
[ -f "$DOT/misc/btop/btop.conf" ] && link "$DOT/misc/btop/btop.conf" "$HOME/.config/btop/btop.conf" || true
[ -f "$DOT/misc/btop/themes/redteam-blood.theme" ] && link "$DOT/misc/btop/themes/redteam-blood.theme" "$HOME/.config/btop/themes/redteam-blood.theme" || true
[ -f "$DOT/misc/fastfetch/config.jsonc" ] && link "$DOT/misc/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc" || true
[ -f "$DOT/misc/vesktop-themes/redteam-blood.css" ] && link "$DOT/misc/vesktop-themes/redteam-blood.css" "$HOME/.config/vesktop/themes/redteam-blood.css" || true

echo ""
echo "✅ Done. Restart fish and VS Code."
echo "⚠️  Edit [user] in ~/.gitconfig — it ships with placeholders."
echo "ℹ️  Theme apply commands (Ember Blackout accent, konsole default): theme/NOTES.md"
echo "ℹ️  GRUB/SDDM themes are NOT auto-installed (need root) — see system/deploy-system.sh"
