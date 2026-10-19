local mp = mp

util.AddNetworkString("mp.properties.buy_motel")
util.AddNetworkString("mp.properties.sell_motel")
util.AddNetworkString("mp.properties.initgroup")

nw.SetGlobal("mp.Properties", nw.GetGlobal("mp.Properties") or {})
nw.SetGlobal("mp.Doors", nw.GetGlobal("mp.Doors") or {})

local vec = Vector
local Color = Color

mp.properties.Doors = {
	//{
	//	Name = "8 кв. Старый город",
	//	MapIDs = { vec(-8276, 1212, -638) }
	//},

	// РФ

	{
		Name = "Санчасть РФ",
		Teams = "rf",
		Clr = mp.faction.rf.color,
		Locked = true,
		MapIDs = { vec(-11452, -8281, -418) }
	},
	{
		Name = "Штаб РФ",
		Teams = "rf",
		Clr = mp.faction.rf.color,
		Locked = true,
		MapIDs = { vec(-12669, -9450, -418), vec(-12888, -10125, -418), vec(-12693, -10234, -418) }
	},

	{
		Name = "Ангар РФ",
		Teams = "rf",
		Clr = mp.faction.rf.color,
		Locked = true,
		MapIDs = { vec(-13248, -11503, -443) }
	},

	{
		Name = "Изолятор РФ",
		Teams = "rf",
		Clr = mp.faction.rf.color,
		Locked = true,
		MapIDs = { vec(-11780, -10985, -418), vec(-11452, -10854, -418) }
	},

	{
		Name = "КХО РФ",
		Teams = "rf",
		Clr = mp.faction.rf.color,
		Locked = true,
		MapIDs = { vec(-12309, -11804, -418) }
	},

	{
		Name = "База РФ",
		Teams = "rf",
		Clr = mp.faction.rf.color,
		Locked = true,
		MapIDs = { vec(-11083, -12042, -458), vec(-12063, -11548, -458), vec(-12038, -11296, -458) }
	},

	// NATO

	{
		Name = "Санчасть NATO",
		Teams = "nato",
		Clr = mp.faction.nato.color,
		Locked = true,
		MapIDs = { vec(10719, -5404, -418) }
	},
	{
		Name = "Штаб NATO",
		Teams = "nato",
		Clr = mp.faction.nato.color,
		Locked = true,
		MapIDs = { vec(12429, -2928, -418), vec(12648, -2253, -418), vec(12453, -2144, -418) }
	},

	{
		Name = "Ангар NATO",
		Teams = "nato",
		Clr = mp.faction.nato.color,
		Locked = true,
		MapIDs = { vec(12333, -1576, -450) }
	},

	{
		Name = "Изолятор NATO",
		Teams = "nato",
		Clr = mp.faction.nato.color,
		Locked = true,
		MapIDs = { vec(10849, -1156, -418), vec(10718, -828, -418) }
	},

	{
		Name = "КХО NATO",
		Teams = "nato",
		Clr = mp.faction.nato.color,
		Locked = true,
		MapIDs = { vec(11409, -3564, -418) }
	},

	{
		Name = "База NATO",
		Teams = "nato",
		Clr = mp.faction.nato.color,
		Locked = true,
		MapIDs = { vec(11160, -1414, -458), vec(11650, -3308, -458), vec(10750, -2660, -458) }
	},

	{
		Name = "Казарма NATO",
		Teams = "nato",
		Clr = mp.faction.nato.color,
		Locked = true,
		MapIDs = { vec(11571, -602, -418), vec(12083, -602, -418), vec(13069, -600, -418), Vector(12595, -602, -418) }
	},
}

local function LoadDoors()
	local searchRadius = 15
	local tb_properties = {}
	local tb_doors = {}

	for k, v in ipairs(mp.properties.Doors) do
		local doors = {}
		local group

		if not v.Teams then
			group = nil
		else
			group = v.Name

			mp.addDoorGroup(v.Name, v.Clr or color_white, v.Teams)
		end

		for i = 1, #v.MapIDs do
			local pos = v.MapIDs[i]
			local found = false

			local allDoors = ents.FindByClass("prop_door_rotating")
			for _, door in ipairs(allDoors) do
				if IsValid(door) and door:GetPos():Distance(pos) <= searchRadius then
					doors[door:EntIndex()] = true

					if v.Locked and v.Locked == true then
						mp.properties.close_door(door)
					else
						mp.properties.open_door(door)
					end

					found = true
					break
				end
			end

			if not found then
				print("Не найдена дверь для позиции: ", pos, v.Name)
			end
		end

		local id = #tb_properties + 1
		tb_properties[id] = {
			name = v.Name,
			cost = (v.Teams or v.Motel or v.StopSell) and 0 or mp.properties.price * #v.MapIDs,
			doors = doors,
			group = group
		}

		for index, _ in pairs(doors) do
			tb_doors[index] = id
		end

		MsgC(RED, "[PROPERTY] ", ("%s (%d) is loaded!"):format(v.Name or group, id))
	end

	nw.SetGlobal("mp.Properties", tb_properties)
	nw.SetGlobal("mp.Doors", tb_doors)
end

function mp.properties.register(id, name, cost, doors, group)
	doors = mp.properties.get_ent_ids(doors)

	if not mp.properties.GetGroup()[group] then
		group = nil
	end

	local tb_properties = nw.GetGlobal("mp.Properties") or {}

	tb_properties[id] = {
		name = name,
		cost = cost,
		doors = doors,
		group = group
	}

	nw.SetGlobal("mp.Properties", tb_properties)

	local tb_doors = nw.GetGlobal("mp.Doors") or {}

	for index, _ in pairs(doors) do
		tb_doors[index] = id

		local ent = ents.GetByIndex(index)
		if IsValid(ent) then
			mp.properties.close_door(ent)
		end
	end

	nw.SetGlobal("mp.Doors", tb_doors)

	MsgC(RED, "[PROPERTY] ", ("%s (%d) is loaded!"):format(name or group, id))
end

function mp.properties.get_map_creation_ids(arr)
	local to_return = {}

	for k, _ in pairs(arr) do
		local ent = ents.GetByIndex(k)
		if not ent then continue end

		to_return[ent:MapCreationID()] = true
	end

	return to_return
end

function mp.properties.get_ent_ids(arr)
	local to_return = {}

	for k, _ in pairs(arr) do
		local ent = ents.GetMapCreatedEntity(k)
		if not ent then continue end

		to_return[ent:EntIndex()] = true
	end

	return to_return
end

function mp.properties.has_access(ply, ent)
	if not ent:IsDoor() then return false end
	if not ent:IsProperty() then return false end

	if ply:IsOwnsProperty(ent) then return true end
	if ply:IsCoownsProperty(ent) then return true end
	if ent:IsPropertyGroupOwned() and ent:GetPropertyGroupTeams()[ply:Team()] then return true end
	if ent:IsPropertyGangOwned() and IsValid(ent:GetPropertyOwner()) and ply:GetGang() == ent:GetPropertyOwner():GetGang() then return true end


	return false
end

function mp.properties.open_door(ent)
	ent:Fire("Unlock")
	ent:SetNetVar("mp.DoorIsLocked", false)
end

function mp.properties.close_door(ent)
	ent:Fire("Lock")
	ent:SetNetVar("mp.DoorIsLocked", true)
end

hook.Add("InitPostEntity", "mp.properties.InitPostEntity", function()
	timer.Simple(5, function()
		LoadDoors()
	end)
end)

hook.Add("PostCleanupMap", "mp.properties.PostCleanupMap", function()
	LoadDoors()
end)
