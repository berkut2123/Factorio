require "tab.AbstractTab"
-------------------------------------------------------------------------------
-- Class to build tab
--
-- @module EnergyTab
-- @extends #AbstractTab
--

EnergyTab = setclass("HMEnergyTab", AbstractTab)

-------------------------------------------------------------------------------
-- Return button caption
--
-- @function [parent=#EnergyTab] getButtonCaption
--
-- @return #string
--
function EnergyTab.methods:getButtonCaption()
  return {"helmod_result-panel.tab-button-energy"}
end

-------------------------------------------------------------------------------
-- Update data
--
-- @function [parent=#EnergyTab] updateData
--
function EnergyTab.methods:updateData()
  Logging:debug(self:classname(), "updatePowers()")
  local model = Model.getModel()
  local globalGui = Player.getGlobalGui()

  -- data
  local scroll_panel = self:getResultScrollPanel({"helmod_result-panel.tab-title-energy"})
  local menu_manel = ElementGui.addGuiFrameH(scroll_panel,"menu", helmod_frame_style.hidden)
  ElementGui.addGuiButton(menu_manel, "HMEnergyEdition=OPEN=ID=", "new", "helmod_button_default", ({"helmod_result-panel.add-button-power"}))

  local countBlock = Model.countPowers()
  if model.powers ~= nil and countBlock > 0 then
    local globalSettings = Player.getGlobal("settings")

    local extra_cols = 0
    if Player.getSettings("display_data_col_id", true) then
      extra_cols = extra_cols + 1
    end
    local resultTable = ElementGui.addGuiTable(scroll_panel,"list-data",4 + extra_cols, "helmod_table-odd")

    self:addTableHeader(resultTable)

    local i = 0
    for _, element in spairs(model.powers, function(t,a,b) if globalGui.order.ascendant then return t[b][globalGui.order.name] > t[a][globalGui.order.name] else return t[b][globalGui.order.name] < t[a][globalGui.order.name] end end) do
      self:addTableRow(resultTable, element)
    end

  end
end

-------------------------------------------------------------------------------
-- Add table header
--
-- @function [parent=#EnergyTab] addTableHeader
--
-- @param #LuaGuiElement itable container for element
--
function EnergyTab.methods:addTableHeader(itable)
  Logging:debug(self:classname(), "addTableHeader():", itable)
  local model = Model.getModel()

  self:addCellHeader(itable, "action", {"helmod_result-panel.col-header-action"})
  -- optionnal columns
  self:addCellHeader(itable, "id", {"helmod_result-panel.col-header-id"},"id")
  -- data columns
  self:addCellHeader(itable, "power", {"helmod_result-panel.col-header-energy"})
  self:addCellHeader(itable, "primary", {"helmod_result-panel.col-header-primary"})
  self:addCellHeader(itable, "secondary", {"helmod_result-panel.col-header-secondary"})
end

-------------------------------------------------------------------------------
-- Add row table
--
-- @function [parent=#EnergyTab] addTableRow
--
-- @param #LuaGuiElement itable container for element
-- @param #table power
--
function EnergyTab.methods:addTableRow(gui_table, power)
  Logging:debug(self:classname(), "addPowersRow():", gui_table, power)
  local model = Model.getModel()

  -- col action
  local cell_action = ElementGui.addGuiFrameH(gui_table,"action"..power.id, helmod_frame_style.hidden)
  ElementGui.addGuiButton(cell_action, self:classname().."=power-remove=ID=", power.id, "helmod_button_default", ({"helmod_result-panel.row-button-delete"}), ({"tooltip.remove-element"}))

  -- col id
  if Player.getSettings("display_data_col_id", true) then
    local cell_id = ElementGui.addGuiFrameH(gui_table,"id"..power.id, helmod_frame_style.hidden)
    ElementGui.addGuiLabel(cell_id, "id", power.id)
  end
  -- col power
  local cell_power = ElementGui.addGuiFrameH(gui_table,"power"..power.id, helmod_frame_style.hidden)
  ElementGui.addGuiLabel(cell_power, power.id, Format.formatNumberKilo(power.power, "W"), "helmod_label_right_70")

  -- col primary
  local cell_primary = ElementGui.addGuiFrameH(gui_table,"primary"..power.id, helmod_frame_style.hidden)
  local primary = power.primary
  if primary.name ~= nil then
    ElementGui.addGuiLabel(cell_primary, primary.name, Format.formatNumberFactory(primary.count), "helmod_label_right_60")
    ElementGui.addGuiButtonSelectSprite(cell_primary, "HMEnergyEdition=OPEN=ID="..power.id.."=", Player.getIconType(primary), primary.name, "X"..Format.formatNumberFactory(primary.count), {"tooltip.edit-energy", Player.getLocalisedName(primary)})
  end
  -- col secondary
  local cell_secondary = ElementGui.addGuiFrameH(gui_table,"secondary"..power.id, helmod_frame_style.hidden)
  local secondary = power.secondary
  if secondary.name ~= nil then
    ElementGui.addGuiLabel(cell_secondary, secondary.name, Format.formatNumberFactory(secondary.count), "helmod_label_right_60")
    ElementGui.addGuiButtonSelectSprite(cell_secondary, "HMEnergyEdition=OPEN=ID="..power.id.."=", Player.getIconType(secondary), secondary.name, "X"..Format.formatNumberFactory(secondary.count), {"tooltip.edit-energy", Player.getLocalisedName(secondary)})
  end
end
