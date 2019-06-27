
BI.Settings.Bio_Cannon = settings.startup["BI_Bio_Cannon"].value
BI.Settings.BI_Bio_Fuel = settings.startup["BI_Bio_Fuel"].value
BI.Settings.BI_Game_Tweaks_Stack_Size = settings.startup["BI_Game_Tweaks_Stack_Size"].value
BI.Settings.BI_Game_Tweaks_Recipe = settings.startup["BI_Game_Tweaks_Recipe"].value
BI.Settings.BI_Game_Tweaks_Tree = settings.startup["BI_Game_Tweaks_Tree"].value
BI.Settings.BI_Game_Tweaks_Player = settings.startup["BI_Game_Tweaks_Player"].value
BI.Settings.BI_Game_Tweaks_Disassemble = settings.startup["BI_Game_Tweaks_Disassemble"].value
BI.Settings.BI_Game_Tweaks_Bot = settings.startup["BI_Game_Tweaks_Bot"].value
BI.Settings.BI_Solar_Additions = settings.startup["BI_Solar_Additions"].value


----Update the Wood Pipe Images
require ("prototypes.Wood_Products.pipes")
--- Update the Rail Images


require ("prototypes.Wood_Products.wooden_rail_bridge_update")
--- Bridge Rail Remnants
require ("prototypes.Wood_Products.update_bridge_rails_remnants")
require ("prototypes.Wood_Products.tint_rails_remnants_function")


-- Concrete Rail
---- Update Standard Rails to use and look like concrete
set_tint_to_rails ({
data.raw["straight-rail"]["straight-rail"],
data.raw["curved-rail"]["curved-rail"]}, 
{r = 183/255, g = 183/255, b = 183/255, a = 1}) -- concrete
	
set_tint_to_remnants ({
data.raw["rail-remnants"]["straight-rail-remnants"],
data.raw["rail-remnants"]["curved-rail-remnants"]}, 
{r = 183/255, g = 183/255, b = 183/255, a = 1}) -- concrete

-- Wood Rail
set_tint_to_rails ({
data.raw["straight-rail"]["bi-straight-rail-wood"],
data.raw["curved-rail"]["bi-curved-rail-wood"]}, 
{r = 183/255, g = 125/255, b = 62/255, a = 1}) -- wood
	
set_tint_to_remnants ({
data.raw["rail-remnants"]["straight-rail-remnants-wood"],
data.raw["rail-remnants"]["curved-rail-remnants-wood"]}, 
{r = 183/255, g = 125/255, b = 62/255, a = 1}) -- wood

	--- Power Rail
set_tint_to_rails ({
data.raw["straight-rail"]["straight-rail"],
data.raw["curved-rail"]["curved-rail"]}, 
{r = 150/255, g = 150/255, b = 150/255, a = 1}) -- mix
	


-- vanilla rail icon & images update
data.raw["straight-rail"]["straight-rail"].icon = "__Bio_Industries__/graphics/icons/straight-rail-concrete.png"
data.raw["straight-rail"]["straight-rail"].icon_size = 32
data.raw["curved-rail"]["curved-rail"].icon = "__Bio_Industries__/graphics/icons/curved-rail-concrete.png"
data.raw["curved-rail"]["curved-rail"].icon_size = 32
data.raw["rail-planner"]["rail"].icon = "__Bio_Industries__/graphics/icons/rail-concrete.png"
data.raw["rail-planner"]["rail"].icon_size = 32


--- Wood Rail added to Tech 
thxbob.lib.tech.add_recipe_unlock("railway", "bi_recipe_rail_wood")

	
	
--- If Bob, move Vanilla Rail to Rail 2 also add Power Rail.
if data.raw.technology["bob-railway-2"] then
	thxbob.lib.tech.remove_recipe_unlock ("railway", "rail")
	thxbob.lib.tech.add_recipe_unlock("bob-railway-2", "rail")
	thxbob.lib.tech.add_recipe_unlock("bob-railway-2", "bi_recipe_rail_wood_to_concrete")
	thxbob.lib.tech.add_recipe_unlock("bob-railway-2", "bi_recipe_rail_wood_bridge")
	thxbob.lib.tech.add_recipe_unlock("bob-railway-2", "bi_rail_power")
	thxbob.lib.tech.add_recipe_unlock("bob-railway-2", "bi_recipe_power_to_rail_pole")
