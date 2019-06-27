bobmods.ores.rutile =
{
  name = "rutile-ore",
  tint = {r=0.8, g=0.55, b=0.7},
  map_color = {r=0.610, g=0.325, b=0.500},
  mining_time = 2.75,
  enabled = false,
  icon = "__bobores__/graphics/icons/rutile-ore.png",
  stage_mult = 100,
  item =
  {
    create = true,
    create_variations = true,
    subgroup = "bob-ores",
  },
  sprite =
  {
    sheet = 1
  },
--[[  autoplace = 
  {
    create = true,
    starting_area = false,
    richness = 0.8,
    size = 1.5
  }
  autoplace = resource_autoplace.resource_autoplace_settings{
    name = "rutile-ore",
    order = "c",
    base_density = 8,
    has_starting_area_placement = false,
    resource_index = resource_autoplace.get_next_resource_index(),
    regular_rq_factor_multiplier = 1,
  },
]]--
  autoplace = false,
}

function bobmods.ores.rutile.create_autoplace()

resource_generator.setup_resource_autoplace_data("rutile-ore", {
    name = "rutile-ore",
    order = "c",
    base_density = 8,
    has_starting_area_placement = false,
    regular_rq_factor_multiplier = 1,
  }
)
bobmods.lib.resource.generate_autoplace_control("rutile-ore")
end
