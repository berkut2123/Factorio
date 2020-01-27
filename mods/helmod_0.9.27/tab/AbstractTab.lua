-------------------------------------------------------------------------------
-- Class to build tab
--
-- @module AbstractTab
--

AbstractTab = newclass(Form,function(base,classname)
  Form.init(base,classname)
end)

-------------------------------------------------------------------------------
-- On Bind Dispatcher
--
-- @function [parent=#AbstractTab] onBind
--
function AbstractTab:onBind()
  Dispatcher:bind("on_gui_refresh", self, self.update)
  Dispatcher:bind("on_gui_pause", self, self.updateTopMenu)
end

-------------------------------------------------------------------------------
-- On initialization
--
-- @function [parent=#AbstractTab] onInit
--
function AbstractTab:onInit()
  self.panelCaption = string.format("%s %s","Helmod",game.active_mods["helmod"])
end

-------------------------------------------------------------------------------
-- Get Button Sprites
--
-- @function [parent=#AbstractTab] getButtonSprites
--
-- @return boolean
--
function AbstractTab:getButtonSprites()
  return "help-white","help"
end

-------------------------------------------------------------------------------
-- Get panel name
--
-- @function [parent=#AbstractTab] getPanelName
--
-- @return #LuaGuiElement
--
function AbstractTab:getPanelName()
  return "HMTab"
end

-------------------------------------------------------------------------------
-- Get or create index panel
--
-- @function [parent=#AbstractTab] getIndexPanel
--
function AbstractTab:getIndexPanel()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  local panel_name = "index_panel"
  if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
    return content_panel[panel_name]["table_index"]
  end
  local panel = GuiElement.add(content_panel, GuiFrameH(panel_name):style(helmod_frame_style.panel))
  panel.style.horizontally_stretchable = true
  local table_index = GuiElement.add(panel, GuiTable("table_index"):column(GuiElement.getIndexColumnNumber()):style(helmod_table_style.list))
  return table_index
end

-------------------------------------------------------------------------------
-- Get or create model panel
--
-- @function [parent=#AbstractTab] getDebugPanel
--
function AbstractTab:getDebugPanel()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  local panel_name = "debug_panel"
  if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
    return content_panel[panel_name]
  end
  local panel = GuiElement.add(content_panel, GuiFrameH(panel_name):style(helmod_frame_style.panel):caption("Debug"))
  return panel
end

-------------------------------------------------------------------------------
-- Get or create info panel
--
-- @function [parent=#AbstractTab] getInfoPanel
--
function AbstractTab:getInfoPanel()
  local parent_panel = self:getResultPanel()
  local panel_name = "info"
  if parent_panel[panel_name] ~= nil and parent_panel[panel_name].valid then
    return parent_panel[panel_name]["info"]["info-scroll"],parent_panel[panel_name]["output"]["output-scroll"],parent_panel[panel_name]["input"]["input-scroll"]
  end
  local panel = GuiElement.add(parent_panel, GuiFlowH(panel_name))
  panel.style.horizontally_stretchable = true
  panel.style.horizontal_spacing=10
  GuiElement.setStyle(panel, "block_info", "height")

  local info_panel = GuiElement.add(panel, GuiFlowV("info"))
  GuiElement.add(info_panel, GuiLabel("label-info"):caption({"helmod_common.information"}):style("helmod_label_title_frame"))
  GuiElement.setStyle(info_panel, "block_info", "width")
  local info_scroll = GuiElement.add(info_panel, GuiScroll("info-scroll"):style(helmod_frame_style.scroll_pane))
  info_scroll.style.horizontally_stretchable = true

  local output_panel = GuiElement.add(panel, GuiFlowV("output"))
  GuiElement.add(output_panel, GuiLabel("label-info"):caption({"helmod_common.output"}):style("helmod_label_title_frame"))
  GuiElement.setStyle(output_panel, "block_info", "height")
  local output_scroll = GuiElement.add(output_panel, GuiScroll("output-scroll"):style(helmod_frame_style.scroll_pane))


  local input_panel = GuiElement.add(panel, GuiFlowV("input"))
  GuiElement.add(input_panel, GuiLabel("label-info"):caption({"helmod_common.input"}):style("helmod_label_title_frame"))
  GuiElement.setStyle(input_panel, "block_info", "height")
  local input_scroll = GuiElement.add(input_panel, GuiScroll("input-scroll"):style(helmod_frame_style.scroll_pane))
  return info_scroll, output_scroll, input_scroll
end

-------------------------------------------------------------------------------
-- Get or create info panel
--
-- @function [parent=#AbstractTab] getInfoPanel2
--
function AbstractTab:getInfoPanel2()
  local _,parent_panel = self:getResultPanel2()
  local panel_name = "info"
  if parent_panel[panel_name] ~= nil and parent_panel[panel_name].valid then
    return parent_panel[panel_name]["options"]["options-scroll"],parent_panel[panel_name]["info"]["info-scroll"],parent_panel[panel_name]["left-info"],parent_panel[panel_name]["right-info"]
  end
  local panel = GuiElement.add(parent_panel, GuiFlowH(panel_name))
  panel.style.horizontally_stretchable = true
  panel.style.horizontal_spacing=10
  GuiElement.setStyle(panel, "block_info", "height")

  local options_panel = GuiElement.add(panel, GuiFlowV("options"))
  GuiElement.add(options_panel, GuiLabel("label-info"):caption({"helmod_button.options"}):style("helmod_label_title_frame"))
  local options_scroll = GuiElement.add(options_panel, GuiScroll("options-scroll"):style(helmod_frame_style.scroll_pane))

  local info_panel = GuiElement.add(panel, GuiFlowV("info"))
  GuiElement.add(info_panel, GuiLabel("label-info"):caption({"helmod_common.information"}):style("helmod_label_title_frame"))
  local info_scroll = GuiElement.add(info_panel, GuiScroll("info-scroll"):style(helmod_frame_style.scroll_pane))

  local left_panel = GuiElement.add(panel, GuiFlowV("left-info"))
  GuiElement.setStyle(left_panel, "block_info", "height")

  local right_panel = GuiElement.add(panel, GuiFlowV("right-info"))
  GuiElement.setStyle(right_panel, "block_info", "height")

  return options_scroll, info_scroll, left_panel, right_panel
end

-------------------------------------------------------------------------------
-- Get or create info panel
--
-- @function [parent=#AbstractTab] getInfoPanel3
--
function AbstractTab:getInfoPanel3()
  local parent_panel = self:getResultPanel()
  local panel_name = "info"
  if parent_panel[panel_name] ~= nil and parent_panel[panel_name].valid then
    return parent_panel[panel_name]["info"]["info-scroll"],parent_panel[panel_name]["output"]["output-scroll"],parent_panel[panel_name]["input"]["input-scroll"]
  end
  local panel = GuiElement.add(parent_panel, GuiFlowH(panel_name))
  panel.style.horizontally_stretchable = true
  panel.style.horizontal_spacing=10
  return panel
end

-------------------------------------------------------------------------------
-- Get or create left info panel
--
-- @function [parent=#AbstractTab] getLeftInfoPanel2
--
function AbstractTab:getLeftInfoPanel2()
  local _, _, parent_panel, _ = self:getInfoPanel2()
  local panel_name = "left-scroll"
  local header_name = "left-header"
  local label_name = "left-label"
  local tool_name = "left-tool"
  if parent_panel[panel_name] ~= nil and parent_panel[panel_name].valid then
    return parent_panel[header_name][label_name], parent_panel[header_name][tool_name], parent_panel[panel_name]
  end
  local header_panel = GuiElement.add(parent_panel, GuiFlowH(header_name))
  local label_panel = GuiElement.add(header_panel, GuiLabel(label_name):caption({"helmod_common.output"}):style("helmod_label_title_frame"))
  local tool_panel = GuiElement.add(header_panel, GuiFlowH(tool_name))
  --tool_panel.style.horizontally_stretchable = true
  --tool_panel.style.horizontal_align = "right"
  local scroll_panel = GuiElement.add(parent_panel, GuiScroll(panel_name):style(helmod_frame_style.scroll_pane))
  scroll_panel.style.horizontally_stretchable = true

  return label_panel, tool_panel, scroll_panel
end

-------------------------------------------------------------------------------
-- Get or create right info panel
--
-- @function [parent=#AbstractTab] getRightInfoPanel2
--
function AbstractTab:getRightInfoPanel2()
  local _, _,  _, parent_panel = self:getInfoPanel2()
  local panel_name = "right-scroll"
  local header_name = "right-header"
  local label_name = "right-label"
  local tool_name = "right-tool"
  if parent_panel[panel_name] ~= nil and parent_panel[panel_name].valid then
    return parent_panel[header_name][label_name], parent_panel[header_name][tool_name], parent_panel[panel_name]
  end
  local header_panel = GuiElement.add(parent_panel, GuiFlowH(header_name))
  local label_panel = GuiElement.add(header_panel, GuiLabel(label_name):caption({"helmod_common.input"}):style("helmod_label_title_frame"))
  local tool_panel = GuiElement.add(header_panel, GuiFlowH(tool_name))
  --tool_panel.style.horizontally_stretchable = true
  --tool_panel.style.horizontal_align = "right"
  local scroll_panel = GuiElement.add(parent_panel, GuiScroll(panel_name):style(helmod_frame_style.scroll_pane))
  scroll_panel.style.horizontally_stretchable = true

  return label_panel, tool_panel, scroll_panel
end

-------------------------------------------------------------------------------
-- Get or create result panel
--
-- @function [parent=#AbstractTab] getResultPanel
--
function AbstractTab:getResultPanel()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  local panel_name = "result"
  if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
    return content_panel[panel_name]
  end
  local panel = GuiElement.add(content_panel, GuiFrameV(panel_name):caption(self:getButtonCaption()))
  panel.style.horizontally_stretchable = true
  panel.style.vertically_stretchable = true
  return panel
end

-------------------------------------------------------------------------------
-- Get or create result panel
--
-- @function [parent=#AbstractTab] getResultPanel2
--
function AbstractTab:getResultPanel2()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  local panel_name = "result2"
  if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
    return content_panel[panel_name]["result1"],content_panel[panel_name]["result2"]
  end
  local panel = GuiElement.add(content_panel, GuiTable(panel_name):column(2):style(helmod_table_style.panel))
  panel.style.horizontally_stretchable = true
  panel.style.vertically_stretchable = true

  local panel1 = GuiElement.add(panel, GuiFrameV("result1"))
  local panel2 = GuiElement.add(panel, GuiFrameV("result2"):caption(self:getButtonCaption()))
  panel2.style.horizontally_stretchable = true
  panel2.style.vertically_stretchable = true
  return panel1,panel2
end

-------------------------------------------------------------------------------
-- Get or create result scroll panel
--
-- @function [parent=#AbstractTab] getResultScrollPanel
--
function AbstractTab:getResultScrollPanel()
  local parent_panel = self:getResultPanel()
  if parent_panel["scroll-data"] ~= nil and parent_panel["scroll-data"].valid then
    return parent_panel["scroll-data"]
  end
  local scroll_panel = GuiElement.add(parent_panel, GuiScroll("scroll-data"):style(helmod_frame_style.scroll_pane))
  scroll_panel.style.horizontally_stretchable = true
  scroll_panel.style.vertically_stretchable = true
  return scroll_panel
end

-------------------------------------------------------------------------------
-- Get or create result scroll panel
--
-- @function [parent=#AbstractTab] getResultScrollPanel2
--
function AbstractTab:getResultScrollPanel2()
  local parent_panel1,parent_panel2 = self:getResultPanel2()
  if parent_panel1["header-data1"] ~= nil and parent_panel1["header-data1"].valid then
    return parent_panel1["header-data1"],parent_panel2["header-data2"],parent_panel1["scroll-data1"],parent_panel2["scroll-data2"]
  end
  local header_panel1 = GuiElement.add(parent_panel1, GuiFlowV("header-data1"))
  local header_panel2 = GuiElement.add(parent_panel2, GuiFlowV("header-data2"))
  local scroll_panel1 = GuiElement.add(parent_panel1, GuiScroll("scroll-data1"):style(helmod_frame_style.scroll_pane))
  --scroll_panel1.style.horizontally_stretchable = true
  scroll_panel1.style.vertically_stretchable = true
  scroll_panel1.style.width = 70
  local scroll_panel2 = GuiElement.add(parent_panel2, GuiScroll("scroll-data2"):style(helmod_frame_style.scroll_pane))
  scroll_panel2.style.horizontally_stretchable = true
  scroll_panel2.style.vertically_stretchable = true
  return header_panel1,header_panel2,scroll_panel1,scroll_panel2
end

-------------------------------------------------------------------------------
-- Update
--
-- @function [parent=#AbstractTab] onUpdate
--
-- @param #LuaEvent event
--
function AbstractTab:onUpdate(event)
  Logging:debug(self.classname, "update()", event)
  self:beforeUpdate(event)
  self:updateMenuPanel(event)
  self:updateIndexPanel(event)

  self:updateHeader(event)
  self:updateData(event)

  Logging:debug(self.classname, "debug_mode", User.getModGlobalSetting("debug"))
  if User.getModGlobalSetting("debug") ~= "none" then
    self:updateDebugPanel()
  end

end

-------------------------------------------------------------------------------
-- Update menu panel
--
-- @function [parent=#AbstractTab] updateMenuPanel
--
-- @param #LuaEvent event
--
function AbstractTab:updateMenuPanel(event)
  Logging:debug(self.classname, "updateMenuPanel()", event)
  local models = Model.getModels()
  local model = Model.getModel()
  local model_id = User.getParameter("model_id")
  local current_block = User.getParameter("current_block")

  -- action panel
  local action_panel = self:getLeftMenuPanel()
  action_panel.clear()

  local group4 = GuiElement.add(action_panel, GuiFlowH("group4"))
  for _, form in pairs(Controller.getViews()) do
    if string.find(form.classname, "Tab") and form:isVisible() and not(form:isSpecial()) then
      local icon_hovered, icon = form:getButtonSprites()
      local style = "helmod_button_menu"
      if User.isActiveForm(form.classname) then style = "helmod_button_menu_selected" end
      GuiElement.add(group4, GuiButton(self.classname, "change-tab", form.classname):sprite("menu", icon_hovered, icon):style(style):tooltip(form:getButtonCaption()))
    end
  end

  if self.classname == "HMAdminTab" then
    GuiElement.add(action_panel, GuiButton("HMRuleEdition", "OPEN"):caption({"helmod_result-panel.add-button-rule"}))
    GuiElement.add(action_panel, GuiButton(self.classname, "reset-rules"):caption({"helmod_result-panel.reset-button-rule"}))
  elseif self.classname == "HMPropertiesTab" then
    GuiElement.add(action_panel, GuiButton("HMEntitySelector", "OPEN", "HMPropertiesTab"):caption({"helmod_result-panel.select-button-entity"}))
    GuiElement.add(action_panel, GuiButton("HMItemSelector", "OPEN", "HMPropertiesTab"):caption({"helmod_result-panel.select-button-item"}))
    GuiElement.add(action_panel, GuiButton("HMFluidSelector", "OPEN", "HMPropertiesTab"):caption({"helmod_result-panel.select-button-fluid"}))
    GuiElement.add(action_panel, GuiButton("HMRecipeSelector", "OPEN", "HMPropertiesTab"):caption({"helmod_result-panel.select-button-recipe"}))
    GuiElement.add(action_panel, GuiButton("HMTechnologySelector", "OPEN", "HMPropertiesTab"):caption({"helmod_result-panel.select-button-technology"}))
  elseif self.classname == "HMPrototypeFiltersTab" then
  else
    -- add recipe
    local group1 = GuiElement.add(action_panel, GuiFlowH("group1"))
    local block_id = current_block or "new"
    GuiElement.add(group1, GuiButton("HMRecipeSelector", "OPEN", block_id):sprite("menu", "wrench-white", "wrench"):style("helmod_button_menu"):tooltip({"helmod_result-panel.add-button-recipe"}))
    GuiElement.add(group1, GuiButton("HMTechnologySelector", "OPEN", block_id):sprite("menu", "graduation-white", "graduation"):style("helmod_button_menu"):tooltip({"helmod_result-panel.add-button-technology"}))
    --GuiElement.add(group1, GuiButton("HMContainerSelector", "OPEN", block_id):sprite("menu", "container-white", "container"):style("helmod_button_menu"):tooltip({"helmod_result-panel.select-button-container"}))
    GuiElement.add(group1, GuiButton("HMRecipeExplorer", "OPEN", block_id):sprite("menu", "search-white", "search"):style("helmod_button_menu"):tooltip({"helmod_button.explorer"}))

    local groupPref = GuiElement.add(action_panel, GuiFlowH("groupPref"))
    GuiElement.add(groupPref, GuiButton("HMPreferenceEdition", "OPEN", block_id):sprite("menu", "services-white", "services"):style("helmod_button_menu"):tooltip({"helmod_button.preferences"}))
    
    local group2 = GuiElement.add(action_panel, GuiFlowH("group2"))
    -- copy past
    GuiElement.add(group2, GuiButton(self.classname, "copy-model", model.id):sprite("menu", "copy-white", "copy"):style("helmod_button_menu"):tooltip({"helmod_button.copy"}))
    GuiElement.add(group2, GuiButton(self.classname, "past-model", model.id):sprite("menu", "paste-white", "paste"):style("helmod_button_menu"):tooltip({"helmod_button.past"}))
    -- download
    if self.classname == "HMProductionLineTab" then
      GuiElement.add(group2, GuiButton("HMDownload", "OPEN", "download"):sprite("menu", "download-white", "download"):style("helmod_button_menu"):tooltip({"helmod_result-panel.download-button-production-line"}))
      GuiElement.add(group2, GuiButton("HMDownload", "OPEN", "upload"):sprite("menu", "upload-white", "upload"):style("helmod_button_menu"):tooltip({"helmod_result-panel.upload-button-production-line"}))
    end
    -- delete control
    if User.isAdmin() or model.owner == User.name() or (model.share ~= nil and bit32.band(model.share, 4) > 0) then
      if self.classname == "HMProductionLineTab" then
        GuiElement.add(group2, GuiButton(self.classname, "remove-model", model.id):sprite("menu", "delete-white", "delete"):style("helmod_button_menu_red"):tooltip({"helmod_result-panel.remove-button-production-line"}))
      end
      if self.classname == "HMProductionBlockTab" then
        GuiElement.add(group2, GuiButton(self.classname, "production-block-remove", block_id):sprite("menu", "delete-white", "delete"):style("helmod_button_menu_red"):tooltip({"helmod_result-panel.remove-button-production-block"}))
      end
    end
    -- refresh control
    GuiElement.add(group2, GuiButton(self.classname, "refresh-model", model.id):sprite("menu", "refresh-white", "refresh"):style("helmod_button_menu"):tooltip({"helmod_result-panel.refresh-button"}))

    local group3 = GuiElement.add(action_panel, GuiFlowH("group3"))
    -- pin control
    if self.classname == "HMProductionBlockTab" then
      GuiElement.add(group3, GuiButton("HMPinPanel", "OPEN", block_id):sprite("menu", "pin-white", "pin"):style("helmod_button_menu"):tooltip({"helmod_result-panel.tab-button-pin"}))
      GuiElement.add(group3, GuiButton("HMSummaryPanel", "OPEN", block_id):sprite("menu", "brief-white","brief"):style("helmod_button_menu"):tooltip({"helmod_result-panel.tab-button-summary"}))
      local block = model.blocks[block_id]
      if block ~= nil then
        local style = "helmod_button_menu"
        if block.solver == true then style = "helmod_button_menu_selected" end
        GuiElement.add(group3, GuiButton(self.classname, "production-block-solver", block_id):sprite("menu", "settings-white", "settings"):style(style):tooltip({"helmod_button.matrix-solver"}))
      end
    end
    -- pin info
    if self.classname == "HMStatisticTab" then
      GuiElement.add(group3, GuiButton("HMStatusPanel", "OPEN", block_id):sprite("menu", "pin-white", "pin"):style("helmod_button_menu"):tooltip({"helmod_result-panel.tab-button-pin"}))
    end
  end


  local time_panel = self:getRightMenuPanel()
  time_panel.clear()

  local group_special = GuiElement.add(time_panel, GuiFlowH("group_special"))
  GuiElement.add(group_special, GuiButton("HMCalculator", "OPEN"):sprite("menu", "calculator-white", "calculator"):style("helmod_button_menu"):tooltip({"helmod_calculator-panel.title"}))
  
  local items = {}
  local default_time = 1
  for index,base_time in pairs(helmod_base_times) do
    table.insert(items,base_time.tooltip)
    if model.time == base_time.value then
      default_time = base_time.tooltip
    end
  end

  local group_time = GuiElement.add(time_panel, GuiFlowH("group_time"))
  GuiElement.add(group_time, GuiLabel("label_time"):caption({"helmod_data-panel.base-time", ""}):style("helmod_label_title_frame"))
  
  GuiElement.add(group_time, GuiDropDown(self.classname, "change-time", model_id):items(items, default_time))

end

-------------------------------------------------------------------------------
-- Has index model (for Tab panel)
--
-- @function [parent=#Form] hasIndexModel
--
-- @return #boolean
--
function AbstractTab:hasIndexModel()
  return true
end

-------------------------------------------------------------------------------
-- Update index panel
--
-- @function [parent=#AbstractTab] updateIndexPanel
--
-- @param #LuaEvent event
--
function AbstractTab:updateIndexPanel(event)
  Logging:debug(self.classname, "updateIndexPanel()", event)
  local models = Model.getModels()
  local model_id = User.getParameter("model_id")

  if self:hasIndexModel() then
    -- index panel
    local index_panel = self:getIndexPanel()
    index_panel.clear()
    Logging:debug(self.classname, "updateIndexPanel():countModel", Model.countModel())
    if Model.countModel() > 0 then
      local i = 0
      for _,imodel in pairs(models) do
        i = i + 1
        local style = "helmod_button_default"
        local element = Model.firstRecipe(imodel.blocks)
        if imodel.id == model_id then
          if element ~= nil then
            GuiElement.add(index_panel, GuiButtonSprite(self.classname, "change-model", imodel.id):sprite("recipe", element.name):tooltip(RecipePrototype(element):getLocalisedName()))
          else
            GuiElement.add(index_panel, GuiButton(self.classname, "change-model", imodel.id):sprite("menu", "help-white", "help"):style("helmod_button_menu_selected"))
          end
        else
          if element ~= nil then
            GuiElement.add(index_panel, GuiButtonSelectSprite(self.classname, "change-model", imodel.id):sprite("recipe", element.name):tooltip(RecipePrototype(element):getLocalisedName()))
          else
            GuiElement.add(index_panel, GuiButton(self.classname, "change-model", imodel.id):sprite("menu", "help-white", "help"):style("helmod_button_menu"))
          end
        end

      end
    end
    GuiElement.add(index_panel, GuiButton(self.classname, "change-model", "new"):caption("+")).style.width=20
  else
    local index_panel = self:getIndexPanel()
    index_panel.clear()
  end
end

-------------------------------------------------------------------------------
-- Before update
--
-- @function [parent=#AbstractTab] beforeUpdate
--
-- @param #LuaEvent event
--
function AbstractTab:beforeUpdate(event)
  Logging:trace(self.classname, "beforeUpdate()", event)
end

-------------------------------------------------------------------------------
-- Add cell header
--
-- @function [parent=#AbstractTab] addCellHeader
--
-- @param #LuaGuiElement guiTable
-- @param #string name
-- @param #string caption
-- @param #string sorted
--
function AbstractTab:addCellHeader(guiTable, name, caption, sorted)
  Logging:trace(self.classname, "addCellHeader()", guiTable, name, caption, sorted)

  if (name ~= "index" and name ~= "id" and name ~= "name" and name ~= "type") or User.getModGlobalSetting("display_data_col_"..name) then
    local cell = GuiElement.add(guiTable, GuiFrameH("header", name):style(helmod_frame_style.hidden))
    GuiElement.add(cell, GuiLabel("label"):caption(caption))
  end
end

-------------------------------------------------------------------------------
-- Update debug panel
--
-- @function [parent=#AbstractTab] updateDebugPanel
--
-- @param #LuaEvent event
--
function AbstractTab:updateDebugPanel(event)
  Logging:debug("AbstractTab", "updateDebugPanel()", event)
end

-------------------------------------------------------------------------------
-- Update header
--
-- @function [parent=#AbstractTab] updateHeader
--
-- @param #LuaEvent event
--
function AbstractTab:updateHeader(event)
  Logging:debug("AbstractTab", "updateHeader()", event)
end
-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#AbstractTab] updateData
--
-- @param #LuaEvent event
--
function AbstractTab:updateData(event)
  Logging:debug("AbstractTab", "updateData()", event)
end
