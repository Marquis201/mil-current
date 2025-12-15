
EFFECT.MatBeam = Material( "effects/lvs_base/spark" )
EFFECT.MatSprite = Material( "sprites/light_glow02_add" )

EFFECT.MatSmoke = {
	"particle/smokesprites_0001",
	"particle/smokesprites_0002",
	"particle/smokesprites_0003",
	"particle/smokesprites_0004",
	"particle/smokesprites_0005",
	"particle/smokesprites_0006",
	"particle/smokesprites_0007",
	"particle/smokesprites_0008",
	"particle/smokesprites_0009",
	"particle/smokesprites_0010",
	"particle/smokesprites_0011",
	"particle/smokesprites_0012",
	"particle/smokesprites_0013",
	"particle/smokesprites_0014",
	"particle/smokesprites_0015",
	"particle/smokesprites_0016"
}

function EFFECT:Init( data )
	local pos  = data:GetOrigin()
	local dir = data:GetNormal()

	self.ID = data:GetMaterialIndex()

	self:SetRenderBoundsWS( pos, pos + dir * 50000 )

	self.emitter = ParticleEmitter( pos, false )

	self.OldPos = pos
	self.Dir = dir


	local trace = util.TraceLine( {
		start = pos,
		endpos = pos - Vector(0,0,500),
		mask = MASK_SOLID_BRUSHONLY,
	} )

	local ply = LocalPlayer()

	if not IsValid( ply ) then return end

	local ViewEnt = ply:GetViewEntity()

	if not IsValid( ViewEnt ) then return end

	local Intensity = ply:InVehicle() and 5 or 50
	local Ratio = math.min( 250 / (ViewEnt:GetPos() - trace.HitPos):Length(), 1 )

	if Ratio < 0 then return end

	util.ScreenShake( trace.HitPos, Intensity * Ratio, 0.1, 0.5, 250 )
end

function EFFECT:Think()
	if not LVS:GetBullet( self.ID ) then
		if self.emitter then
			self.emitter:Finish()
		end

		local StartPos = self.OldPos
		local EndPos = StartPos + self.Dir * 1000

		local trace = util.TraceLine( {
			start = StartPos,
			endpos = EndPos,
		} )

		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self.Dir )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetSurfaceProp( trace.SurfaceProps )
		util.Effect( "lvs_bullet_impact_ap", effectdata )

		return false
	end

	if not self.emitter then return true end

	local bullet = LVS:GetBullet( self.ID )

	local Pos = bullet:GetPos()

	local Sub = self.OldPos - Pos
	local Dist = Sub:Length()
	local Dir = Sub:GetNormalized()


	self.OldPos = Pos

	return true
end

function EFFECT:Render()
	local bullet = LVS:GetBullet( self.ID )

	local endpos = bullet:GetPos()
	local dir = bullet:GetDir()

	local len = 3000 * bullet:GetLength()

	render.SetMaterial( self.MatBeam )

	render.DrawBeam( endpos - dir * len, endpos + dir * len * 0.1, 32, 1, 0, Color( 100, 100, 100, 100 ) )
	render.DrawBeam( endpos - dir * len * 0.5, endpos + dir * len * 0.1, 16, 1, 0, Color( 255, 255, 255, 255 ) )

	render.SetMaterial( self.MatSprite ) 
	render.DrawSprite( endpos, 250, 250, Color( 100, 100, 100, 255 ) )
end
