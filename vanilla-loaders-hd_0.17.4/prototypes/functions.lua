-- Initialize function storage
if not vanillaHD then vanillaHD = {} end

-- Create color masks
vanillaHD.tint_mask = {
	["basic-loader"]   = {r = 227, g = 227, b = 227}, -- Corrected 6-1-2019
	["loader"] 		     = {r = 240, g = 199, b =  86}, -- Corrected 6-1-2019
	["fast-loader"]    = {r = 227, g =  68, b =  68}, -- Corrected 6-1-2019
	["express-loader"] = {r =  92, g = 200, b = 250}, -- Corrected 6-1-2019
	["purple-loader"]  = {r = 199, g =  69, b = 255}, -- Corrected 6-1-2019
	["green-loader"]   = {r =  74, g = 255, b = 137}, -- Corrected 6-1-2019
}

-- Used to patch loader entities, or create new ones, with vanilla-style graphics.
function vanillaHD.patchLoaderEntity(loader)
	if loader then
		local name = loader.name

		-- Allow loaders to render at the same level as splitters, underground belts.
		loader.structure_render_layer = "transport-belt-circuit-connector"

		-- Set flags
		loader.flags = {"placeable-neutral", "placeable-player", "player-creation", "fast-replaceable-no-build-while-moving"}
		
		-- Specifies the entity icons used by the game to generate alert messages
		loader.icons  = 
		{
			{
				icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-base.png"
			},
			{
				icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-mask.png",
				tint = vanillaHD.tint_mask[name]
			}
		}
		
		loader.structure.direction_in.sheets = 
		{
			{
				filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-base.png",				
				width    = 96,
				height   = 96,
				y        = 0,
				hr_version = 
				{
					filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-base.png",
					height   = 192,
					priority = "extra-high",
					scale    = 0.5,
					width    = 192,
					y        = 0
				}
			},
			{
				filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-mask.png",			
				width    = 96,
				height   = 96,
				y        = 0,
				tint	 = vanillaHD.tint_mask[name],
				hr_version = 
				{
					filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-mask.png",
					height   = 192,
					priority = "extra-high",
					scale    = 0.5,
					width    = 192,
					y        = 0,
					tint     = vanillaHD.tint_mask[name]
				}
			}
		}
		loader.structure.direction_out.sheets = 
		{
			{
				filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-base.png",			
				width    = 96,
				height   = 96,
				y        = 96,
				hr_version = 
				{
					filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-base.png",
					height   = 192,
					priority = "extra-high",
					scale    = 0.5,
					width    = 192,
					y        = 192
				}
			},
			{
				filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-mask.png",			
				width    = 96,
				height   = 96,
				y        = 96,
				tint	 = vanillaHD.tint_mask[name],
				hr_version = 
				{
					filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-mask.png",
					height   = 192,
					priority = "extra-high",
					scale    = 0.5,
					width    = 192,
					y        = 192,
					tint     = vanillaHD.tint_mask[name]
				}
			}
		}

		--[[ Waiting on the day these are supported...!
		-- Add back flange beneath items on the belt
		loader.structure.back_patch =
		{
		  sheet =
		  {
			filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-back-patch.png",
			priority = "extra-high",
			width = 96,
			height = 96,
			hr_version =
			{
			  filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-back-patch.png",
			  priority = "extra-high",
			  width = 192,
			  height = 192,
			  scale = 0.5
			}
		  }
		}

		-- Little piece of texture that extends into territory occupied by items while on belt, but rendered beneath them.
		loader.structure.front_patch =
		{
		  sheet =
		  {
			filename = "__vanilla-loaders-hd__/graphics/entity/loader/loader-structure-front-patch.png",
			priority = "extra-high",
			width = 96,
			height = 96,
			hr_version =
			{
			  filename = "__vanilla-loaders-hd__/graphics/entity/loader/hr-loader-structure-front-patch.png",
			  priority = "extra-high",
			  width = 192,
			  height = 192,
			  scale = 0.5
			}
		  }
		}]]
	end
end

-- Used to create new loader entities
function vanillaHD.createLoaderEntity(name, beltname)
	if data.raw["transport-belt"][beltname] then
		local loader = table.deepcopy(data.raw["loader"]["loader"])
		local basebelt = data.raw["transport-belt"][beltname]
		loader.name            = name
		loader.minable.result  = name
		
		-- Inherit graphics from tier-appropriate belts
		loader.belt_animation_set = basebelt.belt_animation_set

		-- Inherit speed from tier-appropriate belts
		loader.speed = basebelt.speed

		-- Generate entity graphics
		vanillaHD.patchLoaderEntity(loader)

		data:extend({loader})
	end
end

function vanillaHD.patchBeltGraphics(name, beltname)
    local loader = data.raw["loader"][name]
    local basebelt = data.raw["transport-belt"][beltname]

    -- Inherit graphics from tier-appropriate belts
	loader.belt_animation_set = basebelt.belt_animation_set
end

-- Patch existing loader items, or create new ones, with vanilla-style graphics
function vanillaHD.patchLoaderItem(item, beltname, subgroup)
	if item then
		local baseitem = data.raw["item"][beltname]
		local name = item.name
		
		-- Optional parameter
		subgroup = subgroup or baseitem.subgroup

		-- Clear existing presets
		item.flags = nil
		item.icon = nil
		
		-- Main function
		item.icons  = 
		{
			{
				icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-base.png"
			},
			{
				icon = "__vanilla-loaders-hd__/graphics/icons/loader-icon-mask.png",
				tint = vanillaHD.tint_mask[name]
			}
		}
    item.subgroup = subgroup
		item.order = string.gsub(string.gsub(item.order,"^[a-z]","d"),"transport%-belt","loader")		
		
	end
end

-- Used to create new loader items
function vanillaHD.createLoaderItem(name, beltname, subgroup)
	if data.raw["item"][beltname] then
		local baseitem = data.raw["item"][beltname]
		local item = table.deepcopy(data.raw["item"]["loader"])
		item.name = name
		item.place_result = name
		
		-- Generate item graphics
		vanillaHD.patchLoaderItem(item, beltname, subgroup)
        
		data:extend({item})
	end
end

-- Function to create the default recipes for each of the loaders.
function vanillaHD.createLoaderRecipe(name, beltname, lastloader)
	if data.raw["item"][beltname] then
		local recipe = table.deepcopy(data.raw["recipe"]["express-loader"])
		recipe.name = name
		recipe.ingredients = {
			{beltname, 5},
			{lastloader, 1}
		}
		recipe.result = name
		data:extend({recipe})
	end
end

-- Function to add the loaders to the technology tree.
function vanillaHD.patchLoaderTechnology(technology, recipe)
	if data.raw["technology"][technology] then
		table.insert(data.raw["technology"][technology].effects, {
			type="unlock-recipe",
			recipe=recipe
		})
	end
end

-- Function to create vanilla-style tech icons
function vanillaHD.patchTechnologyIcon(loader)
	if data.raw["technology"][loader] then
		data.raw["technology"][loader].icons = 
		{
			{
				icon = "__vanilla-loaders-hd__/graphics/technology/loader-tech-base.png"
			},
			{
				icon = "__vanilla-loaders-hd__/graphics/technology/loader-tech-mask.png",
				tint = vanillaHD.tint_mask[loader]
			}
		}
	end
end