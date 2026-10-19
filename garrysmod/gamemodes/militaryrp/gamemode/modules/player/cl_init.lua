-- Клиентская часть меню SteamID с кастомными названиями
if CLIENT then
    -- ========== ПЕРЕМЕННЫЕ ==========
    local SteamIDMenuFrame = nil
    
    -- Цвета из cl_help
    local mp = mp or {}
    mp.Color = mp.Color or {}
    mp.Color.BLACK = mp.Color.BLACK or Color(0, 0, 0)
    mp.Color.WHITE = mp.Color.WHITE or Color(255, 255, 255)
    mp.Color.BASE = mp.Color.BASE or Color(200, 200, 200)
    mp.Color.BASE_TO = mp.Color.BASE_TO or Color(100, 100, 100)
    mp.Color.RED = mp.Color.RED or Color(255, 0, 0)
    
    local ColorAlpha = ColorAlpha or function(col, alpha)
        return Color(col.r, col.g, col.b, alpha)
    end
    
    local C_B_150 = ColorAlpha(mp.Color.BLACK, 150)
    local C_W_200 = ColorAlpha(mp.Color.WHITE, 200)
    local C_W_150 = ColorAlpha(mp.Color.WHITE, 150)
    local C_B_100 = ColorAlpha(mp.Color.BASE, 100)
    local C_W_100 = ColorAlpha(mp.Color.WHITE, 100)
    local C_B_25 = ColorAlpha(mp.Color.BASE, 25)
    local C_B_10 = ColorAlpha(mp.Color.BASE, 10)
    
    local ColorBackground = ColorAlpha(mp.Color.BASE_TO, 200)
    local ColorOutline = ColorAlpha(mp.Color.BASE, 25)
    
    -- Шрифты (если доступны через mp.font, иначе стандартные)
    local title_font = mp.font and mp.font("35:Futura PT Light") or "DermaLarge"
    local header_font = mp.font and mp.font("24:Futura PT Light") or "DermaDefaultBold"
    local btn_font = mp.font and mp.font("20:Futura PT Medium") or "DermaDefault"
    local item_font = mp.font and mp.font("18:DIN Pro Regular") or "DermaDefault"
    
    -- ========== СЕТЕВОЙ ОБРАБОТЧИК ==========
    net.Receive("steamid_menu_open", function()
        local steamid = net.ReadString()
        local rank_name = net.ReadString()
        local weaponsData = net.ReadTable()
        local modelsData = net.ReadTable()
        
        CreateSteamIDMenu(steamid, rank_name, weaponsData, modelsData)
    end)
    
    -- ========== ФУНКЦИЯ СОЗДАНИЯ МЕНЮ ==========
    function CreateSteamIDMenu(steamid, rank_name, weaponsData, modelsData)
        if IsValid(SteamIDMenuFrame) then
            SteamIDMenuFrame:Remove()
        end
        
        local scrw, scrh = ScrW(), ScrH()
        
        local frame = vgui.Create("EditablePanel")
        SteamIDMenuFrame = frame
        frame:SetSize(scrw, scrh)
        frame:SetPos(0, 0)
        frame:MakePopup()
        frame:SetAlpha(0)
        frame:AlphaTo(255, 0.2, 0)
        
        -- Основной фон с блюром (как в cl_help)
        frame.Paint = function(self, w, h)
            if mp.BlurBG then
                mp.BlurBG(self, 2)
            end
            
            draw.RoundedBox(0, 0, 0, w, h, C_B_150)
        end
        
        -- Верхняя панель с информацией
        local PlayerPanel = vgui.Create("Panel", frame)
        PlayerPanel:Dock(TOP)
        PlayerPanel:SetTall(64)
        PlayerPanel:DockMargin(50, 20, 50, 20)
        
        PlayerPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            
            draw.SimpleText("ЭКСКЛЮЗИВНОЕ МЕНЮ", title_font, h + 25, h/2 - 8, mp.Color.WHITE, 0, 4)
            draw.SimpleText("Статус: " .. rank_name, item_font, h + 25, h/2 + 8, C_W_100, 0, 0)
        end
        
        -- Основной контент
        local FillPanel = vgui.Create("Panel", frame)
        FillPanel:Dock(FILL)
        FillPanel:DockMargin(50, 0, 50, 0)
        
        -- Панель оружия (левая сторона)
        local WeaponPanel = vgui.Create("Panel", FillPanel)
        WeaponPanel:Dock(LEFT)
        WeaponPanel:SetWide(frame:GetWide()/2 - 100)
        
        WeaponPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
            draw.RoundedBox(0, 10, 10, w - 20, 42, ColorBackground)
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            surface.DrawOutlinedRect(10, 10, w - 20, 42, 1)
            
            draw.SimpleText("ОРУЖИЕ", item_font, w/2, 30, mp.Color.BASE, 1, 1)
            draw.SimpleText("(" .. #weaponsData .. " доступно)", item_font, w/2, 52, C_W_150, 1, 1)
        end
        
        -- Список оружия
        if #weaponsData > 0 then
            local weaponScroll = vgui.Create("DScrollPanel", WeaponPanel)
            weaponScroll:Dock(FILL)
            weaponScroll:DockMargin(10, 65, 10, 10)
            
            for i, weapon in ipairs(weaponsData) do
                local weaponBtn = vgui.Create("DButton", weaponScroll)
                weaponBtn:Dock(TOP)
                weaponBtn:DockMargin(0, 0, 0, 5)
                weaponBtn:SetTall(36)
                weaponBtn:SetText("")
                weaponBtn.Hover = 0
                
                weaponBtn.Paint = function(self, w, h)
                    if self:IsHovered() then
                        self.Hover = Lerp(FrameTime() * 15, self.Hover, 200)
                    else
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 50)
                    end
                    
                    draw.RoundedBox(0, 0, 0, w, h, C_B_10)
                    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover/3))
                    
                    surface.SetDrawColor(ColorOutline)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)
                    
                    draw.SimpleText(weapon.name, item_font, w/2, h/2 - 8, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
                    draw.SimpleText("(" .. weapon.class .. ")", item_font, w/2, h/2 + 8, C_W_150, 1, 1)
                end
                
                weaponBtn.DoClick = function()
                    net.Start("steamid_give_weapon")
                    net.WriteString(weapon.class)
                    net.SendToServer()
                    
                    if mp.Sound and mp.Sound.CLICK_2 then
                        surface.PlaySound(mp.Sound.CLICK_2)
                    end
                    
                    frame:AlphaTo(0, 0.2, 0, function()
                        frame:Remove()
                    end)
                end
                
                weaponBtn.OnCursorEntered = function()
                    if mp.Sound and mp.Sound.CLICK then
                        surface.PlaySound(mp.Sound.CLICK)
                    end
                end
            end
        end
        
        -- Панель моделей (правая сторона)
        local ModelPanel = vgui.Create("Panel", FillPanel)
        ModelPanel:Dock(RIGHT)
        ModelPanel:SetWide(frame:GetWide()/2 - 100)
        
        ModelPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
            draw.RoundedBox(0, 10, 10, w - 20, 42, ColorBackground)
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            surface.DrawOutlinedRect(10, 10, w - 20, 42, 1)
            
            draw.SimpleText("МОДЕЛИ", item_font, w/2, 30, mp.Color.BASE, 1, 1)
            draw.SimpleText("(" .. #modelsData .. " доступно)", item_font, w/2, 52, C_W_150, 1, 1)
        end
        
        -- Список моделей
        if #modelsData > 0 then
            local modelScroll = vgui.Create("DScrollPanel", ModelPanel)
            modelScroll:Dock(FILL)
            modelScroll:DockMargin(10, 65, 10, 10)
            
            for i, model in ipairs(modelsData) do
                local modelBtn = vgui.Create("DButton", modelScroll)
                modelBtn:Dock(TOP)
                modelBtn:DockMargin(0, 0, 0, 5)
                modelBtn:SetTall(36)
                modelBtn:SetText("")
                modelBtn.Hover = 0
                
                modelBtn.Paint = function(self, w, h)
                    if self:IsHovered() then
                        self.Hover = Lerp(FrameTime() * 15, self.Hover, 200)
                    else
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 50)
                    end
                    
                    draw.RoundedBox(0, 0, 0, w, h, C_B_10)
                    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover/3))
                    
                    surface.SetDrawColor(ColorOutline)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)
                    
                    draw.SimpleText(model.name, item_font, w/2, h/2 - 8, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
                    
                    local shortPath = string.match(model.path, "([^/]+%.mdl)$") or model.path
                    draw.SimpleText(shortPath, item_font, w/2, h/2 + 8, C_W_150, 1, 1)
                end
                
                modelBtn.DoClick = function()
                    net.Start("steamid_set_model")
                    net.WriteString(model.path)
                    net.SendToServer()
                    
                    if mp.Sound and mp.Sound.CLICK_2 then
                        surface.PlaySound(mp.Sound.CLICK_2)
                    end
                    
                    frame:AlphaTo(0, 0.2, 0, function()
                        frame:Remove()
                    end)
                end
                
                modelBtn.OnCursorEntered = function()
                    if mp.Sound and mp.Sound.CLICK then
                        surface.PlaySound(mp.Sound.CLICK)
                    end
                end
            end
        end
        
        -- Нижняя панель с кнопкой закрытия
        local BottomPanel = vgui.Create("Panel", frame)
        BottomPanel:Dock(BOTTOM)
        BottomPanel:SetTall(42)
        BottomPanel:DockMargin(50, 20, 50, 20)
        
        local CloseBtn = vgui.Create("DButton", BottomPanel)
        CloseBtn:Dock(LEFT)
        CloseBtn:SetWide(125)
        CloseBtn:SetText("")
        CloseBtn.Hover = 0
        
        CloseBtn.Paint = function(self, w, h)
            if self:IsHovered() then
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 255)
            else
                self.Hover = Lerp(FrameTime() * 10, self.Hover, 0)
            end
            
            draw.RoundedBox(0, 0, 0, w, h, mp.Color.BLACK)
            
            if mp.Icon and mp.Material then
                mp.Icon(0, 0, w, h, mp.Material.GRADIENT_D, C_B_25)
                mp.Icon(0, 0, w, h, mp.Material.GRADIENT_R, C_B_10)
            end
            
            draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover))
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            
            draw.SimpleText("ЗАКРЫТЬ", item_font, w/2, h/2, ColorAlpha(mp.Color.BASE, 255 - self.Hover), 1, 1)
            draw.SimpleText("ЗАКРЫТЬ", item_font, w/2, h/2, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
        end
        
        CloseBtn.DoClick = function()
            if mp.Sound and mp.Sound.ROLLUP_2 then
                surface.PlaySound(mp.Sound.ROLLUP_2)
            end
            
            frame:AlphaTo(0, 0.2, 0, function()
                frame:Remove()
            end)
        end
    end
    
    -- ========== КОНСОЛЬНАЯ КОМАНДА ==========
    concommand.Add("steamid_menu", function()
        net.Start("steamid_menu_open")
        net.SendToServer()
    end)
    
    -- ========== УВЕДОМЛЕНИЕ ==========
    timer.Simple(3, function()
        print("[Military-Play] Клиентская часть загружена")
        print("[Military-Play] Используйте !меню в чате для открытия")
    end)
end