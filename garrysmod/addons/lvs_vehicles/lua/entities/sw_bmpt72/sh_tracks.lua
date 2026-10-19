
if SERVER then
	ENT.PivotSteerEnable = true
	ENT.PivotSteerByBrake = false
	ENT.PivotSteerWheelRPM = 40

	function ENT:TracksCreate( PObj )
		local WheelModel = "models/props_vehicles/tire001c_car.mdl"

		local L1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(98.65,58,18), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(64.45,58,18), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(30,58,18), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-4.35,58,18), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-38.75,58,18), mdl = WheelModel } )
		local L6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-72.7,58,18), mdl = WheelModel } )
		local LeftWheelChain = self:CreateWheelChain( {L1, L2, L3, L4, L5, L6} )
		self:SetTrackDriveWheelLeft( L1 )

		local R1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(98.65,-58,18), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(64.45,-58,18), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(30,-58,18), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-4.35,-58,18), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-38.75,-58,18), mdl = WheelModel } )
		local R6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-72.7,-58,18), mdl = WheelModel} )
		local RightWheelChain = self:CreateWheelChain( {R1, R2, R3, R4, R5, R6} )
		self:SetTrackDriveWheelRight( R1 )

		local LeftTracksArmor = self:AddArmor( Vector(0,55,39), Angle(0,0,0), Vector(-135,-17,-45), Vector(150,18,22), 1000, 14000 )
		LeftTracksArmor.OnDestroyed = LeftWheelChain.OnDestroyed
		LeftTracksArmor.OnRepaired = LeftWheelChain.OnRepaired
		LeftTracksArmor:SetLabel( "Tracks" )

		local RightTracksArmor = self:AddArmor( Vector(0,-55,39), Angle(0,0,0), Vector(-135,-18,-45), Vector(150,17,22), 1000, 14000 )
		RightTracksArmor.OnDestroyed = RightWheelChain.OnDestroyed
		RightTracksArmor.OnRepaired = RightWheelChain.OnRepaired
		RightTracksArmor:SetLabel( "Tracks" )

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
				Height = 7,
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
				SteerType = LVS.WHEEL_STEER_FRONT,
				SteerAngle = 25,
				TorqueFactor = 0.25,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R2, L2 },
			Suspension = {
				Height = 7,
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
				TorqueFactor = 0.25,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R3, L3 },
			Suspension = {
				Height = 7,
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
				TorqueFactor = 0.25,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R4, L4 },
			Suspension = {
				Height = 7,
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
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 25,
				TorqueFactor = 0.5,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R5, L5 },
			Suspension = {
				Height = 7,
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
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 25,
				TorqueFactor = 1,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R6, L6 },
			Suspension = {
				Height = 7,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )
	end

else			
	ENT.TrackSystemEnable = true

	ENT.TrackScrollTexture = "models/sw/ground/bmpt72/track"
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

	ENT.TrackLeftSubMaterialID = 8
	ENT.TrackLeftSubMaterialMul = Vector(0.013,0,0)

	ENT.TrackRightSubMaterialID = 6
	ENT.TrackRightSubMaterialMul = Vector(0.013,0,0)

	ENT.TrackPoseParameterLeft = "spin_l"
	ENT.TrackPoseParameterLeftMul =  1.252

	ENT.TrackPoseParameterRight = "spin_r"
	ENT.TrackPoseParameterRightMul =  1.252

	ENT.TrackSounds = "sw/bmpt72/tracks.wav"
	ENT.TrackHull = Vector(20,20,20)
	ENT.TrackData = {}
	for i = 1, 6 do
		for n = 0, 1 do
			local LR = n == 0 and "l" or "r"
			local LeftRight = n == 0 and "l" or "r"
			local data = {
				Attachment = {
					name = "sus_att_"..LR..""..i,
					toGroundDistance = 60,
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