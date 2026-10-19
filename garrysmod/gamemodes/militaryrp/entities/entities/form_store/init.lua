AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(5)
    local phys = self:GetPhysicsObject()
    if not phys:IsValid() then
        self:SetModel("models/Items/item_item_crate.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        phys = self:GetPhysicsObject()
    end
    phys:Wake()
end

function ENT:Think()
end

function ENT:Use(pl)
    local data = mp.QuestPlay.List["stat_clothes"]

    if data.check and data.check(pl) and pl:GetFaction() then
        hook.Call("OnPlayerClothes", nil, pl)

        local team_index = pl:GetFaction() == "nato" and TEAM_INFYNATO or TEAM_INFYRF

        hook.Call("PlayerChangeTeam", nil, pl, team_index, true)

        local profession_index = pl:GetFaction() == "nato" and "rifleman_nato" or "rifleman_rf"

        pl:SetNetVar("meta_features", profession_index)

        local db = mysql.connect_config
        db:Query( "UPDATE metahub_characters SET features = ? WHERE player_id = ? AND character_id = ?;", profession_index, pl:GetNetVar("meta_playerid"), pl:GetNetVar("meta_character"))
    end
end
