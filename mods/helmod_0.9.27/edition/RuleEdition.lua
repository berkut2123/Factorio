-------------------------------------------------------------------------------
-- Class to build rule edition dialog
--
-- @module RuleEdition
--

RuleEdition = newclass(Form)

-------------------------------------------------------------------------------
-- On initialization
--
-- @function [parent=#RuleEdition] onInit
--
function RuleEdition:onInit()
  self.panelCaption = ({"helmod_rule-edition-panel.title"})
  self.parameterLast = string.format("%s_%s",self.classname,"last")
end

-------------------------------------------------------------------------------
-- Get or create rule panel
--
-- @function [parent=#RuleEdition] getRulePanel
--
-- @return #LuaGuiElement
--
function RuleEdition:getRulePanel()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  if content_panel["rule_panel"] ~= nil and content_panel["rule_panel"].valid then
    return content_panel["rule_panel"]
  end
  local table_panel = GuiElement.add(content_panel, GuiFrameV("rule_panel"):style(helmod_frame_style.panel))
  return table_panel
end

-------------------------------------------------------------------------------
-- Get or create action panel
--
-- @function [parent=#RuleEdition] getActionPanel
--
function RuleEdition:getActionPanel()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  if content_panel["action_panel"] ~= nil and content_panel["action_panel"].valid then
    return content_panel["action_panel"]
  end
  return GuiElement.add(content_panel, GuiFrameV("action_panel"):style(helmod_frame_style.panel))
end

-------------------------------------------------------------------------------
-- On update
--
-- @function [parent=#RuleEdition] onUpdate
--
-- @param #LuaEvent event
--
function RuleEdition:onUpdate(event)
  Logging:debug(self.classname, "onUpdate()", event)
  self:updateRule(event)
  self:updateAction(event)
end

local rule_mod = nil
local rule_name = nil
local rule_category = nil
local rule_type = nil
local rule_value = nil
local rule_excluded = false
-------------------------------------------------------------------------------
-- Update rule
--
-- @function [parent=#RuleEdition] updateRule
--
-- @param #LuaEvent event
--
function RuleEdition:updateRule(event)
  Logging:debug(self.classname, "updateRule()", event)
  local rule_panel = self:getRulePanel()
  rule_panel.clear()
  local rule_table = GuiElement.add(rule_panel, GuiTable("list-data"):column(2):style(helmod_table_style.rule))

  -- mod
  local mod_list = {}
  for name, version in pairs(game.active_mods) do
    table.insert(mod_list, name)
  end
  if rule_mod == nil then rule_mod = mod_list[1] end
  GuiElement.add(rule_table, GuiLabel("label-mod"):caption({"helmod_rule-edition-panel.mod"}))
  GuiElement.add(rule_table, GuiDropDown(self.classname, "dropdown", "mod"):items(mod_list, rule_mod))

  -- name
  local helmod_rule_manes = {}
  for name,rule in pairs(helmod_rules) do
    table.insert(helmod_rule_manes,name)
  end
  if rule_name == nil then rule_name = helmod_rule_manes[1] end
  GuiElement.add(rule_table, GuiLabel("label-name"):caption({"helmod_rule-edition-panel.name"}))
  GuiElement.add(rule_table, GuiDropDown(self.classname, "dropdown", "name"):items(helmod_rule_manes, rule_name))

  -- category
  local helmod_rule_categories = {}
  for name,rule in pairs(helmod_rules[rule_name].categories) do
    table.insert(helmod_rule_categories,name)
  end
  if rule_category == nil then rule_category = helmod_rule_categories[1] end
  GuiElement.add(rule_table, GuiLabel("label-category"):caption({"helmod_rule-edition-panel.category"}))
  GuiElement.add(rule_table, GuiDropDown(self.classname, "dropdown", "category"):items(helmod_rule_categories, rule_category))

  -- type
  local helmod_rule_types = helmod_rules[rule_name].categories[rule_category]
  if rule_type == nil then rule_type = helmod_rule_types[1] end
  GuiElement.add(rule_table, GuiLabel("label-type"):caption({"helmod_rule-edition-panel.type"}))
  GuiElement.add(rule_table, GuiDropDown(self.classname, "dropdown", "type"):items(helmod_rule_types, rule_type))

  GuiElement.add(rule_table, GuiLabel("label-value"):caption({"helmod_rule-edition-panel.value"}))
  GuiElement.add(rule_table, GuiButton("choose", "value"):choose("entity"))

  GuiElement.add(rule_table, GuiLabel("label-excluded"):caption({"helmod_rule-edition-panel.excluded"}))
  local checkbox = GuiElement.add(rule_table, GuiCheckBox("excluded"):state(false))
  if helmod_rules[rule_name].excluded_only then
    checkbox.state=true
    checkbox.enabled=false
  end
end

-------------------------------------------------------------------------------
-- Update action
--
-- @function [parent=#RuleEdition] updateAction
--
-- @param #LuaEvent event
--
function RuleEdition:updateAction(event)
  Logging:debug(self.classname, "updateAction()", event)
  local action_panel = self:getActionPanel()
  action_panel.clear()
  local action_panel = GuiElement.add(action_panel, GuiTable("table_action"):column(2))
  GuiElement.add(action_panel, GuiButton(self.classname, "save"):caption({"helmod_button.save"}))
  GuiElement.add(action_panel, GuiButton(self.classname, "CLOSE"):caption({"helmod_button.close"}))
end

-------------------------------------------------------------------------------
-- On event
--
-- @function [parent=#RuleEdition] onEvent
--
-- @param #LuaEvent event
--
function RuleEdition:onEvent(event)
  Logging:debug(self.classname, "onEvent()", event)
  if User.isAdmin() then
    if event.action == "dropdown" then
      if event.item1 == "mod" then
        rule_mod = GuiElement.getDropdownSelection(event.element)
      end
      if event.item1 == "name" then
        rule_name = GuiElement.getDropdownSelection(event.element)
      end
      if event.item1 == "category" then
        rule_category = GuiElement.getDropdownSelection(event.element)
      end
      if event.item1 == "type" then
        rule_type = GuiElement.getDropdownSelection(event.element)
      end
      self:updateRule(event)
    end

    if event.action == "save" then
      local rule_panel = self:getRulePanel()
      local rule_table = rule_panel["list-data"]

      local rule_value = rule_table["choose=value"].elem_value
      local rule_excluded = rule_table["excluded"].state

      if rule_value ~= nil then
        if rule_type == "entity-type" then
          rule_value = EntityPrototype(rule_value):getType()
        end
        if rule_type == "entity-group" then
          rule_value = EntityPrototype(rule_value):native().group.name
        end
        if rule_type == "entity-subgroup" then
          rule_value = EntityPrototype(rule_value):native().subgroup.name
        end
      else
        rule_value = "all"
      end
      ModelBuilder.addRule(rule_mod, rule_name, rule_category, rule_type, rule_value, rule_excluded)
      self:close()
      Controller:send("on_gui_refresh", event)
    end
  end
end
