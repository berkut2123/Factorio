local OV = angelsmods.functions.OV
local intermediatemulti = angelsmods.marathon.intermediatemulti

-------------------------------------------------------------------------------
-- BASE OVERRIDES -------------------------------------------------------------
-------------------------------------------------------------------------------
angelsmods.functions.override_item_conditions({
  value = 200,
  list = {
    "stone",
  }
})

angelsmods.functions.move_item("stone", "slag-processing-1", "c")
angelsmods.functions.move_item("stone-brick", "angels-stone", "f")
angelsmods.functions.move_item("concrete", "angels-stone-casting", "ha")
angelsmods.functions.move_item("hazard-concrete", "angels-stone-casting", "hb")
angelsmods.functions.move_item("refined-concrete", "angels-stone-casting", "hc")
angelsmods.functions.move_item("refined-hazard-concrete", "angels-stone-casting", "hd")

angelsmods.functions.move_item("landfill", "slag-processing-1", "d")
angelsmods.functions.move_item("landfill", "processing-crafting", "e[landfill]", "recipe")
OV.patch_recipes({
  { name = "stone-brick", subgroup = "angels-stone", order = "f[stone-brick]" },
  {
    name = "concrete",
    icons = {
      {
        icon = "__base__/graphics/icons/concrete.png",
        icon_size = 64
      },
      {
        icon = "__angelsrefining__/graphics/icons/num_1.png",
        tint = angelsmods.smelting.number_tint,
        scale = 0.32,
        shift = {-12, -12},
      }
    },
    icon_size = 32,
    subgroup = "angels-stone-casting",
    order = "h[concrete]-a" },
  { name = "hazard-concrete", subgroup = "angels-stone-casting", order = "h[concrete]-c" },
  { name = "refined-concrete", subgroup = "angels-stone-casting", order = "h[concrete]-d" },
  { name = "hazard-refined-concrete", subgroup = "angels-stone-casting", order = "h[concrete]-e" },
})

-------------------------------------------------------------------------------
-- ANGEL OVERRIDES ------------------------------------------------------------
-------------------------------------------------------------------------------
if angelsmods.refining then
  OV.patch_recipes({
    {
      name = "angelsore3-crushed-smelting",
      subgroup = "angels-copper-casting",
      order = "j[angels-plate-copper]-a"
    },
  })
end

if not (angelsmods.trigger.smelting_products["lead"].plate or
        angelsmods.trigger.smelting_products["tin"].plate) then
  -- special vanilla
  OV.patch_recipes({
    { 
      name = "cement-mixture-1",
      ingredients =
      {
        { name = "stone-crushed", type = "item", amount = "quartz" },
      },
    },
    { 
      name = "cement-mixture-2",
      ingredients =
      {
        { name = "stone-crushed", type = "item", amount = "quartz" },
        { name = "stone-crushed", type = "item", amount = "solid-aluminium-oxide" },
      },
    }
  })
end

if angelsmods.trigger.smelting_products["steel"].rod then
  -- if steel rod is present, concrete should use these instead of steel plates
  OV.patch_recipes({
    {
      name = "angels-reinforced-concrete-brick",
      ingredients =
      {
        { name = "steel-plate", type = "item", amount = 0 }, -- was 4 plates
        { name = "angels-plate-steel", type = "item", amount = 0 }, -- was 4 plates
        { name = "angels-rod-steel", type = "item", amount = 2 }, -- replaced with 2 rods (equal to 4 plates)
      }
    }
  })
end