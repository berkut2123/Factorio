if mods["angelsbioprocessing"] then
	omni.lib.add_prerequisite("bio-processing-brown","omnialgae")

	omni.lib.remove_unlock_recipe("bio-processing-green","algae-farm")

	omni.lib.add_recipe_ingredient("algae-green",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-green-simple",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-brown",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-red",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-blue",{type="item",name="omnialgae",amount=40})

	for i=1,3 do
		local rec = data.raw.recipe["wood-sawing-"..i]
		omni.marathon.standardise(rec)
		for _,dif in pairs({"normal","expensive"}) do
			rec[dif].results[1].name="omniwood"
			rec[dif].main_product = "omniwood"
		end
		rec.icons[1].icon = data.raw.item["omniwood"].icons[1].icon
		rec.icons[1].icon_size = data.raw.item["omniwood"].icons[1].icon_size
		rec.icons[1].scale = 1
		rec.localised_name = {"item-name.omniwood"}
	end

	RecGen:create("omnimatter_wood","omnialgae"):
	setStacksize(500):
	setSubgroup("algae"):
	setTechName():
	setTechPrereq("omnimutator"):
	setTechIcon("angelsbioprocessing","algae-farm-tech"):
	setTechCost(250):
	setTechTime(15):
	setCategory("bio-processing"):
	setSubgroup("bio-processing-purple"):
	setIngredients({
	{type="fluid",name="omnic-acid",amount=144},
	{type="item",name="omnite",amount=24},
	}):
	setResults({type="item",name="omnialgae", amount = 144}):extend()
	omni.lib.add_unlock_recipe("omnialgae","algae-farm")
data:extend({{
    type = "item-subgroup",
    name = "bio-processing-purple",
	group = "bio-processing-nauvis",
	order = "a",
  }})
  data.raw.recipe["algae-green"].icons = nil
  data.raw.recipe["algae-green"].icon = data.raw.recipe["algae-green-simple"].icon
  data.raw.recipe["algae-green-simple"].hidden = false
end

RecGen:importIf("solid-soil"):setCategory("omnimutator"):addIngredients({type="fluid",name="omnic-acid",amount=20}):setTechName("omnimutator"):extend()