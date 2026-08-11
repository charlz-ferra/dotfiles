#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  sync.sh — pulls current system configs back into the repo
#  Run after tweaking settings, then git commit.
#  Usage:  ./sync.sh
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODE_USER="$HOME/.config/Code/User"

echo "═══ Pulling fresh configs from the system into the repo ═══"

cp -v "$HOME/.config/fish/config.fish" "$DOT/fish/config.fish"
cp -v "$HOME/.config/starship.toml" "$DOT/starship/starship.toml"
mkdir -p "$DOT/ghostty"
cp -v "$HOME/.config/ghostty/config" "$DOT/ghostty/config" 2>/dev/null || true
cp -v "$CODE_USER/settings.json" "$DOT/vscode/settings.json"
cp -v "$CODE_USER/keybindings.json" "$DOT/vscode/keybindings.json"
cp -v "$CODE_USER"/snippets/*.code-snippets "$DOT/vscode/snippets/" 2>/dev/null || true

# NOTE: ~/.gitconfig is NOT synced automatically — it contains your
# identity. The repo ships placeholders on purpose. Update by hand.

# refresh extension list
if command -v code >/dev/null 2>&1; then
	code --list-extensions | sort >"$DOT/vscode/extensions.txt"
	echo "  extension list refreshed ($(wc -l <"$DOT/vscode/extensions.txt") items)"
fi

echo "── Themes (Blackout / MonoBlack) ──"
mkdir -p "$DOT/theme/color-schemes" "$DOT/theme/konsole" "$DOT/theme/gtk" "$DOT/theme/wallpapers"
cp -v "$HOME"/.local/share/color-schemes/MonoBlack*.colors "$DOT/theme/color-schemes/" 2>/dev/null || true
cp -v "$HOME/.local/share/color-schemes/MonoBlack.colors" "$DOT/theme/color-schemes/" 2>/dev/null || true
cp -v "$HOME/.local/share/konsole/MonoBlack.profile" "$DOT/theme/konsole/" 2>/dev/null || true
cp -v "$HOME/.local/share/konsole/MonoBlack.colorscheme" "$DOT/theme/konsole/" 2>/dev/null || true
cp -v "$HOME/.config/alacritty/alacritty.toml" "$DOT/theme/alacritty.toml" 2>/dev/null || true
cp -v "$HOME/.config/gtk-3.0/settings.ini" "$DOT/theme/gtk/gtk3-settings.ini" 2>/dev/null || true
cp -v "$HOME/.config/gtk-4.0/settings.ini" "$DOT/theme/gtk/gtk4-settings.ini" 2>/dev/null || true
cp -v "$HOME/.config/gtk-3.0/gtk.css" "$DOT/theme/gtk/gtk3.css" 2>/dev/null || true
cp -v "$HOME/.config/gtk-4.0/gtk.css" "$DOT/theme/gtk/gtk4.css" 2>/dev/null || true
cp -v "$HOME/.local/bin/accent" "$DOT/theme/accent" 2>/dev/null || true
for w in monoblack blackout blackout-glow blackout-line; do
	cp -v "$HOME/.local/share/wallpapers/$w.png" "$DOT/theme/wallpapers/" 2>/dev/null || true
done

echo "── Icon override (char-white) ──"
if [ -d "$HOME/.local/share/icons/char-white" ]; then
	mkdir -p "$DOT/theme/icons/char-white"
	cp -r "$HOME/.local/share/icons/char-white/." "$DOT/theme/icons/char-white/"
fi

echo "── KDE / Qt ──"
for k in kdeglobals kwinrc kcminputrc ksplashrc; do
	cp -v "$HOME/.config/$k" "$DOT/kde/$k" 2>/dev/null || true
done
cp -v "$HOME/.config/Kvantum/kvantum.kvconfig" "$DOT/kvantum/kvantum.kvconfig" 2>/dev/null || true
# NOTE: kscreenlockerrc is NOT synced — the system copy carries an absolute
# /home/<user> wallpaper path. The repo ships a sanitized version; edit by hand.

echo "── Misc ──"
cp -v "$HOME/.config/btop/btop.conf" "$DOT/misc/btop/btop.conf" 2>/dev/null || true
cp -v "$HOME/.config/btop/themes/monoblack.theme" "$DOT/misc/btop/themes/" 2>/dev/null || true
cp -v "$HOME/.config/fastfetch/config.jsonc" "$DOT/misc/fastfetch/config.jsonc" 2>/dev/null || true
cp -v "$HOME/.config/vesktop/themes/monoblack.css" "$DOT/misc/vesktop-themes/" 2>/dev/null || true

echo ""
echo "✅ Repo updated. Review the diff before committing —"
echo "   watch for absolute paths and identity leaks:"
echo "   git diff --stat && git diff | grep -nE '/home/|@' || true"
