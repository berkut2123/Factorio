require "util"

local function create_technology(prefix, tech_prereqs, tint)
  local name = prefix .. "miniloader"
  local filter_name = prefix .. "filter-miniloader"

  local main_prereq = data.raw["technology"][tech_prereqs[1]]

  local effects = {}
  if settings.startup["miniloader-enable-standard"].value then
    table.insert(effects, { type = "unlock-recipe", recipe = name })
  end
  if settings.startup["miniloader-enable-filter"].value then
    table.insert(effects, { type = "unlock-recipe", recipe = filter_name })
  end

  local technology = {
    type = "technology",
    name = name,
    icons = {
      {
        icon = "__miniloader__/graphics/technology/template.png",
        icon_size = 128,
      },
      {
        icon = "__miniloader__/graphics/technology/mask.png",
        icon_size = 128,
        tint = tint,
      },
    },
    effects = effects,
    prerequisites = tech_prereqs,
    unit = util.table.deepcopy(main_prereq.unit),
    order = main_prereq.order
  }

  data:extend{technology}
end

return {
  create_technology = create_technology,
}
