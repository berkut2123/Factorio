--[[--
Class allowing easy access to useful functions for tables of key/value pairs.
@classmod Map
]]
Map = {}
Map.objMT = {
    __index = Map
}
-- Map = util.map
Map.new = function(start)
    local obj = start or {}
    return setmetatable(obj, Map.objMT)
end
function Map.combine(...)
    local result = {}
    for i, v in pairs({...}) do
        -- local v = ...[i]
        -- if (v) then
        for key, val in pairs(v) do
            result[key] = val
        end
        -- end
    end
    return result
end
Map.any = function(self)
    for k, v in pairs(self) do
        return v
    end
end
Map.anyVal = Map.any
Map.anyKey = function(self)
    for k, v in pairs(self) do
        return k
    end
end
Map.size = function(self)
    local count = 0
    for k, v in pairs(self) do
        count = count + 1
    end
    return count
end
Map.contains = function(self, val)
    for k, v in pairs(self) do
        if v == val then
            return true
        end
    end
    return false
end
Map.containsValue = Map.contains
table.containsValue = Map.contains

Map.copy = function(self)
    local new = {}
    for k, v in pairs(self) do
        new[k] = v
    end
    return new
end

-- Map.containsKey = function(self, key)
--     for k, v in pairs(self) do
--         if v == val then
--             return true
--         end
--     end
--     return false
-- end
return Map
