
if SERVER then
	ENT.PivotSteerEnable = true
	ENT.PivotSteerByBrake = false
	ENT.PivotSteerWheelRPM = 40

	function ENT:TracksCreate( PObj )
		local WheelModel = "models/props_vehicles/tire001c_car.mdl"

		local L1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(90.6,53,16.6), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(59.9,53,16.6), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(29.25,53,16.6), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-1.25,53,16.6), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-31.7,53,16.6), mdl = WheelModel } )
		local L6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-62.85,53,16.6), mdl = WheelModel } )
		local L7 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-93.55,53,16.6), mdl = WheelModel } )
		local LeftWheelChain = self:CreateWheelChain( {L1, L2, L3, L4, L5, L6, L7} )
		self:SetTrackDriveWheelLeft( L1 )

		local R1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(90.6,-53,16.6), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(59.9,-53,16.6), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(29.25,-53,16.6), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-1.25,-53,16.6), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-31.7,-53,16.6), mdl = WheelModel } )
		local R6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-62.85,-53,16.6), mdl = WheelModel} )
		local R7 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-93.55,-53,16.6), mdl = WheelModel} )
		local RightWheelChain = self:CreateWheelChain( {R1, R2, R3, R4, R5, R6, R7} )
		self:SetTrackDriveWheelRight( R1 )

		local LeftTracksArmor = self:AddArmor( Vector(140,40,36), Angle(0,0,0), Vector(-280,0,-36), Vector(0,23,10), 1000, 1000 )
		LeftTracksArmor.OnDestroyed = LeftWheelChain.OnDestroyed
		LeftTracksArmor.OnRepaired = LeftWheelChain.OnRepaired
		LeftTracksArmor:SetLabel( "Tracks" )

		local RightTracksArmor = self:AddArmor( Vector(140,-40,36), Angle(0,0,0), Vector(-280,-23,-36), Vector(0,0,10), 1000, 1000 )
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
				SteerType = LVS.WHEEL_STEER_NONE,
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

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 25,
				TorqueFactor = 1,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R7, L7 },
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

	ENT.TrackScrollTexture = "models/sw/ground/leopard2a4/track"
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

	ENT.TrackLeftSubMaterialID = 1
	ENT.TrackLeftSubMaterialMul = Vector(0,0.013,0)

	ENT.TrackRightSubMaterialID = 0
	ENT.TrackRightSubMaterialMul = Vector(0,0.013,0)

	ENT.TrackPoseParameterLeft = "spin_l"
	ENT.TrackPoseParameterLeftMul =  1.252

	ENT.TrackPoseParameterRight = "spin_r"
	ENT.TrackPoseParameterRightMul =  1.252

	ENT.TrackSounds = "sw/leopard2a4/tracks.wav"
	ENT.TrackHull = Vector(20,20,20)
	ENT.TrackData = {}
	for i = 1, 7 do
		for n = 0, 1 do
			local LR = n == 0 and "l" or "r"
			local LeftRight = n == 0 and "l" or "r"
			local data = {
				Attachment = {
					name = "sus_att_"..LR..""..i,
					toGroundDistance = 40,
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