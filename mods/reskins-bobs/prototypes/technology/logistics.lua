-- Copyright (c) 2020 Kirazy
-- Part of Artisanal Reskins: Bob's Mods
--     
-- See LICENSE.md in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["boblogistics"] then return end

-- Setup standard inputs
local inputs = {
    directory = reskins.bobs.directory,
    mod = "bobs",
    group = "logistics",
    type = "technology",
}

local technologies = {
    ["logistics-0"] = {tier = 0, icon_name = "logistics", technology_icon_layers = 2, tint = reskins.bobs.basic_belt_tint, uses_belt_mask = true},
    ["logistics-4"] = {tier = 4, icon_name = "logistics", technology_icon_layers = 2, uses_belt_mask = true},
    ["logistics-5"] = {tier = 5, icon_name = "logistics", technology_icon_layers = 2, uses_belt_mask = true},
}

-- Only do logistics 1, 2 and 3 if we're doing custom colors
if reskins.lib.setting("reskins-lib-customize-tier-colors") == true then
    technologies["logistics"] = {tier = 1, icon_name = "logistics", technology_icon_layers = 2, uses_belt_mask = true}
    technologies["logistics-2"] = {tier = 2, icon_name = "logistics", technology_icon_layers = 2, uses_belt_mask = true}
    technologies["logistics-3"] = {tier = 3, icon_name = "logistics", technology_icon_layers = 2, uses_belt_mask = true}
end

reskins.lib.create_icons_from_list(technologies, inputs)