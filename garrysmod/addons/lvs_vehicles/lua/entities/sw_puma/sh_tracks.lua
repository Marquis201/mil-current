
if SERVER then
	ENT.PivotSteerEnable = true
	ENT.PivotSteerByBrake = false
	ENT.PivotSteerWheelRPM = 60

	function ENT:OnLeftTrackRepaired()
		self:SetBodygroup(2,0)
	end

	function ENT:OnLeftTrackDestroyed()
		self:SetBodygroup(2,1)
	end

	function ENT:OnRightTrackRepaired()
		self:SetBodygroup(1,0)
	end

	function ENT:OnRightTrackDestroyed()
		self:SetBodygroup(1,1)
	end

	function ENT:TracksCreate( PObj )
		self:CreateTrackPhysics( "models/sw/ground/puma/track_physics.mdl" )
		local WheelModel = "models/props_vehicles/tire001c_car.mdl"

		local L1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(75,55,17.85), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(42.4,55,17.85), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(10.4,55,17.85), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-28.5,55,17.85), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-60,55,17.85), mdl = WheelModel } )
		local L6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-91.2,55,17.85), mdl = WheelModel } )
		local LeftWheelChain = self:CreateWheelChain( {L1, L2, L3, L4, L5, L6 } )
		self:SetTrackDriveWheelLeft( L1 )

		local R1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(75,-55,17.85), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(42.4,-55,17.85), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(10.4,-55,17.85), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-28.5,-55,17.85), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-60,-55,17.85), mdl = WheelModel } )
		local R6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-91.2,-55,17.85), mdl = WheelModel} )
		local RightWheelChain = self:CreateWheelChain( {R1, R2, R3, R4, R5, R6 } )
		self:SetTrackDriveWheelRight( R1 )

		local LeftTracksArmor = self:AddArmor( Vector(0,55,27), Angle(0,0,0), Vector(-135,-11,-30), Vector(135,11,30), 500, 4500 )
		self:SetTrackArmorLeft( LeftTracksArmor, LeftWheelChain )

		local RightTracksArmor = self:AddArmor( Vector(0,-55,27), Angle(0,0,0), Vector(-135,-11,-30), Vector(135,11,30), 500, 4500 )
		self:SetTrackArmorRight( RightTracksArmor, RightWheelChain )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_FRONT,
				SteerAngle = 25,
				TorqueFactor = 0.5,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R1, L1 },
			Suspension = {
				Height = 10,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				SteerAngle = 25,
				TorqueFactor = 0.25,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R2, L2 },
			Suspension = {
				Height = 9,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 21500,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				TorqueFactor = 0.15,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R3, L3 },
			Suspension = {
				Height = 8,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 23000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				TorqueFactor = 0.15,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R4, L4 },
			Suspension = {
				Height = 7,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 24500,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				SteerAngle = 25,
				TorqueFactor = 0.25,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R5, L5 },
			Suspension = {
				Height = 7,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 26000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 25,
				TorqueFactor = 0.5,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R6, L6 },
			Suspension = {
				Height = 7,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 27500,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )
	end

else			
	ENT.TrackSystemEnable = true

	ENT.TrackScrollTexture = "models/sw/ground/puma/track"
	ENT.ScrollTextureData = {
		["$phong"] = "1",
		["$phongboost"] = "0.02", 
		["$phongexponent"] = "3",
		["$phongfresnelranges"] = "[1 1 1]",
		["$translate"] = "[0.0 0.0 0.0]",
		["$colorfix"] = "{255 255 255}",
		["Proxies"] = {
			["TextureTransform"] = {
				["translateVar"] = "$translate",
				["centerVar"]    = "$center",
				["resultVar"]    = "$basetexturetransform",
			},
			["Equals"] = {
				["srcVar1"] =  "$colorfix",
				["resultVar"] = "$color",
			}
		}
	}

	ENT.TrackLeftSubMaterialID = 3
	ENT.TrackLeftSubMaterialMul = Vector(0,0.011,0)

	ENT.TrackRightSubMaterialID = 2
	ENT.TrackRightSubMaterialMul = Vector(0,0.011,0)

	ENT.TrackPoseParameterLeft = "spin_l"
	ENT.TrackPoseParameterLeftMul =  -1.4

	ENT.TrackPoseParameterRight = "spin_r"
	ENT.TrackPoseParameterRightMul =  -1.4

	ENT.TrackSounds = "lvs/vehicles/sherman/tracks_loop.wav"
	ENT.TrackHull = Vector(20,20,20)
	ENT.TrackData = {}
	for i = 1, 6 do
		for n = 0, 1 do
			local LR = n == 0 and "l" or "r"
			local LeftRight = n == 0 and "l" or "r"
			local data = {
				Attachment = {
					name = "sus_att_"..LR..""..i,
					toGroundDistance = 42,
					traceLength = 100,
				},
				PoseParameter = {
					name = "sus_"..LeftRight..""..i,
					rangeMultiplier = -1,
					lerpSpeed = 25,
				}
			}
			table.insert( ENT.TrackData, data )
		end
	end
end