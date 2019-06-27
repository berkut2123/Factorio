local globals = require("globals")

local upgrade_planner_converter = {}

-- character table string
local chartable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

-- encoding
upgrade_planner_converter.enc = function(data)
  return ((data:gsub(
    ".",
    function(x)
      local r, b = "", x:byte()
      for i = 8, 1, -1 do
        r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and "1" or "0")
      end
      return r
    end
  ) .. "0000"):gsub(
    "%d%d%d?%d?%d?%d?",
    function(x)
      if (#x < 6) then
        return ""
      end
      local c = 0
      for i = 1, 6 do
        c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
      end
      return chartable:sub(c + 1, c + 1)
    end
  ) .. ({"", "==", "="})[#data % 3 + 1])
end

-- decoding
upgrade_planner_converter.dec = function(data)
  data = string.gsub(data, "[^" .. chartable .. "=]", "")
  return (data:gsub(
    ".",
    function(x)
      if (x == "=") then
        return ""
      end
      local r, f = "", (chartable:find(x) - 1)
      for i = 6, 1, -1 do
        r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
      end
      return r
    end
  ):gsub(
    "%d%d%d?%d?%d?%d?%d?%d?",
    function(x)
      if (#x ~= 8) then
        return ""
      end
      local c = 0
      for i = 1, 8 do
        c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
      end
      return string.char(c)
    end
  ))
end

upgrade_planner_converter.to_upgrade_planner = function(stack, config, player)
  local entities = game.entity_prototypes
  local items = game.item_prototypes
  stack.set_stack {name = "upgrade-planner"}
  local idx = 1
  for _, entry in pairs(config) do
    local entity_from = entities[entry.from]
    local entity_to = entities[entry.to]
    local item_from = items[entry.from]
    local item_to = items[entry.to]
    if entity_from and entity_from.fast_replaceable_group then
      stack.set_mapper(idx, "from", {type = "entity", name = entity_from.name})
    elseif item_from and item_from.type == "module" then
      stack.set_mapper(idx, "from", {type = "item", name = item_from.name})
    end

    if entity_to and entity_to.fast_replaceable_group then
      if entity_from then
        if entity_from.fast_replaceable_group == entity_to.fast_replaceable_group then
          stack.set_mapper(idx, "to", {type = "entity", name = entity_to.name})
        else
          player.print(
            {"upgrade-planner.partial-upgrade-planner-export", entity_from.localised_name, entity_to.localised_name}
          )
          stack.set_mapper(idx, "from", nil)
        end
      else
        stack.set_mapper(idx, "to", {type = "entity", name = entity_to.name})
      end
    elseif item_to and item_to.type == "module" then
      stack.set_mapper(idx, "to", {type = "item", name = item_to.name})
    end
    idx = idx + 1
  end
end

upgrade_planner_converter.from_upgrade_planner = function(stack)
  local config = {}
  for i = 1, globals.MAX_CONFIG_SIZE, 1 do
    local from = stack.get_mapper(i, "from").name or ""
    local to = stack.get_mapper(i, "to").name or ""

    config[i] = {from = from, to = to}
  end

  return config
end

return upgrade_planner_converter
