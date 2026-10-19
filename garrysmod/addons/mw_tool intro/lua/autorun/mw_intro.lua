-- ==========================================
-- CALL OF DUTY: MW - MISSION INTRO (FIXED)
-- ==========================================

local L = {
    ru = {
        playing = "Интро запустится через %s сек...",
        no_perm = "У вас нет прав (Admin Only)!",
        play = "▶ ЗАПУСТИТЬ ДЛЯ ВСЕХ (ТОЛЬКО АДМИН)",
        delay = "Задержка перед стартом (Сек.)",
        timings = "--- ТАЙМИНГИ И ЭФФЕКТЫ (АДМИН) ---",
        black = "Старт с чёрным экраном",
        black_dur = "Длительность чёрного экрана",
        text_dur = "Общая длительность текста",
        speed = "Скорость печати",
        visuals = "--- ВАШИ ЛИЧНЫЕ НАСТРОЙКИ ---",
        size = "Размер текста",
        pos_x = "Позиция X (%)",
        pos_y = "Позиция Y (%)",
        line = "Строка",
        line3_name = "Ваша личная 3-я строка:",
        line3_help = "Используйте %NAME% для вашего ника",
        admin_lines = "--- ТЕКСТ (ОБЩИЙ ДЛЯ ВСЕХ) ---"
    },
    en = {
        playing = "Intro starts in %s sec...",
        no_perm = "You don't have permission (Admin Only)!",
        play = "▶ PLAY FOR EVERYONE (ADMIN ONLY)",
        delay = "Start Delay (Sec)",
        timings = "--- TIMINGS & EFFECTS (ADMIN) ---",
        black = "Start with Black Screen",
        black_dur = "Black Screen Duration",
        text_dur = "Total Text Duration",
        speed = "Typing Speed",
        visuals = "--- YOUR PERSONAL VISUALS ---",
        size = "Font Size",
        pos_x = "Position X (%)",
        pos_y = "Position Y (%)",
        line = "Line",
        line3_name = "Your Personal Line 3:",
        line3_help = "Use %NAME% for your nickname",
        admin_lines = "--- GLOBAL TEXT (ADMIN ONLY) ---"
    }
}

local function GetPhrase(key)
    local lang = GetConVar("gmod_language"):GetString()
    local t = L[lang] or L["en"]
    return t[key] or key
end

