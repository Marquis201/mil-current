
if SERVER then
	ENT.PivotSteerEnable = true
	ENT.PivotSteerByBrake = false
	ENT.PivotSteerWheelRPM = 25

	ENT.TrackGibs = {
		["left"] = {
			{
				mdl = "models/diggercars/t90m/tracks_ragdoll.mdl",
				pos = Vector(0,57.4,0),
				ang = Angle(-90,-90,0),
			},
		},
		["right"] = {
			{
				mdl = "models/diggercars/t90m/tracks_ragdoll.mdl",
				pos = Vector(0,-57.4,0),
				ang = Angle(-90,-90,0),
			},
		}
	}

	function ENT:OnLeftTrackRepaired()
		self:SetBodygroup(4,0)
	end

	function ENT:OnLeftTrackDestroyed()
		self:SetBodygroup(4,1)
	end

	function ENT:OnRightTrackRepaired()
		self:SetBodygroup(5,0)
	end

	function ENT:OnRightTrackDestroyed()
		self:SetBodygroup(5,1)
	end

	function ENT:TracksCreate( PObj )
		self:CreateTrackPhysics( "models/diggercars/t90m/tracks_col.mdl" )
		local WheelModel = "models/props_vehicles/carparts_wheel01a.mdl"

		local L1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(115,53,50), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(90,53,25), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(53,53,25), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(14,53,25), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-28,53,22), mdl = WheelModel } )
		local L6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-74,53,19), mdl = WheelModel } )
		local L7 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-107,53,45), mdl = WheelModel } )
		local LeftWheelChain = self:CreateWheelChain( {L1, L2, L3, L4, L5, L6, L7} )
		self:SetTrackDriveWheelLeft( L4 )

		local R1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(115,-53,50), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(90,-53,25), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(53,-53,25), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(14,-53,25), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-28,-53,22), mdl = WheelModel } )
		local R6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-74,-53,19), mdl = WheelModel} )
		local R7 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-107,-53,45), mdl = WheelModel} )
		local RightWheelChain = self:CreateWheelChain( {R1, R2, R3, R4, R5, R6, R7} )
		self:SetTrackDriveWheelRight( R4 )

		local LeftTracksArmor = self:AddArmor( Vector(-3,68,12.5), Angle(0,0,0), Vector(-145,-21.5,-34), Vector(145,21.5,34), 1000, self.TurretBottomArmor )
		self:SetTrackArmorLeft( LeftTracksArmor, LeftWheelChain )

		local RightTracksArmor = self:AddArmor( Vector(-3,-68,12.5), Angle(0,0,0), Vector(-145,-21.5,-34), Vector(145,21.5,34), 1000, self.TurretBottomArmor )
		self:SetTrackArmorRight( RightTracksArmor, RightWheelChain )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_FRONT,
				SteerAngle = 30,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R1, L1, R2, L2 },
			Suspension = {
				Height = 15,
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
				TorqueFactor = 1,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R3, L3, L4, R4 },
			Suspension = {
				Height = 15,
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
				SteerAngle = 30,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R5, L5, R6, L6, R7, L7 },
			Suspension = {
				Height = 15,
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

	ENT.TrackScrollTexture = "models/diggercars/t90m/tracks"
	ENT.ScrollTextureData = {
		["$bumpmap"] = "models/diggercars/t90m/tracks_nm",
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

	ENT.TrackLeftSubMaterialID = 6
	ENT.TrackLeftSubMaterialMul = Vector(0,0.0118,0)

	ENT.TrackRightSubMaterialID = 7
	ENT.TrackRightSubMaterialMul = Vector(0,0.0118,0)

	ENT.TrackPoseParameterLeft = "spin_wheels_left"
	ENT.TrackPoseParameterLeftMul =  -1.252

	ENT.TrackPoseParameterRight = "spin_wheels_right"
	ENT.TrackPoseParameterRightMul =  -1.252

	ENT.TrackSounds = "lvs/vehicles/t62/t62_tracks.wav"
	ENT.TrackHull = Vector(20,20,20)
	ENT.TrackData = {}
	for i = 1, 6 do
		for n = 0, 1 do
			local LR = n == 0 and "l" or "r"
			local LeftRight = n == 0 and "left" or "right"
			local data = {
				Attachment = {
					name = "vehicle_suspension_"..LR.."_"..i,
					toGroundDistance = 20,
					traceLength = 100,
				},
				PoseParameter = {
					name = "!suspension_"..LeftRight.."_"..i,
					rangeMultiplier = 0.5,
					lerpSpeed = 25,
				}
			}
			table.insert( ENT.TrackData, data )
		end
	end

end