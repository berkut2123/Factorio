local OV = angelsmods.functions.OV
--replacement tables
require("prototypes.overrides.replacement-fallbacks")
--set local table for use in multiple functions
local building_types = {
  "assembling-machine",
  "mining-drill",
  "lab",
  "furnace",
  "offshore-pump",
  "pump",
  "rocket-silo",
  "radar",
  "beacon",
  "boiler",
  "generator",
  "solar-panel",
  "accumulator",
  "reactor",
  "electric-pole",
  "wall",
  "gate"
}

function pack_replace(techname, old_c, new_c) --tech tier swapping script (for cleaner code)
  OV.remove_science_pack(techname, "angels-science-pack-" .. old_c)
  OV.set_science_pack(techname, "angels-science-pack-" .. new_c)
end

function core_replace(techname, old_c, new_c, tier) -- tech core swapping script
  tier = tier or 1
  if old_c == "basic" then
    OV.remove_science_pack(techname, "datacore-basic")
  else
    OV.remove_science_pack(techname, "datacore-" .. old_c .. "-1")
    OV.remove_science_pack(techname, "datacore-" .. old_c .. "-2")
  end
  if new_c == "basic" then
    OV.set_science_pack(techname, "datacore-basic", 2)
  else
    OV.set_science_pack(techname, "datacore-" .. new_c .. "-" .. tier, 2)
  end
end

function pre_req_replace(techname, old_tech, new_tech1, new_tech2) -- tech prerequisite replacements
  OV.remove_prereq(techname, old_tech)
  OV.add_prereq(techname, new_tech1)
  if new_tech2 then
    OV.add_prereq(techname, new_tech2)
  end
end

function core_tier_up(techname, core_n)
  OV.remove_science_pack(techname, "datacore-" .. core_n .. "-1")
  OV.set_science_pack(techname, "datacore-" .. core_n .. "-2", 2)
end

function set_core(techname, core_n)
  local has_core = false
  for _, pack in pairs((data.raw.technology[techname] or {unit = {ingredients = {}}}).unit.ingredients) do
    local packname = pack.name or pack[1]
    if string.find(packname, "datacore") ~= nil then
      if packname == core_n then
        has_core = true
      else
        OV.remove_science_pack(techname, packname)
      end
    end
  end
  if not has_core then
    OV.set_science_pack(techname, core_n, 2)
  end
end

