swv3 = swv3 or {}
local util = util
local pairs = pairs
local table = table
local istable = istable
local IsInWorld = util.IsInWorld
local TraceLine = util.TraceLine
local QuickTrace = util.QuickTrace
local Effect = util.Effect
local MASK_ALL = MASK_ALL
local tableinsert = table.insert
local IsValid = IsValid
local DMG_BLAST = DMG_BLAST
local soundSpeed 		= 18005.25*18005.25 -- 343m/s
local Level = {
	[1] = {
		112,
		150,
		150,
	},
	[2] = {
		112,
		150,
		150,
	},
	[3] = {
		112,
		150,
		150,
	},
}
local BigExplosionSoundLevels = {
	[1] = {
		150,
		150,
		150,
	},
	[2] = {
		150,
		150,
		150,
	},
	[3] = {
		150,
		150,
		150,
	},
}
local BigExplosionSounds = {
}

net.Receive("swv3_net_sound_new",function()
	local pos = net.ReadVector()
	local tab = net.ReadTable()
	
	if not tab[1] then return end
	
	local e1 = tab[1]
	local e2 = tab[2] or e1
	local e3 = tab[3] or e2
	
	local div = math.Clamp(math.ceil(1),1,#Level)
	local vol = 1
	local currange = 1000 / div
	
	local curRange_min = currange*5
	curRange_min = curRange_min*curRange_min
	local curRange_mid = currange*14
	curRange_mid = curRange_mid * curRange_mid
	local curRange_max = currange*40
	curRange_max = curRange_max * curRange_max
	
	local ply = LocalPlayer():GetViewEntity()
	local plypos = ply:GetPos()
	local distance = ply:GetPos():DistToSqr(pos)
	
	hook.Run("SWV3Explosion",e1,pos,distance,e2,e3)
	
	if distance <= curRange_min then
		
		if not LocalPlayer():InVehicle() then
			util.ScreenShake(pos,10,75,2,math.sqrt(curRange_min))
		end
		
		if BigExplosionSounds[e1] then
			sound.Play(e1,pos,BigExplosionSoundLevels[div][1],100,1 * vol)
		else
			sound.Play(e1,pos,Level[div][1],100,1 * vol)
		end
		
	elseif distance <= curRange_mid then
		timer.Simple(distance/soundSpeed,function()
			if not LocalPlayer():InVehicle() then
				util.ScreenShake(pos,3,75,1.5,math.sqrt(curRange_mid))
			end
			
			if BigExplosionSounds[e3] then
				sound.Play(e2,pos,BigExplosionSoundLevels[div][2],100,1 * vol)
			else
				sound.Play(e2,pos,Level[div][2],100,0.5 * vol)
			end
		end)
	else
		timer.Simple(distance/soundSpeed,function()
			if BigExplosionSounds[e2] then
				sound.Play(e1,pos,BigExplosionSoundLevels[div][3],100,1 * vol)
			else
				sound.Play(e3,pos,Level[div][3],100,1 * vol)
			end
		end)
	end
end)

--Particles
game.AddParticles( "particles/Missile_Thrust.pcf") 
game.AddParticles( "particles/Rocket_Thrust.pcf") 
game.AddParticles( "particles/AAM_Thrust.pcf") 
game.AddParticles( "particles/WP_trail.pcf") 
game.AddParticles( "particles/sw_flare.pcf") 
game.AddParticles( "particles/gb5_emp.pcf") 
game.AddParticles( "particles/gwa_agm62.pcf")
game.AddParticles( "particles/gw_mark77.pcf")
game.AddParticles( "particles/gwa_m388.pcf")
game.AddParticles( "particles/gwa_t12.pcf")
game.AddParticles( "particles/gwa_blu1.pcf")
game.AddParticles( "particles/gwa_fab100.pcf")
game.AddParticles( "particles/gw_moab_gp100_pack.pcf")
game.AddParticles( "particles/gw_gbu12.pcf")
game.AddParticles( "particles/gw_mk84.pcf")
game.AddParticles( "particles/gw_m66.pcf")
game.AddParticles( "particles/gwa_blockbuster.pcf")
game.AddParticles( "particles/gwa_mk82a3.pcf")
game.AddParticles( "particles/gw_rocket_test.pcf")
game.AddParticles( "particles/gw_death.pcf")
game.AddParticles( "particles/gwa_mop.pcf")
game.AddParticles( "particles/gwa_sdb.pcf")
game.AddParticles( "particles/gwa_water_splode.pcf")
game.AddParticles( "particles/gwa_foab.pcf")
game.AddParticles( "particles/gwa_tallboy.pcf")
game.AddParticles( "particles/gwa_m61.pcf")
game.AddParticles( "particles/gwa_foab_new.pcf")
game.AddParticles( "particles/gwa_w48.pcf")
game.AddParticles( "particles/gwa_actual_tallboy.pcf")
game.AddParticles( "particles/gwa_grigori.pcf")
game.AddParticles( "particles/gwa_grandslam.pcf")
game.AddParticles( "particles/gwa_agm_norm.pcf")
game.AddParticles( "particles/gwa_fizzle.pcf")
game.AddParticles( "particles/gwa_littleboy_fizzle.pcf")
game.AddParticles( "particles/gwa_gas.pcf")
game.AddParticles( "particles/gwa_rds1.pcf")
game.AddParticles( "particles/gw_m66_new.pcf")
game.AddParticles( "particles/gw_dirty.pcf")
game.AddParticles( "particles/gw_b61.pcf")
game.AddParticles( "particles/gw_gbu12_new.pcf")
game.AddParticles( "particles/gw_mike.pcf")
game.AddParticles( "particles/gw_must.pcf")
game.AddParticles( "particles/gw_250lb.pcf")
game.AddParticles( "particles/gw_500lb.pcf")
game.AddParticles( "particles/gw_1000kg.pcf")
game.AddParticles( "particles/gw_bunker.pcf")
game.AddParticles( "particles/gw_2000lb.pcf")
game.AddParticles( "particles/gw_foabn.pcf")
game.AddParticles( "particles/gw_moabn.pcf")

game.AddParticles( "particles/doi_explosion_fx.pcf")
game.AddParticles( "particles/doi_explosion_fx_b.pcf")
game.AddParticles( "particles/doi_explosion_fx_c.pcf")
game.AddParticles( "particles/doi_explosion_fx_grenade.pcf")
game.AddParticles( "particles/doi_explosion_fx_new.pcf")
game.AddParticles( "particles/doi_impact_fx.pcf" )
game.AddParticles( "particles/doi_weapon_fx.pcf" )
game.AddParticles( "particles/gb_water.pcf")
game.AddParticles( "particles/gb5_100lb.pcf")
game.AddParticles( "particles/gb5_500lb.pcf")
game.AddParticles( "particles/gb5_1000lb.pcf")
game.AddParticles( "particles/gb5_jdam.pcf")
game.AddParticles( "particles/gb5_large_explosion.pcf")
game.AddParticles( "particles/gb5_napalm.pcf")
game.AddParticles( "particles/gb5_light_bomb.pcf")
game.AddParticles( "particles/gb5_high_explosive_2.pcf")
game.AddParticles( "particles/gb5_high_explosive.pcf")
game.AddParticles( "particles/gb5_fireboom.pcf")
game.AddParticles( "particles/neuro_tank_ap.pcf")
game.AddParticles( "particles/ins_rockettrail.pcf")
game.AddParticles( "particles/ammo_cache_ins.pcf")
game.AddParticles( "particles/doi_rockettrail.pcf")
game.AddParticles( "particles/mnb_flamethrower.pcf")
game.AddParticles( "particles/impact_fx_ins.pcf" )
game.AddParticles( "particles/environment_fx.pcf")
game.AddParticles( "particles/water_impact.pcf")
game.AddParticles( "particles/explosion_fx_ins.pcf")
game.AddParticles( "particles/weapon_fx_tracers.pcf" )
game.AddParticles( "particles/weapon_fx_ins.pcf" )
game.AddParticles( "particles/gred_particles.pcf" )
game.AddParticles( "particles/fire_01.pcf" )
game.AddParticles( "particles/doi_explosions_smoke.pcf" )
game.AddParticles( "particles/explosion_fx_ins_b.pcf" )
game.AddParticles( "particles/ins_smokegrenade.pcf" )
game.AddParticles( "particles/ww1_gas.pcf" )

--Decals
game.AddDecal("scorch_1kg","decals/scorch_1kg")
game.AddDecal("scorch_25kg","decals/scorch_25kg")
game.AddDecal("scorch_50kg","decals/scorch_50kg")
game.AddDecal("scorch_100kg","decals/scorch_100kg")
game.AddDecal("scorch_250kg","decals/scorch_250kg")
game.AddDecal("scorch_500kg","decals/scorch_500kg")
game.AddDecal("scorch_1000kg","decals/scorch_1000kg")
game.AddDecal("scorch_1500kg","decals/scorch_1500kg")
game.AddDecal("scorch_3000kg","decals/scorch_3000kg")
game.AddDecal("scorch_5000kg","decals/scorch_5000kg")
game.AddDecal("scorch_9000kg","decals/scorch_9000kg")

--Fonts
surface.CreateFont( "sw_digital", {
	font = "DS-Digital",
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont("sw_hud", {
    font = "Roboto",
    size = 20,
    weight = 550,
    antialias = true,
    scanlines = 2,
    shadow = true
})

--Missile coordinates
swv3 = istable( swv3 ) and swv3 or {}
swv3.ThemeColor = Color(255,0,0,255)

CreateClientConVar( "sw_coord_x", 0, true, true,"Missile target coordinate on X axis")
CreateClientConVar( "sw_coord_y", 0, true, true,"Missile target coordinate on Y axis")
CreateClientConVar( "sw_coord_z", 0, true, true,"Missile target coordinate on Z axis")
CreateClientConVar( "sw_launch_allowed", 0, true, true,"Allow missile launch")

local FrameSizeX = 500
local FrameSizeY = 190

function swv3:OpenCoordinatesMenu( keep_position )
	local xPos
	local yPos

	if IsValid( swv3.Frame ) then
		if keep_position then
			xPos = swv3.Frame:GetX()
			yPos = swv3.Frame:GetY()
		end

		swv3.Frame:Close()
		swv3.Frame = nil
	end

	swv3.Frame = vgui.Create( "DFrame" )
	swv3.Frame:SetSize( FrameSizeX, FrameSizeY )
	swv3.Frame:SetTitle( "" )
	swv3.Frame:SetDraggable( true )
	swv3.Frame:SetScreenLock( true )
	swv3.Frame:MakePopup()
	swv3.Frame:Center()
	if keep_position and xPos and yPos then
		swv3.Frame:SetPos( xPos, yPos )
	end

	local LCFrame = vgui.Create( "DPanel",swv3.Frame )
	LCFrame:SetPos(330,80)
	LCFrame:SetSize( 150, 60 )

	local XCoord = vgui.Create( "DLabel",LCFrame )
	local YCoord = vgui.Create( "DLabel",LCFrame )
	local ZCoord = vgui.Create( "DLabel",LCFrame )	
	local LC = vgui.Create( "DLabel",LCFrame )	
	local Status = vgui.Create( "DLabel",LCFrame )	
	LC:SetPos(0,45)
	LC:SetTextColor(Color(0,0,0))
	LC:SetText( "Status:" )

	local LaunchButton = vgui.Create( "DButton", swv3.Frame )
	LaunchButton:SetPos( 330, 30 )
	LaunchButton:SetSize( 150, 30 )

	local XFrame = vgui.Create( "DPanel",swv3.Frame )
	XFrame:SetPos(10,30)
	XFrame:SetSize( 300, 40 )

	local XLabel = vgui.Create( "DLabel",XFrame )
	XLabel:SetTextColor(Color(255,0,0))
	XLabel:SetText( "X coordinate" )

	local XEntry = vgui.Create( "DTextEntry",XFrame) -- create the form as a child of frame
	XEntry:SetNumeric(true)
	XEntry:SetPos(0,15)
	XEntry:Dock( BOTTOM )
	XEntry.OnEnter = function( self )
		local X = GetConVar("sw_coord_x")
		X:SetInt(self:GetValue())
	end

	local YFrame = vgui.Create( "DPanel",swv3.Frame )
	YFrame:SetPos(10,80)
	YFrame:SetSize( 300, 40 )

	local YLabel = vgui.Create( "DLabel",YFrame )
	YLabel:SetTextColor(Color(255,0,0))
	YLabel:SetText( "Y coordinate" )

	local YEntry = vgui.Create( "DTextEntry",YFrame) -- create the form as a child of frame
	YEntry:SetNumeric(true)
	YEntry:SetPos(0,15)
	YEntry:Dock( BOTTOM )
	YEntry.OnEnter = function( self )
		local Y = GetConVar("sw_coord_y")
		Y:SetInt(self:GetValue())
	end

	local ZFrame = vgui.Create( "DPanel",swv3.Frame )
	ZFrame:SetPos(10,130)
	ZFrame:SetSize( 300, 40 )

	local ZLabel = vgui.Create( "DLabel",ZFrame )
	ZLabel:SetTextColor(Color(255,0,0))
	ZLabel:SetText( "Z coordinate" )

	local ZEntry = vgui.Create( "DTextEntry",ZFrame) -- create the form as a child of frame
	ZEntry:SetNumeric(true)
	ZEntry:SetPos(0,15)
	ZEntry:Dock( BOTTOM )	
	ZEntry.OnEnter = function( self )
		local Z = GetConVar("sw_coord_z")
		Z:SetInt(self:GetValue())
	end
	
	swv3.Frame.Paint = function(self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
		draw.RoundedBoxEx( 8, 1, 26, w-2, h-27, Color( 255, 255, 255, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 8, 0, 0, w, 25, swv3.ThemeColor, true, true )

		draw.SimpleText( "[SW Bombs V3] - Missile target coordinates ", "sw_hud", 5, 11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		XCoord:SetTextColor(Color(0,0,0))
		XCoord:SetText( "X:"..GetConVar("sw_coord_x"):GetInt() )

		YCoord:SetPos(0,15)
		YCoord:SetTextColor(Color(0,0,0))
		YCoord:SetText( "Y:"..GetConVar("sw_coord_y"):GetInt() )

		ZCoord:SetPos(0,30)
		ZCoord:SetTextColor(Color(0,0,0))
		ZCoord:SetText( "Z:"..GetConVar("sw_coord_z"):GetInt() )

		Status:SetPos(40,45)
		if GetConVar("sw_launch_allowed"):GetInt() == 1 then
			LaunchButton:SetText( "Disallow launch" )
			LaunchButton.DoClick = function()
				RunConsoleCommand( "sw_launch_allowed", 0 )	
			end

			Status:SetTextColor(Color(0,255,0))
			Status:SetText( "Ready" )
		else			
			LaunchButton:SetText( "Allow launch" )
			LaunchButton.DoClick = function()
				RunConsoleCommand( "sw_launch_allowed", 1 )	
			end

			Status:SetTextColor(Color(255,0,0))
			Status:SetText( "Standby" )
		end
 	end
end

concommand.Add( "sw_open_targeting_menu", function( ply, cmd, args ) swv3:OpenCoordinatesMenu() end )