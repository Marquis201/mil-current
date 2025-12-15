
local CONFIG=nordahl_cfg_1524

local function eRight(a)
if a:SteamID()==CONFIG.OwnerSteamID then return true end
if a:IsAdmin()==true then if CONFIG.Allow_Admin==1 then return true end end
if a:IsSuperAdmin()==true then if CONFIG.Allow_SUPER_Admin==1 then return true end end
for _,c in ipairs(CONFIG.Allow_ULX_GROUP_CAN_ACCESS_PANEL)do if a:IsUserGroup(c) then return true end end
for _,c in ipairs(CONFIG.Allow_JOB_CAN_CHANGE_EVENTPLANNING)do if c==team.GetName( a:Team() ) then return true end end
if serverguard then for _,c in ipairs(CONFIG.SERVERGUARD_Access_rank)do if serverguard.player:GetRank(a)==c then return true end end end
return false
end

if CONFIG.F1_to_Open_the_planning==1 then
local function ShowHelp(ply)
ply:ConCommand("planning_event")
return false
end
hook.Add("ShowHelp", "ShowHelp123", ShowHelp)
end

if CONFIG.USeWorkshopContent==1 then
resource.AddWorkshop("493897275")
end
hook.Add( "PlayerSay", "nordahl_planning_event", function( ply, text, public )
	text = string.lower( text )
	if ( text == "!event" ) then
	ply:ConCommand("planning_event")
		return ""
	end
end )

function planning_server_reset(ply)
if eRight(ply)==true then
local r=1
for a=1, 7 do
for i=1, 24 do
local i=i-1
file.Write("planningevent"..r.."/planningdata"..a..(i)..".txt","")SetGlobalString("zeventplan"..r..a..i,"")
end
end
end
end
concommand.Add("planning_server_reset",planning_server_reset)

function Nordahlevent_PlayerInitialSpawn(ply)
local osdw=os.date("%w")
local osdHo=os.date("%H")
local osdH=os.date("%H")+CONFIG.UTC_GMT
if osdHo+CONFIG.UTC_GMT<0 then
osdw=osdw-1
osdH=24+osdHo+CONFIG.UTC_GMT
if osdw<0 then
osdw=6
end
elseif osdHo+CONFIG.UTC_GMT>23 then
osdw=osdw+1
osdH=-24+osdHo+CONFIG.UTC_GMT
if osdw>6 then
osdw=0
end
else
end
ply:ConCommand("tmevent "..osdH.." "..osdw.." "..os.date("%M").." "..os.date("%S"))
end
hook.Add("PlayerInitialSpawn", "NordahleventPlayerInitialSpawn", Nordahlevent_PlayerInitialSpawn);

function Nordahl_Planning_Event()
local r=1
for a=1, 7 do
for i=1, 24 do
local i=i-1
local files=file.Read("planningevent"..r.."/planningdata"..a..(i)..".txt", "DATA")
if (!files) then
file.CreateDir("planningevent"..r)
file.Write("planningevent"..r.."/planningdata"..a..(i)..".txt","")
SetGlobalString("zeventplan"..r..a..i,"")
else
SetGlobalString("zeventplan"..r..a..i,file.Read("planningevent"..r.."/planningdata"..a..(i)..".txt", "DATA"))
end
end
end
end
hook.Add("Initialize", "Nordahl_Planning_Event", Nordahl_Planning_Event);
function majeventplanning(a,b,c)
if eRight(a) then
file.Write("planningevent"..c[4].."/planningdata"..c[2]..c[3]..".txt",c[1])
SetGlobalString("zeventplan"..c[4]..c[2]..c[3],c[1])
end
end
concommand.Add("majeventplanning",majeventplanning)