-- Libraries
local table = table
local math = math

-- Functions
local Vector = Vector
local ipairs = ipairs
local Angle = Angle
local pairs = pairs

math.Map = math.Remap

function math.Aspiration( from, to, delay )
    return from + ( to - from ) / delay
end

function math.BezierLinear( from, to, delta )
    return from + ( to - from ) * ( delta / 100 )
end

function math.Bezier( vec1, vec2, vec3, delta )
    return math.BezierLinear( math.BezierLinear( vec1, vec2, delta ), math.BezierLinear( vec2, vec3, delta ), delta )
end

function math.SinWave( x, freq, amp, offset )
    return math.sin( 2 * math.pi * freq * x ) * amp + offset
end

function math.Divisible( num, factor )
    return num % factor == 0
end

function math.Even( num )
    return math.Divisible( num, 2 )
end

function math.Odd( num )
    return not math.Even( num )
end

function table.GetMin( tbl, issequential )
    local min = nil
    for _, value in ( issequential and ipairs or pairs )( tbl ) do
        if min == nil or value < min then min = value end
    end

    return min
end

function table.GetMax( tbl, issequential )
    local max = nil
    for _, value in ( issequential and ipairs or pairs )( tbl ) do
        if max == nil or value > max then max = value end
    end

    return max
end

function table.Summary( tbl, issequential )
    local result, count = 0, 0
    for _, number in ( issequential and ipairs or pairs )( tbl ) do
        result = result + number
        count = count + 1
    end

    return result, count
end

function table.Average( tbl, issequential )
    local result, count = table.Summary( tbl, issequential )
    return result / count
end

function math.Summary( ... )
    return table.Summary( { ... }, true )
end

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

    local vector_up = Vector( 0, 0, 1 )

    function VECTOR:IsIn2DShape( ... )
        local corners = { ... }
        for index = 1, #corners do
            local vector = corners[ index ]
            local diff = ( corners[ index + 1 ] or corners[ 1 ] ) - vector

            local diffNormal = diff:Copy()
            VECTOR.Normalize( diffNormal )

            local center = diff / 2 + vector
            local normal = ( self - center )
            VECTOR.Normalize( normal )

            if VECTOR.Dot( VECTOR.Cross( vector_up, diffNormal ), normal ) > 0 then
                return false
            end
        end

        return true
    end

    -- maybe later
    function VECTOR:IsInFake3DShape( ... )
        if not self:IsIn2DShape( ... ) then return false end
        local minZ, maxZ = nil, nil

        for _, vec in ipairs( { ... } ) do
            local z = vec[ 3 ]
            if minZ then
                if minZ > z then
                    minZ = z
                end
            else
                minZ = z
            end

            if maxZ then
                if maxZ < z then
                    maxZ = z
                end
            else
                maxZ = z
            end
        end

        return self[ 3 ] >= minZ and self[ 3 ] <= maxZ
    end

end

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