function core_builder()
  -- Start of research Automated Stack...
  for rec_4tech in pairs(data.raw.technology) do
    if angelsmods.functions.check_exception(rec_4tech, angelsmods.industries.tech_exceptions) then
      --personal-equipment and other enhancements take priority
      if
        string.find(rec_4tech, "module") ~= nil or string.find(rec_4tech, "equipment") ~= nil or
          string.find(rec_4tech, "armor") ~= nil or
          string.find(rec_4tech, "axe") ~= nil or
          string.find(rec_4tech, "personal") ~= nil
       then
        --war takes next priority
        set_core(rec_4tech, "datacore-enhance-1", 2)
      elseif
        string.find(rec_4tech, "military") ~= nil or string.find(rec_4tech, "laser") ~= nil or
          string.find(rec_4tech, "combat") ~= nil or
          string.find(rec_4tech, "damage") ~= nil or
          string.find(rec_4tech, "shell") ~= nil or
          string.find(rec_4tech, "flam") ~= nil or
          string.find(rec_4tech, "bullet") ~= nil or
          string.find(rec_4tech, "rocket") ~= nil
       then
        --exploration is next
        set_core(rec_4tech, "datacore-war-1", 2)
      elseif string.find(rec_4tech, "explor") ~= nil then
        --energy is next
        set_core(rec_4tech, "datacore-exploration-1", 2)
      elseif
        string.find(rec_4tech, "energy") ~= nil or string.find(rec_4tech, "power") ~= nil or
          string.find(rec_4tech, "cabling") ~= nil or
          string.find(rec_4tech, "steam-engine") ~= nil or
          string.find(rec_4tech, "heat") ~= nil or
          string.find(rec_4tech, "turbine") ~= nil or
          string.find(rec_4tech, "reactor") ~= nil or
          string.find(rec_4tech, "pole") ~= nil or
          string.find(rec_4tech, "substation") ~= nil or
          string.find(rec_4tech, "boiler") ~= nil
       then
        --logistics is next
        set_core(rec_4tech, "datacore-energy-1", 2)
      elseif
        string.find(rec_4tech, "insert") ~= nil or string.find(rec_4tech, "logistic") ~= nil or
          string.find(rec_4tech, "rail") ~= nil or
          string.find(rec_4tech, "train") ~= nil or
          string.find(rec_4tech, "braking") ~= nil or
          string.find(rec_4tech, "robot") ~= nil or
          string.find(rec_4tech, "fluid") ~= nil or
          string.find(rec_4tech, "warehouse") ~= nil
       then
        --production is up next
        set_core(rec_4tech, "datacore-logistic-1", 2)
      elseif
        string.find(rec_4tech, "processing") ~= nil or string.find(rec_4tech, "automation") ~= nil or
          string.find(rec_4tech, "plastic") ~= nil or
          string.find(rec_4tech, "mining") ~= nil or
          string.find(rec_4tech, "research") ~= nil or
          string.find(rec_4tech, "battery") ~= nil or
          string.find(rec_4tech, "electronic") ~= nil
       then
        --smelting and metallurgy
        set_core(rec_4tech, "datacore-processing-1", 2)
      elseif
        string.find(rec_4tech, "smelting") ~= nil or string.find(rec_4tech, "casting") ~= nil or
          string.find(rec_4tech, "metallurgy") ~= nil or
          string.find(rec_4tech, "cool") ~= nil
       then
        --Bioprocessing updates
        set_core(rec_4tech, "datacore-processing-1", 2)
      elseif
        string.find(rec_4tech, "bio") ~= nil or string.find(rec_4tech, "farm") ~= nil or
          string.find(rec_4tech, "arbor") ~= nil or
          string.find(rec_4tech, "cool") ~= nil or
          string.find(rec_4tech, "garden") ~= nil
       then
        --more war updates
        set_core(rec_4tech, "datacore-processing-1", 2)
      elseif
        string.find(rec_4tech, "wall") ~= nil or string.find(rec_4tech, "gate") ~= nil or
          string.find(rec_4tech, "shoot") ~= nil or
          string.find(rec_4tech, "turret") ~= nil or
          string.find(rec_4tech, "explo") ~= nil
       then
        --petrochem and refining updates
        set_core(rec_4tech, "datacore-war-1", 2)
      elseif
        string.find(rec_4tech, "chemistry") ~= nil or string.find(rec_4tech, "ore") ~= nil or
          string.find(rec_4tech, "crack") ~= nil or
          string.find(rec_4tech, "science-pack") ~= nil or
          string.find(rec_4tech, "water") ~= nil
       then
        set_core(rec_4tech, "datacore-processing-1", 2)
      end
    end
  end
end

function pack_count_update(tech, pack, count) --cheap and cheerful replacement (possibly should use a better script but if it works...)
  OV.remove_science_pack(tech, pack)
  OV.set_science_pack(tech, pack, count)
end

--MODIFY ALL TECHS ACCORDING TO TIERS
angelsmods.industries.techtiers = {
  grey = {amount = 16, time = 10}, --BURNER
  red = {amount = 64, time = 20}, --AUTOMATION
  green = {amount = 128, time = 30}, --TRAINS
  orange = {amount = 256, time = 40}, --OIL
  blue = {amount = 512, time = 50}, --ROBOTS
  yellow = {amount = 1024, time = 60}, --ENDGAME
  white = {amount = 2024, time = 75} --MEGABASE
}

angelsmods.marathon.tech_amount_multi = 1
angelsmods.marathon.tech_time_multi = 1

local function set_research_tiers(tech_name, tech_time, tech_amount)
  if data.raw.technology[tech_name] and (data.raw.technology[tech_name].unit or {}).count then
    OV.set_research_difficulty(tech_name, tech_time, tech_amount)
  else
    -- todo: what in the case of a count_formula?
  end
end

