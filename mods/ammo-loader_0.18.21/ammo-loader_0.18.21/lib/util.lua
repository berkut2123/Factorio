require "stdlib/string"
require "stdlib/Map"
require "stdlib/Array"
require "stdlib/Queue"
require "stdlib/area/area"
require "stdlib/area/position"

---Module containing many utility functions.
util = {}

---Shortcut for some commonly used colors with the desired alpha already set.
util.colors = {}
util.colors.alpha = 0.1
local alpha = util.colors.alpha
util.colors.red = {r = 1, g = 0, b = 0, a = alpha}
util.colors.blue = {r = 0, g = 0, b = 1, a = alpha}
util.colors.green = {r = 0, g = 1, b = 0, a = alpha}
util.colors.purple = {r = 0.5, g = 0, b = 0.5, a = alpha}
util.colors.fuchsia = {r = 1, g = 0, b = 1, a = alpha}
util.colors.litePurple = {r = 0, g = 0.08, b = 0.08, a = alpha}
util.colors.teal = {r = 0, g = 0.5, b = 0.5, a = alpha}

---Checks validity of Factorio game objects. Checks nil and object.valid.
---@param gameObj LuaObject
---@return boolean
function util.isValid(gameObj)
    if (not gameObj) or (not gameObj.valid) then
        return false
    end
    return true
end
isValid = util.isValid

---Check if LuaItemStack is nil or valid_for_read is false
---@param stack LuaItemStack
function util.readyForRead(stack)
    if (stack) and (stack.valid_for_read) then
        return true
    end
    return false
end

---Check if any object is either nil or empty.
---@param var any
function util.isEmpty(var)
    if (var == nil) then
        return true
    end
    local t = type(var)
    if (t == "string") and (var == "") then
        return true
    elseif (t == "boolean") and (var == false) then
        return true
    elseif (t == "number") and (t == 0) then
        return true
    elseif (t == "table") then
        if (var.valid ~= nil) and (var.valid == false) then
            return true
        elseif (var.valid_for_read ~= nil) and (var.valid_for_read == false) then
            return true
        elseif (var.count ~= nil) and (var.count <= 0) then
            return true
        elseif (next(var) == nil) then
            return true
        end
    end
    return false
end

---Print to console if debugging is enabled.
---@param s string
---@param forceShow boolean
function util.inform(s, forceShow)
    if (not game) then
        -- error("called inform when game was invalid:\n" .. debug.traceback())
        return nil
    end
    local debug = true
    if (gSets) and (gSets.cache()) then
        debug = gSets.debug()
    end
    if (not debug) and (not forceShow) then
        return false
    end
    local str = string.toString(s)
    game.print("[Ammo-Loader]:> " .. str)
end
inform = util.inform

---Concatenate all args and print the result.
function util.cInform(...)
    if (not gSets.debugging()) then
        return nil
    end
    return util.inform(string.concat(...))
end
cInform = util.cInform

---Concatenate all args and print the result. Will print even if debugging is disabled.
function util.ctInform(...)
    return util.inform(string.concat(...), true)
end
ctInform = util.ctInform

---Print a profiler's value to the console.
---@param prof LuaProfiler
---@param msg string
function util.printProfiler(prof, msg)
    if (gSets.debugging()) then
        cInform("Profiler: ", msg)
        game.print(prof)
    end
end
printProfiler = util.printProfiler

---Alias for game.surfaces.nauvis.find_entities_filtered
---@param options table
---@return LuaEntity[]
function util.nauvisFind(options)
    local res = game.surfaces.nauvis.find_entities_filtered(options)
    return res
end
util.nFind = util.nauvisFind

---Find entities on all surfaces.
---@param options table
---@return LuaEntity[]
function util.allFind(options)
    local results = {}
    for id, surf in pairs(game.surfaces) do
        local find = surf.find_entities_filtered(options)
        results = Array.merge(results, find)
    end
    return results
end

---Drop items on a surface.
---@param opts table
function util.spillItemStack(opts)
    ---@type LuaItemStack
    local stack = opts.stack
    ---@type LuaForce
    local force = opts.force
    ---@type LuaSurface
    local surf = opts.surface
    ---@type Position
    local pos = opts.position

    if (util.isEmpty(stack)) then
        return
    end
    surf = surf or game.get_surface("nauvis")
    pos = pos or {x = 0, y = 0}
    surf.spill_item_stack(pos, stack, true, force, false)
end
util.spillStack = util.spillItemStack

---Destroy all entities with a given name.
---@param name string
function util.destroyAll(name)
    local found = util.allFind({name = name})
    for i = 1, #found do
        found[i].destroy()
    end
