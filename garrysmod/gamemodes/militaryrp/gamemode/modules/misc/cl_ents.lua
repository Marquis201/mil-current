-- I try too hard
local ENTITY = ENTITY
local LocalPlayer = LocalPlayer
local GetPos = ENTITY.GetPos
local EyePos = ENTITY.EyePos
local DistToSqr = VECTOR.DistToSqr
local IsLineOfSightClear = ENTITY.IsLineOfSightClear
local util_TraceLine = util.TraceLine
local GetAimVector = PLAYER.GetAimVector
local DotProduct = VECTOR.DotProduct
local lp

local trace = {
    mask = -1,
    filter = {}
}

-- Check if the ent is in your line of sight, fastish
function ENTITY:InSight()
    return false
end

function PLAYER:InSight()
    return false
end

-- Check if the ent is in your line of sight, very slow
function ENTITY:InTrace()
    return false
end

function PLAYER:InTrace()
    return false
end

-- Check if the ent is on your screen, very fast
function ENTITY:InView()
    return false
end

function ENTITY:InDistance()
    return false
end

hook.Add("Think", "VisChecks", function()
    if IsValid(LocalPlayer()) then
        lp = LocalPlayer()
        trace.filter[1] = LocalPlayer()

        function ENTITY:InSight()
            if (DistToSqr(GetPos(self), GetPos(lp)) < 250000) then return IsLineOfSightClear(lp, self) end

            return false
        end

        function PLAYER:InSight()
            if (DistToSqr(EyePos(self), EyePos(lp)) < 250000) then return IsLineOfSightClear(lp, self) end

            return false
        end

        function ENTITY:InTrace()
            trace.start = EyePos(lp)
            trace.endpos = GetPos(self)
            trace.filter[2] = self

            return not util_TraceLine(trace).Hit
        end

        function PLAYER:InTrace()
            trace.start = EyePos(lp)
            trace.endpos = EyePos(self)
            trace.filter[2] = self

            return not util_TraceLine(trace).Hit
        end

        function ENTITY:InView()
            return (DotProduct(GetPos(self) - GetPos(lp), GetAimVector(lp)) > 0)
        end

        function ENTITY:InDistance(maxDistance)
            local dist = DistToSqr(GetPos(self), GetPos(lp))

            return (dist < (maxDistance or 250000)), dist
        end

        hook.Remove("Think", "VisChecks")
    end
end)
