function prof --description 'Переключение профиля питания ASUS (game/work/quiet)'
    switch "$argv[1]"
        case game gaming perf performance
            asusctl profile set Performance; and echo "🎮 Performance — макс мощность (под игры)"
        case work balanced bal
            asusctl profile set Balanced; and echo "💻 Balanced — тихо + шустро (повседнев)"
        case quiet silent battery
            asusctl profile set Quiet; and echo "🔇 Quiet — тихо/экономно (батарея)"
        case '' get status
            printf '%s\n' (asusctl profile get 2>/dev/null | string match -r 'Active.*')
            echo "юзай: prof game | prof work | prof quiet"
        case '*'
            echo "не знаю профиль '$argv[1]'. юзай: prof game | prof work | prof quiet"
    end
end
