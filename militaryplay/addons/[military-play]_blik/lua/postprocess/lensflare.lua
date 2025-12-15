-- Lens Flare Post-Processing Effect
-- Version 2.0
-- By Mahalis (revised by Rush_Freak)<mahalis@gmail.com>
--
-- Feel free to learn from and reuse this code; if you release something that uses it,
-- please credit me as the original author.

-- Mew appreciates this. Thank you - shortnamesalex

local pp_lensflare = CreateClientConVar("pp_lensflare", "1", false, false)
local pp_lensflare_intensity = CreateClientConVar("pp_lensflare_intensity","1.0",false,false)

local iris = surface.GetTextureID("effects/lensflare/iris")
local iris2 = surface.GetTextureID("effects/lensflare/iris2")
local iris3 = surface.GetTextureID("effects/lensflare/iris3")
local flare = surface.GetTextureID("effects/lensflare/flare")

local function mulW(x,f)
	return (x - ScrW()/2) * f + ScrW()/2
end

local function mulH(y,f)
	return (y - ScrH()/2) * f + ScrH()/2
end

local function CenteredSprite(x,y,sz)
	surface.DrawTexturedRect(x - sz/2,y - sz/2,sz,sz)
end

local function DrawFlare()
	if !pp_lensflare:GetBool() then return end
	
	local sun = util.GetSunInfo()
	
	if !sun or sun.obstruction == 0 then return end
	
	local sunpos = (EyePos() + sun.direction * 4096):ToScreen()
	
	local dot = (sun.direction:Dot(EyeVector()) - 0.8) * 5
	
	local rSz = ScrW() * 0.15
	
	local aMul = math.Clamp((sun.direction:Dot(EyeVector()) - 0.4) * (1 - math.pow(1 - sun.obstruction,2)),0,1) * pp_lensflare_intensity:GetFloat()
	
	if aMul == 0 then return end
	
	surface.SetTexture(flare)
	surface.SetDrawColor(255,255,255,255 * aMul)
	CenteredSprite(sunpos.x,sunpos.y,rSz*7)

	surface.SetTexture(iris)
	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,1.8),mulH(sunpos.y,1.0),rSz*0.55)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,1.82),mulH(sunpos.y,1.0),rSz*0.1)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,1.5),mulH(sunpos.y,1.0),rSz*0.05)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,0.6),mulH(sunpos.y,1.0),rSz*0.05)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,0.59),mulH(sunpos.y,1.0),rSz*0.15)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,0.3),mulH(sunpos.y,1.0),rSz*0.1)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-0.7),mulH(sunpos.y,1.0),rSz*0.1)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-0.72),mulH(sunpos.y,1.0),rSz*0.15)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-0.73),mulH(sunpos.y,1.0),rSz*0.05)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-0.9),mulH(sunpos.y,1.0),rSz*0.1)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-0.92),mulH(sunpos.y,1.0),rSz*0.15)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-1.3),mulH(sunpos.y,1.0),rSz*0.15)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-1.4),mulH(sunpos.y,1.0),rSz*1.5)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,6))
	CenteredSprite(mulW(sunpos.x,-1.7),mulH(sunpos.y,1.0),rSz*2.5)

	surface.SetDrawColor(255,255,255,555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-1.7),mulH(sunpos.y,1.0),rSz*0.1)

	surface.SetTexture(iris2)
	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,2.4),mulH(sunpos.y,1.2),rSz*0.95)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-1.2),mulH(sunpos.y,0.8),rSz*0.55)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,1.0),mulH(sunpos.y,1.0),rSz*1.55)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-2.3),mulH(sunpos.y,1.0),rSz*1.5)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-3.2),mulH(sunpos.y,1.0),rSz*1.5)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,2.3),mulH(sunpos.y,1.0),rSz*1.5)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,2.3),mulH(sunpos.y,1.3),rSz*0.55)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,1.0),mulH(sunpos.y,1.0),rSz*0.65)

	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,3.4),mulH(sunpos.y,1.0),rSz*0.25)

	surface.SetTexture(iris3)
	surface.SetDrawColor(255,255,255,1555 * math.pow(aMul,3))
	CenteredSprite(mulW(sunpos.x,-0.3),mulH(sunpos.y,1.2),rSz*1.3)
	
end

hook.Add("RenderScreenspaceEffects","LensFlare",DrawFlare)

local function BuildControlPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#Lens Flare", Description = "#Cinematic lens-flare effect" }  )
	CPanel:AddControl( "Slider", { Label = "#Intensity", Command = "pp_lensflare_intensity", Type = "Float", Min = "0", Max = "1" }  )
end

local function AddPostProcessMenu()
	spawnmenu.AddToolMenuOption( "PostProcessing", "PPSimple", "LensFlare", "#Lens Flare", "", "", BuildControlPanel, { SwitchConVar = "pp_lensflare" } )
end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_LensFlare", AddPostProcessMenu )