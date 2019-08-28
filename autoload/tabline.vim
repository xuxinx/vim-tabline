function! s:GetCurrBufNames(tabCount)
    let bufNames = {}
    for i in range(a:tabCount)
        let tabNum = i + 1
        let winNum = tabpagewinnr(tabNum)
        let buflist = tabpagebuflist(tabNum)
        let bufNum = buflist[winNum - 1]
        let bufName = fnamemodify(bufname(bufNum), ':~:.')
        let baseName = fnamemodify(bufName, ':t')
        let bufNames[tabNum] = {}
        let bufNames[tabNum]["fn"] = bufName
        let bufNames[tabNum]["bn"] = baseName
        let bufNames[tabNum]["sn"] = baseName
    endfor

    let bnGroup = {}
    for [tabNum, name] in items(bufNames)
        let bn = name["bn"]
        if !has_key(bnGroup, bn)
            let bnGroup[bn] = []
        endif
        let bnGroup[bn] = add(bnGroup[bn], tabNum)
    endfor

    for tabNums in values(bnGroup)
        if len(tabNums) > 1
            for tabNum in tabNums
                let bufNames[tabNum]["sn"] = bufNames[tabNum]["fn"]
            endfor
        endif
    endfor

    return bufNames
endfunction

function! tabline#MyTabline()
    let s = ''
    let tabCount = tabpagenr('$')
    let bufNames = s:GetCurrBufNames(tabCount)
    for i in range(tabCount)
        let tabNum = i + 1
        let winNum = tabpagewinnr(tabNum)
        let buflist = tabpagebuflist(tabNum)
        let bufNum = buflist[winNum - 1]
        let bufName = bufNames[tabNum]["sn"]

        let bufmodified = 0
        for b in buflist
            if getbufvar(b, "&modified")
                let bufmodified = 1
                break
            endif
        endfor

        let fname = '' 
        let buftype = getbufvar(bufNum, "&buftype")
        if buftype == ''
            let fname = bufName != "" ? bufName : '[No Name]'
        elseif buftype == 'quickfix'
            let fname = '[Quickfix List]'
        elseif buftype == 'help'
            let fname = '[Help]'
        else
            let fname = '[' . bufName . ']'
        endif

        " select the highlighting
        let hl = tabNum == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
        let s .= hl

        " set the tab page number (for mouse clicks)
        let s .= '%' . tabNum . 'T'

        let s .= ' [' . tabNum . '] '

        if exists('g:tabline_show_wins_count')
            let winCount = tabpagewinnr(tabNum, '$')
            if winCount > 1
                let s .= "%#TabWinsCount#" . winCount . hl . ' '
            endif
        endif

        let s .= fname . ' '

        if bufmodified
            let s .= '+ '
        endif
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabCount > 1
        let s .= '%=%#TabLine#%999XX'
    endif

    return s
endfunction
