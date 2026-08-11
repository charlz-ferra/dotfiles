# Тема «MonoBlack» — строгий монохром (чёрный / белый / серый)

Палитра: фон **#060608** (true black, пиксели OLED off), слои `#0F0F12`/`#16161A`,
бордер `#242429`, текст `#C8C8D0`/`#E6E6EB`, dim `#6C6C78`,
акцент **#d0d0d8** = `208,208,216`, hover `#e8e8ee`, pressed `#96969e`.
Ни одного цветного пятна — только оттенки серого, везде.

Источник правды цвета KDE — color-scheme **`MonoBlack.colors`** + скрипт **`accent`**.

## Применить после install.sh

```sh
plasma-apply-lookandfeel -a MonoBlack   # L&F-пакет (MonoBlack + char-white + WhiteSur + Breeze-декорация)
accent                                   # переасертить MonoBlack: схема + KDE-акцент + starship + kwin reconfigure
```

`accent` не принимает цветов — тема одна, строго монохром. Запускать после
apply Global Theme (KDE перетинчивает Header акцентом) или чтобы вернуть палитру.

## Где живут оттенки серого (если правишь)

- **KDE:** `theme/color-schemes/MonoBlack.colors`, `kde/kdeglobals` (`AccentColor`), `kde/look-and-feel/MonoBlack/contents/defaults`
- **Терминал:** `ghostty/config` (основной, дефолтный), `theme/alacritty.toml`, `theme/konsole/MonoBlack.colorscheme`
- **Shell:** `starship/starship.toml` (`accent`/`bright`), `fish/config.fish` (`fish_color_*`)
- **VS Code:** `vscode/settings.json` (`workbench.colorCustomizations` + `editor.tokenColorCustomizations` — grayscale-подсветка)
- **GTK:** `theme/gtk/gtk3.css`, `gtk4.css`
- **Прочее:** `misc/btop/themes/`, `misc/vesktop-themes/`, `zen/userChrome.css` + `zen/user.js`
- **Система (sudo):** `system/grub/monoblack/`, `system/sddm/monoblack/` → деплой `system/deploy-system.sh`

## KWin (аскет — приоритет скорости)

Эффекты blur/fade/scale/slide и тайлер krohnkite **выключены**, `AnimationDurationFactor=0`
(окна мгновенно), `LatencyPolicy=ExtremelyLow`. Оставлен drag-snap по краям (`ElectricBorderTiling=true`)
— виндовый Aero Snap. Хоткеи в `kde/kglobalshortcutsrc`: Meta+E (Dolphin), Meta+Return (Ghostty),
Meta+C (VS Code), Meta+Shift+B (Brave), Meta+Shift+S (скрин области), Meta+W (Overview).

## Обои

`theme/wallpapers/blackout{,-glow,-line}.png` → `~/.local/share/wallpapers/blackout/`
Применить: `plasma-apply-wallpaperimage ~/.local/share/wallpapers/blackout/blackout.png`

- `blackout.png` — чистый true black (макс OLED-экономия)
- `blackout-glow.png` — true black + едва заметный серый центр
- `blackout-line.png` — true black + тонкая серая диагональ

Генератор обоев: `magick -size 2560x1600 radial-gradient:'#101013'-'#060608' out.png`

## Экран логина (SDDM) + GRUB — нужен sudo

Темы в `system/sddm/monoblack/` и `system/grub/monoblack/` — строгий монохром,
ассеты в grayscale RGBA (GRUB-ридер не умеет палитровые PNG). Деплой одним
скриптом: `sudo bash system/deploy-system.sh` (см. файл).

## Поп-ап «Share screen with org.chromium.Chromium»

Это фича Claude Code «Claude in Chrome» (`claude --claude-in-chrome-mcp`) — поднимает Chromium и просит экран.
Не системный баг. Если лезет — не подключать Chrome в панели Claude Code; процесс с `--no-chrome` поп-ап не вызывает.

## Фан-кривые по профилям (asusctl, enabled на каждом)

- Quiet (батарея): молчит до ~70C — `cpu "50c:0%,70c:0%,77c:18%,84c:33%,90c:52%,95c:72%,98c:90%,100c:100%"`
- Balanced (универсал/dev): тихо на idle — `cpu "50c:0%,62c:0%,70c:18%,77c:32%,84c:50%,89c:68%,94c:85%,99c:100%"`
- Performance (игры): агрессивно — `cpu "40c:25%,55c:40%,65c:55%,72c:70%,80c:85%,86c:95%,92c:100%,100c:100%"`
- (gpu/mid аналогично). Включить: `asusctl fan-curve --mod-profile <P> --enable-fan-curves true`
