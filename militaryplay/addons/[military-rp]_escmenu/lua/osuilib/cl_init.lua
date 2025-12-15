oseanui = oseanui or {}

oseanui.BaseColors = {
    base = Color(98, 122, 145),
    second = Color(98, 122, 145),
    red = Color(200, 58, 20),
    green = Color(71, 177, 138),
}

function oseanui.CreateFont(name, fontname, w, sizefont, blursize)
    sizefont = ScreenScale(sizefont/3)

    surface.CreateFont('oseanui.' .. name, {
        font = fontname,
        size = sizefont,
        weight = not w and 300 or w,
        extended = true
    })

    surface.CreateFont('oseanui.' .. name .. '.shadow', {
        font = fontname,
        size = sizefont,
        weight = not w and 300 or w,
        blursize = blursize and blursize or 2,
        extended = true
    })
end

// fonts
    // Regular
    for i = 10, 80 do 
        oseanui.CreateFont(i, 'Montserrat', 400, i, (i/8) > 2 and i/8 or 2)
    end

    // Bold
    for i = 10, 80 do 
        oseanui.CreateFont('Bold.' .. i, 'Montserrat', 700, i, (i/8) > 2 and i/8 or 2)
    end

    // Medium
    for i = 10, 80 do 
        oseanui.CreateFont('Medium.' .. i, 'Montserrat', 500, i, (i/8) > 2 and i/8 or 2)
    end
//

function oseanui.DrawText(text, font, x, y, color, xalign, yalign, _shadow)
    if not isbool(_shadow) then
        _shadow = true
    end

    if _shadow then
        draw.SimpleText(text, font .. '.shadow', x, y, ColorAlpha(color_black, color.a), xalign, yalign)
    end

    draw.SimpleText(text, font, x, y, color, xalign, yalign)

    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)

    return w, h
end