else
	thxbob.lib.tech.add_recipe_unlock("railway", "bi_recipe_rail_wood_to_concrete")
	thxbob.lib.tech.add_recipe_unlock("rail-signals", "bi_recipe_rail_wood_bridge")
	thxbob.lib.tech.add_recipe_unlock("rail-signals", "bi_rail_power")
	thxbob.lib.tech.add_recipe_unlock("rail-signals", "bi_recipe_power_to_rail_pole")
end
	
-- Damage Bonus to Ammo
-- Don't duplicate what NE does
if not mods["Natural_Evolution_Buildings"] then
	
	thxbob.lib.tech.add_recipe_unlock ("military", "bi_recipe_standard_dart_magazine")
	thxbob.lib.tech.add_recipe_unlock ("military-2", "bi_recipe_enhanced_dart_magazine")
	thxbob.lib.tech.add_recipe_unlock ("military-3", "bi_recipe_poison_dart_magazine")

end

require("prototypes.Bio_Turret.technology-updates")
require("prototypes.Bio_Cannon.technology-updates")

if not mods["Natural_Evolution_Buildings"] and BI.Settings.Bio_Cannon then

	-- add Prototype Artillery as pre req for artillery
	thxbob.lib.tech.add_prerequisite("artillery", "bi_tech_bio_cannon")
	
end

--- Move Stone Crusher up in tech tree
thxbob.lib.tech.add_recipe_unlock("steel-processing", "bi_recipe_stone_crusher")
thxbob.lib.tech.add_recipe_unlock("steel-processing", "bi_recipe_crushed_stone")

-- Add Wooden Chests
thxbob.lib.tech.add_recipe_unlock("logistics", "bi_recipe_large_wooden_chest")
thxbob.lib.tech.add_recipe_unlock("logistics-2", "bi_recipe_huge_wooden_chest")
thxbob.lib.tech.add_recipe_unlock("logistics-3", "bi_recipe_giga_wooden_chest")

	-- Add Big and Huge electric poles to tech tree
thxbob.lib.tech.add_recipe_unlock ("logistics", "bi_recipe_big_wooden_pole")
thxbob.lib.tech.add_recipe_unlock ("electric-energy-distribution-2", "bi_recipe_huge_wooden_pole")
	
--- Wood Floors
data.raw.item["wood"].place_as_tile =
	{
		result = "bi-wood-floor",
		condition_size = 4,
		condition = { "water-tile" }
	}
	


--- Make it so that the Base game tile "grass" can't be placed in blueprints
--- New as of 0.16
BI_Functions.lib.remove_from_blueprint("grass-1")
BI_Functions.lib.remove_from_blueprint("grass-2")
BI_Functions.lib.remove_from_blueprint("grass-3")
BI_Functions.lib.remove_from_blueprint("grass-4")


