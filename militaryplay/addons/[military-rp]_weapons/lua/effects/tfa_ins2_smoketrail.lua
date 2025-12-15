function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.Forward = data:GetEntity():GetForward()
	local emitter = ParticleEmitter(self.Position)
    for i = 0, 15 do
        local smokes = emitter:Add( "inseffects/smoke_grenade", self.Position + (self.Forward * -50 * i))
        if (smokes) then
            smokes:SetVelocity( self.Forward * -1000 )
            smokes:SetDieTime( math.Rand( 1.5, 3 ) )
            smokes:SetStartAlpha( math.random( 50, 100 ) )
            smokes:SetEndAlpha( 0 )
            smokes:SetStartSize( math.random( 40, 50 ) )
            smokes:SetEndSize( math.random( 130, 150 ) )
            smokes:SetRoll( math.Rand(0, 360) )
            smokes:SetRollDelta( math.Rand(-1, 1) )
            smokes:SetColor( 255, 255, 255 ) 
            smokes:SetAirResistance( 300 ) 
            smokes:SetGravity( Vector( 500, 0, 0 ) ) 	
        end
    end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end