
if SERVER then
AddCSLuaFile("nordahl_cl/nordahl_event_planning_cl.lua")
include("nordahl_sv/nordahl_event_planning_sv.lua")
end

if CLIENT then
include("nordahl_cl/nordahl_event_planning_cl.lua")
end

print("Nordahl - Event Planning Editor - Init Ok")