function tech_unlock_reset()
  for techname, technology in pairs(data.raw.technology) do
    if angelsmods.functions.check_exception(techname, angelsmods.industries.tech_exceptions) then
      --SET AMOUNT AND TIME REQUIRED FOR TECH TO FINISH
      if technology.unit.ingredients and not technology.max_level and technology.unit.ingredients[1] then
        for i, ingredients in pairs(technology.unit.ingredients[1]) do
          if ingredients == "angels-science-pack-grey" and techname ~= "tech-specialised-labs" then
            OV.add_prereq(techname, "tech-specialised-labs")
            set_research_tiers(
              techname,
              angelsmods.industries.techtiers.grey.time * angelsmods.marathon.tech_time_multi,
              angelsmods.industries.techtiers.grey.amount * angelsmods.marathon.tech_amount_multi
            )
          end
          if ingredients == "angels-science-pack-red" then
            OV.add_prereq(techname, "tech-red-packs")
            set_research_tiers(
              techname,
              angelsmods.industries.techtiers.red.time * angelsmods.marathon.tech_time_multi,
              angelsmods.industries.techtiers.red.amount * angelsmods.marathon.tech_amount_multi
            )
          end
          if ingredients == "angels-science-pack-green" then
            OV.add_prereq(techname, "tech-green-packs")
            set_research_tiers(
              techname,
              angelsmods.industries.techtiers.green.time * angelsmods.marathon.tech_time_multi,
              angelsmods.industries.techtiers.green.amount * angelsmods.marathon.tech_amount_multi
            )
          end
          if ingredients == "angels-science-pack-orange" then
            OV.add_prereq(techname, "tech-orange-packs")
            set_research_tiers(
              techname,
              angelsmods.industries.techtiers.orange.time * angelsmods.marathon.tech_time_multi,
              angelsmods.industries.techtiers.orange.amount * angelsmods.marathon.tech_amount_multi
            )
          end
          if ingredients == "angels-science-pack-blue" then
            OV.add_prereq(techname, "tech-blue-packs")
            set_research_tiers(
              techname,
              angelsmods.industries.techtiers.blue.time * angelsmods.marathon.tech_time_multi,
              angelsmods.industries.techtiers.blue.amount * angelsmods.marathon.tech_amount_multi
            )
          end
          if ingredients == "angels-science-pack-yellow" then
            OV.add_prereq(techname, "tech-yellow-packs")
            set_research_tiers(
              techname,
              angelsmods.industries.techtiers.yellow.time * angelsmods.marathon.tech_time_multi,
              angelsmods.industries.techtiers.yellow.amount * angelsmods.marathon.tech_amount_multi
            )
          end
          if ingredients == "angels-science-pack-white" then
            OV.add_prereq(techname, "space-science-pack")
            set_research_tiers(
              techname,
              angelsmods.industries.techtiers.white.time * angelsmods.marathon.tech_time_multi,
              angelsmods.industries.techtiers.white.amount * angelsmods.marathon.tech_amount_multi
            )
          end
        end
      end
    end
  end
end

function core_tier_upgrade()
  for techname, technology in pairs(data.raw.technology) do
    -- find the science pack and the datacore
    local pack_name = nil
    local core_name = nil
    for _, pack in pairs(technology.unit and technology.unit.ingredients or {}) do
      local pack_n = pack[1] or pack.name or ""
      if string.find(pack_n, "angels") and string.find(pack_n, "science") and string.find(pack_n, "pack") then
        pack_name = pack_n
      elseif string.find(pack_n, "datacore") then
        core_name = pack_n
      end
    end

    -- now update the core if required and also depend on the correct tech
    if pack_name then
      if core_name then
        core_type = string.sub(core_name, 9, -2)
        if string.sub(core_type, 1, 1) == "-" and string.sub(core_type, -1, -1) == "-" then
          local research_type = string.sub(core_type, 2, -2)

          local tech_prereq = {
            ["grey"] = "tech-specialised-labs",
            ["red"] = "tech-specialised-labs-basic-%s-1",
            ["green"] = "tech-specialised-labs-basic-%s-2",
            ["orange"] = "tech-specialised-labs-basic-%s-3",
            ["blue"] = "tech-specialised-labs-advanced-%s-1",
            ["yellow"] = "tech-specialised-labs-advanced-%s-2",
            ["white"] = "tech-specialised-labs-advanced"
          }
          for pack_color, tier_up in pairs(
            {
              ["white"] = true,
              ["yellow"] = true,
              ["blue"] = true,
              ["orange"] = false,
              ["green"] = false,
              ["red"] = false,
              --["grey"] = false
            }
          ) do
            if pack_name == string.format("angels-science-pack-%s", pack_color) then
              if tier_up then
                core_tier_up(techname, research_type)
              end

              if research_type ~= "basic" then
                OV.remove_prereq(techname, string.format("tech-%s-packs", pack_color))
                OV.add_prereq(techname, string.format(tech_prereq[pack_color], research_type))
              end
            end
          end
        end
      elseif angelsmods.functions.check_exception(techname, angelsmods.industries.tech_exceptions) then
        set_core(techname, "datacore-basic", 2)

        if pack_name == "angels-science-pack-grey" then
          OV.add_prereq(techname, "tech-specialised-labs")
        elseif techname ~= "tech-specialised-labs-basic" then
          OV.add_prereq(techname, "tech-specialised-labs-basic")
        end
      end
    end
  end
