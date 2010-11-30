" Vim color file
" Maintainer:	Joseph Wecker <joseph.wecker@gmail.com>
" Last Change:	2010-11-29

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "murphytango"
if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}

    call <SID>X("Normal",         "aed7a7", "111111", ""       )
    call <SID>X("NonText",        "555753", "111111", "none"   )

    " highlight groups
    call <SID>X("Cursor",         "111111", "4e9a06", ""       )
    "ICursor
    call <SID>X("Search",         "eeeeec", "c4a000", ""       )
    call <SID>X("IncSearch",      "eeeeec", "729fcf", ""       )
    call <SID>X("StatusLine",     "eeeeec", "3465a4", "bold"   )
    call <SID>X("StatusLineNC",   "d3d7df", "3465a4", ""       )
    call <SID>X("VertSplit",      "eeeeec", "eeeeec", ""       )
    call <SID>X("Folded",         "eeeeec", "75507b", ""       )
    call <SID>X("FoldColumn",     "eeeeec", "7229cf", ""       )
    call <SID>X("Visual",         "d3d7cf", "4e9a06", ""       )
    call <SID>X("Title",          "ffffff", "111111", "bold"   )
    hi DiffAdd      guifg=fg guibg=#3465a4 gui=none
    hi DiffAdd      ctermfg=gray ctermbg=blue cterm=none
    hi DiffChange   guifg=fg guibg=#555753 gui=none
    hi DiffChange   ctermfg=gray ctermbg=darkgray cterm=none
    hi DiffDelete   guibg=bg
    hi DiffDelete   ctermfg=gray ctermbg=none cterm=none
    hi DiffText     guifg=fg guibg=#c4a000 gui=none
    hi DiffText     ctermfg=gray ctermbg=yellow cterm=none
    call <SID>X("LineNr",         "2e3436", "111111", ""      )

    call <SID>X("Comment",        "555753", "111111", "")
    call <SID>X("SpecialComment", "557753", "", "")
    call <SID>X("Todo",           "557753", "112211", "")

    call <SID>X("Constant",       "a2dc06", "", "")
    call <SID>X("String",         "eeeeec", "", "")
    call <SID>X("Character",      "bebebc", "", "")
    call <SID>X("Number",         "fce94f", "", "")
    call <SID>X("Boolean",        "c4a000", "", "")
    call <SID>X("Float",          "8aae23", "", "")

    call <SID>X("Identifier",     "3465a4", "", "")
    call <SID>X("Function",       "68cd08", "", "")

    call <SID>X("Statement",      "5ff50b", "", "")
    call <SID>X("Conditional",    "72f9cf", "", "")
    call <SID>X("Repeat",         "34e2e2", "", "")
    call <SID>X("Label",          "06989a", "", "underline")
    call <SID>X("Operator",       "3465a4", "", "none")
    call <SID>X("Keyword",        "729fcf", "", "")

    call <SID>X("Exception",      "ff6801", "", "")

    call <SID>X("PreProc",        "7b6550", "", "")
    call <SID>X("Include",        "ad7fa8", "", "")
    call <SID>X("Define",         "7ba9a9", "", "")
    call <SID>X("Macro",          "cb7465", "", "")
    call <SID>X("PreCondit",      "cb9765", "", "")
    "call <SID>X("Include",        "ad967f", "", "")
    "call <SID>X("PreProc",        "75507b", "", "")
    "call <SID>X("Define",         "cb65c5", "", "")
    "call <SID>X("Macro",          "9265cb", "", "")
    "call <SID>X("PreCondit",      "7423db", "", "")

    call <SID>X("Type",           "72f9cf", "", "")
    call <SID>X("StorageClass",   "34e2e2", "", "")
    call <SID>X("Structure",      "06989a", "", "")
    call <SID>X("Typedef",        "729fcf", "", "")

    call <SID>X("Special",        "5eaa96", "", "")
    call <SID>X("SpecialChar",    "f03535", "", "")
    call <SID>X("Tag",            "9265cb", "", "underline")
    call <SID>X("Delimiter",      "656763", "", "none")

    call <SID>X("Debug",          "78dd08", "333300", "")
    call <SID>X("Underlined",     "aeb7a7", "", "underline")
    call <SID>X("Ignore",         "373737", "", "none")
    call <SID>X("Error",          "f03535", "272722", "")

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}

endif
"else
" Default Colors
"hi Normal       guifg=#eeeeec guibg=#000000
"hi NonText      guifg=#555753 guibg=#000000 gui=none
"hi NonText      ctermfg=darkgray
"hi Cursor       guibg=#d3d7cf
"hi lCursor      guibg=#d3d7cf

" Search
"hi Search       guifg=#eeeeec guibg=#c4a000
"hi Search       cterm=none ctermfg=grey ctermbg=blue
"hi IncSearch    guibg=#eeeeec guifg=#729fcf
"hi IncSearch    cterm=none ctermfg=yellow ctermbg=green

" Window Elements
"hi StatusLine   guifg=#eeeeec guibg=#4e9a06 gui=bold
"hi StatusLine   ctermfg=white ctermbg=green cterm=bold
"hi StatusLineNC guifg=#d3d7df guibg=#4e9a06
"hi StatusLineNC ctermfg=lightgray ctermbg=darkgreen
"hi VertSplit    guifg=#eeeeec guibg=#eeeeec
"hi Folded       guifg=#eeeeec guibg=#75507b
"hi Folded       ctermfg=white ctermbg=magenta
"hi Visual       guifg=#d3d7cf guibg=#4e9a06
"hi Visual       ctermbg=white ctermfg=lightgreen cterm=reverse



"hi Normal
"hi NonText
"hi Cursor
"hi lCursor

"hi Comment

"hi Constant
"hi String
"hi Character
"hi Number
"hi Boolean
"hi Float

"hi Identifier


    " color terminal definitions
"    hi SpecialKey    ctermfg=darkgreen
"    hi NonText       cterm=bold ctermfg=darkblue
"    hi Directory     ctermfg=darkcyan
"    hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
"    hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
"    hi Search        cterm=NONE ctermfg=grey ctermbg=blue
"    hi MoreMsg       ctermfg=darkgreen
"    hi ModeMsg       cterm=NONE ctermfg=brown
"    hi LineNr        ctermfg=3
"    hi Question      ctermfg=green
"    hi StatusLine    cterm=bold,reverse
"    hi StatusLineNC  cterm=reverse
"    hi VertSplit     cterm=reverse
"    hi Title         ctermfg=5
"    hi Visual        cterm=reverse
"    hi VisualNOS     cterm=bold,underline
"    hi WarningMsg    ctermfg=1
"    hi WildMenu      ctermfg=0 ctermbg=3
"    hi Folded        ctermfg=darkgrey ctermbg=NONE
"    hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
"    hi DiffAdd       ctermbg=4
"    hi DiffChange    ctermbg=5
"    hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
"    hi DiffText      cterm=bold ctermbg=1
"    hi Comment       ctermfg=darkcyan
"    hi Constant      ctermfg=brown
"    hi Special       ctermfg=5
"    hi Identifier    ctermfg=6
"    hi Statement     ctermfg=3
"    hi PreProc       ctermfg=5
"    hi Type          ctermfg=2
"    hi Underlined    cterm=underline ctermfg=5
"    hi Ignore        ctermfg=darkgrey
"    hi Error         cterm=bold ctermfg=7 ctermbg=1
"endif

" vim: set fdl=0 fdm=marker:
