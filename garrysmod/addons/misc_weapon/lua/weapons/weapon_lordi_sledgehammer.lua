CreateConVar( "lordi_sledge_break_doors", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "Should people be able to break down doors using the sledgehammer? 1 for true, 0 for false" )
CreateConVar( "lordi_sledge_break_doors_chance", "5", { FCVAR_REPLICATED, FCVAR_NOTIFY }, "What should the 1/<command> chance be before a door breaks? The higher this is, the harder it is. 1 makes it break immediadly" )

SWEP.WElements = {
	["sledge"] = { type = "Model", model = "models/weapons/lordi/c_sledgehammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-16.33, -3.294, -16.605), angle = Angle(8.395, 0, -115.988), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/weapons/lordi/c_sledgehammer.mdl" 
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true
SWEP.AutoSwitchTo = true 
SWEP.Slot = 0
SWEP.HoldType = "passive" 
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = false
SWEP.Category = "Military Play | Ножи" 
SWEP.SlotPos = 0 
SWEP.DrawAmmo = true 
SWEP.PrintName = "Кувалда"
SWEP.Author = "LordiAnders"
SWEP.Instructions = "Bash heads in! Or if they are afar, throw the thing after them!"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"                                                                    
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.AboutToSwing = false
SWEP.IsSwinging = false

SWEP.AboutToSwing2 = false
SWEP.IsSwinging2 = false

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/weapon_lordi_sledgehammer")
	killicon.Add("weapon_lordi_sledgehammer","vgui/entities/weapon_lordi_sledgehammer",Color(255,255,255,255))
	killicon.Add("ent_lordi_sledgehammer","vgui/entities/weapon_lordi_sledgehammer",Color(255,255,255,255))
	SWEP.BounceWeaponIcon = false
end

function SWEP:VerifyAndSet(bone,data)
	if not IsValid(self.Owner) then return end
	local bone = self.Owner:LookupBone(bone)
	if bone then
		self.Owner:ManipulateBoneAngles(bone,data)
	end
end

function SWEP:SetPassiveHoldType()
	if not IsValid(self.Owner) then return end
	if CLIENT then return end
	
	self:SetHoldType("passive")
	
	self:VerifyAndSet('ValveBiped.Bip01_R_UpperArm',Angle(13.8940719901227,12.334109775164,14.597405385818))
	self:VerifyAndSet('ValveBiped.Bip01_R_Hand',Angle(17,30,9))
	self:VerifyAndSet('ValveBiped.Bip01_L_Forearm',Angle(-16.224373259067,-24.886877720213,7.8929222269922))
	self:VerifyAndSet('ValveBiped.Bip01_L_UpperArm',Angle(-32.017127057138,-35.637168682527,16))
	self:VerifyAndSet('ValveBiped.Bip01_L_Hand',Angle(0.17154435310358,0,0))
end

function SWEP:SetMelee2HoldType()
	if not IsValid(self.Owner) then return end
	if CLIENT then return end
	
	self:SetHoldType("melee2")
	
	self:VerifyAndSet('ValveBiped.Bip01_R_UpperArm',Angle(0,0,0))
	self:VerifyAndSet('ValveBiped.Bip01_R_Hand',Angle(0,0,0))
	self:VerifyAndSet('ValveBiped.Bip01_L_Forearm',Angle(0,0,0))
	self:VerifyAndSet('ValveBiped.Bip01_L_UpperArm',Angle(0,0,0))
	self:VerifyAndSet('ValveBiped.Bip01_L_Hand',Angle(0,0,0))
end

function SWEP:Deploy()
self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
self:SetDeploySpeed(self.Owner:GetViewModel():SequenceDuration())
self.Weapon:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Weapon:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )

self.AboutToSwing = true --Just to disable holstering

self:SetPassiveHoldType()

if SERVER then
	timer.Simple(0.9,function()
		if not self:IsValid() then return end
		self:EmitSound("npc/combine_soldier/gear6.wav")
		self.Owner:ViewPunch( Angle(-2,0,1) )
	end)
	timer.Simple(2,function()
		if not self:IsValid() then return end
		self.Owner:ViewPunch( Angle(5,0,-5) )
		self:EmitSound("physics/flesh/flesh_impact_hard2.wav",75,180)
		self.AboutToSwing = false
	end)
end
end

function SWEP:Think()
	if self.IsSwinging and not self.Owner:KeyDown(IN_ATTACK) then
		self:PrimaryAttack()
	elseif self.IsSwinging2 and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SecondaryAttack()
	end
end

function SWEP:PrimaryAttack()
	if self.IsSwinging2 or self.AboutToSwing2 then return end
	if not self.IsSwinging then
	self.AboutToSwing = true
	self:SetMelee2HoldType()
	self.Weapon:SetNextPrimaryFire( CurTime() + 5000 )
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	timer.Simple(self.Owner:GetViewModel():SequenceDuration(),function()
		self.AboutToSwing = false
		self.IsSwinging = true
	end)
	end
	
	if self.IsSwinging then
	--Trace shit from weapon_fists.lua packed with Gmod
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		timer.Simple(0.25,function() if not self:IsValid() then return end self:SetPassiveHoldType() end)
		local trace = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 105,
			filter = self.Owner
		} )

		if ( !IsValid( trace.Entity ) ) then 
			trace = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 105,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 )
			} )
		end
		
		if trace.Entity:IsValid() or trace.HitWorld then
			self.Weapon:SendWeaponAnim(ACT_VM_HITKILL)
			self.Owner:ViewPunch( Angle(-10,0,0) )
			timer.Simple(0.1,function()
				if not self:IsValid() then return end
				self.Owner:ViewPunch( Angle(15,0,0) )
			end)
			if trace.Entity:IsValid() then
				if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
					if SERVER then trace.Entity:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav",75,math.random(70,90)) end
					local effectdata = EffectData()
					effectdata:SetOrigin(trace.HitPos)
					effectdata:SetEntity(trace.Entity)
					util.Effect( "BloodImpact", effectdata )
				elseif trace.Entity:GetClass() == "prop_door_rotating" and GetConVarNumber( "lordi_sledge_break_doors" ) == 1 then
					if SERVER and math.random(1,GetConVarNumber( "lordi_sledge_break_doors_chance" )) == 1 then
					trace.Entity:Fire("unlock")
					trace.Entity:Fire("open")
					
					trace.Entity:SetNotSolid(true)
					trace.Entity:SetNoDraw(true)
					
					--Bit of madcow stuff here... :L
					
					local ent = ents.Create("prop_physics")
					
					trace.Entity:EmitSound("physics/wood/wood_furniture_break1.wav")
					
					ent:SetPos(trace.Entity:GetPos())
					ent:SetAngles(trace.Entity:GetAngles())
					ent:SetModel(trace.Entity:GetModel())
			
					if trace.Entity:GetSkin() then
						ent:SetSkin(trace.Entity:GetSkin())
					end

					ent:Spawn()
					
					ent:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * 10000 )
					
					timer.Simple(25,function()
						if ent:IsValid() then
							ent:Remove()
						end
						trace.Entity:SetNotSolid(false)
						trace.Entity:SetNoDraw(false)
					end)
					elseif SERVER then
						trace.Entity:EmitSound("physics/wood/wood_box_break"..math.random(1,2)..".wav",75,math.random(50,150))
					end
				end
				if SERVER then trace.Entity:TakeDamage(math.random(70,120),self.Owner) end
			end
			if trace.HitWorld then
				local trace = self.Owner:GetEyeTrace()
				
				if self.Owner:GetShootPos():Distance(trace.HitPos) <= 105 then
					util.Decal("Impact.Sand",trace.HitPos + trace.HitNormal,trace.HitPos - trace.HitNormal)
				end
			end
			if SERVER then timer.Simple(0,function() if not self:IsValid() then return end self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav",75,math.random(90,110)) end) end
		else
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			if SERVER then timer.Simple(0,function() if not self:IsValid() then return end self:EmitSound("npc/zombie/claw_miss1.wav",75,60) end) end
			self.Owner:ViewPunch( Angle(-10,0,0) )
			timer.Simple(0.1,function()
				if not self:IsValid() then return end
				self.Owner:ViewPunch( Angle(30,0,0) )
			end)
		end
		self.IsSwinging = false
		self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
		self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	end
end

function SWEP:GetViewModelPosition(pos, ang)
	if self.IsSwinging then
	pos = pos + (math.random(-1,1) / 40) * ang:Right()
	pos = pos + (math.random(-1,1) / 40) * ang:Forward()
	pos = pos + (math.random(-1,1) / 40) * ang:Up()
	end
	
	return pos, ang
end

function SWEP:SecondaryAttack()
	if self.IsSwinging or self.AboutToSwing then return end
	if not self.IsSwinging2 then
	self.AboutToSwing2 = true
	self:SetMelee2HoldType()
	self.Weapon:SetNextSecondaryFire( CurTime() + 5000 )
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	timer.Simple(self.Owner:GetViewModel():SequenceDuration(),function()
		self.AboutToSwing2 = false
		self.IsSwinging2 = true
	end)
	end
	
	if self.IsSwinging2 then
	self.IsSwinging2 = false
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	timer.Simple(0.1,function()
	if SERVER then
		local sledge = ents.Create("ent_lordi_sledgehammer")
		sledge:SetOwner(self.Owner)
		sledge:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector())
		sledge:SetAngles(self.Owner:GetAngles())
		sledge:Spawn()
		sledge:Activate()
		
		sledge:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * 7000 )
		
		timer.Simple(0.25,function() self.Owner:StripWeapon(self:GetClass()) end)
	end
	end)
	end
end

function SWEP:Reload() end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self:VerifyAndSet('ValveBiped.Bip01_R_UpperArm',Angle(0,0,0))
		self:VerifyAndSet('ValveBiped.Bip01_R_Hand',Angle(0,0,0))
		self:VerifyAndSet('ValveBiped.Bip01_L_Forearm',Angle(0,0,0))
		self:VerifyAndSet('ValveBiped.Bip01_L_UpperArm',Angle(0,0,0))
		self:VerifyAndSet('ValveBiped.Bip01_L_Hand',Angle(0,0,0))
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then vm:SetMaterial("") end
	end
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end

/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	// other initialize code goes here

	if CLIENT then

		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
			
			// Init viewmodel visibility
		end
		
	end

end

function SWEP:Holster()

	if self.AboutToSwing or self.IsSwinging or self.IsSwinging2 or self.AboutToSwing2 then return end

	self:OnRemove()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end

		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		self:DrawModel()
		self:SetMaterial( "engine/occlusionproxy" )
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false
	
	function SWEP:UpdateBonePositions2(vm)
		
		if self.GrenadeThrowBoneMods then
			
			if (!vm:GetBoneCount()) then return end

			local loopthrough = self.GrenadeThrowBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.GrenadeThrowBoneMods[bonename]) then 
						allbones[bonename] = self.GrenadeThrowBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end

			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end

				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms

				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end