end

--gets the row count so you can iterate through row count
function table_rows(table_chk)
  local ct = 0
  if type(table_chk) == "table" then
    for _ in pairs(table_chk) do
      ct = ct + 1
    end
  end
  return ct
end

--ADD BUILDING BLOCKS TO BUILDINGS
function add_con_mats()
  for n, _ in pairs(building_types) do
    replace_con_mats(building_types[n])
  end
end

function add_minable_results()
  for n, _ in pairs(building_types) do
    replace_minable_results(building_types[n])
  end
end

-- uses block_replace table from /overrides/replacement-fallbacks.lua
function replace_blocks_list(ing_list) --specifically build to be used for replace_con_mats function
  local block_replace = angelsmods.industries.block_replace
  --reset existing each call
  local existing = {}
  --run through each list first and check if it exists
  for ni, _ in pairs(ing_list) do
    existing[ni] = {name = ing_list[ni].name, amount = ing_list[ni].amount}
  end
  --now do the replacements -- id rather not have to do a double loop
  for n, _ in pairs(ing_list) do
    nme = ing_list[n].name
    if block_replace[nme] then
      new = block_replace[nme].new
      amt_multi = block_replace[nme].amt_multi
      if existing[new] then
        --if it exists, just add more? may just remove this
        if ing_list[n].amount and ing_list[n].amount ~= existing[new][amount] then
          diff = existing[new][amount] - ing_list[n].amount
          ing_list[n].amount = 0
          for ch, _ in pairs(ing_list) do
            if new == ing_list[ch].name then
              ing_list[ch].amount = ing_list[ch].amount + diff
            end
          end
        end
      else --check if replacement is already listed
        ing_list[n].name = block_replace[nme].new
        ing_list[n].amount = math.ceil((ing_list[n].amount or 1) * amt_multi)
      end
    -- else not on the replacement list
    end
  end
end

--Replace non-construction components with angels components
-- uses general_replace table from /overrides/replacement-fallbacks.lua
function replace_gen_mats()
  for nme, info in pairs(angelsmods.industries.general_replace) do
    if nme and data.raw.item[nme] then
      OV.global_replace_item(nme, info.new)
      data.raw.recipe[nme].hidden = true
      data.raw.item[nme].hidden = true
      OV.disable_recipe({nme})
      --in case hiding is not enough
      angelsmods.functions.add_flag(nme, "hidden")
      if info.unlock_by then
        OV.remove_unlock(info.unlock_by, nme)
        if info.alt_rec and data.raw.recipe[alt_rec] then --check if recipe actually exists
          OV.remove_unlock(info.unlock_by, alt_rec)
        end
      end
      if info.alt_rec and data.raw.recipe[alt_rec] then --check if recipe actually exists
        data.raw.recipe[alt_rec].hidden = true
      end
    end
  end
  OV.execute()
end

--REPLACE CONSTRUCTION BLOCKS
function replace_con_mats(buildings)
  for assembly_check, build in pairs(data.raw[buildings]) do
    if data.raw.recipe[assembly_check] then
      local rec_check = data.raw.recipe[assembly_check]
      if rec_check.normal or rec_check.expensive then
        if rec_check.normal then
          ing_list = rec_check.normal.ingredients
          replace_blocks_list(ing_list)
          rec_check.normal.energy_required = 0.5
        end
        if rec_check.expensive then
          ing_list = rec_check.expensive.ingredients
          replace_blocks_list(ing_list)
          rec_check.expensive.energy_required = 0.5
        end
      else
        ing_list = rec_check.ingredients
        replace_blocks_list(ing_list)
        rec_check.energy_required = 0.5
      end
    end
  end
end

--REPLACE ON MINED RESULTS
function replace_minable_results(buildings)
  for assembly_check, build in pairs(data.raw[buildings]) do
    if data.raw.recipe[assembly_check] then
      local rec_check = data.raw.recipe[assembly_check]
      if rec_check.normal then
        ing_list = rec_check.normal.ingredients
      else
        ing_list = rec_check.ingredients
      end
      if data.raw[build.type][assembly_check].minable then
        data.raw[build.type][assembly_check].minable.results = ing_list
      end
    end
  end
end
