ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

if CLIENT then
	local vec0 = Vector(0, 0, 0)
	local vec1 = Vector(1, 1, 1)
	local debugT = 0
	local string_StartsWith = string.StartsWith
	function ENT:Controller_OnCalcView(cEnt, ply, origin, angles, myFOV)
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
			local setPos = self:EyePos() +self:GetForward() *1
			local offset = ply.VJC_FP_Offset
			//camera:SetLocalPos(camera:GetLocalPos() + ply.VJC_TP_Offset) -- Help keep the camera stable
			if ply.VJC_FP_Bone != -1 then -- If the bone does exist, then use the bone position
				local bonePos, boneAng = self:GetBonePosition(self:LookupBone("bone5"))
				setPos = bonePos +boneAng:Forward() *-2 +boneAng:Up() *1
				if ply.VJC_FP_ShrinkBone then
					-- self:ManipulateBoneScale(ply.VJC_FP_Bone, vec0) -- Bone manipulate to make it easier to see
					-- for _,v in pairs(self:GetChildBones(ply.VJC_FP_Bone)) do
					-- 	self:ManipulateBoneScale(v, vec0)
					-- end
				end
			end
			pos = setPos +(self:GetForward() *offset.x +self:GetRight() *offset.y +self:GetUp() *offset.z)
			refreshRate = 0
		else
			if ply.VJC_FP_Bone != -1 then
				self:ManipulateBoneScale(ply.VJC_FP_Bone, vec1)
				for _,v in pairs(self:GetChildBones(ply.VJC_FP_Bone)) do
					self:ManipulateBoneScale(v, vec1)
				end
			end
			local bonePos, boneAng = self:GetBonePosition(self:LookupBone("bone4"))
			local isTaunting = string_StartsWith(self:GetSequenceName(self:GetSequence()),"taunt") && self:GetCycle() < 0.9
			local tr = util.TraceHull({
				start = bonePos,
				endpos = bonePos + angles:Forward() *-80 +(self:GetRight() *30 +self:GetUp() *18),
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