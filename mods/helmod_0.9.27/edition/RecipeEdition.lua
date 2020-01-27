-------------------------------------------------------------------------------
-- Class to build recipe edition dialog
--
-- @module RecipeEdition
-- @extends #AbstractEdition
--

RecipeEdition = newclass(Form,function(base,classname)
  Form.init(base,classname)
  base.content_verticaly = true
end)

local limit_display_height = 850

-------------------------------------------------------------------------------
-- On Bind Dispatcher
--
-- @function [parent=#RecipeEdition] onBind
--
function RecipeEdition:onBind()
  Dispatcher:bind("on_gui_priority_module", self, self.updateFactoryModules)
  Dispatcher:bind("on_gui_priority_module", self, self.updateBeaconModules)
end

-------------------------------------------------------------------------------
-- On initialization
--
-- @function [parent=#RecipeEdition] onInit
--
function RecipeEdition:onInit()
  Logging:debug(self.classname, "onInit()")
  self.panelCaption = ({"helmod_recipe-edition-panel.title"})
  self.parameterLast = string.format("%s_%s",self.classname,"last")
end

-------------------------------------------------------------------------------
-- Get or create recipe info panel
--
-- @function [parent=#RecipeEdition] getObjectInfoPanel
--
-- @return #LuaGuiElement
--
function RecipeEdition:getObjectInfoPanel()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  if content_panel["info"] ~= nil and content_panel["info"].valid then
    return content_panel["info"]
  end
  local panel = GuiElement.add(content_panel, GuiFrameV("info"))
  panel.style.horizontally_stretchable = true
  return panel
end

-------------------------------------------------------------------------------
-- Get or create tab panel
--
-- @function [parent=#RecipeEdition] getTabPanel
--
function RecipeEdition:getTabPanel()
  local display_width, display_height = GuiElement.getDisplaySizes()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  local panel_name = "tab_panel"
  local factory_panel_name = "facory_panel"
  local beacon_panel_name = "beacon_panel"

  if display_height >= limit_display_height then
    -- affichage normal
    if content_panel[factory_panel_name] ~= nil and content_panel[factory_panel_name].valid then
      return content_panel[factory_panel_name], content_panel[beacon_panel_name]
    end
    local factory_panel = GuiElement.add(content_panel, GuiFrameH(factory_panel_name))
    factory_panel.style.horizontally_stretchable = true

    local beacon_panel = GuiElement.add(content_panel, GuiFrameH(beacon_panel_name))
    beacon_panel.style.horizontally_stretchable = true

    return factory_panel, beacon_panel
  else
    -- affichage tab
    if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
      return content_panel[panel_name][panel_name][factory_panel_name], content_panel[panel_name][panel_name][beacon_panel_name]
    end
    local panel = GuiElement.add(content_panel, GuiFrameH(panel_name))
    local tab_panel = GuiElement.add(panel, GuiTabPane(panel_name))
    local factory_tab_panel = GuiElement.add(tab_panel, GuiTab("factory-tab"):caption({"helmod_common.factory"}))
    local factory_panel = GuiElement.add(tab_panel, GuiFlowV(factory_panel_name))
    tab_panel.add_tab(factory_tab_panel, factory_panel)

    local beacon_tab_panel = GuiElement.add(tab_panel, GuiTab("beacon-tab"):caption({"helmod_common.beacon"}))
    local beacon_panel = GuiElement.add(tab_panel, GuiFlowV(beacon_panel_name))
    tab_panel.add_tab(beacon_tab_panel, beacon_panel)
    return factory_panel, beacon_panel
  end
end

-------------------------------------------------------------------------------
-- Get object
--
-- @function [parent=#RecipeEdition] getObject
--
function RecipeEdition:getObject()
  local model = Model.getModel()
  local element = User.getParameter("recipe_edition_object")
  if element ~= nil and model.blocks[element.block] ~= nil and model.blocks[element.block].recipes[element.recipe] ~= nil then
    return model.blocks[element.block].recipes[element.recipe]
  end
  return nil
end

-------------------------------------------------------------------------------
-- Get or create factory panel
--
-- @function [parent=#RecipeEdition] getFactoryPanel
--
function RecipeEdition:getFactoryPanel()
  local content_panel, _ = self:getTabPanel()
  local table_name = "factory_table"
  local factory_info_name = "factory_info"
  local factory_module_name = "factory_module"
  if content_panel[table_name] ~= nil and content_panel[table_name].valid then
    return content_panel[table_name][factory_info_name], content_panel[table_name][factory_module_name]
  end

  local table_panel = GuiElement.add(content_panel, GuiTable(table_name):column(2))
  table_panel.vertical_centering = false
  local factory_info_panel = GuiElement.add(table_panel, GuiFlowV(factory_info_name))
  factory_info_panel.style.width = 250
  local factory_module_panel = GuiElement.add(table_panel, GuiFlowV(factory_module_name))
  factory_module_panel.style.width = 300
  return factory_info_panel, factory_module_panel
end

-------------------------------------------------------------------------------
-- Get or create beacon panel
--
-- @function [parent=#RecipeEdition] getBeaconPanel
--
function RecipeEdition:getBeaconPanel()
  local _, content_panel = self:getTabPanel()
  local table_name = "beacon_table"
  local beacon_info_name = "beacon_info"
  local beacon_module_name = "beacon_module"
  if content_panel[table_name] ~= nil and content_panel[table_name].valid then
    return content_panel[table_name][beacon_info_name], content_panel[table_name][beacon_module_name]
  end

  local table_panel = GuiElement.add(content_panel, GuiTable(table_name):column(2))
  table_panel.vertical_centering = false
  local beacon_info_panel = GuiElement.add(table_panel, GuiFlowV(beacon_info_name))
  beacon_info_panel.style.width = 250
  local beacon_module_panel = GuiElement.add(table_panel, GuiFlowV(beacon_module_name))
  beacon_module_panel.style.width = 300
  return beacon_info_panel, beacon_module_panel
end

-------------------------------------------------------------------------------
-- On before open
--
-- @function [parent=#RecipeEdition] onBeforeOpen
--
-- @param #LuaEvent event
--
-- @return #boolean if true the next call close dialog
--
function RecipeEdition:onBeforeOpen(event)
  local close = (event.action == "OPEN") -- only on open event
  User.setParameter("module_list_refresh",false)
  if event.action == "OPEN" and event.item1 ~= nil and event.item2 ~= nil then
    local parameter_last = string.format("%s%s", event.item1, event.item2)
    User.setParameter("recipe_edition_object", {block=event.item1, recipe=event.item2})
    Logging:debug(self.classname, "onBeforeEvent()", {block=event.item1, recipe=event.item2})
    if User.getParameter(self.parameterLast) or User.getParameter(self.parameterLast) ~= parameter_last then
      close = false
      User.setParameter("factory_group_selected",nil)
      User.setParameter("beacon_group_selected",nil)
      User.setParameter("module_list_refresh",true)
    end

    User.setParameter(self.parameterLast, parameter_last)
  end
  return close
end

-------------------------------------------------------------------------------
-- On event
--
-- @function [parent=#RecipeEdition] onEvent
--
-- @param #LuaEvent event
--
function RecipeEdition:onEvent(event)
  Logging:debug(self.classname, "onEvent()", event)
  local display_width, display_height = GuiElement.getDisplaySizes()
  local model = Model.getModel()

  if User.isWriter() then
    if event.action == "object-update" then
      local options = {}
      local text = event.element.text
      options["production"] = (tonumber(text) or 100)/100
      ModelBuilder.updateObject(event.item1, event.item2, options)
      ModelCompute.update()
      self:updateObjectInfo(event)
      Controller:send("on_gui_refresh", event)
    end

    if event.action == "factory-select" then
      -- item1=recipe item2=factory
      Model.setFactory(event.item1, event.item2, event.item3)
      ModelBuilder.applyFactoryModulePriority(event.item1, event.item2)
      ModelCompute.update()
      self:update(event)
      Controller:send("on_gui_refresh", event)
    end

    if event.action == "factory-update" then
      local options = {}

      local text = event.element.text
      local ok , err = pcall(function()
        options["limit"] = formula(text) or 0

        ModelBuilder.updateFactory(event.item1, event.item2, options)
        ModelCompute.update()
        self:updateFactoryInfo(event)
        self:updateHeader(event)
        Controller:send("on_gui_refresh", event)
      end)
      if not(ok) then
        Player.print("Formula is not valid!")
      end
    end

    if event.action == "factory-fuel-update" then

      local index = event.element.selected_index
      local object = self:getObject()
      local factory_prototype = EntityPrototype(object.factory)
      local fuel_list = factory_prototype:getBurnerPrototype():getFuelItemPrototypes()
      local items = {}
      local options = {}
      for _,item in pairs(fuel_list) do
        if index == 1 then
          options.fuel = item.name
          break end
        index = index - 1
      end
      ModelBuilder.updateFuelFactory(event.item1, event.item2, options)
      ModelCompute.update()
      self:updateFactoryInfo(event)
      self:updateHeader(event)
      Controller:send("on_gui_refresh", event)
    end

    if event.action == "factory-tool" then
      local recipe = self:getObject()
      if event.item3 == "default" then
        User.setDefaultFactory(recipe)
      elseif event.item3 == "block" then
        ModelBuilder.setFactoryBlock(event.item1, recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "line" then
        ModelBuilder.setFactoryLine(recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "all" then
        User.setParameter("default_factory_mode", "all")
      elseif event.item3 == "category" then
        User.setParameter("default_factory_mode", "category")
      elseif event.item3 == "module" then
        User.setParameter("default_factory_with_module", not(User.getParameter("default_factory_with_module")))
      end
      self:update(event)
    end

    if event.action == "factory-module-tool" then
      local recipe = self:getObject()
      if event.item3 == "default" then
        User.setDefaultFactoryModule(recipe)
      elseif event.item3 == "block" then
        ModelBuilder.setFactoryModuleBlock(event.item1, recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "line" then
        ModelBuilder.setFactoryModuleLine(recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "erase" then
        ModelBuilder.setFactoryModulePriority(event.item1, event.item2, nil)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      end
      self:update(event)
    end

    if event.action == "factory-module-priority-select" then
      User.setParameter("factory_module_priority", tonumber(event.item3))
      self:updateFactoryModules(event)
    end

    if event.action == "factory-module-priority-apply" then
      local factory_module_priority = User.getParameter("factory_module_priority") or 1
      local priority_modules = User.getParameter("priority_modules")
      if factory_module_priority ~= nil and priority_modules ~= nil and priority_modules[factory_module_priority] ~= nil then
        ModelBuilder.setFactoryModulePriority(event.item1, event.item2, priority_modules[factory_module_priority])
        ModelCompute.update()
        self:update(event)
        Controller:send("on_gui_refresh", event)
      end
    end

    if event.action == "factory-module-select" then
      ModelBuilder.addFactoryModule(event.item1, event.item2, event.item3)
      ModelCompute.update()
      self:update(event)
      Controller:send("on_gui_refresh", event)
    end
    
    if event.action == "factory-module-remove" then
      ModelBuilder.removeFactoryModule(event.item1, event.item2, event.item3)
      ModelCompute.update()
      self:update(event)
      Controller:send("on_gui_refresh", event)
    end
    
    if event.action == "beacon-tool" then
      local recipe = self:getObject()
      if event.item3 == "default" then
        User.setDefaultBeacon(recipe)
      elseif event.item3 == "block" then
        ModelBuilder.setBeaconBlock(event.item1, recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "line" then
        ModelBuilder.setBeaconLine(recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "all" then
        User.setParameter("default_beacon_mode", "all")
      elseif event.item3 == "category" then
        User.setParameter("default_beacon_mode", "category")
      elseif event.item3 == "module" then
        User.setParameter("default_beacon_with_module", not(User.getParameter("default_beacon_with_module")))
      end
      self:update(event)
    end

    if event.action == "beacon-module-tool" then
      local recipe = self:getObject()
      if event.item3 == "default" then
        User.setDefaultBeaconModule(recipe)
      elseif event.item3 == "block" then
        ModelBuilder.setBeaconModuleBlock(event.item1, recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "line" then
        ModelBuilder.setBeaconModuleLine(recipe)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      elseif event.item3 == "erase" then
        ModelBuilder.setBeaconModulePriority(event.item1, event.item2, nil)
        ModelCompute.update()
        Controller:send("on_gui_refresh", event)
      end
      self:update(event)
    end

    if event.action == "beacon-module-priority-select" then
      User.setParameter("beacon_module_priority", tonumber(event.item3))
      self:updateBeaconModules(event)
    end

    if event.action == "beacon-module-priority-apply" then
      local beacon_module_priority = User.getParameter("beacon_module_priority") or 1
      local priority_modules = User.getParameter("priority_modules")
      if beacon_module_priority ~= nil and priority_modules ~= nil and priority_modules[beacon_module_priority] ~= nil then
        ModelBuilder.setBeaconModulePriority(event.item1, event.item2, priority_modules[beacon_module_priority])
        ModelCompute.update()
        self:update(event)
        Controller:send("on_gui_refresh", event)
      end
    end

    if event.action == "beacon-module-select" then
      ModelBuilder.addBeaconModule(event.item1, event.item2, event.item3)
      ModelCompute.update()
      self:update(event)
      Controller:send("on_gui_refresh", event)
    end
    
    if event.action == "beacon-module-remove" then
      ModelBuilder.removeBeaconModule(event.item1, event.item2, event.item3)
      ModelCompute.update()
      self:update(event)
      Controller:send("on_gui_refresh", event)
    end
    
    if event.action == "beacon-select" then
      Model.setBeacon(event.item1, event.item2, event.item3)
      ModelCompute.update()
      self:update(event)
      Controller:send("on_gui_refresh", event)
    end

    if event.action == "beacon-update" then
      local options = {}
      local text = event.element.text
      -- item3 = "combo" or "factory"
      local ok , err = pcall(function()
        options[event.item3] = formula(text) or 0

        ModelBuilder.updateBeacon(event.item1, event.item2, options)
        ModelCompute.update()
        self:updateBeaconInfo(event)
        if display_height >= limit_display_height or User.getParameter("factory_tab") then
          self:updateFactoryInfo(event)
        end
        Controller:send("on_gui_refresh", event)
      end)
      if not(ok) then
        Player.print("Formula is not valid!")
      end
    end

    if event.action == "factory-switch-module" then
      local factory_switch_priority = event.element.switch_state == "right"
      User.setParameter("factory_switch_priority", factory_switch_priority)
      self:updateFactoryModules(event)
    end

    if event.action == "beacon-switch-module" then
      local beacon_switch_priority = event.element.switch_state == "right"
      User.setParameter("beacon_switch_priority", beacon_switch_priority)
      self:updateBeaconModules(event)
    end
  end
end

-------------------------------------------------------------------------------
-- On close dialog
--
-- @function [parent=#RecipeEdition] onClose
--
function RecipeEdition:onClose()
  User.setParameter(self.parameterLast,nil)
  User.setParameter("module_list_refresh",false)
end

-------------------------------------------------------------------------------
-- On open
--
-- @function [parent=#RecipeEdition] onOpen
--
-- @param #LuaEvent event
--
function RecipeEdition:onOpen(event)
  Logging:debug(self.classname, "onOpen()", event)
  local object = self:getObject()

  if User.getParameter("module_panel") == nil then
    User.setParameter("module_panel", true)
  end
  if User.getParameter("factory_tab") == nil then
    User.setParameter("factory_tab", true)
  end

end
-------------------------------------------------------------------------------
-- On update
--
-- @function [parent=#RecipeEdition] onUpdate
--
-- @param #LuaEvent event
--
function RecipeEdition:onUpdate(event)
  Logging:debug(self.classname, "onUpdate()", event)
  local object = self:getObject()
  -- header
  self:updateHeader(event)
  if object ~= nil then
    self:updateFactory(event)
    self:updateBeacon(event)
  end
end

-------------------------------------------------------------------------------
-- Update tab menu
--
-- @function [parent=#RecipeEdition] updateTabMenu
--
-- @param #LuaEvent event
--
function RecipeEdition:updateTabMenu(event)
  Logging:debug(self.classname, "updateTabMenu()", event)
  local tab_left_panel = self:getTabLeftPanel()
  local tab_right_panel = self:getTabRightPanel()
  local object = self:getObject()

  local display_width, display_height = GuiElement.getDisplaySizes()

  tab_left_panel.clear()
  tab_right_panel.clear()

  -- left tab
  if display_height < limit_display_height then
    local style = "helmod_button_tab"
    if User.getParameter("factory_tab") == true then style = "helmod_button_tab_selected" end

    GuiElement.add(tab_left_panel, GuiFrameH(self.classname, "separator_factory"):style(helmod_frame_style.tab)).style.width = 5
    GuiElement.add(tab_left_panel, GuiButton(self.classname, "edition-change-tab", event.item1, object.id, "factory"):style(style):caption({"helmod_common.factory"}):tooltip({"helmod_common.factory"}))

    local style = "helmod_button_tab"
    if User.getParameter("factory_tab") == false then style = "helmod_button_tab_selected" end

    GuiElement.add(tab_left_panel, GuiFrameH(self.classname, "separator_beacon"):style(helmod_frame_style.tab)).style.width = 5
    GuiElement.add(tab_left_panel, GuiButton(self.classname, "edition-change-tab", event.item1, object.id, "beacon"):style(style):caption({"helmod_common.beacon"}):tooltip({"helmod_common.beacon"}))

    GuiElement.add(tab_left_panel, GuiFrameH("tab_final"):style(helmod_frame_style.tab)).style.width = 100
  end
  -- right tab
  local style = "helmod_button_tab"
  if User.getParameter("module_panel") == false then style = "helmod_button_tab_selected" end

  GuiElement.add(tab_right_panel, GuiFrameH(self.classname, "separator_factory"):style(helmod_frame_style.tab)).style.width = 5
  GuiElement.add(tab_right_panel, GuiButton(self.classname, "change-panel", event.item1, object.id, "factory"):style(style):caption({"helmod_common.factory"}):tooltip({"tooltip.selector-factory"}))

  local style = "helmod_button_tab"
  if User.getParameter("module_panel") == true then style = "helmod_button_tab_selected" end

  GuiElement.addGuiFrameH(tab_right_panel, self.classname.."_separator_module",helmod_frame_style.tab).style.width = 5
  GuiElement.add(tab_right_panel, GuiButton(self.classname, "change-panel", event.item1, object.id, "module"):style(style):caption({"helmod_common.module"}):tooltip({"tooltip.selector-module"}))

  GuiElement.add(tab_right_panel, GuiFrameH("tab_final"):style(helmod_frame_style.tab)).style.width = 100
end

-------------------------------------------------------------------------------
-- Update factory
--
-- @function [parent=#RecipeEdition] updateFactory
--
-- @param #LuaEvent event
--
function RecipeEdition:updateFactory(event)
  Logging:debug(self.classname, "updateFactory()", event)

  self:updateFactoryInfo(event)
  self:updateFactoryModules(event)
end

-------------------------------------------------------------------------------
-- Update beacon
--
-- @function [parent=#RecipeEdition] updateBeacon
--
-- @param #LuaEvent event
--
function RecipeEdition:updateBeacon(event)
  Logging:debug(self.classname, "updateBeacon()", event)

  self:updateBeaconInfo(event)
  self:updateBeaconModules(event)
end

-------------------------------------------------------------------------------
-- Update information
--
-- @function [parent=#RecipeEdition] updateFactoryInfo
--
-- @param #LuaEvent event
--
function RecipeEdition:updateFactoryInfo(event)
  Logging:debug(self.classname, "updateFactoryInfo()", event)
  local factory_info_panel, factory_module_panel = self:getFactoryPanel()
  local element = User.getParameter("recipe_edition_object")
  local recipe = self:getObject()
  if element ~= nil and recipe ~= nil then
    local block_id = element.block
    local recipe_id = element.recipe
    Logging:debug(self.classname, "updateFactoryInfo():object:",recipe)
    local factory = recipe.factory
    local factory_prototype = EntityPrototype(factory)

    factory_info_panel.clear()
    GuiElement.add(factory_info_panel, GuiLabel("factory_label"):caption({"helmod_common.factory"}):style("helmod_label_title_frame"))

    -- factory tool
    local tool_action_panel = GuiElement.add(factory_info_panel, GuiFlowH("tool-action"))
    tool_action_panel.style.horizontal_spacing = 10
    tool_action_panel.style.bottom_padding = 10
    local tool_panel1 = GuiElement.add(tool_action_panel, GuiFlowH("tool1"))

    local default_factory = User.getDefaultFactory(recipe)
    local record_style = "helmod_button_menu_sm"
    if default_factory ~= nil and default_factory.name == factory.name  then record_style = "helmod_button_menu_sm_selected" end
    GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-tool", block_id, recipe_id, "default"):sprite("menu", "record-white-sm", "record-sm"):style(record_style):tooltip(GuiTooltipFactory("helmod_recipe-edition-panel.set-default"):element(default_factory)))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-tool", block_id, recipe_id, "block"):sprite("menu", "play-white-sm", "play-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipFactory("helmod_recipe-edition-panel.apply-block"):element(factory):tooltip("helmod_recipe-edition-panel.current-factory")))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-tool", block_id, recipe_id, "line"):sprite("menu", "end-white-sm", "end-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipFactory("helmod_recipe-edition-panel.apply-line"):element(factory):tooltip("helmod_recipe-edition-panel.current-factory")))

    local tool_panel2 = GuiElement.add(tool_action_panel, GuiFlowH("tool2"))
    local button_style = "helmod_button_small_bold"
    local selected_button_style = "helmod_button_small_bold_selected"
    local default_factory_mode = User.getParameter("default_factory_mode")
    local all_button_style = button_style
    local category_button_style = selected_button_style
    if default_factory_mode ~= "category" then
      all_button_style = selected_button_style
      category_button_style = button_style
    end
    GuiElement.add(tool_panel2, GuiButton(self.classname, "factory-tool", block_id, recipe_id, "all"):caption("A"):style(all_button_style):tooltip({"helmod_recipe-edition-panel.apply-option-all"}))
    GuiElement.add(tool_panel2, GuiButton(self.classname, "factory-tool", block_id, recipe_id, "category"):caption("C"):style(category_button_style):tooltip({"helmod_recipe-edition-panel.apply-option-category"}))
    local default_factory_with_module = User.getParameter("default_factory_with_module")
    local module_button_style = button_style
    if default_factory_with_module == true then module_button_style = selected_button_style end
    GuiElement.add(tool_panel2, GuiButton(self.classname, "factory-tool", block_id, recipe_id, "module"):caption("M"):style(module_button_style):tooltip({"helmod_recipe-edition-panel.apply-option-module"}))

    -- factory selection
    local scroll_panel = GuiElement.add(factory_info_panel, GuiScroll("factory-scroll"):policy(true))
    local recipe_prototype = RecipePrototype(recipe)
    local category = recipe_prototype:getCategory()
    local factories = Player.getProductionsCrafting(category, recipe)

    local factory_table_panel = GuiElement.add(scroll_panel, GuiTable("factory-table"):column(5))
    for key, element in pairs(factories) do
      local localised_name = EntityPrototype(element.name):getLocalisedName()
      local color = nil
      if factory.name == element.name then color = GuiElement.color_button_edit end
      GuiElement.add(factory_table_panel, GuiButtonSelectSprite(self.classname, "factory-select", block_id, recipe_id):sprite("entity", element.name):tooltip(localised_name):color(color))
    end

    -- factory info
    local header_panel = GuiElement.add(factory_info_panel, GuiTable("table-header"):column(2))
    if factory_prototype:native() == nil then
      GuiElement.add(header_panel, GuiLabel("label"):caption(factory.name))
    else
      GuiElement.add(header_panel, GuiLabel("label"):caption(factory_prototype:getLocalisedName()))
    end

    local input_panel = GuiElement.add(factory_info_panel, GuiTable("table-input"):column(2))
    input_panel.style.horizontal_spacing = 10

    GuiElement.add(input_panel, GuiLabel("label-module-slots"):caption({"helmod_label.module-slots"}))
    GuiElement.add(input_panel, GuiLabel("module-slots"):caption(factory_prototype:getModuleInventorySize()))

    GuiElement.add(input_panel, GuiLabel("label-energy"):caption({"helmod_label.energy"}))

    local sign = ""
    if factory.effects.consumption > 0 then sign = "+" end
    GuiElement.add(input_panel, GuiLabel("energy"):caption(Format.formatNumberKilo(factory.energy, "W").." ("..sign..Format.formatPercent(factory.effects.consumption).."%)"))
    if factory_prototype:getEnergyType() == "burner" then

      GuiElement.add(input_panel, GuiLabel("label-burner"):caption({"helmod_common.resource"}))
      local fuel_list = factory_prototype:getBurnerPrototype():getFuelItemPrototypes()
      local first_fuel = factory_prototype:getBurnerPrototype():getFirstFuelItemPrototype()
      local items = {}
      for _,item in pairs(fuel_list) do
        table.insert(items,"[item="..item.name.."]")
      end
      local default_fuel = "[item="..(factory.fuel or first_fuel.name).."]"
      GuiElement.add(input_panel, GuiDropDown(self.classname, "factory-fuel-update", block_id, recipe_id):items(items, default_fuel))
    end

    local sign = ""
    if factory.effects.speed > 0 then sign = "+" end
    GuiElement.add(input_panel, GuiLabel("label-speed"):caption({"helmod_label.speed"}))
    GuiElement.add(input_panel, GuiLabel("speed"):caption(Format.formatNumber(factory.speed).." ("..sign..Format.formatPercent(factory.effects.speed).."%)"))

    local sign = ""
    if factory.effects.productivity > 0 then sign = "+" end
    GuiElement.add(input_panel, GuiLabel("label-productivity"):caption({"helmod_label.productivity"}))
    
    local productivity_tooltip = nil
    if recipe.type == "resource" then
    --productivity_tooltip = ({"gui-bonus.mining-drill-productivity-bonus"})
    end
    GuiElement.add(input_panel, GuiLabel("productivity"):caption(sign..Format.formatPercent(factory.effects.productivity).."%"):tooltip(productivity_tooltip))

    GuiElement.add(input_panel, GuiLabel("label-pollution"):caption({"helmod_common.pollution"}))
    --GuiElement.add(input_panel, GuiLabel("pollution"):caption(factory_prototype:getPollution()))
    GuiElement.add(input_panel, GuiLabel("pollution"):caption({"helmod_si.per-minute", Format.formatNumberElement((factory.pollution or 0)*60)}))
    
    GuiElement.add(input_panel, GuiLabel("label-limit"):caption({"helmod_label.limit"}):tooltip({"tooltip.factory-limit"}))
    GuiElement.add(input_panel, GuiTextField(self.classname, "factory-update", block_id, recipe_id):text(factory.limit):tooltip({"tooltip.factory-limit"}))

  end
end

-------------------------------------------------------------------------------
-- Update modules information
--
-- @function [parent=#RecipeEdition] updateFactoryModules
--
-- @param #LuaEvent event
--
function RecipeEdition:updateFactoryModules(event)
  if not(self:isOpened()) then return end
  Logging:debug(self.classname, "updateFactoryModules()", event)
  local factory_info_panel, factory_module_panel, factory_tool_panel = self:getFactoryPanel()
  local element = User.getParameter("recipe_edition_object")
  local recipe = self:getObject()
  if element ~= nil and recipe ~= nil then
    local block_id = element.block
    local recipe_id = element.recipe
    local factory = recipe.factory

    factory_module_panel.clear()

    GuiElement.add(factory_module_panel, GuiLabel("module_label"):caption({"helmod_recipe-edition-panel.current-modules"}):style("helmod_label_title_frame"))

    -- module tool
    local tool_action_panel = GuiElement.add(factory_module_panel, GuiFlowH("tool-action"))
    tool_action_panel.style.horizontal_spacing = 10
    tool_action_panel.style.bottom_padding = 10
    local tool_panel1 = GuiElement.add(tool_action_panel, GuiFlowH("tool1"))
    local default_factory_module = User.getDefaultFactoryModule(recipe)
    local record_style = "helmod_button_menu_sm"
    Logging:debug(self.classname, "default_factory_module", default_factory_module, factory.module_priority)
    if compare_priority(default_factory_module, factory.module_priority) then record_style = "helmod_button_menu_sm_selected" end
    GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-module-tool", block_id, recipe_id, "default"):sprite("menu", "record-white-sm", "record-sm"):style(record_style):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.set-default"):element(default_factory_module)))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-module-tool", block_id, recipe_id, "block"):sprite("menu", "play-white-sm", "play-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.apply-block"):element(factory.module_priority):tooltip("helmod_recipe-edition-panel.current-module")))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-module-tool", block_id, recipe_id, "line"):sprite("menu", "end-white-sm", "end-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.apply-line"):element(factory.module_priority):tooltip("helmod_recipe-edition-panel.current-module")))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-module-tool", block_id, recipe_id, "erase"):sprite("menu", "erase-white-sm", "erase-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.module-clear"):element(factory.module_priority)))

    -- actived modules panel
    local module_table = GuiElement.add(factory_module_panel, GuiTable("modules"):column(6):style("helmod_table_recipe_modules"))
    for module, count in pairs(factory.modules) do
      for i = 1, count, 1 do
        local tooltip = GuiTooltipModule("tooltip.remove-module"):element({type="item", name=module})
        GuiElement.add(module_table, GuiButtonSelectSprite(self.classname, "factory-module-remove", block_id, recipe_id, module, i):sprite("item", module):tooltip(tooltip))
      end
    end

    local factory_switch_priority = User.getParameter("factory_switch_priority")
    local element_state = "left"
    if factory_switch_priority == true then element_state = "right" end
    local factory_switch_module = GuiElement.add(factory_module_panel, GuiSwitch(self.classname, "factory-switch-module", block_id, recipe_id):state(element_state):leftLabel({"helmod_recipe-edition-panel.selection-modules"}):rightLabel({"helmod_label.priority-modules"}))
    if factory_switch_priority == true then
      -- module priority
      self:updateFactoryModulesPriority(factory_module_panel)
    else
      -- module selector
      self:updateFactoryModulesSelector(factory_module_panel)
    end
  end
end

-------------------------------------------------------------------------------
-- Update modules priority
--
-- @function [parent=#RecipeEdition] updateFactoryModulesPriority
--
-- @param #LuaGuiElement factory_module_panel
-- @param #string block_id
-- @param #string recipe_id
--
function RecipeEdition:updateFactoryModulesPriority(factory_module_panel)
  local recipe = self:getObject()
  local element = User.getParameter("recipe_edition_object")
  local block_id = element.block
  local recipe_id = element.recipe
  -- module priority
  local factory_module_priority = User.getParameter("factory_module_priority") or 1
  local priority_modules = User.getParameter("priority_modules") or {}

  -- configuration select
  local tool_action_panel2 = GuiElement.add(factory_module_panel, GuiFlowH("tool-action2"))
  tool_action_panel2.style.horizontal_spacing = 10
  tool_action_panel2.style.bottom_padding = 10

  local tool_panel1 = GuiElement.add(tool_action_panel2, GuiFlowH("tool1"))
  local button_style = "helmod_button_small_bold"
  GuiElement.add(tool_panel1, GuiButton("HMPreferenceEdition", "OPEN", "priority_module"):sprite("menu", "services-white-sm", "services-sm"):style("helmod_button_menu_sm"):tooltip({"helmod_button.preferences"}))
  GuiElement.add(tool_panel1, GuiButton(self.classname, "factory-module-priority-apply", block_id, recipe_id):sprite("menu", "arrow-up-white-sm", "arrow-up-sm"):style("helmod_button_menu_sm"):tooltip({"helmod_recipe-edition-panel.apply-priority"}))

  local tool_panel2 = GuiElement.add(tool_action_panel2,  GuiTable("tool2"):column(6))
  for i, priority_module in pairs(priority_modules) do
    local button_style2 = button_style
    if factory_module_priority == i then button_style2 = "helmod_button_small_bold_selected" end
    GuiElement.add(tool_panel2, GuiButton(self.classname, "factory-module-priority-select", block_id, recipe_id, i):caption(i):style(button_style2))
  end

  -- module priority info
  local priority_table_panel = GuiElement.add(factory_module_panel, GuiTable("module-priority-table"):column(2))
  if priority_modules[factory_module_priority] ~= nil then
    Logging:debug(self.classname, "priority_modules", priority_modules, factory_module_priority)
    for index, element in pairs(priority_modules[factory_module_priority]) do
      local color = nil
      local module = ItemPrototype(element.name)
      local tooltip = GuiTooltipModule("tooltip.add-module"):element({type="item", name=element.name})
      if Player.checkFactoryLimitationModule(module:native(), recipe) == false then
        if module.limitation_message_key ~= nil then
          tooltip = {"item-limitation."..module.limitation_message_key}
        else
          tooltip = {"item-limitation.production-module-usable-only-on-intermediates"}
        end
        color = GuiElement.color_button_rest
      end
      GuiElement.add(priority_table_panel, GuiButtonSelectSprite(self.classname, "factory-module-select", block_id, recipe_id):sprite("entity", element.name):color(color):index(index):tooltip(tooltip))
      GuiElement.add(priority_table_panel, GuiLabel("priority-value", index):caption(element.value))
    end
  end
end

-------------------------------------------------------------------------------
-- Update modules selector
--
-- @function [parent=#RecipeEdition] updateFactoryModulesSelector
--
-- @param #LuaGuiElement factory_module_panel
-- @param #string block_id
-- @param #string recipe_id
--
function RecipeEdition:updateFactoryModulesSelector(factory_module_panel)
  local recipe = self:getObject()
  local element = User.getParameter("recipe_edition_object")
  local block_id = element.block
  local recipe_id = element.recipe
  local module_scroll = GuiElement.add(factory_module_panel, GuiScroll("module-selector-scroll"))
  module_scroll.style.maximal_height = 118
  local module_table_panel = GuiElement.add(module_scroll, GuiTable("module-selector-table"):column(6))
  for k, element in pairs(Player.getModules()) do
    local color = nil
    local tooltip = GuiTooltipModule("tooltip.add-module"):element({type="item", name=element.name})
    local module = ItemPrototype(element.name)
    if Player.checkFactoryLimitationModule(module:native(), recipe) == false then
      if module.limitation_message_key ~= nil then
        tooltip = {"item-limitation."..module.limitation_message_key}
      else
        tooltip = {"item-limitation.production-module-usable-only-on-intermediates"}
      end
      color = GuiElement.color_button_rest
    end
    GuiElement.add(module_table_panel, GuiButtonSelectSprite(self.classname, "factory-module-select", block_id, recipe_id):sprite("entity", element.name):color(color):tooltip(tooltip))
  end
end

-------------------------------------------------------------------------------
-- Update information
--
-- @function [parent=#RecipeEdition] updateBeaconInfo
--
-- @param #LuaEvent event
--
function RecipeEdition:updateBeaconInfo(event)
  Logging:debug(self.classname, "updateBeaconInfo()", event)
  local beacon_info_panel, beacon_module_panel = self:getBeaconPanel()
  local element = User.getParameter("recipe_edition_object")
  local recipe = self:getObject()
  if element ~= nil and recipe ~= nil then
    local block_id = element.block
    local recipe_id = element.recipe
    local beacon = recipe.beacon
    local beacon_prototype = EntityPrototype(beacon)

    beacon_info_panel.clear()
    GuiElement.add(beacon_info_panel, GuiLabel("beacon_label"):caption({"helmod_common.beacon"}):style("helmod_label_title_frame"))
    -- factory tool
    local tool_action_panel = GuiElement.add(beacon_info_panel, GuiFlowH("tool-action"))
    tool_action_panel.style.horizontal_spacing = 10
    tool_action_panel.style.bottom_padding = 10
    local tool_panel1 = GuiElement.add(tool_action_panel, GuiFlowH("tool1"))

    local default_beacon = User.getDefaultBeacon(recipe)
    local record_style = "helmod_button_menu_sm"
    if default_beacon ~= nil and default_beacon.name == beacon.name  then record_style = "helmod_button_menu_sm_selected" end
    GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-tool", block_id, recipe_id, "default"):sprite("menu", "record-white-sm", "record-sm"):style(record_style):tooltip(GuiTooltipFactory("helmod_recipe-edition-panel.set-default"):element(default_beacon)))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-tool", block_id, recipe_id, "block"):sprite("menu", "play-white-sm", "play-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipFactory("helmod_recipe-edition-panel.apply-block"):element(beacon):tooltip("helmod_recipe-edition-panel.current-beacon")))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-tool", block_id, recipe_id, "line"):sprite("menu", "end-white-sm", "end-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipFactory("helmod_recipe-edition-panel.apply-line"):element(beacon):tooltip("helmod_recipe-edition-panel.current-beacon")))

    local tool_panel2 = GuiElement.add(tool_action_panel, GuiFlowH("tool2"))
    local button_style = "helmod_button_small_bold"
    local selected_button_style = "helmod_button_small_bold_selected"
    local default_beacon_mode = User.getParameter("default_beacon_mode")
    local all_button_style = button_style
    local category_button_style = selected_button_style
    if default_beacon_mode ~= "category" then
      all_button_style = selected_button_style
      category_button_style = button_style
    end
    GuiElement.add(tool_panel2, GuiButton(self.classname, "beacon-tool", block_id, recipe_id, "all"):caption("A"):style(all_button_style):tooltip({"helmod_recipe-edition-panel.apply-option-all"}))
    GuiElement.add(tool_panel2, GuiButton(self.classname, "beacon-tool", block_id, recipe_id, "category"):caption("C"):style(category_button_style):tooltip({"helmod_recipe-edition-panel.apply-option-category"}))
    local default_beacon_with_module = User.getParameter("default_beacon_with_module")
    local module_button_style = button_style
    if default_beacon_with_module == true then module_button_style = selected_button_style end
    GuiElement.add(tool_panel2, GuiButton(self.classname, "beacon-tool", block_id, recipe_id, "module"):caption("M"):style(module_button_style):tooltip({"helmod_recipe-edition-panel.apply-option-module"}))

    -- factory selection
    local scroll_panel = GuiElement.add(beacon_info_panel, GuiScroll("beacon-scroll"):policy(true))
    local factories = Player.getProductionsBeacon()

    local factory_table_panel = GuiElement.add(scroll_panel, GuiTable("beacon-table"):column(5))
    for key, element in pairs(factories) do
      local localised_name = EntityPrototype(element.name):getLocalisedName()
      local color = nil
      if beacon.name == element.name then color = GuiElement.color_button_edit end
      GuiElement.add(factory_table_panel, GuiButtonSelectSprite(self.classname, "beacon-select", block_id, recipe_id):sprite("entity", element.name):tooltip(localised_name):color(color))
    end

    -- beacon info
    local header_panel = GuiElement.add(beacon_info_panel, GuiTable("table-header"):column(2))
    if beacon_prototype:native() == nil then
      GuiElement.add(header_panel, GuiLabel("label"):caption(beacon.name))
    else
      GuiElement.add(header_panel, GuiLabel("label"):caption(beacon_prototype:getLocalisedName()))
    end

    local input_panel = GuiElement.add(beacon_info_panel, GuiTable("table-input"):column(2))

    GuiElement.add(input_panel, GuiLabel("label-module-slots"):caption({"helmod_label.module-slots"}))
    GuiElement.add(input_panel, GuiLabel("module-slots"):caption(beacon_prototype:getModuleInventorySize()))

    GuiElement.add(input_panel, GuiLabel("label-energy-nominal"):caption({"helmod_label.energy"}))
    GuiElement.add(input_panel, GuiLabel("energy"):caption(Format.formatNumberKilo(beacon_prototype:getEnergyUsage(), "W")))

    GuiElement.add(input_panel, GuiLabel("label-efficiency"):caption({"helmod_label.efficiency"}))
    GuiElement.add(input_panel, GuiLabel("efficiency"):caption(beacon_prototype:getDistributionEffectivity()))

    GuiElement.add(input_panel, GuiLabel("label-combo"):caption({"helmod_label.beacon-on-factory"}):tooltip({"tooltip.beacon-on-factory"}))
    GuiElement.add(input_panel, GuiTextField(self.classname, "beacon-update", block_id, recipe_id, "combo"):text(beacon.combo):style("helmod_textfield"):tooltip({"tooltip.beacon-on-factory"}))

    GuiElement.add(input_panel, GuiLabel("label-factory"):caption({"helmod_label.factory-per-beacon"}):tooltip({"tooltip.factory-per-beacon"}))
    GuiElement.add(input_panel, GuiTextField(self.classname, "beacon-update", block_id, recipe_id, "factory"):text(beacon.factory):style("helmod_textfield"):tooltip({"tooltip.factory-per-beacon"}))
  end
end

-------------------------------------------------------------------------------
-- Update modules information
--
-- @function [parent=#RecipeEdition] updateBeaconModules
--
-- @param #LuaEvent event
--
function RecipeEdition:updateBeaconModules(event)
  if not(self:isOpened()) then return end
  Logging:debug(self.classname, "updateBeaconActivedModules()", event)
  local beacon_info_panel, beacon_module_panel = self:getBeaconPanel()
  local element = User.getParameter("recipe_edition_object")
  local recipe = self:getObject()
  if element ~= nil and recipe ~= nil then
    local block_id = element.block
    local recipe_id = element.recipe
    local beacon = recipe.beacon

    beacon_module_panel.clear()

    GuiElement.add(beacon_module_panel, GuiLabel("module_label"):caption({"helmod_recipe-edition-panel.current-modules"}):style("helmod_label_title_frame"))

    -- module tool
    local tool_action_panel = GuiElement.add(beacon_module_panel, GuiFlowH("tool-action"))
    tool_action_panel.style.horizontal_spacing = 10
    tool_action_panel.style.bottom_padding = 10
    local tool_panel1 = GuiElement.add(tool_action_panel, GuiFlowH("tool1"))
    local default_beacon_module = User.getDefaultBeaconModule(recipe)
    local record_style = "helmod_button_menu_sm"
    Logging:debug(self.classname, "default_factory_module", default_beacon_module, beacon.module_priority)
    if compare_priority(default_beacon_module, beacon.module_priority) then record_style = "helmod_button_menu_sm_selected" end
    GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-module-tool", block_id, recipe_id, "default"):sprite("menu", "record-white-sm", "record-sm"):style(record_style):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.set-default"):element(default_beacon_module)))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-module-tool", block_id, recipe_id, "block"):sprite("menu", "play-white-sm", "play-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.apply-block"):element(beacon.module_priority):tooltip("helmod_recipe-edition-panel.current-module")))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-module-tool", block_id, recipe_id, "line"):sprite("menu", "end-white-sm", "end-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.apply-line"):element(beacon.module_priority):tooltip("helmod_recipe-edition-panel.current-module")))
    GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-module-tool", block_id, recipe_id, "erase"):sprite("menu", "erase-white-sm", "erase-sm"):style("helmod_button_menu_sm"):tooltip(GuiTooltipPriority("helmod_recipe-edition-panel.module-clear"):element(beacon.module_priority)))

    -- actived modules panel
    local module_table = GuiElement.add(beacon_module_panel, GuiTable("modules"):column(6):style("helmod_table_recipe_modules"))
    for module, count in pairs(beacon.modules) do
      for i = 1, count, 1 do
        local tooltip = GuiTooltipModule("tooltip.remove-module"):element({type="item", name=module})
        GuiElement.add(module_table, GuiButtonSelectSprite(self.classname, "beacon-module-remove", block_id, recipe_id, module, i):sprite("item", module):tooltip(tooltip))
      end
    end

    local beacon_switch_priority = User.getParameter("beacon_switch_priority")
    local element_state = "left"
    if beacon_switch_priority == true then element_state = "right" end
    local factory_switch_module = GuiElement.add(beacon_module_panel, GuiSwitch(self.classname, "beacon-switch-module", block_id, recipe_id):state(element_state):leftLabel({"helmod_recipe-edition-panel.selection-modules"}):rightLabel({"helmod_label.priority-modules"}))
    if beacon_switch_priority == true then
      -- module priority
      self:updateBeaconModulesPriority(beacon_module_panel)
    else
      -- module selector
      self:updateBeaconModulesSelector(beacon_module_panel)
    end
  end
end

-------------------------------------------------------------------------------
-- Update modules priority
--
-- @function [parent=#RecipeEdition] updateBeaconModulesPriority
--
-- @param #LuaGuiElement beacon_module_panel
-- @param #string block_id
-- @param #string recipe_id
--
function RecipeEdition:updateBeaconModulesPriority(beacon_module_panel)
  local recipe = self:getObject()
  local element = User.getParameter("recipe_edition_object")
  local block_id = element.block
  local recipe_id = element.recipe
  -- module priority
  local beacon_module_priority = User.getParameter("beacon_module_priority") or 1
  local priority_modules = User.getParameter("priority_modules") or {}

  -- configuration select
  local tool_action_panel2 = GuiElement.add(beacon_module_panel, GuiFlowH("tool-action2"))
  tool_action_panel2.style.horizontal_spacing = 10
  tool_action_panel2.style.bottom_padding = 10

  local tool_panel1 = GuiElement.add(tool_action_panel2, GuiFlowH("tool1"))
  local button_style = "helmod_button_small_bold"
  GuiElement.add(tool_panel1, GuiButton("HMPreferenceEdition", "OPEN", "priority_module"):sprite("menu", "services-white-sm", "services-sm"):style("helmod_button_menu_sm"):tooltip({"helmod_button.preferences"}))
  GuiElement.add(tool_panel1, GuiButton(self.classname, "beacon-module-priority-apply", block_id, recipe_id):sprite("menu", "arrow-up-white-sm", "arrow-up-sm"):style("helmod_button_menu_sm"):tooltip({"helmod_recipe-edition-panel.apply-priority"}))

  local tool_panel2 = GuiElement.add(tool_action_panel2,  GuiTable("tool2"):column(6))
  for i, priority_module in pairs(priority_modules) do
    local button_style2 = button_style
    if beacon_module_priority == i then button_style2 = "helmod_button_small_bold_selected" end
    GuiElement.add(tool_panel2, GuiButton(self.classname, "beacon-module-priority-select", block_id, recipe_id, i):caption(i):style(button_style2))
  end

  -- module priority info
  local priority_table_panel = GuiElement.add(beacon_module_panel, GuiTable("module-priority-table"):column(2))
  if priority_modules[beacon_module_priority] ~= nil then
    Logging:debug(self.classname, "priority_modules", priority_modules, beacon_module_priority)
    for index, element in pairs(priority_modules[beacon_module_priority]) do
      local color = nil
      local tooltip = GuiTooltipModule("tooltip.add-module"):element({type="item", name=element.name})
      local module = ItemPrototype(element.name)
      if Player.checkBeaconLimitationModule(module:native(), recipe) == false then
        if module.limitation_message_key ~= nil then
          tooltip = {"item-limitation."..module.limitation_message_key}
        else
          tooltip = {"item-limitation.production-module-usable-only-on-intermediates"}
        end
        color = GuiElement.color_button_rest
      end
      GuiElement.add(priority_table_panel, GuiButtonSelectSprite(self.classname, "beacon-module-select", block_id, recipe_id):sprite("entity", element.name):color(color):index(index):tooltip(tooltip))
      GuiElement.add(priority_table_panel, GuiLabel("priority-value", index):caption(element.value))
    end
  end
end

-------------------------------------------------------------------------------
-- Update modules selector
--
-- @function [parent=#RecipeEdition] updateBeaconModulesSelector
--
-- @param #LuaGuiElement beacon_module_panel
-- @param #string block_id
-- @param #string recipe_id
--
function RecipeEdition:updateBeaconModulesSelector(beacon_module_panel)
  local recipe = self:getObject()
  local element = User.getParameter("recipe_edition_object")
  local block_id = element.block
  local recipe_id = element.recipe
  local module_scroll = GuiElement.add(beacon_module_panel, GuiScroll("module-selector-scroll"))
  module_scroll.style.maximal_height = 118
  local module_table_panel = GuiElement.add(module_scroll, GuiTable("module-selector-table"):column(6))
  for k, element in pairs(Player.getModules()) do
    local color = nil
    local tooltip = GuiTooltipModule("tooltip.add-module"):element({type="item", name=element.name})
    local module = ItemPrototype(element.name)
    if Player.checkFactoryLimitationModule(module:native(), recipe) == false then
      if module.limitation_message_key ~= nil then
        tooltip = {"item-limitation."..module.limitation_message_key}
      else
        tooltip = {"item-limitation.production-module-usable-only-on-intermediates"}
      end
      color = GuiElement.color_button_rest
    end
    GuiElement.add(module_table_panel, GuiButtonSelectSprite(self.classname, "beacon-module-select", block_id, recipe_id):sprite("entity", element.name):color(color):tooltip(tooltip))
  end
end

-------------------------------------------------------------------------------
-- Update header
--
-- @function [parent=#RecipeEdition] updateHeader
--
-- @param #LuaEvent event
--
function RecipeEdition:updateHeader(event)
  Logging:debug(self.classname, "updateHeader()", event)
  self:updateObjectInfo(event)
end

-------------------------------------------------------------------------------
-- Update information
--
-- @function [parent=#RecipeEdition] updateObjectInfo
--
-- @param #LuaEvent event
--
function RecipeEdition:updateObjectInfo(event)
  Logging:debug(self.classname, "updateObjectInfo()", event)
  local info_panel = self:getObjectInfoPanel()
  local model = Model.getModel()
  local element = User.getParameter("recipe_edition_object")
  local recipe = self:getObject()
  if element ~= nil and recipe ~= nil then
    local block_id = element.block
    local recipe_id = element.recipe
    Logging:debug(self.classname, "updateObjectInfo():recipe=",recipe)
    info_panel.clear()

    local recipe_prototype = RecipePrototype(recipe)
    local recipe_table = GuiElement.add(info_panel, GuiTable("list-data"):column(4))
    recipe_table.style.horizontally_stretchable = false
    recipe_table.style.horizontal_spacing = 10
    recipe_table.vertical_centering = false

    GuiElement.add(recipe_table, GuiLabel("header-recipe"):caption({"helmod_result-panel.col-header-recipe"}))
    GuiElement.add(recipe_table, GuiLabel("header-energy"):caption({"helmod_result-panel.col-header-energy"}))
    GuiElement.add(recipe_table, GuiLabel("header-products"):caption({"helmod_result-panel.col-header-products"}))
    GuiElement.add(recipe_table, GuiLabel("header-ingredients"):caption({"helmod_result-panel.col-header-ingredients"}))
    local cell_recipe = GuiElement.add(recipe_table, GuiFrameH("recipe", recipe.id):style(helmod_frame_style.hidden))
    GuiElement.add(cell_recipe, GuiCellRecipe(self.classname, "do_noting"):element(recipe):tooltip("helmod_common.recipe"):color("gray"))


    -- energy
    local cell_energy = GuiElement.add(recipe_table, GuiFrameH("energy", recipe.id):style(helmod_frame_style.hidden))
    local element_energy = {name = "helmod_button_menu_flat", hovered = "clock-white", sprite = "clock" , count = recipe_prototype:getEnergy(),localised_name = "helmod_label.energy"}
    GuiElement.add(cell_energy, GuiCellProduct(self.classname, "do_noting"):element(element_energy):tooltip("tooltip.product"):color("gray"))

    -- products
    local cell_products = GuiElement.add(recipe_table, GuiTable("products", recipe.id):column(3):style("helmod_table_element"))
    if recipe_prototype:getProducts() ~= nil then
      for index, lua_product in pairs(recipe_prototype:getProducts()) do
        local product_prototype = Product(lua_product)
        local product = product_prototype:clone()
        product.count = product_prototype:getElementAmount()
        GuiElement.add(cell_products, GuiCellProductSm(self.classname, "do_noting"):element(product):tooltip("tooltip.product"):index(index):color(GuiElement.color_button_none))
      end
    end

    -- ingredients
    local cell_ingredients = GuiElement.add(recipe_table, GuiTable("ingredients_"..recipe.id, recipe.id):column(5):style("helmod_table_element"))
    if recipe_prototype:getIngredients() ~= nil then
      for index, lua_ingredient in pairs(recipe_prototype:getIngredients(recipe.factory)) do
        local ingredient_prototype = Product(lua_ingredient)
        local ingredient = ingredient_prototype:clone()
        ingredient.count = ingredient_prototype:getElementAmount()
        GuiElement.add(cell_ingredients, GuiCellProductSm(self.classname, "do_noting"):element(ingredient):tooltip("tooltip.product"):index(index):color(GuiElement.color_button_add))
      end
    end

    local tablePanel = GuiElement.add(info_panel, GuiTable("table-input"):column(3))
    GuiElement.add(tablePanel, GuiLabel("label-production"):caption({"helmod_recipe-edition-panel.production"}))
    GuiElement.add(tablePanel, GuiTextField(self.classname, "object-update", event.item1, recipe.id):text((recipe.production or 1)*100):style("helmod_textfield"))

  end
end
