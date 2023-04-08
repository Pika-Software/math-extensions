-- Libraries
local table = table
local math = math

-- Variables
local ipairs = ipairs
local pairs = pairs

-- math.Aspiration( from, to, delay )
function math.Aspiration( from, to, delay )
    return from + ( to - from ) / delay
end

-- math.BezierLinear( from, to, delta )
function math.BezierLinear( from, to, delta )
    return from + ( to - from ) * ( delta / 100 )
end

-- math.Bezier( vec1, vec2, vec3, delta )
function math.Bezier( vec1, vec2, vec3, delta )
    return math.BezierLinear( math.BezierLinear( vec1, vec2, delta ), math.BezierLinear( vec2, vec3, delta ), delta )
end

-- table.GetMin( tbl )
function table.GetMin( tbl )
    local min = nil
    for _, value in ipairs( tbl ) do
        if min == nil or value < min then min = value end
    end

    return min
end

-- table.GetMax( tbl )
function table.GetMax( tbl )
    local max = nil
    for _, value in ipairs( tbl ) do
        if max == nil or value > max then max = value end
    end

    return max
end

-- table.Summary( tbl, issequential )
function table.Summary( tbl, issequential )
    local result, count = 0, 0
    if issequential then
        for _, number in ipairs( tbl ) do
            result = result + number
            count = count + 1
        end
    else
        for _, number in pairs( tbl ) do
            result = result + number
            count = count + 1
        end
    end

    return result, count
end

-- table.Average( tbl, issequential )
function table.Average( tbl, issequential )
    local result, count = table.Summary( tbl, issequential )
    return result / count
end

-- math.Summary( ... )
function math.Summary( ... )
    return table.Summary( { ... }, true )
end

-- math.Average( ... )
function math.Average( ... )
    return table.Average( { ... }, true )
end

do

    local ANGLE = FindMetaTable("Angle")

    function ANGLE:Copy()
        return Angle( self[ 1 ], self[ 2 ], self[ 3 ] )
    end

    function ANGLE:floor()
        self[ 1 ] = math.floor( self[ 1 ] )
        self[ 2 ] = math.floor( self[ 2 ] )
        self[ 3 ] = math.floor( self[ 3 ] )
        return self
    end

    function ANGLE:abs()
        self[ 1 ] = math.abs( self[ 1 ] )
        self[ 2 ] = math.abs( self[ 2 ] )
        self[ 3 ] = math.abs( self[ 3 ] )
        return self
    end

    function ANGLE:Round( number )
        self[ 1 ] = math.Round( self[ 1 ], number )
        self[ 2 ] = math.Round( self[ 2 ], number )
        self[ 3 ] = math.Round( self[ 3 ], number )
        return self
    end

end

do

    local VECTOR = FindMetaTable( "Vector" )

    function VECTOR:Copy()
        return Vector( self[ 1 ], self[ 2 ], self[ 3 ] )
    end

    function VECTOR:abs()
        self[ 1 ] = math.abs( self[ 1 ] )
        self[ 2 ] = math.abs( self[ 2 ] )
        self[ 3 ] = math.abs( self[ 3 ] )
        return self
    end

    function VECTOR:floor()
        self[ 1 ] = math.floor( self[ 1 ] )
        self[ 2 ] = math.floor( self[ 2 ] )
        self[ 3 ] = math.floor( self[ 3 ] )
        return self
    end

    function VECTOR:Round( number )
        self[ 1 ] = math.Round( self[ 1 ], number )
        self[ 2 ] = math.Round( self[ 2 ], number )
        self[ 3 ] = math.Round( self[ 3 ], number )
        return self
    end

    function VECTOR:Diameter( maxs )
        return math.max( maxs[1] + math.abs( self[1] ), maxs[2] + math.abs( self[2] ), maxs[3] + math.abs( self[3] ) )
    end

    function VECTOR:InBox( mins, maxs )
        return self[ 1 ] >= mins[ 1 ] and self[ 1 ] <= maxs[ 1 ] and self[ 2 ] >= mins[ 2 ] and self[ 2 ] <= maxs[ 2 ] and self[ 3 ] >= mins[ 3 ] and self[ 3 ] <= maxs[ 3 ]
    end

    function VECTOR:Center( vec )
        if type( vec ) == "Vector" then
            return ( self + vec ) / 2
        else
            return ( self[1] + self[2] + self[3] ) / 3
        end
    end

end

-- ents.FindInBoxRotated( pos, ang, mins, maxs )
do

    local ents_FindInSphere = ents.FindInSphere
    local WorldToLocal = WorldToLocal

    function ents.FindInBoxRotated( pos, ang, mins, maxs )
        local result = {}
        for _, ent in ipairs( ents_FindInSphere( pos, mins:Diameter( maxs ) ) ) do
            if WorldToLocal( ent:GetPos(), ent:GetAngles(), pos, ang ):WithinAABox( mins, maxs ) then
                result[ #result + 1 ] = ent
            end
        end

        return result
    end

end