if mods["alien-biomes"] then

	BI_Functions.lib.remove_from_blueprint("frozen-snow-0")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-1")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-2")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-3")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-4")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-5")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-6")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-7")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-8")
	BI_Functions.lib.remove_from_blueprint("frozen-snow-9")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-aubergine-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-beige-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-black-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-black-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-black-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-black-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-black-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-black-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-black-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-black-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-black-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-brown-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-cream-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-dustyrose-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-grey-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-purple-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-red-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-red-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-red-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-red-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-red-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-red-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-red-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-red-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-red-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-tan-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-violet-sand-3")
	BI_Functions.lib.remove_from_blueprint("mineral-white-dirt-1")
	BI_Functions.lib.remove_from_blueprint("mineral-white-dirt-2")
	BI_Functions.lib.remove_from_blueprint("mineral-white-dirt-3")
	BI_Functions.lib.remove_from_blueprint("mineral-white-dirt-4")
	BI_Functions.lib.remove_from_blueprint("mineral-white-dirt-5")
	BI_Functions.lib.remove_from_blueprint("mineral-white-dirt-6")
	BI_Functions.lib.remove_from_blueprint("mineral-white-sand-1")
	BI_Functions.lib.remove_from_blueprint("mineral-white-sand-2")
	BI_Functions.lib.remove_from_blueprint("mineral-white-sand-3")
	BI_Functions.lib.remove_from_blueprint("vegetation-blue-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-blue-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-green-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-green-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-green-grass-3")
	BI_Functions.lib.remove_from_blueprint("vegetation-green-grass-4")
	BI_Functions.lib.remove_from_blueprint("vegetation-mauve-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-mauve-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-olive-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-olive-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-orange-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-orange-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-purple-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-purple-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-red-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-red-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-turquoise-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-turquoise-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-violet-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-violet-grass-2")
	BI_Functions.lib.remove_from_blueprint("vegetation-yellow-grass-1")
	BI_Functions.lib.remove_from_blueprint("vegetation-yellow-grass-2")
	BI_Functions.lib.remove_from_blueprint("volcanic-blue-heat-1")
	BI_Functions.lib.remove_from_blueprint("volcanic-blue-heat-2")
	BI_Functions.lib.remove_from_blueprint("volcanic-blue-heat-3")
	BI_Functions.lib.remove_from_blueprint("volcanic-blue-heat-4")
	BI_Functions.lib.remove_from_blueprint("volcanic-green-heat-1")
	BI_Functions.lib.remove_from_blueprint("volcanic-green-heat-2")
	BI_Functions.lib.remove_from_blueprint("volcanic-green-heat-3")
	BI_Functions.lib.remove_from_blueprint("volcanic-green-heat-4")
	BI_Functions.lib.remove_from_blueprint("volcanic-orange-heat-1")
	BI_Functions.lib.remove_from_blueprint("volcanic-orange-heat-2")
	BI_Functions.lib.remove_from_blueprint("volcanic-orange-heat-3")
	BI_Functions.lib.remove_from_blueprint("volcanic-orange-heat-4")
	BI_Functions.lib.remove_from_blueprint("volcanic-purple-heat-1")
	BI_Functions.lib.remove_from_blueprint("volcanic-purple-heat-2")
	BI_Functions.lib.remove_from_blueprint("volcanic-purple-heat-3")
	BI_Functions.lib.remove_from_blueprint("volcanic-purple-heat-4")

end


--- Adds Solar Farm, Solar Plant, Musk Floor, Bio Accumulator and Substation to Tech tree
if BI.Settings.BI_Solar_Additions then

	if data.raw.technology["bob-solar-energy-2"] then
		
		thxbob.lib.tech.add_recipe_unlock("bob-electric-energy-accumulators-3", "bi_recipe_accumulator")
		thxbob.lib.tech.add_recipe_unlock("electric-energy-distribution-2", "bi_recipe_huge_substation")
		thxbob.lib.tech.add_recipe_unlock("bob-solar-energy-2", "bi_recipe_bio_solar_farm")
		thxbob.lib.tech.add_recipe_unlock("bob-solar-energy-2", "bi_recipe_solar_boiler_panel")
		
	else

		thxbob.lib.tech.add_recipe_unlock("electric-energy-accumulators", "bi_recipe_accumulator")
		thxbob.lib.tech.add_recipe_unlock("electric-energy-distribution-2", "bi_recipe_huge_substation")
		thxbob.lib.tech.add_recipe_unlock("solar-energy", "bi_recipe_bio_solar_farm")
		thxbob.lib.tech.add_recipe_unlock("solar-energy", "bi_recipe_solar_boiler_panel")
		
	end	
	
	if data.raw.technology["bob-solar-energy-3"] then
		
		thxbob.lib.tech.add_recipe_unlock("bob-solar-energy-3", "bi_recipe_solar_mat")
		
	else

		thxbob.lib.tech.add_recipe_unlock("solar-energy", "bi_recipe_solar_mat")
	
	end	
	
	
	--- Electric redo if Bob' Electric
	-- Huge Electric Pole
	if data.raw.item["tinned-copper-cable"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_huge_wooden_pole", "wood")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_huge_wooden_pole", {type = "item", name = "tinned-copper-cable", amount = 15})
		
	end

	-- Solar Farm
	if data.raw.item["solar-panel-large"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_bio_solar_farm", "solar-panel")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_bio_solar_farm", {type = "item", name = "solar-panel-large", amount = 30})
		
	end

	-- Huge Sub Station
	if data.raw.item["substation-3"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_huge_substation", "substation")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_huge_substation", {type = "item", name = "substation-3", amount = 6})
		
	end
	
	if data.raw.item["electrum-alloy"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_huge_substation", "steel-plate")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_huge_substation", {type = "item", name = "electrum-alloy", amount = 10})
		
	end

	-- Huge Accumulator
	if data.raw.item["large-accumulator-2"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_accumulator", "accumulator")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_accumulator", {type = "item", name = "large-accumulator", amount = 30})
		
	end
	
	if data.raw.item["aluminium-plate"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_accumulator", "copper-cable")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_accumulator", {type = "item", name = "aluminium-plate", amount = 50})
		
	end
	
	-- Solar Mat
	if data.raw.item["aluminium-plate"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_solar_mat", "steel-plate")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_solar_mat", {type = "item", name = "aluminium-plate", amount = 1})
		
	end
	
	if data.raw.item["silicon-wafer"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_solar_mat", "copper-cable")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_solar_mat", {type = "item", name = "silicon-wafer", amount = 4})
		
	end

	-- Solar Boiler / Plant
	if data.raw.item["angels-electric-boiler"] then
	
		thxbob.lib.recipe.remove_ingredient ("bi_recipe_solar_boiler_panel", "boiler")
		thxbob.lib.recipe.add_new_ingredient ("bi_recipe_solar_boiler_panel", {type = "item", name = "angels-electric-boiler", amount = 1})
		
	end
	
