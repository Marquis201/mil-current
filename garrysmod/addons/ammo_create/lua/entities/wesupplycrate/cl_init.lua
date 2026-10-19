include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

-- В начало файла после local LastStates = {}
local GrenadeRemaining = {}

net.Receive("wbl_grenade_limit_update", function()
    local weaponClass = net.ReadString()
    local remaining = net.ReadInt(8)
    
    GrenadeRemaining[weaponClass] = remaining
    
    -- Показываем уведомление на экране
    if remaining > 0 then
        chat.AddText(Color(255, 200, 0), "[Ящик] ", Color(255, 255, 255), "Осталось пополнений гранат: ", Color(255, 100, 100), remaining)
    else
        chat.AddText(Color(255, 0, 0), "[Ящик] ", Color(255, 255, 255), "Вы больше не можете пополнять гранаты!")
    end
end)