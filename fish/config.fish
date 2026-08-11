source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting — отключаем fastfetch при старте терминала
# (запустить вручную: просто набери `fastfetch`)
function fish_greeting
end

# ===== Claude Code: GPU Aliases =====
# NVIDIA запуск
alias code-nvidia="prime-run code"
alias steam-nvidia="prime-run steam"
alias firefox-nvidia="prime-run firefox"

# Проверка температур
alias temps="sensors | grep -E 'Core|Package|Temp|cpu_fan|gpu_fan'"

# Яркость OLED
alias bright-up="echo (math (cat /sys/class/backlight/intel_backlight/max_brightness) / 20) | pkexec tee /sys/class/backlight/intel_backlight/brightness > /dev/null"
alias bright-down="echo (math (cat /sys/class/backlight/intel_backlight/brightness) - (cat /sys/class/backlight/intel_backlight/max_brightness) / 20) | pkexec tee /sys/class/backlight/intel_backlight/brightness > /dev/null"

# ASUS профили
alias fan-silent="asusctl profile -n"
alias fan-perf="asusctl profile -p"
alias fan-bal="asusctl profile -b"

# GPU статус
alias gpu-status="nvidia-smi --query-gpu=power.draw,utilization.gpu,temperature.gpu --format=csv"

# ═══════════════════════════════════════════════════════════════
#  ПРОКАЧКА ТЕРМИНАЛА (добавлено Claude) — интерактивный режим
# ═══════════════════════════════════════════════════════════════
if status is-interactive
    # ─── Starship: красивый быстрый промпт ───
    if type -q starship
        starship init fish | source
    end

    # ─── zoxide: умный cd (z <часть пути>, zi — интерактивно) ───
    if type -q zoxide
        zoxide init fish | source
    end

    # ─── fzf: Ctrl+R история, Ctrl+T файлы, Alt+C переход в папку ───
    if type -q fzf
        fzf --fish | source
        set -gx FZF_DEFAULT_OPTS "--height 40% --layout reverse --border --inline-info"
        # fd как движок поиска (быстрее find, уважает .gitignore)
        if type -q fd
            set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
            set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
            set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
        end
    end

    # ─── bat как красивый pager/cat ───
    if type -q bat
        set -gx PAGER "bat --plain"
        set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    end

    # ─── yazi: файловый менеджер в терминале ───
    # `y` запускает yazi и при выходе переходит в выбранный каталог
    if type -q yazi
        function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
        end
    end
end

# ═══════════════════════════════════════════════════════════════
#  АББРЕВИАТУРЫ (разворачиваются при пробеле — видно полную команду)
# ═══════════════════════════════════════════════════════════════
if status is-interactive
    # eza вместо ls (иконки + цвета)
    if type -q eza
        abbr -a ls  'eza --icons --group-directories-first'
        abbr -a ll  'eza -l --icons --group-directories-first --git'
        abbr -a la  'eza -la --icons --group-directories-first --git'
        abbr -a lt  'eza --tree --level=2 --icons'
        abbr -a tree 'eza --tree --icons'
    end
    type -q bat; and abbr -a cat 'bat'

    # git (под пацанский воркфлоу)
    abbr -a g    'git'
    abbr -a gs   'git status -sb'
    abbr -a ga   'git add'
    abbr -a gaa  'git add -A'
    abbr -a gc   'git commit -m'
    abbr -a gca  'git commit --amend --no-edit'
    abbr -a gco  'git checkout'
    abbr -a gsw  'git switch'
    abbr -a gd   'git diff'
    abbr -a gl   'git lg'
    abbr -a gp   'git push'
    abbr -a gpl  'git pull'
    abbr -a gf   'git fetch --all --prune'
    abbr -a gb   'git branch'
    abbr -a gst  'git stash'

    # pacman/yay по-человечески
    abbr -a pi   'sudo pacman -S'
    abbr -a pr   'sudo pacman -Rns'
    abbr -a ps   'pacman -Ss'
    abbr -a pu   'sudo pacman -Syu'
    abbr -a orphan 'pacman -Qtdq'

    # навигация
    abbr -a ..   'cd ..'
    abbr -a ...  'cd ../..'
    abbr -a .... 'cd ../../..'

    # утиль
    abbr -a c    'clear'
    abbr -a v    'code'
    abbr -a reload 'source ~/.config/fish/config.fish'
end

# ═══════════════════════════════════════════════════════════════
#  ТЕМА MonoBlack — цвета синтаксиса fish (графит + кровь)
#  Перебивает дефолты cachyos. Команды — красные, строки — зелёные.
# ═══════════════════════════════════════════════════════════════
if status is-interactive
    set -g fish_color_normal        c8c8d0
    set -g fish_color_command       d2772e
    set -g fish_color_keyword       e08a45
    set -g fish_color_quote         7a9f6c
    set -g fish_color_redirection   d2aa46
    set -g fish_color_end           d2772e
    set -g fish_color_error         e08a45 --bold
    set -g fish_color_param         c8c8d0
    set -g fish_color_comment       6c6c78 --italics
    set -g fish_color_operator      d2aa46
    set -g fish_color_escape        e08a45
    set -g fish_color_autosuggestion 6c6c78
    set -g fish_color_cwd           d2772e
    set -g fish_color_user          9a9aa6
    set -g fish_color_host          9a9aa6
    set -g fish_color_selection     --background=a85a20
    set -g fish_color_search_match  --background=a85a20
    set -g fish_pager_color_prefix  d2772e --bold
    set -g fish_pager_color_progress 6c6c78
    set -g fish_pager_color_selected_background --background=26262c
end

# ═══════════════════════════════════════════════════════════════
#  atuin — умная история на Alt+R (Ctrl+R за fzf, Ctrl+E за KDE-проводником)
#  ATUIN_NOBIND отключает дефолтные бинды atuin → fzf не конфликтует.
#  Первый раз импортнуть старую историю:  atuin import auto
# ═══════════════════════════════════════════════════════════════
if status is-interactive
    and type -q atuin
    set -gx ATUIN_NOBIND true
    atuin init fish | source
    bind \er _atuin_search
    bind \cr _atuin_search   # дублируем на Ctrl+R тоже (вытесняет fzf-историю; fzf Ctrl+T/Alt+C целы)
end