end


require("prototypes.Bio_Farm.compatible_recipes") -- Bob and Angels mesh
require("prototypes.Bio_Farm.technology2")


if BI.Settings.BI_Bio_Fuel or mods["Natural_Evolution_Buildings"] then

	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_clean_air_2")
	
end

-- Adds Bio recipes
if BI.Settings.BI_Bio_Fuel then 

	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_bioreactor")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_cellulose_1")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_cellulose_2")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_biomass_1")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_biomass_2")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_biomass_3")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_battery")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_biomass_conversion_1")	
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_biomass_conversion_2")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_biomass_conversion_3")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_biomass_conversion_4")
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_acid")	
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_boiler")

	if mods["angelspetrochem"] then
		thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_sulfur_angels")	
	else
		thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_sulfur")	
	end
	
	thxbob.lib.recipe.add_new_ingredient("bi_recipe_adv_fertiliser_1", {type="fluid", name="bi-biomass", amount=10})
	thxbob.lib.recipe.add_new_ingredient("bi_recipe_adv_fertiliser_2", {type="fluid", name="bi-biomass", amount=10})

else
	
	thxbob.lib.recipe.add_new_ingredient("bi_recipe_adv_fertiliser_1", {type="item", name="fertiliser", amount=50})
	thxbob.lib.recipe.remove_ingredient ("bi_recipe_adv_fertiliser_2", "fertiliser")
	thxbob.lib.recipe.add_new_ingredient("bi_recipe_adv_fertiliser_2", {type="item", name="fertiliser", amount=30})
	
end

	
--- if the Alien Artifact is in the game, use if for some recipes
if data.raw.item["alien-artifact"] then

	--- Advanced Fertiliser will use Alien Artifact
	thxbob.lib.recipe.remove_ingredient ("bi_recipe_adv_fertiliser_1", "bi-biomass")
	thxbob.lib.recipe.add_new_ingredient("bi_recipe_adv_fertiliser_1", {type="item", name="alien-artifact", amount=5})
	thxbob.lib.tech.add_recipe_unlock("bi_tech_advanced_biotechnology", "bi_recipe_adv_fertiliser_1")	
	
end	


------- Adds a Mk3 recipe for wood if you're playing with Natural Evolution Buildings
if mods["Natural_Evolution_Buildings"] then
		
	thxbob.lib.recipe.remove_ingredient ("bi_recipe_adv_fertiliser_1", "bi-biomass")	
	thxbob.lib.recipe.remove_ingredient ("bi_recipe_adv_fertiliser_1", "alien-artifact")
	thxbob.lib.recipe.add_new_ingredient ("bi_recipe_adv_fertiliser_1", {type="fluid", name="NE_enhanced-nutrient-solution", amount=50})

end