end

---Check if a Slot is in range of a Chest.
---@param slot Slot
---@param chest Chest
function util.isInRange(slot, chest)
    -- if (not chest.area) then
    -- return true
    -- end
    local rad = gSets.chestRadius()
    if (rad <= 0) then
        return true
    end
    local surfName = chest:surfaceName()
    -- if (slot:surfaceName() == surfName) and (Area.inside(chest.area, slot:position())) then
    -- local radius = gSets.chestRadius()
    if (slot:surfaceName() == surfName) and (Position.distance_squared(slot:position(), chest:position()) <= rad * rad) then
        return true
    end
    return false
end

---Submodule containing useful string functions.
-- util.string = {}

---Destroy all renders belonging to a player. Returns true if any renders were destroyed.
---@param player LuaPlayer
function util.clearPlayerRenders(player, destroyNow)
    local didClear = false
    local ids = rendering.get_all_ids("ammo-loader")
    for i, id in pairs(ids) do
        local players = rendering.get_players(id)
        if (players and players[1] and players[1].index == player.index) then
            -- rendering.set_visible(id, false)
            if (destroyNow) then
                rendering.destroy(id)
            else
                alGui.rendersNeedDestroy()[id] = 1
            end
            didClear = true
        end
    end
    return didClear
end

---Destroy all renders belonging to the mod.
function util.clearRenders()
    rendering.clear("ammo-loader")
    -- local ids = rendering.get_all_ids("ammo-loader")
    -- for i, id in pairs(ids) do
    -- rendering.set_visible(id, false)
    -- rendering.destroy(id)
    -- end
end

function util.empty(val)
    local type = type
    local t = type(val)
    if (t == "nil") then
        return true
    elseif (t == "number") and (val <= 0) then
        return true
    elseif (t == "string") and (val == "") then
        return true
    elseif (t == "table") then
        local next = next
        if (next(val) == nil) then
            return true
        elseif (val["isEmpty"]) and (type(val["isEmpty"]) == "function") and (val:isEmpty()) then
            return true
        elseif (val["valid"]) and (type(val["valid"]) == "boolean") and (not val["valid"]) then
            return true
        elseif (val["isValid"]) and (type(val["isValid"]) == "function") and (not val:isValid()) then
            return true
        end
    end
    return false
end
empty = util.empty

function util.isPositive(val)
    if (type(val) ~= "number") then
        return false
    end
    if (val <= 0) then
        return false
    end
    return true
end
isPositive = util.isPositive

function util.hashToArray(hash)
end

function util.startProfiler()
    if (gSets.canUseProfiler()) then
        Profiler.Start()
    end
end

function util.stopProfiler()
    Profiler.Stop()
end

function util.memoize(f)
    local mem = {} -- memoizing table
    setmetatable(mem, {__mode = "kv"}) -- make it weak
    return function(x) -- new version of ’f’, with memoizing
        local r = mem[x]
        if r == nil then -- no previous result?
            r = f(x) -- calls original function
            mem[x] = r -- store result for reuse
        end
        return r
    end
end

function util.serpLog(...)
    if (gSets.debugging()) then
        local args = table.pack(...)
        local res = ""
        for i = 1, #args do
            local curArg = args[i]
            if (type(curArg) == "string") then
                res = res .. curArg
            else
                -- log(serpent.block(args[i]))
                res = res .. serpent.block(curArg)
            end
        end
        -- log("2")
        log(res)
    end
end
serpLog = util.serpLog

function util.getPlayer(p)
    if (not p) then
        return
    end
    if (type(p) == "number") then
        p = game.get_player(p)
    end
    if (not isValid(p)) then
        return
    end
    return p
end

function util.eventPlayer(event)
    return util.getPlayer(event.player_index)
end

function util.eventName(event)
    if (not event) then
        return
    end
    if (event.input_name) then
        return event.input_name
    end
    if (not event.name) then
        return
    end
    local eName = event.name
    for name, id in pairs(defines.events) do
        if (id == eName) then
            return name
        end
    end
    return nil
end

function util.capitalize(str)
    str =
        string.gsub(
        str,
        "^%w",
        function(a, b)
            if (not b) then
                return string.upper(a)
            end
            return a .. string.upper(b)
        end
    )
    str =
        string.gsub(
        str,
        "%W%w",
        function(a, b)
            if (not b) then
                return string.upper(a)
            end
            return a .. string.upper(b)
        end
    )
    return str
end
string.capitalize = util.capitalize

return util
