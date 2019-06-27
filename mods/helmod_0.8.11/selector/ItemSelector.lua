require "selector.AbstractSelector"
-------------------------------------------------------------------------------
-- Class to build technology selector
--
-- @module ItemSelector
-- @extends #AbstractSelector
--

ItemSelector = setclass("HMItemSelector", AbstractSelector)

local list_group = {}
local list_subgroup = {}
local list_prototype = {}

-------------------------------------------------------------------------------
-- Return caption
--
-- @function [parent=#ItemSelector] getCaption
--
-- @param #Controller parent parent controller
--
function ItemSelector.methods:getCaption(parent)
  return {"helmod_selector-panel.item-title"}
end

-------------------------------------------------------------------------------
-- Reset groups
--
-- @function [parent=#ItemSelector] resetGroups
--
function ItemSelector.methods:resetGroups()
  Logging:trace(self:classname(), "resetGroups()")
  list_group = {}
  list_subgroup = {}
  list_prototype = {}
end

-------------------------------------------------------------------------------
-- Return list prototype
--
-- @function [parent=#ItemSelector] getListPrototype
--
-- @return #table
--
function ItemSelector.methods:getListPrototype()
  return list_prototype
end

-------------------------------------------------------------------------------
-- Return list group
--
-- @function [parent=#ItemSelector] getListGroup
--
-- @return #table
--
function ItemSelector.methods:getListGroup()
  return list_group
end

-------------------------------------------------------------------------------
-- Return list subgroup
--
-- @function [parent=#ItemSelector] getListSubgroup
--
-- @return #table
--
function ItemSelector.methods:getListSubgroup()
  return list_subgroup
end

-------------------------------------------------------------------------------
-- Append groups
--
-- @function [parent=#ItemSelector] appendGroups
--
-- @param #string name
-- @param #string type
-- @param #table list_group
-- @param #table list_subgroup
-- @param #table list_prototype
--
function ItemSelector.methods:appendGroups(name, type, list_group, list_subgroup, list_prototype)
  Logging:debug(self:classname(), "appendGroups()", name, type)
  ItemPrototype.load(name, type)
  local find = self:checkFilter(ItemPrototype.native())
  local filter_show_disable = Player.getGlobalSettings("filter_show_disable")
  local filter_show_hidden = Player.getGlobalSettings("filter_show_hidden")
  
  if find == true and (ItemPrototype.getValid() == true or filter_show_disable == true) then
    local group_name = ItemPrototype.native().group.name
    local subgroup_name = ItemPrototype.native().subgroup.name
    
    if list_group[group_name] == nil then
      list_group[group_name] = {name=group_name, search_products="", search_ingredients=""}
    end
    list_subgroup[subgroup_name] = ItemPrototype.native().subgroup
    if list_prototype[group_name] == nil then list_prototype[group_name] = {} end
    if list_prototype[group_name][subgroup_name] == nil then list_prototype[group_name][subgroup_name] = {} end
    
    local search_products = name
    list_group[group_name].search_products = list_group[group_name].search_products .. search_products
    
    local search_ingredients = name
    list_group[group_name].search_ingredients = list_group[group_name].search_ingredients .. search_ingredients

    table.insert(list_prototype[group_name][subgroup_name], {name=name, type=type, order=ItemPrototype.native().order, search_products=search_products, search_ingredients=search_ingredients})
  end
end

-------------------------------------------------------------------------------
-- Update groups
--
-- @function [parent=#ItemSelector] updateGroups
--
-- @param #LuaEvent event
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function ItemSelector.methods:updateGroups(event, action, item, item2, item3)
  Logging:trace(self:classname(), "updateGroups()", action, item, item2, item3)
  local global_player = Player.getGlobal()
  local global_gui = Player.getGlobalGui()

  self:resetGroups()

  for key, item in pairs(Player.getItemPrototypes()) do
    self:appendGroups(item.name, "item", list_group, list_subgroup, list_prototype)
  end
end

-------------------------------------------------------------------------------
-- Build prototype tooltip
--
-- @function [parent=#ItemSelector] buildPrototypeTooltip
--
-- @param #LuaPrototype prototype
--
function ItemSelector.methods:buildPrototypeTooltip(prototype)
  Logging:trace(self:classname(), "buildPrototypeTooltip(player, prototype):", prototype)
  -- initalize tooltip
  local tooltip = ItemPrototype.load(prototype).getLocalisedName()
  return tooltip
end

-------------------------------------------------------------------------------
-- Build prototype icon
--
-- @function [parent=#ItemSelector] buildPrototypeIcon
--
function ItemSelector.methods:buildPrototypeIcon(guiElement, prototype, tooltip)
  Logging:trace(self:classname(), "buildPrototypeIcon(player, guiElement, prototype, tooltip:", guiElement, prototype, tooltip)
  ElementGui.addGuiButtonSelectSprite(guiElement, self:classname().."=element-select=ID=item=", Player.getItemIconType(prototype), prototype.name, prototype.name, tooltip)
end



