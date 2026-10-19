--Arizard's bodygroup thingy for DarkRP
print("Loading Arizard's bodyGroupr")

function BodygroupManagerLog(text)

	local time = string.Explode( " ", os.date() )[2]
	print("["..time.."]", text)

end

function BODYMAN:Log( msg )
	BodygroupManagerLog( msg )
end

function PlayerSpawnBodygroups( ply )

	if not IsValid(ply) then return end
	if not ply:Alive() then return end

	local skins = {}
	local bodygroups = {}

	local current = ply:GetBodyGroups()

	if bodygroups ~= {} then -- if the job has set bodygroups
		for k,v in pairs(bodygroups) do
			local name = k
			local id = ply:FindBodygroupByName( name ) -- take the name of the bodygroup specified in jobs.lua, then convert it to an ID

			if id ~= -1 then -- check if it exists
				local cur_group = ply:GetBodygroup( id ) -- the currently used bodygroup
				local allowed = false
				for k2, group in ipairs(bodygroups[name]) do
					if group == cur_group then
						allowed = true -- if the current bodygroup is in the table, then it's allowed
					end
				end

				if not allowed then
					ply:SetBodygroup( id, bodygroups[name][1] )
				end
			end
			
		end
		
	end


end

hook.Add("PlayerLoadout", "PlayerSpawnBodygroups", function(ply)
	PlayerSpawnBodygroups(ply)
	timer.Simple(0,	function() PlayerSpawnBodygroups( ply ) end)
end)

hook.Add("OnPlayerChangedTeam", "PlayerSpawnBodygroups", function( ply, before, after )
	PlayerSpawnBodygroups( ply ) -- We need to make sure that it checks allowed bodygroups on spawn, on teamchange, and just to be safe, on darkrpvarchanged
	timer.Simple(0, function()
		PlayerSpawnBodygroups( ply )
	end)
end)
hook.Add("OnDarkRPVarChanged", "PlayerSpawnBodygroups", function()
	for k,v in ipairs(player.GetAll()) do
		PlayerSpawnBodygroups( v )
	end
end)

concommand.Add("listbodygroups", function(ply, cmd, args)

	if ply:Alive() and BODYMAN:CanAccessCommand(ply, cmd) then

		ply:SendLua([[PrintTable(LocalPlayer():GetBodyGroups())]])
		ply:SendLua([[print("SkinCount :",LocalPlayer():SkinCount())]])

	end

end)

if not file.Exists("bodyman", "DATA") then
	file.CreateDir("bodyman")
end

if not file.Exists("bodyman/data.txt", "DATA") then
	file.Write("bodyman/data.txt", "")
end

function BODYMAN:LoadData()
	self.Data = util.JSONToTable( file.Read("bodyman/data.txt", "DATA") ) or {}
end
BODYMAN:LoadData()
function BODYMAN:SaveData()
	file.Write( "bodyman/data.txt", util.TableToJSON( self.Data ) )
end
function BODYMAN:SaveClosets()
	self.Data.Closets = {}

	local closets = ents.FindByClass("bodyman_closet")

	for k,ent in ipairs( closets ) do
		table.insert( self.Data.Closets, { pos = ent:GetPos(), ang = ent:GetAngles(), map = game.GetMap() } )
	end

	self:SaveData()
	self:LoadData()
end

function BODYMAN:LoadClosets()
	if self.Data.Closets then
		if self.Data.Closets ~= {} then
			-- remove old closets
			for k,v in ipairs( ents.FindByClass( "bodyman_closet" ) ) do
				v:Remove()
			end
			for k,v in ipairs( self.Data.Closets ) do
				if v.map == game.GetMap() then
					local ent = ents.Create("bodyman_closet")
					ent:SetPos( v.pos )
					ent:SetAngles( v.ang )
					ent:Initialize()
					ent:Activate()
					ent:Spawn()
					ent:GetPhysicsObject():EnableMotion( false )
				end
			end
		end
	end
end
hook.Add("InitPostEntity", "BODYMAN:LoadClosets", function() BODYMAN:LoadClosets() end) -- load closets on map load

function BODYMAN:RemoveClosets()
	for k,v in ipairs( ents.FindByClass( "bodyman_closet" ) ) do
		v:Remove()
	end
end

function BODYMAN:HasAdmin( ply )
	if IsValid( ply ) then
		if not ply:IsSuperAdmin() then
			return false
		end
	end
	return true 
end
concommand.Add("bodyman_saveclosets", function(ply, cmd, args)
	if BODYMAN:CanAccessCommand(ply, cmd) then
		BODYMAN:SaveClosets()
		BODYMAN:ChatPrint( ply, "Saved Closets.")
		local testmeme = "{{steamid}}"
		local name = "SERVER"
		if IsValid( ply ) then name = ply:Nick() end
		BODYMAN:Log( name.." Saved Closets." )
	end
end)
concommand.Add("bodyman_loadclosets", function(ply, cmd, args)
	if BODYMAN:CanAccessCommand(ply, cmd) then
		BODYMAN:LoadClosets()
		BODYMAN:ChatPrint( ply, "Loaded Closets.")

		local name = "SERVER"
		if IsValid( ply ) then name = ply:Nick() end
		BODYMAN:Log( name.." Loaded Closets." )
	end
end)
concommand.Add("bodyman_removeclosets", function(ply, cmd, args)
	if BODYMAN:CanAccessCommand(ply, cmd) then
		BODYMAN:RemoveClosets()
		BODYMAN:ChatPrint( ply, "Removed Closets without saving. Save Closets to make this permanent.")

		local name = "SERVER"
		if IsValid( ply ) then name = ply:Nick() end
		BODYMAN:Log( name.." Removed Closets without saving." )
	end
end)
concommand.Add("bodyman_spawncloset", function(ply, cmd, args)
	if BODYMAN:CanAccessCommand(ply, cmd) then
		
		local ent = ents.Create("bodyman_closet")
		local tr = ply:GetEyeTrace()

		ent:SetPos( tr.HitPos )
		ent:SetAngles( ply:EyeAngles() - Angle( ply:EyeAngles().p, 0,0) )
		ent:Activate()
		ent:Spawn()

		BODYMAN:ChatPrint( ply, "Spawned a Closet where they were looking. "..tostring( ent:GetPos() ) )

		local name = "SERVER"
		if IsValid( ply ) then name = ply:Nick() end
		BODYMAN:Log( name.." Removed Closets without saving." )
	end
end)
