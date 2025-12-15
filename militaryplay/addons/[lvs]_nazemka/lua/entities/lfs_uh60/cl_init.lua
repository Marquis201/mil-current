-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

local VisibleTime = 0
local smVisible = 0
local zoom_mat = Material( "vgui/zoom" )
local mat = Material( "sprites/light_glow02_add" )

function ENT:LFSCalcViewFirstPerson( view )
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return view
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local THR = RPM / self:GetLimitRPM()
	
	if self.ENG then
		self.ENG:ChangePitch( math.Clamp( math.min(RPM / self:GetIdleRPM(),1) * 75+ Doppler + THR * 30,0,255) )
		self.ENG:ChangeVolume( math.Clamp(THR,0.8,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "rebel_heli" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
	local RotorBlown = self:GetRotorDestroyed()
	
	if not RotorBlown then
		local RPM = self:GetRPM()
		local PhysRot = RPM < 700
		self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 4 or 1.1)) or 0
		
		self:SetBodygroup( 5, PhysRot and 0 or 1 ) 
		self:SetBodygroup( 6, PhysRot and 0 or 1 ) 
		
		self:SetPoseParameter("rotor_spin", -self.RPM )
		self:InvalidateBoneCache()
	end
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:ExhaustFX()
end

