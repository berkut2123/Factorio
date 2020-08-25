-- Copyright (c) 2020 Kirazy
-- Part of Artisanal Reskins: Bob's Mods
--     
-- See LICENSE.md in the project directory for license information.

-- Check to see if reskinning needs to be done.
if not mods["bobrevamp"] then return end

-- Setup standard inputs
local inputs = {
    directory = reskins.bobs.directory,
    mod = "bobs",
    group = "revamp",
    type = "technology",
}

-- Automation (Assembling Machines)
local technologies = {
    -- Chemical plant
    ["chemical-plant"] = {group = "assembly", tier = 1, prog_tier = 2, icon_name = "chemical-plant"},
}

reskins.lib.create_icons_from_list(technologies, inputs)