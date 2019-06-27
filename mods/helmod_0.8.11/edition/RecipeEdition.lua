require "edition.AbstractEdition"

-------------------------------------------------------------------------------
-- Class to build recipe edition dialog
--
-- @module RecipeEdition
-- @extends #AbstractEdition
--

RecipeEdition = setclass("HMRecipeEdition", AbstractEdition)

-------------------------------------------------------------------------------
-- On initialization
--
-- @function [parent=#RecipeEdition] onInit
--
-- @param #Controller parent parent controller
--
function RecipeEdition.methods:onInit(parent)
  self.panelCaption = ({"helmod_recipe-edition-panel.title"})
end

-------------------------------------------------------------------------------
-- Get or create recipe panel
--
-- @function [parent=#RecipeEdition] getRecipePanel
--
-- @return #LuaGuiElement
--
function RecipeEdition.methods:getRecipePanel()
  local panel = self:getPanel()
  if panel["recipe_panel"] ~= nil and panel["recipe_panel"].valid then
    return panel["recipe_panel"]
  end
  local table_panel = ElementGui.addGuiTable(panel, "recipe_panel", 2, helmod_table_style.panel)
  ElementGui.setStyle(table_panel, "recipe_info_object", "height")
  return table_panel
end

-------------------------------------------------------------------------------
-- Get or create recipe info panel
--
-- @function [parent=#RecipeEdition] getObjectInfoPanel
--
-- @return #LuaGuiElement
--
function RecipeEdition.methods:getObjectInfoPanel()
  local panel = self:getRecipePanel()
  if panel["info"] ~= nil and panel["info"].valid then
    return panel["info"]
  end
  local panel = ElementGui.addGuiFrameH(panel, "info", helmod_frame_style.recipe_column, ({"helmod_common.recipe"}))
  ElementGui.setStyle(panel, "recipe_edition_1", "width")
  return panel
end

-------------------------------------------------------------------------------
-- Get or create other info panel
--
-- @function [parent=#RecipeEdition] getOtherInfoPanel
--
-- @return #LuaGuiElement
--
function RecipeEdition.methods:getOtherInfoPanel()
  local panel = self:getRecipePanel()
  if panel["other_info_panel"] ~= nil and panel["other_info_panel"].valid then
    return panel["other_info_panel"]
  end
  local table_panel = ElementGui.addGuiTable(panel, "other_info_panel", 1, helmod_table_style.panel)
  return table_panel
end

-------------------------------------------------------------------------------
-- Get or create ingredients recipe panel
--
-- @function [parent=#RecipeEdition] getRecipeIngredientsPanel
--
-- @return #LuaGuiElement
--
function RecipeEdition.methods:getRecipeIngredientsPanel()
  local panel = self:getOtherInfoPanel()
  if panel["ingredients"] ~= nil and panel["ingredients"].valid then
    return panel["ingredients"]
  end
  local panel = ElementGui.addGuiFrameV(panel, "ingredients", helmod_frame_style.panel, ({"helmod_common.ingredients"}))
  ElementGui.setStyle(panel, "recipe_edition_2", "width")
  ElementGui.setStyle(panel, "recipe_product", "height")
  return panel
end

-------------------------------------------------------------------------------
-- Get or create products recipe panel
--
-- @function [parent=#RecipeEdition] getRecipeProductsPanel
--
-- @return #LuaGuiElement
--
function RecipeEdition.methods:getRecipeProductsPanel()
  local panel = self:getOtherInfoPanel()
  if panel["products"] ~= nil and panel["products"].valid then
    return panel["products"]
  end
  local panel = ElementGui.addGuiFrameV(panel, "products", helmod_frame_style.panel, ({"helmod_common.products"}))
  ElementGui.setStyle(panel, "recipe_edition_2", "width")
  ElementGui.setStyle(panel, "recipe_product", "height")
  return panel
end

-------------------------------------------------------------------------------
-- Get object
--
-- @function [parent=#RecipeEdition] getObject
--
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function RecipeEdition.methods:getObject(item, item2, item3)
  Logging:debug(self:classname(), "getObject():", item, item2, item3)
  local model = Model.getModel()
  if  model.blocks[item] ~= nil and model.blocks[item].recipes[item2] ~= nil then
    -- return recipe
    return model.blocks[item].recipes[item2]
  end
  return nil
end

-------------------------------------------------------------------------------
-- Build header panel
--
-- @function [parent=#RecipeEdition] buildHeaderPanel
--
function RecipeEdition.methods:buildHeaderPanel()
  Logging:debug(self:classname(), "buildHeaderPanel()")
  self:getObjectInfoPanel()
  self:getRecipeIngredientsPanel()
  self:getRecipeProductsPanel()
end

-------------------------------------------------------------------------------
-- Update header
--
-- @function [parent=#RecipeEdition] updateHeader
--
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function RecipeEdition.methods:updateHeader(item, item2, item3)
  Logging:debug(self:classname(), "updateHeader():", item, item2, item3)
  self:updateObjectInfo(item, item2, item3)
  self:updateRecipeIngredients(item, item2, item3)
  self:updateRecipeProducts(item, item2, item3)
end

-------------------------------------------------------------------------------
-- Update information
--
-- @function [parent=#RecipeEdition] updateObjectInfo
--
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function RecipeEdition.methods:updateObjectInfo(item, item2, item3)
  Logging:debug(self:classname(), "updateObjectInfo():", item, item2, item3)
  local infoPanel = self:getObjectInfoPanel()
  local model = Model.getModel()
  if  model.blocks[item] ~= nil then
    local recipe = self:getObject(item, item2, item3)
    if recipe ~= nil then
      Logging:debug(self:classname(), "updateObjectInfo():recipe=",recipe)
      infoPanel.clear()

      local tablePanel = ElementGui.addGuiTable(infoPanel,"table-input",2)
      ElementGui.addGuiButtonSprite(tablePanel, "recipe", Player.getRecipeIconType(recipe), recipe.name)

      local lua_recipe = RecipePrototype.load(recipe).native()
      if lua_recipe == nil then
        ElementGui.addGuiLabel(tablePanel, "label", lua_recipe.name)
      else
        ElementGui.addGuiLabel(tablePanel, "label", lua_recipe.localised_name)
      end


      ElementGui.addGuiLabel(tablePanel, "label-energy", ({"helmod_common.energy"}))
      ElementGui.addGuiLabel(tablePanel, "energy", RecipePrototype.getEnergy())

      ElementGui.addGuiLabel(tablePanel, "label-production", ({"helmod_recipe-edition-panel.production"}))
      ElementGui.addGuiText(tablePanel, "production", (recipe.production or 1)*100, "helmod_textfield")

      ElementGui.addGuiButton(tablePanel, self:classname().."=object-update=ID="..item.."=", recipe.id, "helmod_button_default", ({"helmod_button.update"}))
    end
  end
end

-------------------------------------------------------------------------------
-- Update ingredients information
--
-- @function [parent=#RecipeEdition] updateRecipeIngredients
--
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function RecipeEdition.methods:updateRecipeIngredients(item, item2, item3)
  Logging:debug(self:classname(), "updateRecipeIngredients():", item, item2, item3)
  local ingredientsPanel = self:getRecipeIngredientsPanel()
  local recipe = self:getObject(item, item2, item3)

  if recipe ~= nil then
    local lua_recipe = RecipePrototype.load(recipe).native()

    ingredientsPanel.clear()
    local tablePanel= ElementGui.addGuiTable(ingredientsPanel, "table-ingredients", 6)

    for index, ingredient in pairs(RecipePrototype.getIngredients(recipe.factory)) do
      local tooltip = nil
      local localisedName = Player.getLocalisedName(ingredient)
      if ingredient.amount ~= nil then
        tooltip = ({"tooltip.element-amount", localisedName, Format.formatNumber(ingredient.amount,5)})
      else
        tooltip = ({"tooltip.element-amount-probability", localisedName, ingredient.amount_min, ingredient.amount_max, ingredient.probability})
      end
      local cell = ElementGui.addCell(tablePanel, ingredient.name, nil, index)
      ElementGui.addGuiButtonSpriteSm(cell, "item=ID=", Player.getIconType(ingredient), ingredient.name, ingredient.name, tooltip)
      ElementGui.addGuiLabel(cell, ingredient.name, Format.formatNumber(Product.getElementAmount(ingredient),5), "helmod_label_sm")
    end
  end
end

-------------------------------------------------------------------------------
-- Update products information
--
-- @function [parent=#RecipeEdition] updateRecipeProducts
--
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function RecipeEdition.methods:updateRecipeProducts(item, item2, item3)
  Logging:debug(self:classname(), "updateRecipeProducts():", item, item2, item3)
  local productsPanel = self:getRecipeProductsPanel()
  local recipe = self:getObject(item, item2, item3)

  if recipe ~= nil then
    local lua_recipe = RecipePrototype.load(recipe).native()
    if lua_recipe ~= nil then

      productsPanel.clear()
      local tablePanel= ElementGui.addGuiTable(productsPanel, "table-products", 6)
      for key, product in pairs(RecipePrototype.getProducts()) do
        local tooltip = nil
        local localisedName = Player.getLocalisedName(product)
        if product.amount ~= nil then
          tooltip = ({"tooltip.element-amount", localisedName, product.amount})
        else
          tooltip = ({"tooltip.element-amount-probability", localisedName, product.amount_min, product.amount_max, product.probability})
        end
        local cell = ElementGui.addCell(tablePanel, product.name)
        ElementGui.addGuiButtonSpriteSm(cell, "item=ID=", Player.getIconType(product), product.name, product.name, tooltip)
        ElementGui.addGuiLabel(cell, product.name, Product.getElementAmount(product), "helmod_label_sm")
      end
    end
  end
end
