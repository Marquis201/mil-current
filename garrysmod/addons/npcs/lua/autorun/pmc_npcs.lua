--[[
	Author: Wolfyo
	E-Mail: wolfyo@wolfyo.eu
	Github: https://github.com/RWolfyo
	Steam: https://steamcommunity.com/profiles/76561197960922671
	Description: This file contains the code for creating friendly and enemy PMC NPCs.
	License: This code is licensed under the GNU Affero General Public License v3.0.
--]]

local Category = "Military Play | PMCs"

list.Set( "ContentCategoryIcons", "PMCs", "icon16/pmc16.png" )

--- Creates an NPC and adds it to the NPC list.
--- @param name string The name of the NPC.
--- @param npc_class string The class name of the NPC.
--- @param class string The base class of the NPC.
--- @param model string The model of the NPC.
--- @param weapons table A table of weapons to give to the NPC.
--- @param keyValues table A table of key values to set for the NPC.
--- @param category string The category of the NPC.
local function CreateNPC(name, npc_class, class, model, weapons, keyValues, category)
	local NPC = {
		Name = name,
		Class = class,
		Weapons = weapons,
		Model = model,
		KeyValues = keyValues,
		Category = category
	}
	NPC.KeyValues.parentname = npc_class
	list.Set("NPC", npc_class, NPC)
end

-- Friendly NPCs

