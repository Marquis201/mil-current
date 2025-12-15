
ENT.Base = "lvs_base_wheeldrive_trailer"

ENT.PrintName = "[LVS] UAV Control"
ENT.Author = "Shermann Wolf"
ENT.Information = ""
ENT.Category = "MP Bombs | RU"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.MDL = "models/sw/shared/uav_control.mdl"

ENT.AITEAM = 0

ENT.MaxHealth = 250

function ENT:CalcMainActivity( ply )
	if ply ~= self:GetDriver() then return self:CalcMainActivityPassenger( ply ) end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 

	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "cidle_knife" )

	return ply.CalcIdeal, ply.CalcSeqOverride
end