local assert = assert
local type = type

local math_Round = math.Round
local math_floor = math.floor
local math_abs = math.abs
local math_max = math.max

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