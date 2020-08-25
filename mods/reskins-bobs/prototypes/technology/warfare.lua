-- Copyright (c) 2020 Kirazy
-- Part of Artisanal Reskins: Bob's Mods
--     
-- See LICENSE.md in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["bobwarfare"] then return end

-- Setup inputs
local inputs = {
    directory = reskins.bobs.directory,
    mod = "bobs",
    group = "warfare",
    type = "technology",
}

local technology = {
    -- Radars
    ["radars"] = {tier = 2, icon_name = "radar"},
    ["radars-2"] = {tier = 3, icon_name = "radar"},
    ["radars-3"] = {tier = 4, icon_name = "radar"},
    ["radars-4"] = {tier = 5, icon_name = "radar"},

    -- Miscellaneous
    ["reinforced-wall"] = {flat_icon = true}
}

reskins.lib.create_icons_from_list(technology, inputs)