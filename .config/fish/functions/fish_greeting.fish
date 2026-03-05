function _gradient_fish --argument-names fish_str c1 c2 c3
    set -l len (string length -- $fish_str)
    set -l s1 (math "ceil($len / 3)")
    set -l s2 (math "ceil(($len - $s1) / 2)")
    set -l s3 (math "$len - $s1 - $s2")

    set_color $c1
    echo -n (string sub -s 1 -l $s1 -- $fish_str)
    set_color $c2
    echo -n (string sub -s (math "$s1 + 1") -l $s2 -- $fish_str)
    set_color $c3
    echo -n (string sub -s (math "$s1 + $s2 + 1") -l $s3 -- $fish_str)
    set_color normal
end

function fish_greeting
    set -l fish_art \
        '><>' \
        '><(°>' \
        '><((°>' \
        '><(((°>' \
        '><((((°>' \
        "><((('>" \
        '><(((*>' \
        '><(((º>' \
        '><((((º>' \
        '><{{{°>' \
        '><{{{{º>' \
        '<<(((°<' \
        '>=((((°>' \
        '>><((°>' \
        '><((((•>' \
        '►<((((°>' \
        '}><((((°>' \
        '><((((¤>' \
        '><>>>>' \
        '>=(°>' \
        '><((((˚>' \
        '~><((((°>' \
        '<º)))><' \
        '><[[[°>' \
        '><|||°>' \
        '><((x>' \
        '3<(((°>' \
        '><###°>' \
        '><((@>' \
        '><:::::°>' \
        '><///°>' \
        '><o>' \
        '><+++°>' \
        '><((^>' \
        '><((0>' \
        '><(((*>' \
        '><((((X>' \
        '><((((O>' \
        '><((((ø>' \
        '><((((©>' \
        "><((((''>" \
        '><"""°>' \
        '><,,,°>' \
        '~~><(((°>'

    # 8 gradient themes: dark → mid → light
    set -l themes \
        'ff4500 ff6347 ff7f50' \
        '005f87 0087af 00afd7' \
        'ff5f00 ff8700 ffaf00' \
        '00af00 5fd75f 87d787' \
        'af00ff af5fff d7afff' \
        '008080 00afaf 5fd7d7' \
        'd7005f ff5f87 ff87af' \
        'd78700 ffaf00 ffd700'

    if test (random 1 50) -eq 1
        # Big goldfish — per-line gradient
        set -l lines \
            '  ,_           ,_' \
            "  \\ '-.        ) '." \
            "   \\   '.    .'_...\\_" \
            "    '._  \\.-' `      `'-." \
            "      _> =;           (o )" \
            "    .'   /`;-.__ __//,.-'" \
            "   /   .'  (/ /`| (/" \
            "  /_.-'       \\_/"
        set -l gold ffd700 ffaf00 ff8c00 ff7700 ff6600 ff7700 ff8c00 ffaf00
        echo
        for i in (seq (count $lines))
            set_color $gold[$i]
            echo "$lines[$i]"
        end
        set_color normal
        echo

    else if test (random 1 250) -eq 1
        set -l theme (string split ' ' -- $themes[(random 1 (count $themes))])
        echo
        echo -n '  '
        _gradient_fish '><((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((°>' $theme[1] $theme[2] $theme[3]
        echo
        echo '        the loooooooooooooooooooooooooooooooooooooooooong fish'
        echo

    else if test (random 1 333) -eq 1
        set -l t1 (string split ' ' -- $themes[(random 1 (count $themes))])
        set -l t2 (string split ' ' -- $themes[(random 1 (count $themes))])
        set -l t3 (string split ' ' -- $themes[(random 1 (count $themes))])
        echo
        echo -n '    '
        _gradient_fish '><>' $t1[1] $t1[2] $t1[3]
        echo -n '   '
        _gradient_fish '><>' $t2[1] $t2[2] $t2[3]
        echo -n '   '
        _gradient_fish '><>' $t3[1] $t3[2] $t3[3]
        echo
        echo '  TRIPLE FISH MAYHEM'
        echo

    else if test (random 1 777) -eq 1
        set -l theme (string split ' ' -- $themes[(random 1 (count $themes))])
        echo
        echo -n '     '
        _gradient_fish '><777°>' $theme[1] $theme[2] $theme[3]
        echo
        echo '  Lucky Seven!!'
        echo

    else
        set -l theme (string split ' ' -- $themes[(random 1 (count $themes))])
        set -l pick $fish_art[(random 1 (count $fish_art))]
        echo
        echo -n '  '
        _gradient_fish $pick $theme[1] $theme[2] $theme[3]
        echo
        echo
    end
end