CreateNPC("MGS PMC (Friendly)", "mgs_pmc", "npc_citizen", "models/PMC/PMC_1/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)

CreateNPC("ACU PMC (Friendly)", "acu_pmc", "npc_citizen", "models/PMC/PMC_2/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)

CreateNPC("MPT PMC (Friendly)", "mpt_pmc", "npc_citizen", "models/PMC/PMC_3/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)

CreateNPC("SWAT PMC (Friendly)", "swat_pmc", "npc_citizen", "models/PMC/PMC_4/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)

CreateNPC("SAS PMC (Friendly)", "sas_pmc", "npc_citizen", "models/PMC/PMC_5/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)

CreateNPC("Desert PMC (Friendly)", "desert_pmc", "npc_citizen", "models/PMC/PMC_6/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)

CreateNPC("Super PMC (Friendly)", "super_pmc", "npc_citizen", "models/PMC/PMC_7/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)
	
	CreateNPC("Snow PMC (Friendly)", "snow_pmc", "npc_citizen", "models/PMC/PMC_8/male_04.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ citizentype = CT_REBEL, SquadName = "resistance" },
	Category)

-- Hostile NPCs

CreateNPC("MGS PMC (Hostile)", "mgs_pmc_bad", "npc_combine_s", "models/PMC/PMC_1/PMC_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)

CreateNPC("ACU PMC (Hostile)", "acu_pmc_bad", "npc_combine_s", "models/PMC/PMC_2/ACU_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)

CreateNPC("MPT PMC (Hostile)", "mpt_pmc_bad", "npc_combine_s", "models/PMC/PMC_3/MPT_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)

CreateNPC("SWAT PMC (Hostile)", "swat_pmc_bad", "npc_combine_s", "models/PMC/PMC_4/SWAT_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)

CreateNPC("SAS PMC (Hostile)", "sas_pmc_bad", "npc_combine_s", "models/PMC/PMC_5/SAS_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)

CreateNPC("Desert PMC (Hostile)", "desert_pmc_bad", "npc_combine_s", "models/PMC/PMC_6/Desert_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)

CreateNPC("Super PMC (Hostile)", "super_pmc_bad", "npc_combine_s", "models/PMC/PMC_7/Super_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)
	
	CreateNPC("Snow PMC (Hostile)", "snow_pmc_bad", "npc_combine_s", "models/PMC/PMC_8/snw_npch.mdl",
	{ "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	{ SquadName = "overwatch", Numgrenades = 5 },
	Category)

local PMC_class = {
	["mgs_pmc"] = true,
	["acu_pmc"] = true,
	["mpt_pmc"] = true,
	["swat_pmc"] = true,
	["sas_pmc"] = true,
	["snow_pmc"] = true,
	["desert_pmc"] = true,
}

local PMC_class_bad = {
	["mgs_pmc_bad"] = true,
	["acu_pmc_bad"] = true,
	["mpt_pmc_bad"] = true,
	["swat_pmc_bad"] = true,
	["sas_pmc_bad"] = true,
	["snow_pmc_bad"] = true,
	["desert_pmc_bad"] = true,
}

local PMC_models = {
	["models/pmc/pmc_1/male_04.mdl"] = true,
	["models/pmc/pmc_2/male_04.mdl"] = true,
	["models/pmc/pmc_3/male_04.mdl"] = true,
	["models/pmc/pmc_4/male_04.mdl"] = true,
	["models/pmc/pmc_5/male_04.mdl"] = true,
	["models/pmc/pmc_6/male_04.mdl"] = true,
	["models/pmc/pmc_7/male_04.mdl"] = true,
	["models/pmc/pmc_8/male_04.mdl"] = true,
}

local PMC_models_bad = {
	["models/pmc/pmc_1/pmc_npch.mdl"] = true,
	["models/pmc/pmc_2/acu_npch.mdl"] = true,
	["models/pmc/pmc_3/mpt_npch.mdl"] = true,
	["models/pmc/pmc_4/swat_npch.mdl"] = true,
	["models/pmc/pmc_5/sas_npch.mdl"] = true,
	["models/pmc/pmc_6/desert_npch.mdl"] = true,
	["models/pmc/pmc_7/super_npch.mdl"] = true,
	["models/pmc/pmc_8/snw_npch.mdl"] = true,
}

local normalAmmoTypes = {
	["AR2"] = true,
	["Pistol"] = true,
	["SMG1"] = true,
	["AlyxGun"] = true,
}

local heavyAmmoTypes = {
	["357"] = true,
	["Buckshot"] = true,
	["XBowBolt"] = true,
	["SniperRound"] = true,
	["SniperPenetratedRound"] = true,
	["CombineCannon"] = true,
	["AirboatGun"] = true,
	["StriderMinigun"] = true,
	["HelicopterGun"] = true,
	["StriderMinigunDirect"] = true,
	["CombineHeavyCannon"] = true
}

local explosiveAmmoTypes = {
	["AR2AltFire"] = true,
	["SMG1_Grenade"] = true,
	["RPG_Round"] = true,
	["Grenade"] = true,
	["slam"] = true
}

--- Sets a random appearance for an NPC entity.
--- @param npc Entity The NPC entity to set the appearance for.
--- @param validModels table (optional) A table of valid NPC models to choose from.
--- @param skinMin number (optional) The minimum skin value to set.
--- @param skinMax number (optional) The maximum skin value to set.
--- @param bodygroups table (optional) A table of bodygroups to set.
local function SetRandomNPCAppearance(npc, validModels, skinMin, skinMax, bodygroups)
	if validModels then
		local modelNames = table.GetKeys(validModels)
		local randomModel = table.Random(modelNames)
		npc:SetModel(randomModel)
	end
	if skinMin and skinMax then
		npc:SetSkin(math.random(skinMin, skinMax))
	end
	if bodygroups then
		for i, bodygroup in ipairs(bodygroups) do
			npc:SetBodygroup(bodygroup.num, math.random(bodygroup.min, bodygroup.max))
		end
	end
end

--- Sets a random ammo supply for an NPC entity.
--- @param npc Entity The NPC entity to set the ammo supply for.
--- @param validAmmoTypes table A table of valid ammo types to choose from.
--- @param ammoMin number The minimum amount of ammo to set.
--- @param ammoMax number The maximum amount of ammo to set.
local function SetRandomAmmoSupply(npc, validAmmoTypes, ammoMin, ammoMax)
	local ammoNames = table.GetKeys(validAmmoTypes)
	local randomAmmo = table.Random(ammoNames)
	npc:SetKeyValue("ammosupply", randomAmmo)
	npc:SetKeyValue("ammoamount", math.random(ammoMin or 1, ammoMax or 5))
end

--- Handles a spawned NPC entity.
--- @param ply Entity The player entity who spawned the NPC.
--- @param npc Entity The NPC entity that was spawned.
local function HandleSpawnedNPC(ply, npc)
	if IsValid(npc) then
		local parentname = npc:GetKeyValues()["parentname"]
		if PMC_class[parentname] then
			SetRandomNPCAppearance(npc, nil, 0, 2, {
				{num = 1, min = 0, max = 1},
				{num = 2, min = 0, max = 1},
				{num = 3, min = 0, max = 61},
				{num = 4, min = 0, max = 2},
				{num = 5, min = 0, max = 1},
				{num = 6, min = 0, max = 2},
				{num = 7, min = 0, max = 1},
				{num = 8, min = 0, max = 2},
				{num = 9, min = 0, max = 3},
				{num = 10, min = 0, max = 1},
			})
			npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_AVERAGE )
		elseif PMC_class_bad[parentname] then
			SetRandomNPCAppearance(npc, nil, 0, 2, {
				{num = 1, min = 0, max = 1},
				{num = 2, min = 0, max = 1},
				{num = 3, min = 0, max = 61},
				{num = 4, min = 0, max = 2},
				{num = 5, min = 0, max = 1},
				{num = 6, min = 0, max = 2},
				{num = 7, min = 0, max = 1},
				{num = 8, min = 0, max = 2},
				{num = 9, min = 0, max = 3},
				{num = 10, min = 0, max = 1},
			})
			npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_GOOD )
		elseif parentname == "super_pmc" or parentname == "super_pmc_bad" then
		SetRandomNPCAppearance(npc, nil, 0, 1, {
			{num = 1, min = 0, max = 1},
			{num = 2, min = 0, max = 1},
			{num = 3, min = 0, max = 61},
			{num = 4, min = 0, max = 2},
			{num = 5, min = 0, max = 1},
			{num = 6, min = 0, max = 2},
			{num = 7, min = 0, max = 1},
			{num = 8, min = 0, max = 2},
			{num = 9, min = 0, max = 3},
			{num = 10, min = 0, max = 1},
		})
		npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
		end
	end
end

hook.Add("PlayerSpawnedNPC", "HandleSpawnedNPC_" .. Category, HandleSpawnedNPC)