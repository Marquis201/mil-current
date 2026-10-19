ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

function ENT:SetupDataTables()
	self:NetworkVar("Bool","Boss")
	self:NetworkVar("Int","HP")
	self:NetworkVar("Int","Clip")
end

if CLIENT then
    if EmissiveSys then
        EmissiveSys:Add("models/cpthazama/re5/em84/pl0800_10Core_T",{
            Brightness=0.4,
            Mask="models/cpthazama/re5/em84/pl0800_10Core_C",
			Think = function(now, rt, def)
				local time = 2
				local glow = 2 +(math.sin(now *(math.pi *2 /time)) +1) *1.5
				local brightness = 0.1 +(math.sin(now *(math.pi *2 /time)) +1) *0.005
				return glow, brightness, def.Mask
			end
        })
    end

	local matHUD = Material("hud/cpthazama/re5/lowhp.png", "smooth additive")
	local matHUD_Base = Material("hud/cpthazama/re5/hp_base.png","smooth additive")
	local matHUD_HP = Material("hud/cpthazama/re5/hp_bar_c.png","smooth additive")

	surface.CreateFont("VJFont_WeskerAmmo", {
		font = "Trebuchet24",
		size = 80,
		weight = 600,
		blursize = 1,
		antialias = true,
		italic = false,
	})

	local function ScreenPos(x,y)
		local w = ScrW()
		local h = ScrH()
		local pos = {}
		pos.x = w *0.5 +w *x *0.01
		pos.y = h *0.5 +w *y *0.01

		return pos
	end

	local function ScreenScale(x,y)
		local w = ScrW()
		local h = ScrH()
		local size = {}
		size.x = (w *x *0.01)
		size.y = (w *y *0.01)
		return size
	end

	local function DrawIcon(mat,x,y,width,height,r,g,b,a,ang)
		surface.SetDrawColor(Color(r or 255,g or 255,b or 255,a or 255))
		surface.SetMaterial(mat)
		local pos = ScreenPos(x,y)
		local size = ScreenScale(width,height)
		surface.DrawTexturedRectRotated(pos.x,pos.y,size.x,size.y,ang or 0)
	end

	local function DrawIcon_UV(mat,x,y,width,height,uv,r,g,b,a)
		local uv = uv or {0,0,1,1}
		surface.SetDrawColor(Color(r or 255,g or 255,b or 255,a or 255))
		surface.SetMaterial(mat)
		local pos = ScreenPos(x,y)
		local size = ScreenScale(width,height)
		surface.DrawTexturedRectUV(pos.x,pos.y,size.x,size.y,uv[1],uv[2],uv[3],uv[4])
	end

	local function DrawText(text,font,x,y,color,alignX,alignY)
		local textSize = surface.GetTextSize(text) or string.len(text)
		local pos = ScreenPos(x,y)
		local size = ScreenScale(textSize,0)
	
		draw.SimpleText(text,font,pos.x,pos.y,color or color_white,alignX or 0,alignY or 0)
	end

	local function DrawRect(x,y,w,h,r,g,b,a)
		surface.SetDrawColor(Color(r or 255,g or 255,b or 255,a or 255))
		local pos = ScreenPos(x,y)
		local size = ScreenScale(w,h)
		surface.DrawRect(pos.x -size.x *0.5, pos.y -size.y *0.5, size.x, size.y)
	end

    function ENT:Initialize()
		local pulseAlpha = 0
		local hpHold = 0
		local hpAlpha = 255
		local ammoHold = 0
		local ammoAlpha = 255
		local ammoCol = Color(255,255,255)
		local ammoColLow = Color(255,115,115)
		local ammoColLerp = ammoCol
		local rmbUsed = false
		local aimPos
		hook.Add("HUDPaint",self,function()
			if GetConVar("vj_re5_wesker_nohud"):GetBool() then return end
			local ply = LocalPlayer()
			if IsValid(ply) && ply.VJCE_NPC == self then
			-- if IsValid(ply) then
				self.LastHP = self.LastHP or self:GetHP()
				if self.LastHP != self:GetHP() then
					hpHold = CurTime() +6
					self.LastHP = self:GetHP()
				end
				self.LastClip = self.LastClip or self:GetClip()
				if self.LastClip != self:GetClip() or rmbUsed != ply:KeyDown(IN_ATTACK2) then
					rmbUsed = ply:KeyDown(IN_ATTACK2)
					ammoHold = CurTime() +2
					self.LastClip = self:GetClip()
				end
				local FT = FrameTime()
				if aimPos == nil then
					aimPos = ply:EyePos()
				end
				local minAlpha, maxAlpha = 0, 0
				if ply:KeyDown(IN_JUMP) then
					minAlpha, maxAlpha = 180, 255
				end
				pulseAlpha = Lerp(FT *10, pulseAlpha, math.Clamp(math.sin(CurTime() *math.pi) *maxAlpha, minAlpha, maxAlpha))
				surface.SetDrawColor(115,138,255,pulseAlpha)
				surface.SetMaterial(matHUD)
				surface.DrawTexturedRect(0,0,ScrW(),ScrH())

				local clip = self:GetClip()
				local clipMax = 50
				local HP = self:GetHP()
				local maxHP = self:GetMaxHealth()
				local hpPer = HP /maxHP
				if hpHold > CurTime() then
					hpAlpha = Lerp(FT *10, hpAlpha, 255)
				else
					hpAlpha = Lerp(FT *10, hpAlpha, 0)
				end
				if ammoHold > CurTime() then
					ammoAlpha = Lerp(FT *10, ammoAlpha, 255)
				else
					ammoAlpha = Lerp(FT *10, ammoAlpha, 0)
				end
				DrawIcon_UV(matHUD_Base,20,22,25,3,{0,0,1,1},255,255,255,hpAlpha)
				DrawIcon_UV(matHUD_HP,20,22,hpPer *25,3,{0,0,hpPer,1},115,138,255,hpAlpha)

				DrawRect(39.4,18,9,4,0,0,0,math.Clamp(ammoAlpha,0,150))
				local lowAmmo = clip <= 5
				ammoColLerp = Color(
					Lerp(FT *10, ammoColLerp.r, lowAmmo && ammoColLow.r or ammoCol.r),
					Lerp(FT *10, ammoColLerp.g, lowAmmo && ammoColLow.g or ammoCol.g),
					Lerp(FT *10, ammoColLerp.b, lowAmmo && ammoColLow.b or ammoCol.b),
					ammoAlpha
				)
				DrawText(clip .. "/" .. clipMax,"VJFont_WeskerAmmo",42.5,16.4,ammoColLerp,2,3)

				if rmbUsed then
					local tr = util.TraceLine({
						start = ply:EyePos(),
						endpos = ply:EyePos() +ply:GetAimVector() *10000,
						filter = {ply,self},
						mask = MASK_SHOT_HULL
					})
					aimPos = LerpVector(FT *8, aimPos, tr.HitPos)
					local pos = aimPos:ToScreen()
					local size = 15
					local gap = 5
					local color = Color(255,255,255,255)
					surface.SetDrawColor(color)
					surface.DrawLine(pos.x - size - gap, pos.y, pos.x - gap, pos.y)
					surface.DrawLine(pos.x + size + gap, pos.y, pos.x + gap, pos.y)
					surface.DrawLine(pos.x, pos.y - size - gap, pos.x, pos.y - gap)
					surface.DrawLine(pos.x, pos.y + size + gap, pos.x, pos.y + gap)
				end
			end
		end)
	end

    function ENT:GetFPViewPos()
		local eyesBone = self:LookupAttachment("eyes")
		if eyesBone > 0 then
			local att = self:GetAttachment(eyesBone)
			-- print("Using eyes B attachment for first person view")
			return att.Pos +self:GetForward() *7, att.Ang
		end
		local bone = self:LookupBone("Head")
		if !bone then
			bone = self:LookupBone("bone17")
		end
		if bone then
			local bonePos,boneAng = self:GetBonePosition(bone)
			if bonePos == self:GetPos() then
				local matrix = self:GetBoneMatrix(bone)
				if matrix then
					bonePos = matrix:GetTranslation()
					boneAng = matrix:GetAngles()
				end
				if bonePos == self:GetPos() then
					bonePos = self:EyePos()
					boneAng = self:EyeAngles()
				end
			end
			-- print("Using head bone for first person view")
			return bonePos +self:GetForward() *3 +self:GetUp() *5, boneAng
		end
		return self:EyePos() +self:GetForward() *3 +self:GetUp() *5
	end

	local vec0 = Vector(0, 0, 0)
	local vec1 = Vector(1, 1, 1)
	local debugT = 0
	local string_StartsWith = string.StartsWith
	local angAdjust = nil
	local lerpFOV = nil
	function ENT:Controller_OnCalcView(cEnt, ply, origin, eyeangles, myFOV)
		local pos = origin
		local ang = ply:EyeAngles()
		local newFOV = myFOV
		-- local camera = cEnt
		local camera = cEnt:GetCamera()
		local cameraMode = cEnt:GetCameraMode()
		ply.VJCE_Camera = camera
		ply.VJCE_Camera.Zoom = cEnt.VJC_Camera_Zoom
		ply.VJCE_NPC = cEnt:GetNPC()
		ply.VJC_Camera_Mode = cEnt:GetCameraMode()
		ply.VJC_TP_Offset = cEnt:GetCameraTP_Offset()
		ply.VJC_FP_Offset = cEnt:GetCameraFP_Offset()
		ply.VJC_FP_Bone = cEnt:GetCameraFP_Bone()
		ply.VJC_FP_ShrinkBone = cEnt:GetCameraFP_ShrinkBone()
		ply.VJC_FP_CameraBoneAng = cEnt:GetCameraFP_BoneAng()
		ply.VJC_FP_CameraBoneAng_Offset = cEnt:GetCameraFP_BoneAngOffset()
		local refreshRate = nil
		self.VJC_FP_Bone = ply.VJC_FP_Bone
		if cameraMode == 2 then -- First person
			local fpPos,fpAng = self:GetFPViewPos()
			local curSeq = self:GetSequenceName(self:GetSequence())
			local targetAng = eyeangles
			angAdjust = angAdjust or targetAng
			-- print(fpAng)
			if fpAng then
				angAdjust = LerpAngle(FrameTime() *20,angAdjust,eyeangles +Angle(fpAng.p *0.2,0,fpAng.r *0.45))
			end
			lerpFOV = Lerp(FrameTime() *10, lerpFOV or myFOV, myFOV +(((curSeq == "run" && 40) or ((string_StartsWith(curSeq,"dodge") && self:GetCycle() <= 0.15) && 40)) or 20))
			return {origin = fpPos, angles = angAdjust, fov = lerpFOV, speed = 0}
		else
			if ply.VJC_FP_Bone != -1 then
				self:ManipulateBoneScale(ply.VJC_FP_Bone, vec1)
				for _,v in pairs(self:GetChildBones(ply.VJC_FP_Bone)) do
					self:ManipulateBoneScale(v, vec1)
				end
			end
			local bonePos, boneAng = self:GetBonePosition(self:LookupBone("bone14"))
			local isTaunting = string_StartsWith(self:GetSequenceName(self:GetSequence()),"taunt") && self:GetCycle() < 0.9
			local tr = util.TraceHull({
				start = bonePos,
				endpos = bonePos + eyeangles:Forward() *-(isTaunting && 50 or (ply:KeyDown(IN_ATTACK2) && 40 or 60)) +(self:GetRight() *(isTaunting && 0 or 22) +self:GetUp() *(isTaunting && 15 or (ply:KeyDown(IN_ATTACK2) && 20 or 12))),
				filter = {ply, camera, self},
				mins = Vector(-5, -5, -5),
				maxs = Vector(5, 5, 5),
				mask = MASK_SHOT,
			})
			pos = tr.HitPos + tr.HitNormal*2 +(self:GetVelocity() /13)
		end
		return {origin = pos, angles = ang, fov = newFOV, speed = refreshRate}
	end
end