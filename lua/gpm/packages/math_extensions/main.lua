local assert = assert
local ipairs = ipairs
local type = type

local math_random = math.random
local math_Round = math.Round
local math_floor = math.floor
local math_abs = math.abs
local math_max = math.max

--[[-------------------------------------------------------------------------
	math.sum
---------------------------------------------------------------------------]]

function math.sum( ... )
	local sum = 0
	for num, int in ipairs({...}) do
		sum = sum + int
	end

	return sum
end

--[[-------------------------------------------------------------------------
	math.striving_for
---------------------------------------------------------------------------]]

function math.striving_for(value, valueTo, delay)
	return value + (valueTo - value) / delay
end

--[[-------------------------------------------------------------------------
	math.average
---------------------------------------------------------------------------]]

do

    local select = select
    function math.average( ... )
        local amount = select( "#", ... )
        assert(amount > 1, "At least two numbers are required!")

        local total = 0
        for i = 1, amount do
            total = total + select(i, ...)
        end

        return total / amount
    end

end

--[[-------------------------------------------------------------------------
	Angle improvements
---------------------------------------------------------------------------]]

do

    local ANGLE = FindMetaTable("Angle")
    function ANGLE:Floor()
        self[1] = math_floor(self[1])
        self[2] = math_floor(self[2])
        self[3] = math_floor(self[3])
        return self
    end

    function ANGLE:abs()
        self[1] = math_abs(self[1])
        self[2] = math_abs(self[2])
        self[3] = math_abs(self[3])
        return self
    end

end

--[[-------------------------------------------------------------------------
	Vector improvements
---------------------------------------------------------------------------]]

do

    local VECTOR = FindMetaTable("Vector")
    function VECTOR:Diameter(maxs)
        return math_max( maxs[1] + math_abs(self[1]), maxs[2] + math_abs(self[2]), maxs[3] + math_abs(self[3]) )
    end

    function VECTOR:InBox(vec1, vec2)
        return self[1] >= vec1[1] and self[1] <= vec2[1] and self[2] >= vec1[2] and self[2] <= vec2[2] and self[3] >= vec1[3] and self[3] <= vec2[3]
    end

    function VECTOR:Round(dec)
        return Vector( math_Round(self[1], dec or 0), math_Round(self[2], dec or 0), math_Round(self[3], dec or 0) )
    end

    function VECTOR:Floor()
        self[1] = math_floor(self[1])
        self[2] = math_floor(self[2])
        self[3] = math_floor(self[3])
        return self
    end

    function VECTOR:Abs()
        self[1] = math_abs(self[1])
        self[2] = math_abs(self[2])
        self[3] = math_abs(self[3])
        return self
    end

end

--[[-------------------------------------------------------------------------
	ents.FindInBoxRotated( global pos, ang, mins, maxs )
---------------------------------------------------------------------------]]

do

    local ents_FindInSphere = ents.FindInSphere
    local WorldToLocal = WorldToLocal
    local table_insert = table.insert

    function ents.FindInBoxRotated(pos, ang, mins, maxs)
        local result = {}
        for num, ent in ipairs( ents_FindInSphere( pos, mins:Diameter( maxs ) ) ) do
            if WorldToLocal( ent:GetPos(), ent:GetAngles(), pos, ang ):WithinAABox( mins, maxs ) then
                table_insert( result, ent )
            end
        end

        return result
    end

end

--[[-------------------------------------------------------------------------
	player.Random
---------------------------------------------------------------------------]]

do

    local player_GetHumans = player.GetHumans
    local player_GetAll = player.GetAll

    function player.Random( no_bots )
        local players = no_bots and player_GetHumans() or player_GetAll()
        return players[math_random(1, #players)]
    end

end