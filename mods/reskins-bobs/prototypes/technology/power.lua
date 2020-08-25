-- Copyright (c) 2020 Kirazy
-- Part of Artisanal Reskins: Bob's Mods
--     
-- See LICENSE.md in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["bobpower"] then return end

-- Setup standard inputs
local inputs = {
    directory = reskins.bobs.directory,
    mod = "bobs",
    group = "power",
    type = "technology",
}

-- Setup boiler and oil-boiler icon_extras
local boiler_icon_extra = {
    {
        icon = inputs.directory.."/graphics/technology/power/boiler/boiler-technology-light.png",
        tint = {1, 1, 1, 0}
    }
}

local oil_boiler_icon_extra = {
    {
        icon = inputs.directory.."/graphics/technology/power/oil-boiler/oil-boiler-technology-light.png",
        tint = {1, 1, 1, 0}
    }
}

-- Solar Energy
local technologies = {
    -- Solar Panels
    ["solar-energy"] = {tier = 1, prog_tier = 2, icon_name = "solar-energy"},
    ["bob-solar-energy-2"] = {tier = 1, prog_tier = 2, icon_name = "solar-energy"},
    ["bob-solar-energy-3"] = {tier = 2, prog_tier = 3, icon_name = "solar-energy"},
    ["bob-solar-energy-4"] = {tier = 3, prog_tier = 4, icon_name = "solar-energy"},

    -- Boilers
    ["bob-boiler-2"] = {tier = 2, icon_name = "boiler", technology_icon_extras = boiler_icon_extra},
    ["bob-boiler-3"] = {tier = 3, icon_name = "boiler", technology_icon_extras = boiler_icon_extra},
    ["bob-boiler-4"] = {tier = 4, icon_name = "boiler", technology_icon_extras = boiler_icon_extra},
    ["bob-boiler-5"] = {tier = 5, icon_name = "boiler", technology_icon_extras = boiler_icon_extra},

    -- Oil boilers
    ["bob-oil-boiler-1"] = {tier = 1, prog_tier = 2, icon_name = "oil-boiler", technology_icon_extras = oil_boiler_icon_extra},
    ["bob-oil-boiler-2"] = {tier = 2, prog_tier = 3, icon_name = "oil-boiler", technology_icon_extras = oil_boiler_icon_extra},
    ["bob-oil-boiler-3"] = {tier = 3, prog_tier = 4, icon_name = "oil-boiler", technology_icon_extras = oil_boiler_icon_extra},
    ["bob-oil-boiler-4"] = {tier = 4, prog_tier = 5, icon_name = "oil-boiler", technology_icon_extras = oil_boiler_icon_extra},

    -- Heat Exchangers
    ["bob-heat-exchanger-1"] = {tier = 1, prog_tier = 3, icon_name = "heat-exchanger", icon_base = "heat-exchanger-1"},
    ["bob-heat-exchanger-2"] = {tier = 2, prog_tier = 4, icon_name = "heat-exchanger", icon_base = "heat-exchanger-2"},
    ["bob-heat-exchanger-3"] = {tier = 3, prog_tier = 5, icon_name = "heat-exchanger", icon_base = "heat-exchanger-3"},
}

reskins.lib.create_icons_from_list(technologies, inputs)