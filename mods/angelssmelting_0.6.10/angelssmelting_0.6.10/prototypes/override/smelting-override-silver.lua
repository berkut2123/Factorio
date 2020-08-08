local OV = angelsmods.functions.OV
local intermediatemulti = angelsmods.marathon.intermediatemulti

if angelsmods.trigger.smelting_products["enable-all"] then
  angelsmods.trigger.smelting_products["silver"].ingot = true
  angelsmods.trigger.smelting_products["silver"].plate = true
  angelsmods.trigger.smelting_products["silver"].wire = true
  angelsmods.trigger.smelting_products["silver"].powder = true
end

-------------------------------------------------------------------------------
-- ORE ------------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.ores["silver"] then
else
  angelsmods.functions.add_flag("silver-ore", "hidden")
end

-------------------------------------------------------------------------------
-- INGOT ----------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.smelting_products["silver"].ingot then
  -- REPLACE ITEMS (use bob version)
  if mods['bobplates'] then
    OV.global_replace_item("solid-silver-nitrate", "silver-nitrate")
    angelsmods.functions.add_flag("solid-silver-nitrate", "hidden")
    OV.disable_recipe({"silver-nitrate"})
  end

  if mods['bobplates'] then
    angelsmods.functions.move_item("silver-oxide", "angels-silver", "e")
    data.raw.item["silver-oxide"].icon = "__angelssmelting__/graphics/icons/solid-silver-oxide.png"
    data.raw.item["silver-oxide"].icon_size = 32
    OV.patch_recipes({ { name = "silver-oxide", subgroup = "angels-silver", order = "e[silver-oxide]" } })
  end

  if angelsmods.trigger.smelting_products["silver"].plate or
     angelsmods.trigger.smelting_products["silver"].wire then
  else
    -- no need for molten recipe
    angelsmods.functions.add_flag("liquid-molten-silver", "hidden")
    OV.disable_recipe({"molten-silver-smelting"})
  end
else
  angelsmods.functions.add_flag("processed-silver", "hidden")
  angelsmods.functions.add_flag("pellet-silver", "hidden")
  angelsmods.functions.add_flag("solid-silver-nitrate", "hidden")
  angelsmods.functions.add_flag("solid-sodium-silver-cyanide", "hidden")
  angelsmods.functions.add_flag("cathode-silver", "hidden")
  angelsmods.functions.add_flag("ingot-silver", "hidden")
  angelsmods.functions.add_flag("liquid-molten-silver", "hidden")
  OV.disable_recipe({"silver-ore-processing", "silver-processed-processing"})
  OV.disable_recipe({"processed-silver-smelting", "pellet-silver-smelting", "solid-sodium-silver-cyanide-smelting"})
  OV.disable_recipe({"silver-ore-smelting", "solid-silver-nitrate-smelting", "cathode-silver-smelting"})
  OV.disable_recipe({"molten-silver-smelting"})
  OV.disable_technology({"angels-silver-smelting-1", "angels-silver-smelting-2", "angels-silver-smelting-3"})
end

-------------------------------------------------------------------------------
-- PLATE ----------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.smelting_products["silver"].plate then
  -- REPLACE ITEMS (use bob version)
  if mods['bobplates'] then
    OV.global_replace_item("angels-plate-silver", "silver-plate")
    angelsmods.functions.add_flag("angels-plate-silver", "hidden")

    OV.patch_recipes({
      {
        name = "silver-plate",
        energy_required = 10.5,
        normal =
        {
          ingredients =
          {
            { name = "silver-ore", type = "item", amount = "+3" }
          },
          results =
          {
            { name = "silver-plate", type = "item", amount = "+2" }
          }
        },
        expensive =
        {
          ingredients =
          { {"!!"},
            { name = "silver-ore", type = "item", amount = 5 * intermediatemulti }
          },
          results =
          {
            { name = "silver-plate", type = "item", amount = "+2" }
          }
        },
        icons = {
          {
            icon = "__angelssmelting__/graphics/icons/plate-silver.png",
          },
          {
            icon = "__angelssmelting__/graphics/icons/ore-silver.png",
            scale = 0.4375,
            shift = { -10, -10},
          },
        },
        icon_size = 32,
        subgroup = "angels-silver-casting",
        order = "m[angels-plate-silver]-a"
      },
    })
  end
else
  angelsmods.functions.add_flag("angels-plate-silver", "hidden")
  angelsmods.functions.add_flag("angels-roll-silver", "hidden")
  OV.disable_recipe({"roll-silver-casting", "roll-silver-casting-fast"})
  OV.disable_recipe({"angels-plate-silver", "angels-roll-silver-converting"})
end

-------------------------------------------------------------------------------
-- WIRE -----------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.smelting_products["silver"].wire then
  if mods['bobassembly'] then
    OV.patch_recipes({
      {
        name = "basic-silvered-copper-wire",
        category = "electronics"
      },
      {
        name = "angels-wire-coil-silver-converting",
        category = "electronics-machine"
      }
    })
  end
else
  angelsmods.functions.add_flag("angels-wire-silver", "hidden")
  angelsmods.functions.add_flag("angels-wire-coil-silver", "hidden")
  OV.disable_recipe({"angels-wire-coil-silver-casting", "angels-wire-coil-silver-casting-fast"})
  OV.disable_recipe({"basic-silvered-copper-wire", "angels-wire-coil-silver-converting"})
end

-------------------------------------------------------------------------------
-- POWDER ---------------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.trigger.smelting_products["silver"].powder then
else
  angelsmods.functions.add_flag("powder-silver", "hidden")
  OV.disable_recipe({ "powder-silver" })
end