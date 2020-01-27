require "core.Object"

-------------------------------------------------------------------------------
-- Class to help to build form
--
-- @module Form
-- @extends Object#Object
--
Form = newclass(Object,function(base,classname)
  Object.init(base,classname)
  base.otherClose = true
  base.locate = "screen"
  base.panelClose = true
  base.help_button = true
  base.auto_clear = true
  base.content_verticaly = true
end)

-------------------------------------------------------------------------------
-- Bind Dispatcher
--
-- @function [parent=#Form] bind
--
function Form:bind()
  Dispatcher:bind("on_gui_event", self, self.event)

  Dispatcher:bind("on_gui_open", self, self.open)
  Dispatcher:bind("on_gui_open", self, self.update)

  Dispatcher:bind("on_gui_update", self, self.update)
  Dispatcher:bind("on_gui_close", self, self.close)

  self:onBind()
end

-------------------------------------------------------------------------------
-- On Bind Dispatcher
--
-- @function [parent=#Form] onBind
--
function Form:onBind()
end

-------------------------------------------------------------------------------
-- On initialization
--
-- @function [parent=#Form] onInit
--
function Form:onInit()
end

-------------------------------------------------------------------------------
-- Is visible
--
-- @function [parent=#Form] isVisible
--
-- @return boolean
--
function Form:isVisible()
  return true
end

-------------------------------------------------------------------------------
-- Is special
--
-- @function [parent=#Form] isSpecial
--
-- @return boolean
--
function Form:isSpecial()
  return false
end

-------------------------------------------------------------------------------
-- Get panel name
--
-- @function [parent=#Form] getPanelName
--
-- @return #LuaGuiElement
--
function Form:getPanelName()
  Logging:trace(self.classname, "getPanelName()", self.classname)
  return self.classname
end

-------------------------------------------------------------------------------
-- Get the parent panel
--
-- @function [parent=#Form] getParentPanel
--
-- @return #LuaGuiElement
--
function Form:getParentPanel()
  local lua_player = Player.native()
  return lua_player.gui[self.locate]
end

-------------------------------------------------------------------------------
-- Get the parent panel
--
-- @function [parent=#Form] getPanel
--
-- @return #LuaGuiElement
--
function Form:getPanel()
  Logging:trace(self.classname, "getPanel()")
  local parent_panel = self:getParentPanel()
  if parent_panel[self:getPanelName()] ~= nil and parent_panel[self:getPanelName()].valid then
    return parent_panel[self:getPanelName()], parent_panel[self:getPanelName()]["content_panel"], parent_panel[self:getPanelName()]["header_panel"]["menu_panel"]
  end

  local flow_panel = GuiElement.add(parent_panel, GuiFrameV(self:getPanelName()):style(helmod_frame_style.hidden))
  flow_panel.style.horizontally_stretchable = true
  flow_panel.style.vertically_stretchable = true
  flow_panel.location = User.getLocationForm(self:getPanelName())
  GuiElement.setStyle(flow_panel, self.classname, "width")
  GuiElement.setStyle(flow_panel, self.classname, "height")
  GuiElement.setStyle(flow_panel, self.classname, "minimal_width")
  GuiElement.setStyle(flow_panel, self.classname, "minimal_height")
  GuiElement.setStyle(flow_panel, self.classname, "maximal_width")
  GuiElement.setStyle(flow_panel, self.classname, "maximal_height")

  local header_panel = GuiElement.add(flow_panel, GuiFlowH("header_panel"))
  local title_panel = GuiElement.add(header_panel, GuiFrameH("title_panel"):caption(self.panelCaption or self.classname))
  title_panel.style.height = 40
  local menu_panel = GuiElement.add(header_panel,  GuiFrameH("menu_panel"):style(helmod_frame_style.panel))
  --menu_panel.style.horizontal_spacing = 10
  menu_panel.style.horizontal_align = "right"

  local content_panel
  if self.content_verticaly == true then
    content_panel = GuiElement.add(flow_panel, GuiFlowV("content_panel"))
  else
    content_panel = GuiElement.add(flow_panel, GuiFlowH("content_panel"))
  end
  title_panel.drag_target = flow_panel
  return flow_panel, content_panel, menu_panel
end

-------------------------------------------------------------------------------
-- Get the menu panel
--
-- @function [parent=#Form] getMenuPanel
--
-- @return #LuaGuiElement
--
function Form:getMenuPanel()
  local flow_panel, content_panel, menu_panel = self:getPanel()
  local panel_name = "menu"
  if content_panel[panel_name] ~= nil and content_panel[panel_name].valid then
    return content_panel[panel_name]
  end
  local panel = GuiElement.add(content_panel, GuiFrameH(panel_name))
  panel.style.horizontally_stretchable = true
  --panel.style.vertically_stretchable = true
  panel.style.height = 40
  return panel
end

-------------------------------------------------------------------------------
-- Get the left menu panel
--
-- @function [parent=#Form] getLeftMenuPanel
--
-- @return #LuaGuiElement
--
function Form:getLeftMenuPanel()
  local parent_panel = self:getMenuPanel()
  local panel_name = "left_menu"
  if parent_panel[panel_name] ~= nil and parent_panel[panel_name].valid then
    return parent_panel[panel_name]
  end
  local panel = GuiElement.add(parent_panel, GuiFlowH(panel_name))
  panel.style.horizontal_spacing = 10
  panel.style.horizontally_stretchable = true
  --panel.style.vertically_stretchable = true
  return panel
end

-------------------------------------------------------------------------------
-- Get the right menu panel
--
-- @function [parent=#Form] getRightMenuPanel
--
-- @return #LuaGuiElement
--
function Form:getRightMenuPanel()
  local parent_panel = self:getMenuPanel()
  local panel_name = "right_menu"
  if parent_panel[panel_name] ~= nil and parent_panel[panel_name].valid then
    return parent_panel[panel_name]
  end
  local panel = GuiElement.add(parent_panel, GuiFlowH(panel_name))
  panel.style.horizontal_spacing = 10
  --panel.style.horizontally_stretchable = true
  --panel.style.vertically_stretchable = true
  panel.style.horizontal_align = "right"
  return panel
end

-------------------------------------------------------------------------------
-- Is opened panel
--
-- @function [parent=#Form] isOpened
--
function Form:isOpened()
  Logging:trace(self.classname, "isOpened()")
  local parent_panel = self:getParentPanel()
  Logging:debug(self.classname, "isOpened test", parent_panel[self:getPanelName()] ~= nil, User.isActiveForm(self.classname))
  if parent_panel[self:getPanelName()] ~= nil and User.isActiveForm(self.classname) then
    return true
  end
  return false
end

-------------------------------------------------------------------------------
-- Build first container
--
-- @function [parent=#Form] open
--
-- @param #LuaEvent event
--
function Form:open(event)
  Logging:debug(self.classname, "open()", event)
  self:onBeforeOpen(event)
  if self:isOpened() then return true end
  local parent_panel = self:getParentPanel()
  User.setActiveForm(self.classname)
  if parent_panel[self:getPanelName()] == nil then
    self:updateTopMenu(event)
    self:onOpen(event)
    self:isOpened()
  end
  return true
end

-------------------------------------------------------------------------------
-- On before event
--
-- @function [parent=#Form] beforeEvent
--
-- @param #LuaEvent event
--
function Form:beforeEvent(event)
  Logging:debug(self.classname, "beforeEvent()", event)
  local parent_panel = self:getParentPanel()
  local close = self:onBeforeEvent(event)
  if parent_panel ~= nil and parent_panel[self:getPanelName()] ~= nil and parent_panel[self:getPanelName()].valid then
    Logging:debug(self.classname , "must close?",close)
    if close and event.action == "OPEN" then
      self:close(true)
    end
  end
end

-------------------------------------------------------------------------------
-- On before event
--
-- @function [parent=#Form] onBeforeEvent
--
-- @param #LuaEvent event
--
function Form:onBeforeEvent(event)
  return false
end

-------------------------------------------------------------------------------
-- On before open
--
-- @function [parent=#Form] onBeforeOpen
--
-- @param #LuaEvent event
--
function Form:onBeforeOpen(event)
  return false
end

-------------------------------------------------------------------------------
-- Event
--
-- @function [parent=#Form] event
--
-- @param #LuaEvent event
--
function Form:event(event)
  Logging:debug(self.classname, "event()", event)
  self:onBeforeEvent(event)
  if not(self:isOpened()) then return end
  self:onEvent(event)
end

-------------------------------------------------------------------------------
-- On event
--
-- @function [parent=#Form] onEvent
--
-- @param #LuaEvent event
--
function Form:onEvent(event)
end

-------------------------------------------------------------------------------
-- On open
--
-- @function [parent=#Form] onOpen
--
-- @param #LuaEvent event
--
function Form:onOpen(event)
  return false
end

-------------------------------------------------------------------------------
-- Prepare
--
-- @function [parent=#Form] prepare
--
-- @param #LuaEvent event
--
function Form:prepare(event)
  return false
end

-------------------------------------------------------------------------------
-- Update top menu
--
-- @function [parent=#Form] updateTopMenu
--
-- @param #LuaEvent event
--
function Form:updateTopMenu(event)
  Logging:debug(self.classname, "updateTopMenu()", event)
  -- ajoute un menu
  if self.panelCaption ~= nil then
    Logging:debug(self.classname, "self.panelCaption OK")
    local flow_panel, content_panel, menu_panel = self:getPanel()
    menu_panel.clear()
    if self.panelClose then
      -- pause game
      if string.find(self.classname, "Tab") then
        local group3 = GuiElement.add(menu_panel, GuiFlowH("group3"))
        if game.is_multiplayer() and not(game.tick_paused) then
          local pause_button = GuiElement.add(group3, GuiButton("do-nothing"):sprite("menu", "play-white", "play"):style("helmod_button_menu_flat"):tooltip({"helmod_button.game-play-multiplayer"}))
          pause_button.enabled = false
        else
          if game.tick_paused then
            GuiElement.add(group3, GuiButton(self.classname, "game-play"):sprite("menu", "pause", "pause"):style("helmod_button_menu_actived_red"):tooltip({"helmod_button.game-pause"}))
          else
            GuiElement.add(group3, GuiButton(self.classname, "game-pause"):sprite("menu", "play-white", "play"):style("helmod_button_menu"):tooltip({"helmod_button.game-play"}))
          end
        end
      end
      -- special tab
      local group1 = GuiElement.add(menu_panel, GuiFlowH("group1"))
      for _, form in pairs(Controller.getViews()) do
        if string.find(self.classname, "Tab") and string.find(form.classname, "Tab") and form:isVisible() and form:isSpecial() then
          local icon_hovered, icon = form:getButtonSprites()
          local style = "helmod_button_menu"
          if User.isActiveForm(form.classname) then style = "helmod_button_menu_selected" end
          GuiElement.add(group1, GuiButton(self.classname, "change-tab", form.classname):sprite("menu", icon_hovered, icon):style(style):tooltip(form:getButtonCaption()))
        end
      end
      -- current button
      local group2 = GuiElement.add(menu_panel, GuiFlowH("group2"))
      if self.help_button then
        GuiElement.add(group2, GuiButton("HMHelpPanel", "OPEN"):sprite("menu", "help-white", "help"):style("helmod_button_menu"):tooltip({"helmod_button.help"}))
      end
      GuiElement.add(group2, GuiButton(self.classname, "CLOSE"):sprite("menu", "close-window-white", "close-window"):style("helmod_button_menu_red"):tooltip({"helmod_button.close"}))
    end
  else
    Logging:warn(self.classname, "self.panelCaption not found")
  end
end

-------------------------------------------------------------------------------
-- Update
--
-- @function [parent=#Form] update
--
-- @param #LuaEvent event
--
function Form:update(event)
  Logging:debug(self.classname, "update()", event)
  if not(self:isOpened()) then return end
  local flow_panel, content_panel, menu_panel = self:getPanel()
  if self.auto_clear then content_panel.clear() end
  self:onUpdate(event)
end

-------------------------------------------------------------------------------
-- On update
--
-- @function [parent=#Form] onUpdate
--
-- @param #LuaEvent event
--
function Form:onUpdate(event)

end

-------------------------------------------------------------------------------
-- Close dialog
--
-- @function [parent=#Form] close
--
function Form:close(force)
  if not(force) and not(self:isOpened()) then return end
  Logging:debug(self.classname, "close()")
  local flow_panel, content_panel, menu_panel = self:getPanel()
  User.setCloseForm(self.classname, flow_panel.location)
  self:onClose()
  flow_panel.destroy()
end

-------------------------------------------------------------------------------
-- On close dialog
--
-- @function [parent=#Form] onClose
--
-- @return #boolean if true the next call close dialog
--
function Form:onClose()
end
