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

    call <SID>X("Normal",         "aed7a7", "111111", "")
    call <SID>X("NonText",        "555753", "111111", "none")

    " highlight groups
    call <SID>X("Cursor",         "111111", "4e9a06", "")
    "ICursor
    call <SID>X("Search",         "eeeeec", "c4a000", "")
    call <SID>X("IncSearch",      "eeeeec", "729fcf", "")
    call <SID>X("StatusLine",     "000000", "4e9a06", "bold")
    call <SID>X("StatusLineNC",   "333333", "4e9a06", "")
    call <SID>X("VertSplit",      "eeeeec", "eeeeec", "")
    call <SID>X("Folded",         "eeeeec", "65801a", "")
    call <SID>X("FoldColumn",     "eeeeec", "87ab23", "")
    call <SID>X("Title",          "ffffff", "111111", "bold")
    call <SID>X("LineNr",         "222222", "000000", "")

    call <SID>X("Comment",        "555753", "111111", "")
    call <SID>X("SpecialComment", "557753", "",       "")
    call <SID>X("Todo",           "557753", "112211", "")

    call <SID>X("Constant",       "a2dc06", "",       "")
    call <SID>X("String",         "eeeeec", "",       "")
    call <SID>X("Character",      "bebebc", "",       "")
    call <SID>X("Number",         "fce94f", "",       "")
    call <SID>X("Boolean",        "c4a000", "",       "")
    call <SID>X("Float",          "8aae23", "",       "")

    call <SID>X("Identifier",     "7495a4", "",       "")
    call <SID>X("Function",       "68cd08", "",       "")

    call <SID>X("Statement",      "5ff50b", "",       "")
    call <SID>X("Conditional",    "72f9bf", "",       "")
    call <SID>X("Repeat",         "34e2d2", "",       "")
    call <SID>X("Label",          "06988a", "",       "underline")
    call <SID>X("Operator",       "346594", "",       "none")
    call <SID>X("Keyword",        "b29fbf", "",       "")

    call <SID>X("Exception",      "ff6801", "",       "")

    call <SID>X("PreProc",        "7b6550", "",       "")
    call <SID>X("Include",        "ad7fa8", "",       "")
    call <SID>X("Define",         "7ba9a9", "",       "")
    call <SID>X("Macro",          "cb7465", "",       "")
    call <SID>X("PreCondit",      "cb9765", "",       "")

    " Older attempts with lots of purples - made Ruby look awful
    "call <SID>X("Include",        "ad967f", "",       "")
    "call <SID>X("PreProc",        "75507b", "",       "")
    "call <SID>X("Define",         "cb65c5", "",       "")
    "call <SID>X("Macro",          "9265cb", "",       "")
    "call <SID>X("PreCondit",      "7423db", "",       "")

    call <SID>X("Type",           "72f9ef", "",       "none")
    call <SID>X("StorageClass",   "34e2ff", "",       "none")
    call <SID>X("Structure",      "0698ba", "",       "none")
    call <SID>X("Typedef",        "729fef", "",       "none")

    call <SID>X("Special",        "5eaa96", "",       "")
    call <SID>X("SpecialChar",    "eebbb9", "",       "")
    call <SID>X("Tag",            "5495b4", "",       "underline")
    call <SID>X("Delimiter",      "656763", "",       "none")

    call <SID>X("Debug",          "78dd08", "333300", "")
    call <SID>X("Underlined",     "aeb7a7", "",       "underline")
    call <SID>X("Ignore",         "373737", "",       "none")
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

else
  " COPIED FROM Tango.vim!  Looks nothing like the colors above (for now)
  " author:   Michele Campeotto <micampe@micampe.it>

  " Default Color"
  hi Normal       guifg=#eeeeec guibg=#000000
  hi NonText      guifg=#555753 guibg=#000000 gui=none
  hi NonText      ctermfg=darkgray
  hi Cursor       guibg=#d3d7cf
  hi lCursor      guibg=#d3d7cf

  " Search
  hi Search       guifg=#eeeeec guibg=#c4a000
  hi Search       cterm=none ctermfg=grey ctermbg=blue
  hi IncSearch    guibg=#eeeeec guifg=#729fcf
  hi IncSearch    cterm=none ctermfg=yellow ctermbg=green

  " Window Elements
  hi StatusLine   guifg=#eeeeec guibg=#4e9a06 gui=bold
  hi StatusLine   ctermfg=white ctermbg=green cterm=bold
  hi StatusLineNC guifg=#d3d7df guibg=#4e9a06
  hi StatusLineNC ctermfg=lightgray ctermbg=darkgreen
  hi VertSplit    guifg=#eeeeec guibg=#eeeeec
  hi Folded       guifg=#eeeeec guibg=#75507b
  hi Folded       ctermfg=white ctermbg=magenta
  hi Visual       guifg=#d3d7cf guibg=#4e9a06
  hi Visual       ctermbg=white ctermfg=lightgreen cterm=reverse

  " Specials
  hi Todo         guifg=#8ae234 guibg=#4e9a06 gui=bold
  hi Todo         ctermfg=white ctermbg=green
  hi Title        guifg=#eeeeec gui=bold
  hi Title        ctermfg=white cterm=bold

  " Syntax
  hi Constant     guifg=#c4a000
  hi Constant     ctermfg=darkyellow
  hi Number       guifg=#729fcf
  hi Number       ctermfg=darkblue
  hi Statement    guifg=#4e9a06 gui=bold
  hi Statement    ctermfg=green
  hi Identifier   guifg=#8ae234
  hi Identifier   ctermfg=darkgreen
  hi PreProc      guifg=#cc0000
  hi PreProc      ctermfg=darkred
  hi Comment      guifg=#06989a gui=italic
  hi Comment      ctermfg=cyan cterm=none
  hi Type         guifg=#d3d7cf gui=bold
  hi Type         ctermfg=gray cterm=bold
  hi Special      guifg=#75507b
  hi Special      ctermfg=magenta cterm=none
  hi Error        guifg=#eeeeec guibg=#ef2929
  hi Error        ctermfg=white ctermbg=red
endif

" Not sure these will work correctly with X(), though I haven't tried very
" hard.
hi DiffAdd      guibg=#143574 gui=none ctermbg=darkblue   cterm=none
hi DiffChange   guibg=#555753 gui=none ctermbg=darkgray   cterm=none
hi DiffDelete   guifg=#442222 guibg=bg ctermbg=none       cterm=none
hi DiffText     guibg=#a49000 gui=none ctermbg=darkyellow cterm=none
hi Visual       guibg=#333333          ctermbg=darkgray cterm=none

" vim: set fdl=0 fdm=marker:
