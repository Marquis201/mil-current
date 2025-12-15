include('shared.lua')

-- Создаем шрифты аналогично cl_donate
surface.CreateFont("Arialf_35", {
    font = "Arial",
    antialias = true,
    size = 35
})

surface.CreateFont("Arialf_30", {
    font = "Arial", 
    antialias = true,
    size = 30
})

surface.CreateFont("Arialf_25", {
    font = "Arial",
    antialias = true, 
    size = 25
})

surface.CreateFont("Arialf_22", {
    font = "Arial",
    antialias = true,
    size = 22
})

function ENT:Initialize()
    self.Color = Color(255, 255, 255, 255)
end

function ENT:Draw()
    self:DrawModel()
end

hook.Add("HUDPaint", "BriefcaseBombText", function()
    local visible_entity = LocalPlayer():GetEyeTrace().Entity
    if not IsValid(visible_entity) then return end
    
    local entityClass = visible_entity:GetClass()
    local player_to_entity_distance = LocalPlayer():GetPos():Distance(visible_entity:GetPos())
    
    if entityClass == 'briefcase_bomb' and player_to_entity_distance < 100 then
        -- Текст инструкции (используем шрифт 25 как в донат меню)
        draw.DrawText("Удерживайте [Использовать] для обезвреживания", "Arialf_25", ScrW()/2, ScrH()/2+100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        
        -- Прогресс бар таймера
        local x = ScrW() / 2.0
        local y = (ScrH() / 2.0) + 175
        local MaxTimer = ConVarExists("BriefcaseBomb_Countdown") and GetConVar("BriefcaseBomb_Countdown"):GetInt() or 30
        local newcharge = visible_entity:GetNWInt("CountdownTimer") / MaxTimer
        
        if newcharge > 0 then
            local w, h = 200, 18
            
            -- Фон прогресс бара
            surface.SetDrawColor(0, 0, 0, 240)
            surface.DrawRect(x - w / 2 - 5, y - h - 5, w + 10, h + 10)
            
            -- Заполнение прогресс бара
            surface.SetDrawColor(255, 88, 88)
            surface.DrawRect(x - w / 2, y - h, w * newcharge, h)
            
            -- Текст времени (опционально, используем шрифт 22)
            local timeLeft = math.Round(visible_entity:GetNWInt("CountdownTimer") or 0)
            if timeLeft > 0 then
                draw.SimpleText("Осталось: " .. timeLeft .. " сек.", "Arialf_22", x, y - h - 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            end
        end
    end
end)