-- ==========================================
-- СЕРВЕРНАЯ ЧАСТЬ
-- ==========================================
if SERVER then
    util.AddNetworkString("MW_Intro_Trigger")

    -- Серверные переменные (строки 1, 2, 4, 5 управляются админом)
    CreateConVar("mw_intro_line1", "Добро Пожаловать на «Military-Play»", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
    CreateConVar("mw_intro_line2", "«Military-Play»", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
    CreateConVar("mw_intro_line4", "«Military-Play»", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
    CreateConVar("mw_intro_line5", "Не нарушайте правила.", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
    CreateConVar("mw_intro_delay", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED})

    concommand.Add("mw_intro_play", function(ply)
        if IsValid(ply) and not ply:IsAdmin() then 
            ply:ChatPrint(GetPhrase("no_perm"))
            return 
        end

        net.Start("MW_Intro_Trigger")
            net.WriteString(GetConVar("mw_intro_line1"):GetString())
            net.WriteString(GetConVar("mw_intro_line2"):GetString())
            -- Мы НЕ шлем 3-ю строку, клиент возьмет её сам из своих настроек
            net.WriteString(GetConVar("mw_intro_line4"):GetString())
            net.WriteString(GetConVar("mw_intro_line5"):GetString())
            net.WriteFloat(GetConVar("mw_intro_delay"):GetFloat())
        net.Broadcast()
    end)
    return
end

-- ==========================================
-- КЛИЕНТСКАЯ ЧАСТЬ
-- ==========================================
local SOUND_TYPE = "mw_intro/type.mp3"
local SOUND_GLITCH = "mw_intro/glitch.mp3"

-- Личная 3-я строка теперь клиентская!
CreateClientConVar("mw_intro_line3", "%NAME%", true, false)

CreateClientConVar("mw_intro_color_r", "160", true, false)
CreateClientConVar("mw_intro_color_g", "225", true, false)
CreateClientConVar("mw_intro_color_b", "160", true, false)
CreateClientConVar("mw_intro_size", "26", true, false)
CreateClientConVar("mw_intro_pos_x", "5", true, false)
CreateClientConVar("mw_intro_pos_y", "70", true, false)
CreateClientConVar("mw_intro_black_screen", "0", true, false)
CreateClientConVar("mw_intro_black_duration", "4", true, false)
CreateClientConVar("mw_intro_black_fade", "1.5", true, false)
CreateClientConVar("mw_intro_text_duration", "8", true, false)
CreateClientConVar("mw_intro_speed", "40", true, false)

-- Шрифты
local allowedSizes = {16, 20, 24, 26, 30, 36, 42, 48, 54, 60}
hook.Add("InitPostEntity", "MW_Intro_Fonts", function()
    for _, sz in ipairs(allowedSizes) do
        surface.CreateFont("MW_Intro_OCR_" .. sz, { font = "OCR A Becker RUS-LAT", size = sz, weight = 400, antialias = true, extended = true })
        surface.CreateFont("MW_Intro_Glow_" .. sz, { font = "OCR A Becker RUS-LAT", size = sz, weight = 400, antialias = true, blursize = 3, extended = true })
    end
end)

local function GetClosestSize(target)
    local closest = 26
    local minDiff = 999
    for _, sz in ipairs(allowedSizes) do
        local diff = math.abs(target - sz)
        if diff < minDiff then minDiff = diff; closest = sz end
    end
    return closest
end

local function GetGlitchChar(seed)
    local charset = "0123456789@#$%&*"
    local idx = (seed % #charset) + 1
    return string.sub(charset, idx, idx)
end

local introActive, introStartTime = false, 0
local linesToPrint = {}
local lastCharCounts = {0, 0, 0, 0, 0}
local outtroSoundPlayed = false

net.Receive("MW_Intro_Trigger", function()
    local l1 = net.ReadString()
    local l2 = net.ReadString()
    local l4 = net.ReadString()
    local l5 = net.ReadString()
    local delay = net.ReadFloat()

    -- Собираем итоговую таблицу: берем админские 1,2,4,5 и КЛИЕНТСКУЮ 3-ю
    local personalLine3 = GetConVar("mw_intro_line3"):GetString()
    personalLine3 = string.gsub(personalLine3, "%%NAME%%", LocalPlayer():Nick())

    local data = { l1, l2, personalLine3, l4, l5 }

    local function Run()
        introActive = true
        introStartTime = UnPredictedCurTime()
        linesToPrint = data
        lastCharCounts = {0, 0, 0, 0, 0}
        outtroSoundPlayed = false
    end

    if delay > 0 then
        notification.AddLegacy(string.format(GetPhrase("playing"), delay), NOTIFY_GENERIC, 3)
        surface.PlaySound("buttons/blip1.wav")
        timer.Simple(delay, Run)
    else
        Run()
    end
end)

hook.Add("HUDPaint", "DrawMWIntro", function()
    if not introActive then return end

    local currentTime = UnPredictedCurTime()
    local t = currentTime - introStartTime
    
    local active_duration = GetConVar("mw_intro_text_duration"):GetFloat()
    local active_black = GetConVar("mw_intro_black_screen"):GetBool()
    local active_black_dur = GetConVar("mw_intro_black_duration"):GetFloat()
    local active_black_fade = GetConVar("mw_intro_black_fade"):GetFloat()
    local active_speed = GetConVar("mw_intro_speed"):GetInt()

    if t > math.max(active_duration, active_black and active_black_dur or 0) then introActive = false return end

    -- Черный экран
    if active_black then
        local bAlpha = 255
        local actual_fade = math.min(active_black_fade, active_black_dur)
        local fadeStartTime = math.max(0, active_black_dur - actual_fade)
        if t > fadeStartTime then
            bAlpha = math.Clamp(255 - (((t - fadeStartTime) / actual_fade) * 255), 0, 255)
        elseif t >= active_black_dur then bAlpha = 0 end
        if bAlpha > 0 then
            surface.SetDrawColor(0, 0, 0, bAlpha)
            surface.DrawRect(0, 0, ScrW(), ScrH())
        end
    end

    -- Рендер текста
    if t <= active_duration then
        local r, g, b = GetConVar("mw_intro_color_r"):GetInt(), GetConVar("mw_intro_color_g"):GetInt(), GetConVar("mw_intro_color_b"):GetInt()
        local drawColor = Color(r, g, b, 255)
        local actualSize = GetClosestSize(GetConVar("mw_intro_size"):GetInt())
        local fontNormal = "MW_Intro_OCR_" .. actualSize
        local fontGlow = "MW_Intro_Glow_" .. actualSize

        local startX = ScrW() * (GetConVar("mw_intro_pos_x"):GetFloat() / 100)
        local startY = ScrH() * (GetConVar("mw_intro_pos_y"):GetFloat() / 100)
        local outtroStartTime = active_duration - 1.0

        for i, lineText in ipairs(linesToPrint) do
            local lineStartTime = (i - 1) * 1.0
            if t < lineStartTime then continue end

            local textLen = utf8.len(lineText) or 0
            local isOuttro = t > outtroStartTime
            local charsToShow = isOuttro and math.floor(textLen * (1 - (t - outtroStartTime))) or math.floor((t - lineStartTime) * active_speed)
            charsToShow = math.Clamp(charsToShow, 0, textLen)

            if not isOuttro and charsToShow > lastCharCounts[i] and charsToShow < textLen then
                if charsToShow % 2 == 0 then surface.PlaySound(SOUND_TYPE) end
            elseif isOuttro and not outtroSoundPlayed then
                surface.PlaySound(SOUND_GLITCH)
                outtroSoundPlayed = true
            end
            lastCharCounts[i] = charsToShow

            local visibleText = ""
            if isOuttro then
                for c = 1, charsToShow do
                    local hash = (c * 13 + math.floor(CurTime()*20)) % 100
                    visibleText = visibleText .. (hash > 50 and GetGlitchChar(hash) or utf8.sub(lineText, c, c))
                end
            else
                visibleText = utf8.sub(lineText, 1, charsToShow)
            end

            if charsToShow > 0 then
                local curY = startY + ((i - 1) * (actualSize + 4))
                draw.SimpleText(visibleText, fontNormal, startX + 2, curY + 2, Color(0,0,0,200), 0, 0)
                draw.SimpleText(visibleText, fontGlow, startX, curY, drawColor, 0, 0)
                draw.SimpleText(visibleText, fontNormal, startX, curY, drawColor, 0, 0)
            end
        end
    end
end)

-- ==========================================
-- МЕНЮ (С ОГРАНИЧЕНИЕМ ПРАВ)
-- ==========================================
hook.Add("PopulateToolMenu", "AddMWIntroMenuToUtilities", function()
    spawnmenu.AddToolMenuOption("Utilities", "MW Tools", "MW_Intro_Utilities", "Mission Intro", "", "", function(panel)
        panel:ClearControls()
        
        local isAdmin = LocalPlayer():IsAdmin()

        -- Кнопка запуска (Только админ)
        if isAdmin then
            local playBtn = panel:Button(GetPhrase("play"))
            playBtn.DoClick = function() RunConsoleCommand("mw_intro_play") end
            panel:NumSlider(GetPhrase("delay"), "mw_intro_delay", 0, 60, 1)
        end

        -- Тайминги (Только админ)
        if isAdmin then
            panel:ControlHelp("\n" .. GetPhrase("timings"))
            panel:CheckBox(GetPhrase("black"), "mw_intro_black_screen")
            panel:NumSlider(GetPhrase("black_dur"), "mw_intro_black_duration", 1, 20, 1)
            panel:NumSlider(GetPhrase("text_dur"), "mw_intro_text_duration", 3, 30, 1)
            panel:NumSlider(GetPhrase("speed"), "mw_intro_speed", 10, 100, 0)
        end

        -- Визуал (Доступно всем)
        panel:ControlHelp("\n" .. GetPhrase("visuals"))
        panel:NumSlider(GetPhrase("size"), "mw_intro_size", 16, 60, 0)
        panel:NumSlider(GetPhrase("pos_x"), "mw_intro_pos_x", 0, 100, 1)
        panel:NumSlider(GetPhrase("pos_y"), "mw_intro_pos_y", 0, 100, 1)
        
        local mixer = vgui.Create("DColorMixer", panel)
        mixer:SetConVarR("mw_intro_color_r") mixer:SetConVarG("mw_intro_color_g") mixer:SetConVarB("mw_intro_color_b")
        panel:AddItem(mixer)

        -- Настройка текста
        panel:ControlHelp("\n--- ТЕКСТ ---")
        
        -- Своя 3-я строка (Доступно всем)
        panel:TextEntry(GetPhrase("line3_name"), "mw_intro_line3")
        panel:ControlHelp(GetPhrase("line3_help"))

        -- Остальные строки (Только админ)
        if isAdmin then
            panel:ControlHelp("\n" .. GetPhrase("admin_lines"))
            panel:TextEntry("Line 1:", "mw_intro_line1")
            panel:TextEntry("Line 2:", "mw_intro_line2")
            panel:TextEntry("Line 4:", "mw_intro_line4")
            panel:TextEntry("Line 5:", "mw_intro_line5")
        end
    end)
end)