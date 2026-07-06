# Тема «Ember Blackout» — true black OLED + тёплый оранж

Палитра: фон **#060608** (true black, пиксели OLED off), слои `#0F0F12`/`#16161A`,
бордер `#242429`, текст `#C8C8D0`/`#E6E6EB`, dim `#6C6C78`,
акцент **#D2772E (Ember)** = `210,119,46`, hover `#E08A45`, pressed `#A85A20`,
success `#7A9F6C`, amber `#D2AA46`.

Источник правды цвета KDE — color-scheme **`BlackOrange.colors`** + скрипт **`accent`**.

## Применить после install.sh

```sh
plasma-apply-lookandfeel -a Redteam-Blood   # L&F-пакет (BlackOrange + char-white + WhiteSur + Breeze-стиль)
accent ember                                # схема BlackOrange + KDE-акцент + starship + kwin reconfigure
```

## Переключатель акцента (один скрипт на всё)

```sh
accent ember     # тёплый оранж #D2772E  (дефолт)
accent red       # кровь #FF2C2C  (старый redteam-вайб)
accent lime | cyan | amber
```

## Где живут цвета (если меняешь оттенок)

- **KDE:** `theme/color-schemes/BlackOrange.colors`, `kde/kdeglobals` (`AccentColor`), `kde/look-and-feel/Redteam-Blood/contents/defaults`
- **Терминал:** `ghostty/config` (основной, дефолтный), `theme/alacritty.toml`, `theme/konsole/RedteamBlood.colorscheme`
- **Shell:** `starship/starship.toml` (`[palettes.redteam]`), `fish/config.fish` (`fish_color_*`)
- **VS Code:** `vscode/settings.json` (`workbench.colorCustomizations` + `editor.tokenColorCustomizations`)
- **GTK:** `theme/gtk/gtk3.css`, `gtk4.css`
- **Прочее:** `misc/btop/themes/`, `misc/vesktop-themes/`, `zen/userChrome.css` + `zen/user.js`
- **Система (sudo):** `system/grub/`, `system/sddm/` → деплой `system/deploy-system.sh`

## KWin (аскет — приоритет скорости)

Эффекты blur/fade/scale/slide и тайлер krohnkite **выключены**, `AnimationDurationFactor=0`
(окна мгновенно), `LatencyPolicy=ExtremelyLow`. Оставлен drag-snap по краям (`ElectricBorderTiling=true`)
— виндовый Aero Snap. Хоткеи в `kde/kglobalshortcutsrc`: Meta+E (Dolphin), Meta+Return (Ghostty),
Meta+C (VS Code), Meta+Shift+B (Brave), Meta+Shift+S (скрин области), Meta+W (Overview).

## Обои

`theme/wallpapers/ember-blackout{,-glow,-line}.png` → `~/.local/share/wallpapers/ember-blackout/`
Применить: `plasma-apply-wallpaperimage ~/.local/share/wallpapers/ember-blackout/ember-blackout-glow.png`

- `ember-blackout.png` — чистый true black (макс OLED-экономия)
- `ember-blackout-glow.png` — true black + едва тёплый центр (дефолт)
- `ember-blackout-line.png` — true black + тонкая ember-диагональ

Генератор обоев: `magick -size 2560x1600 radial-gradient:'#130c07'-'#060608' out.png`

## Экран логина (SDDM) + GRUB — нужен sudo

Темы в `system/sddm/redteam-blood/` и `system/grub/redteam-blood/` (перекрашены в Ember).
Деплой одним скриптом: `sudo bash system/deploy-system.sh` (см. файл).

## Поп-ап «Share screen with org.chromium.Chromium»

Это фича Claude Code «Claude in Chrome» (`claude --claude-in-chrome-mcp`) — поднимает Chromium и просит экран.
Не системный баг. Если лезет — не подключать Chrome в панели Claude Code; процесс с `--no-chrome` поп-ап не вызывает.

## Фан-кривые по профилям (asusctl, enabled на каждом)

- Quiet (батарея): молчит до ~70C — `cpu "50c:0%,70c:0%,77c:18%,84c:33%,90c:52%,95c:72%,98c:90%,100c:100%"`
- Balanced (универсал/dev): тихо на idle — `cpu "50c:0%,62c:0%,70c:18%,77c:32%,84c:50%,89c:68%,94c:85%,99c:100%"`
- Performance (игры): агрессивно — `cpu "40c:25%,55c:40%,65c:55%,72c:70%,80c:85%,86c:95%,92c:100%,100c:100%"`
- (gpu/mid аналогично). Включить: `asusctl fan-curve --mod-profile <P> --enable-fan-curves true`
