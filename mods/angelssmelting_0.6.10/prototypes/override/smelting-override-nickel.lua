local OV = angelsmods.functions.OV
local intermediatemulti = angelsmods.marathon.intermediatemulti

if angelsmods.trigger.smelting_products["enable-all"] then
  angelsmods.trigger.smelting_products["nickel"].ingot = true
  angelsmods.trigger.smelting_products["nickel"].plate = true
  angelsmods.trigger.smelting_products["nickel"].powder = true
end

-------------------------------------------------------------------------------
-- ORE ------------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.ores["nickel"] then
else
  angelsmods.functions.add_flag("nickel-ore", "hidden")
end

-------------------------------------------------------------------------------
-- INGOT ----------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.smelting_products["nickel"].ingot then
  if mods['bobplates'] then
    OV.global_replace_technology("nickel-processing", "angels-nickel-smelting-1")
  end

  if angelsmods.trigger.smelting_products["nickel"].plate then
  else
    -- no need for molten recipe
    angelsmods.functions.add_flag("liquid-molten-nickel", "hidden")
    OV.disable_recipe({"molten-nickel-smelting"})
  end
else
  angelsmods.functions.add_flag("processed-nickel", "hidden")
  angelsmods.functions.add_flag("pellet-nickel", "hidden")
  angelsmods.functions.add_flag("cathode-nickel", "hidden")
  angelsmods.functions.add_flag("solid-nickel-carbonyl", "hidden")
  angelsmods.functions.add_flag("ingot-nickel", "hidden")
  angelsmods.functions.add_flag("liquid-molten-nickel", "hidden")
  OV.disable_recipe({"nickel-ore-processing", "nickel-processed-processing"})
  OV.disable_recipe({"processed-nickel-smelting", "pellet-nickel-smelting"})
  OV.disable_recipe({"nickel-ore-smelting", "cathode-nickel-smelting", "solid-nickel-carbonyl-smelting"})
  OV.disable_recipe({"molten-nickel-smelting"})
  OV.disable_technology({"angels-nickel-smelting-1", "angels-nickel-smelting-2", "angels-nickel-smelting-3"})
end

-------------------------------------------------------------------------------
-- PLATE ----------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.smelting_products["nickel"].plate then
  -- REPLACE ITEMS (use bob version)
  if mods['bobplates'] then
    OV.global_replace_item("angels-plate-nickel", "nickel-plate")
    angelsmods.functions.add_flag("angels-plate-nickel", "hidden")
  end
else
  angelsmods.functions.add_flag("angels-plate-nickel", "hidden")
  angelsmods.functions.add_flag("angels-roll-nickel", "hidden")
  OV.disable_recipe({"roll-nickel-casting", "roll-nickel-casting-fast"})
  OV.disable_recipe({"angels-plate-nickel", "angels-roll-nickel-converting"})
end

-------------------------------------------------------------------------------
-- POWDER ---------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.smelting_products["nickel"].powder then
else
  angelsmods.functions.add_flag("powder-nickel", "hidden")
  OV.disable_recipe({ "powder-nickel" })
end