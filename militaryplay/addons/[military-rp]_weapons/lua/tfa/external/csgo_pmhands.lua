TFA.CSGO = TFA.CSGO or {}
TFA.CSGO.HandsTbl = TFA.CSGO.HandsTbl or {}

function TFA.CSGO.AddHandsModel(id, mdl, name)
	assert(type(id) == "string", "Invalid hands variant ID specified: " .. tostring(id))
	assert(type(mdl) == "string", "Invalid hands model path specified: " .. tostring(mdl))

	if not file.Exists(mdl, "GAME") then
		print("[TFA CS:GO] Unable to add hands with id " .. id .. ", model " .. mdl .. " not found.")

		return
	end

	TFA.CSGO.HandsTbl[id] = {}
	TFA.CSGO.HandsTbl[id].mdl = mdl
	TFA.CSGO.HandsTbl[id].name = type(name) == "string" and name or "#tfa_csgo_hands_" .. id
end

if not CLIENT then return end

local cv_hands = CreateClientConVar("cl_tfa_csgo_hands_override", "none", true, false)

if IsValid(TFA.CSGO.HandsEnt) then
	TFA.CSGO.HandsEnt:Remove()
	TFA.CSGO.HandsEnt = nil
end

local handsFallback = "models/weapons/tfa_csgo/c_hands_translator.mdl"
local handsOverride, handsID, handsMDL = false, "", ""

function TFA.CSGO.ParentHands(hands, vm, ply, wep)
	if not IsValid(hands) or not IsValid(vm) or not IsValid(wep) then
		if IsValid(TFA.CSGO.HandsEnt) then
			TFA.CSGO.HandsEnt:RemoveEffects(EF_BONEMERGE)
			TFA.CSGO.HandsEnt:RemoveEffects(EF_BONEMERGE_FASTCULL)
			TFA.CSGO.HandsEnt:SetParent(NULL)

			TFA.CSGO.HandsEnt:Remove()
		end
	
		return
	end

	if not wep.IsTFAWeapon or not wep.IsTFACSGOWeapon then return end

	handsID = cv_hands:GetString()
	handsOverride = handsID ~= "none" and TFA.CSGO.HandsTbl[handsID]

	handsMDL = handsOverride and TFA.CSGO.HandsTbl[handsID].mdl or handsFallback

	if not IsValid(TFA.CSGO.HandsEnt) then
		TFA.CSGO.HandsEnt = ClientsideModel(handsMDL)

		TFA.CSGO.HandsEnt:SetupBones()
		TFA.CSGO.HandsEnt:SetNoDraw(true)
	elseif TFA.CSGO.HandsEnt:GetModel() ~= handsMDL then
		TFA.CSGO.HandsEnt:SetModel(handsMDL)
		TFA.CSGO.HandsEnt:SetupBones()
	end

	if not vm:LookupBone("ValveBiped.Bip01_R_Hand") then
		local newhands = TFA.CSGO.HandsEnt

		newhands:SetParent(vm)
		newhands:SetPos(vm:GetPos())
		newhands:SetAngles(vm:GetAngles())

		if not newhands:IsEffectActive(EF_BONEMERGE) then
			newhands:AddEffects(EF_BONEMERGE)
			newhands:AddEffects(EF_BONEMERGE_FASTCULL)
		end

		if handsOverride then
			newhands:DrawModel()
		else
			hands:SetParent(newhands)
		end
	end
end

hook.Add("PreDrawPlayerHands", "TFA_CSGO_PreDrawPlayerHands", TFA.CSGO.ParentHands)