------------ Support for Bob's Greenhouse
if data.raw["item"]["bob-greenhouse"] then 

	data.raw["item"]["seedling"].place_result = "seedling"
	data.raw["item"]["seedling"].icon = "__Bio_Industries__/graphics/icons/Seedling.png"
	data.raw["item"]["seedling"].icon_size = 32
	data.raw["item"]["fertiliser"].icon = "__Bio_Industries__/graphics/icons/fertiliser_32.png"
	data.raw["item"]["fertiliser"].icon_size = 32
	
	if mods["alien-biomes"] then
		data.raw["item"]["fertiliser"].place_as_tile = {result = "vegetation-green-grass-3",	condition_size = 1,	condition = { "water-tile" }}
	else
		data.raw["item"]["fertiliser"].place_as_tile = {result = "grass-3",	condition_size = 1,	condition = { "water-tile" }}
	end
		
end



if settings.startup["angels-use-angels-barreling"] and settings.startup["angels-use-angels-barreling"].value then
   data.raw.technology["bi_tech_fertiliser"].prerequisites = 
      {
         "bi_tech_bio_farming",
         -- AND (
         "water-treatment", -- sulfur
         -- OR
         "angels-fluid-barreling", -- barreling (needed 'water-treatment' as prerequisites)
         -- )
      }
end


----- Angels Merge ----
if mods["angelspetrochem"] then

    data.raw.item["pellet-coke"].icon = "__angelspetrochem__/graphics/icons/pellet-coke.png"
	data.raw.item["pellet-coke"].icon_size = 32
	data.raw.item["pellet-coke"].fuel_acceleration_multiplier = 1.1
	data.raw.item["pellet-coke"].fuel_top_speed_multiplier = 1.2
	
	data.raw.recipe["pellet-coke"].category = "biofarm-mod-smelting"	
	thxbob.lib.tech.remove_recipe_unlock ("angels-coal-processing-2", "pellet-coke")
	thxbob.lib.tech.add_recipe_unlock("angels-coal-cracking", "pellet-coke")

end


if data.raw.item["ash"] and mods["pycoalprocessing"] then
	-- # grep -E "(name|result)\s*=\s*.bi-ash" -rn *

	-- Bio_Farm/compatible_recipes.lua:30:                  {type="item", name="bi-ash", amount=10}
	thxbob.lib.recipe.replace_ingredient ("bi_recipe_fertiliser_2", "bi-ash", "ash")

	-- Bio_Farm/compatible_recipes.lua:201:                         {type="item", name="bi-ash", amount=40},
	if mods["angelsrefining"] then
		thxbob.lib.recipe.replace_ingredient ("bi_recipe_slag_slurry", "bi-ash", "ash")
	end

	-- Bio_Farm/recipe.lua:42:                      {type="item", name="bi-ash", amount=10},
	thxbob.lib.recipe.replace_ingredient ("bi_recipe_seed_2", "bi-ash", "ash")
	-- Bio_Farm/recipe.lua:144:               {type="item", name="bi-ash", amount=10},
	thxbob.lib.recipe.replace_ingredient ("bi_recipe_seedling_mk2", "bi-ash", "ash")
	-- Bio_Farm/recipe.lua:251:               {type="item", name="bi-ash", amount=10},
	thxbob.lib.recipe.replace_ingredient ("bi_recipe_logs_mk2", "bi-ash", "ash")

	-- Bio_Farm/recipe.lua:451:             result = "bi-ash",
	data.raw.recipe["bi_recipe_ash_1"].result = "ash"
	-- Bio_Farm/recipe.lua:471:             result = "bi-ash",
	data.raw.recipe["bi_recipe_ash_2"].result = "ash"

	-- Bio_Farm/recipe.lua:609:               {type="item", name="bi-ash", amount=2},
	thxbob.lib.recipe.replace_ingredient ("bi_recipe_stone_brick", "bi-ash", "ash")
	-- Bio_Farm/recipe.lua:746:                     {type="item", name="bi-ash", amount=10}
	thxbob.lib.recipe.replace_ingredient ("bi_recipe_fertiliser_1", "bi-ash", "ash")

	if BI.Settings.BI_Bio_Fuel then
		-- Bio_Fuel/recipe.lua:209:                             {type="item", name="bi-ash", amount=10},
		thxbob.lib.recipe.replace_ingredient ("bi_recipe_biomass_2", "bi-ash", "ash")
		-- Bio_Fuel/recipe.lua:401:                             {type="item", name="bi-ash", amount=10},
		thxbob.lib.recipe.replace_ingredient ("bi_recipe_sulfur", "bi-ash", "ash")
		-- Bio_Fuel/recipe.lua:425:                             {type="item", name="bi-ash", amount=10},
		thxbob.lib.recipe.replace_ingredient ("bi_recipe_sulfur_angels", "bi-ash", "ash")
	end

	-- Bio_Farm/item.lua:105:               name = "bi-ash",
	data.raw.item["bi-ash"] = nil
	data.raw.recipe["bi_recipe_ash_1"].icon = "__pycoalprocessing__/graphics/icons/ash.png"
	data.raw.recipe["bi_recipe_ash_1"].icon_size = 32
	data.raw.recipe["bi_recipe_ash_2"].icon = "__pycoalprocessing__/graphics/icons/ash.png"
	data.raw.recipe["bi_recipe_ash_2"].icon_size = 32
	
