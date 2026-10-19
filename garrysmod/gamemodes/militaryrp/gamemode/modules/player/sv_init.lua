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
    
    -- Шрифты
    local title_font = mp.font and mp.font("30:Futura PT Light") or "DermaLarge"
    local status_font = mp.font and mp.font("22:Futura PT Light") or "DermaDefaultBold"
    local header_font = mp.font and mp.font("22:Futura PT Medium") or "DermaDefaultBold"
    local item_font = mp.font and mp.font("17:DIN Pro Regular") or "DermaDefault"
    local small_font = mp.font and mp.font("14:DIN Pro Regular") or "DermaDefault"
    
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
        
        -- Основной фон с блюром
        frame.Paint = function(self, w, h)
            if mp.BlurBG then
                mp.BlurBG(self, 2)
            end
            
            draw.RoundedBox(0, 0, 0, w, h, C_B_150)
        end
        
        -- Верхняя панель с заголовком
        local TopPanel = vgui.Create("Panel", frame)
        TopPanel:Dock(TOP)
        TopPanel:SetTall(80)
        TopPanel:DockMargin(50, 20, 50, 10)
        
        TopPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            
            -- Заголовок по центру
            draw.SimpleText("ЭКСКЛЮЗИВНОЕ МЕНЮ", title_font, w/2, h/2 - 12, mp.Color.WHITE, 1, 1)
            draw.SimpleText("Статус: " .. rank_name, status_font, w/2, h/2 + 18, C_W_200, 1, 1)
        end
        
        -- Основной контент
        local ContentPanel = vgui.Create("Panel", frame)
        ContentPanel:Dock(FILL)
        ContentPanel:DockMargin(50, 0, 50, 0)
        
        -- Панель оружия (левая сторона)
        local WeaponPanel = vgui.Create("Panel", ContentPanel)
        WeaponPanel:Dock(LEFT)
        WeaponPanel:SetWide(ContentPanel:GetWide() * 0.35)
        
        WeaponPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            
            -- Заголовок секции
            draw.RoundedBox(0, 10, 10, w - 20, 36, ColorBackground)
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(10, 10, w - 20, 36, 1)
            
            draw.SimpleText("ОРУЖИЕ", header_font, w/2, 28, mp.Color.BASE, 1, 1)
            draw.SimpleText("(" .. #weaponsData .. " доступно)", small_font, w/2, 48, C_W_150, 1, 1)
        end
        
        -- Список оружия
        if #weaponsData > 0 then
            local weaponScroll = vgui.Create("DScrollPanel", WeaponPanel)
            weaponScroll:Dock(FILL)
            weaponScroll:DockMargin(10, 60, 10, 10)
            
            for i, weapon in ipairs(weaponsData) do
                local weaponBtn = vgui.Create("DButton", weaponScroll)
                weaponBtn:Dock(TOP)
                weaponBtn:DockMargin(0, 0, 0, 5)
                weaponBtn:SetTall(40)
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
                    draw.SimpleText("(" .. weapon.class .. ")", small_font, w/2, h/2 + 10, C_W_150, 1, 1)
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
        
        -- Панель предпросмотра модели (центр)
        local PreviewPanel = vgui.Create("Panel", ContentPanel)
        PreviewPanel:Dock(FILL)
        PreviewPanel:DockMargin(15, 0, 15, 0)
        
        PreviewPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            
            -- Заголовок секции
            draw.RoundedBox(0, 10, 10, w - 20, 36, ColorBackground)
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(10, 10, w - 20, 36, 1)
            
            draw.SimpleText("ПРЕДПРОСМОТР", header_font, w/2, 28, mp.Color.BASE, 1, 1)
        end
        
        -- DModelPanel для отображения модели
        local ModelPreview = vgui.Create("DModelPanel", PreviewPanel)
        ModelPreview:Dock(FILL)
        ModelPreview:DockMargin(10, 55, 10, 10)
        ModelPreview:SetModel("models/error.mdl")
        ModelPreview:SetFOV(70)
        ModelPreview:SetCamPos(Vector(0, 0, 50))
        ModelPreview:SetLookAt(Vector(0, 0, 40))
        ModelPreview:SetDirectionalLight(BOX_RIGHT, Color(255, 255, 255))
        ModelPreview:SetDirectionalLight(BOX_BACK, Color(255, 255, 255))
        ModelPreview:SetDirectionalLight(BOX_FRONT, Color(0, 0, 0))
        ModelPreview.Angles = Angle(0, 45, 0)
        ModelPreview:SetAnimated(true)
        
        -- Переменная для вращения
        ModelPreview.PressX = 0
        ModelPreview.PressY = 0
        ModelPreview.Pressed = false
        ModelPreview.Hover = 0
        
        function ModelPreview:DragMousePress()
            self.PressX, self.PressY = input.GetCursorPos()
            self.Pressed = true
        end
        
        function ModelPreview:DragMouseRelease()
            self.Pressed = false
        end
        
        function ModelPreview:LayoutEntity(ent)
            if (self.bAnimated) then self:RunAnimation() end
            
            local mx, my = input.GetCursorPos()
            
            if (self.Pressed) then
                self.Hover = Lerp(FrameTime() * 2, self.Hover, (self.PressX or mx) - mx)
                self.Angles = self.Angles - Angle(0, self.Hover, 0)
                self.PressX, self.PressY = input.GetCursorPos()
            else
                self.Hover = Lerp(FrameTime() * 4, self.Hover, 0)
                self.Angles = self.Angles - Angle(0, self.Hover, 0)
                self.PressX, self.PressY = input.GetCursorPos()
            end
            
            ent:SetAngles(self.Angles)
            ent:SetPos(Vector(0, 0, 2))
        end
        
        -- Панель моделей (правая сторона)
        local ModelPanel = vgui.Create("Panel", ContentPanel)
        ModelPanel:Dock(RIGHT)
        ModelPanel:SetWide(ContentPanel:GetWide() * 0.35)
        
        ModelPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, ColorBackground)
            
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            
            -- Заголовок секции
            draw.RoundedBox(0, 10, 10, w - 20, 36, ColorBackground)
            surface.SetDrawColor(ColorOutline)
            surface.DrawOutlinedRect(10, 10, w - 20, 36, 1)
            
            draw.SimpleText("МОДЕЛИ", header_font, w/2, 28, mp.Color.BASE, 1, 1)
            draw.SimpleText("(" .. #modelsData .. " доступно)", small_font, w/2, 48, C_W_150, 1, 1)
        end
        
        -- Список моделей
        if #modelsData > 0 then
            local modelScroll = vgui.Create("DScrollPanel", ModelPanel)
            modelScroll:Dock(FILL)
            modelScroll:DockMargin(10, 60, 10, 10)
            
            for i, model in ipairs(modelsData) do
                local modelBtn = vgui.Create("DButton", modelScroll)
                modelBtn:Dock(TOP)
                modelBtn:DockMargin(0, 0, 0, 5)
                modelBtn:SetTall(60) -- Увеличил высоту для лучшего отображения
                modelBtn:SetText("")
                modelBtn.Hover = 0
                
                -- Сохраняем путь к модели
                modelBtn.ModelPath = model.path
                
                modelBtn.Paint = function(self, w, h)
                    if self:IsHovered() then
                        self.Hover = Lerp(FrameTime() * 15, self.Hover, 200)
                        
                        -- При наведении обновляем модель в предпросмотре
                        if self.ModelPath and ModelPreview:GetModel() ~= self.ModelPath then
                            ModelPreview:SetModel(self.ModelPath)
                        end
                    else
                        self.Hover = Lerp(FrameTime() * 10, self.Hover, 50)
                    end
                    
                    draw.RoundedBox(0, 0, 0, w, h, C_B_10)
                    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(mp.Color.BASE, self.Hover/3))
                    
                    surface.SetDrawColor(ColorOutline)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)
                    
                    draw.SimpleText(model.name, item_font, w/2, h/2 - 12, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
                    
                    local shortPath = string.match(model.path, "([^/]+%.mdl)$") or model.path
                    draw.SimpleText(shortPath, small_font, w/2, h/2 + 10, C_W_150, 1, 1)
                    
                    -- Индикатор предпросмотра
                    if self:IsHovered() then
                        draw.SimpleText("◄ ПРЕДПРОСМОТР", small_font, w/2, h/2 + 25, ColorAlpha(mp.Color.WHITE, self.Hover), 1, 1)
                    end
                end
                
                modelBtn.OnCursorEntered = function(self)
                    if mp.Sound and mp.Sound.CLICK then
                        surface.PlaySound(mp.Sound.CLICK)
                    end
                    
                    -- Устанавливаем модель при наведении
                    if self.ModelPath then
                        ModelPreview:SetModel(self.ModelPath)
                    end
                end
                
                modelBtn.DoClick = function(self)
                    net.Start("steamid_set_model")
                    net.WriteString(self.ModelPath)
                    net.SendToServer()
                    
                    if mp.Sound and mp.Sound.CLICK_2 then
                        surface.PlaySound(mp.Sound.CLICK_2)
                    end
                    
                    frame:AlphaTo(0, 0.2, 0, function()
                        frame:Remove()
                    end)
                end
            end
        end
        
        -- Если есть модели, показываем первую при открытии
        if #modelsData > 0 then
            timer.Simple(0.1, function()
                if IsValid(ModelPreview) and modelsData[1] then
                    ModelPreview:SetModel(modelsData[1].path)
                end
            end)
        end
        
        -- Нижняя панель с кнопкой закрытия
        local BottomPanel = vgui.Create("Panel", frame)
        BottomPanel:Dock(BOTTOM)
        BottomPanel:SetTall(42)
        BottomPanel:DockMargin(50, 10, 50, 20)
        
        local CloseBtn = vgui.Create("DButton", BottomPanel)
        CloseBtn:Dock(LEFT)
        CloseBtn:SetWide(130)
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