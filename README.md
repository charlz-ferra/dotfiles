# dotfiles

> CachyOS (Arch) · KDE Plasma / Wayland · fish · ghostty · true black with one warm accent

![Redteam-Blood](kde/look-and-feel/Redteam-Blood/contents/previews/fullscreenpreview.jpg)

A full desktop rice built around one idea: **the machine should look like it
means business.** Zero visual noise from GRUB to the browser chrome, and a
single accent color doing all the talking. Two moods, one accent away:

- **Ember Blackout** — the daily driver. True black `#060608` (OLED pixels
  off), warm ember `#d2772e`. Muted, calm, zero acid.
- **Redteam / Blood** — graphite + blood red `#ff2c2c`. GRUB, SDDM, konsole
  and the Plasma Global Theme still carry it.

Switching accents across KDE/fish/terminals is one command: `accent ember`.

## What's inside

| Path        | What                                                                                                    |
| ----------- | ------------------------------------------------------------------------------------------------------- |
| `fish/`     | fish config: starship, zoxide, fzf, abbreviations that expand in place                                  |
| `starship/` | prompt — git status, language versions, command duration                                                |
| `ghostty/`  | Ember Blackout terminal: palette, JetBrainsMono, sane keybinds                                          |
| `git/`      | gitconfig (aliases, delta, zdiff3) + global ignore — identity is a placeholder                          |
| `vscode/`   | settings, keybindings, snippets, extension list                                                         |
| `theme/`    | color schemes (BlackOrange + Redteam Blood/Amber/Cyan/Lime), konsole, alacritty, GTK, icons, wallpapers, `accent` switcher |
| `kde/`      | Plasma Look-and-Feel package + kdeglobals/kwinrc/kcminputrc/ksplashrc/kscreenlockerrc                   |
| `kvantum/`  | Qt theming                                                                                              |
| `system/`   | **GRUB theme** + **SDDM theme** (Redteam-Blood, QML) + root deploy script                               |
| `zen/`      | Zen Browser: hardened `user.js` (telemetry off, privacy prefs that don't break sites), `userChrome.css`, `policies.json` |
| `misc/`     | btop theme, fastfetch config, vesktop (Discord) theme                                                   |

## Install

```bash
git clone https://github.com/charlz-ferra/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh        # backs up everything it touches, timestamped
```

Dependencies:

```bash
sudo pacman -S --needed fish starship zoxide fzf git-delta eza bat fd ripgrep github-cli
sudo pacman -S --needed ttf-jetbrains-mono-nerd ttf-meslo-nerd   # Nerd Fonts for icons
```

GRUB/SDDM themes need root and are deployed separately:

```bash
sudo ./system/deploy-system.sh
```

Apply-commands that aren't files (colorscheme, konsole default, KWin bits)
live in [`theme/NOTES.md`](theme/NOTES.md).

## Sync back

`./sync.sh` pulls the current system configs into the repo. It deliberately
skips `~/.gitconfig` and `kscreenlockerrc` — both carry identity or absolute
paths. Review the diff before committing; the last line of the script greps
for the usual leaks.

## License

MIT — take the theme, leave the paranoia. Or take both.