end

----- If Bob's bobrevamp, then ----
if mods["bobrevamp"] then
	
	thxbob.lib.tech.remove_recipe_unlock ("bi-tech-coal-processing-1", "bi_recipe_solid_fuel")
	thxbob.lib.tech.add_recipe_unlock("solid-fuel", "bi_recipe_solid_fuel")

end


--- Enable Productivity in Recipies
BI_Functions.lib.allow_productivity("bi_recipe_seed_1")
BI_Functions.lib.allow_productivity("bi_recipe_seed_2")
BI_Functions.lib.allow_productivity("bi_recipe_seed_3")
BI_Functions.lib.allow_productivity("bi_recipe_seed_4")

BI_Functions.lib.allow_productivity("bi_recipe_seedling_mk1")
BI_Functions.lib.allow_productivity("bi_recipe_seedling_mk2")
BI_Functions.lib.allow_productivity("bi_recipe_seedling_mk3")
BI_Functions.lib.allow_productivity("bi_recipe_seedling_mk4")

BI_Functions.lib.allow_productivity("bi_recipe_logs_mk1")
BI_Functions.lib.allow_productivity("bi_recipe_logs_mk2")
BI_Functions.lib.allow_productivity("bi_recipe_logs_mk3")
BI_Functions.lib.allow_productivity("bi_recipe_logs_mk4")

BI_Functions.lib.allow_productivity("bi_recipe_stone_brick")

BI_Functions.lib.allow_productivity("bi_recipe_resin_pulp")
BI_Functions.lib.allow_productivity("bi_recipe_press_wood")
BI_Functions.lib.allow_productivity("bi_recipe_resin_wood")
BI_Functions.lib.allow_productivity("bi_recipe_woodpulp")

BI_Functions.lib.allow_productivity("bi_recipe_liquid_air")
BI_Functions.lib.allow_productivity("bi_recipe_nitrogen")

BI_Functions.lib.allow_productivity("bi_recipe_biomass_1")
BI_Functions.lib.allow_productivity("bi_recipe_biomass_2")
BI_Functions.lib.allow_productivity("bi_recipe_biomass_3")

BI_Functions.lib.allow_productivity("bi_recipe_biomass_conversion_1")
BI_Functions.lib.allow_productivity("bi_recipe_biomass_conversion_2")
BI_Functions.lib.allow_productivity("bi_recipe_biomass_conversion_3")
BI_Functions.lib.allow_productivity("bi_recipe_biomass_conversion_4")

BI_Functions.lib.allow_productivity("bi_recipe_battery")
BI_Functions.lib.allow_productivity("bi_recipe_acid")
BI_Functions.lib.allow_productivity("bi_recipe_sulfur")
BI_Functions.lib.allow_productivity("bi_recipe_sulfur_angels")
BI_Functions.lib.allow_productivity("bi_recipe_plastic_1")
BI_Functions.lib.allow_productivity("bi_recipe_plastic_2")
BI_Functions.lib.allow_productivity("bi_recipe_cellulose_1")
BI_Functions.lib.allow_productivity("bi_recipe_cellulose_2")

