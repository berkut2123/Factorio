bobmods.ores.silver =
{
  name = "silver-ore",
  tint = {r = 0.875, g = 0.975, b = 1},
  map_color = {r=0.578, g=0.684, b=0.695},
  mining_time = 0.625,
  enabled = false,
  icon = "__bobores__/graphics/icons/silver-ore.png",
  stage_mult = 100,
  item =
  {
    create = true,
    create_variations = true,
    subgroup = "bob-ores",
  },
  sprite =
  {
    sheet = 2
  },
--[[
  autoplace = 
  {
    create = true,
    starting_area = false,
    richness = 1.2,
    size = 1
  }
  autoplace = resource_autoplace.resource_autoplace_settings{
    name = "silver-ore",
    order = "c",
    base_density = 4,
    has_starting_area_placement = false,
    resource_index = resource_autoplace.get_next_resource_index(),
    regular_rq_factor_multiplier = 0.9,
  },
]]--
  autoplace = false,
}

function bobmods.ores.silver.create_autoplace()

resource_generator.setup_resource_autoplace_data("silver-ore", {
    name = "silver-ore",
    order = "c",
    base_density = 4,
    has_starting_area_placement = false,
    regular_rq_factor_multiplier = 0.9,
  }
)
bobmods.lib.resource.generate_autoplace_control("silver-ore")
end
