data:extend(
{
	{
		type = "technology",
		name = "scattergun-turrets",
		icon = "__scattergun_turret__/graphics/technology/scattergun-turret-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "scattergun-turret"
			},
		},
		prerequisites =
		{
			"military",
			"turrets",
			"logistic-science-pack",
		},
		unit =
		{
			count = 50,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
			},
			time = 45
		},
		order = "e-a-e"
	},
	{
		type = "technology",
		name = "w93-modular-turrets",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-turret-base"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-hmg"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-hmg-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-hmg-turret2"
			},
		},
		prerequisites =
		{
			"military-science-pack",
			"turrets",
			"engine",
			"automation",
		},
		unit =
		{
			count = 75,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 45
		},
		order = "e-a-a"
	},
	{
		type = "technology",
		name = "w93-modular-turrets2",
		icon = "__scattergun_turret__/graphics/technology/modular-turret2-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-turret2-base"
			},
		},
		prerequisites =
		{
			"w93-modular-turrets",
			"electric-engine",
			"advanced-electronics-2",
			"concrete",
		},
		unit =
		{
			count = 200,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 60
		},
		order = "e-a-a"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-gatling",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-gatling-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-gatling"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-gatling-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-gatling-turret2"
			},
		},
		prerequisites =
		{
			"w93-modular-turrets",
			"electric-engine",
			"military-3",
		},
		unit =
		{
			count = 200,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 60
		},
		order = "e-a-b"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-rocket",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-rocket-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-rocket"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-rocket-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-rocket-turret2"
			},
		},
		prerequisites =
		{
			"w93-modular-turrets",
			"military-3",
			"rocketry",
		},
		unit =
		{
			count = 150,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 60
		},
		order = "e-a-d"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-tlaser",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-tlaser-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-tlaser"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-tlaser-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-tlaser-turret2"
			},
		},
		prerequisites =
		{
			"w93-modular-turrets",
			"military-4",
			"laser",
		},
		unit =
		{
			count = 250,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
				{"utility-science-pack",1},
			},
			time = 60
		},
		order = "e-a-e"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-beam",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-beam-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-beam"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-beam-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-beam-turret2"
			},
		},
		prerequisites =
		{
			"w93-modular-turrets-tlaser",
			"uranium-processing",
			"space-science-pack",
		},
		unit =
		{
			count = 300,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
				{"utility-science-pack",1},
				{"space-science-pack",1},
			},
			time = 60
		},
		order = "e-a-e"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-lcannon",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-lcannon-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-lcannon"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-lcannon-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-lcannon-turret2"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-turret-light-cannon-shells",
			},
		},
		prerequisites =
		{
			"w93-modular-turrets",
			"advanced-electronics",
		},
		unit =
		{
			count = 100,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 45
		},
		order = "e-a-c"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-dcannon",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-dcannon-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-dcannon"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-dcannon-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-dcannon-turret2"
			},
		},
		prerequisites =
		{
			"w93-modular-turrets-lcannon",
			"military-3",
			"speed-module",
		},
		unit =
		{
			count = 100,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 60
		},
		order = "e-a-c"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-hcannon",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-hcannon-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "unlock-recipe",
				recipe = "w93-modular-gun-hcannon"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-hcannon-turret"
			},
			{
				type = "unlock-recipe",
				recipe = "w93-hcannon-turret2"
			},
		},
		prerequisites =
		{
			"w93-modular-turrets-dcannon",
			"military-4",
			"tanks",
		},
		unit =
		{
			count = 200,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
				{"utility-science-pack",1},
			},
			time = 60
		},
		order = "e-a-c"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-damage-1",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-damage-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret2",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret2",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret2",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret2",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret2",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret",
				modifier = 0.3
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret2",
				modifier = 0.3
			},
		},
		prerequisites =
		{
			"w93-modular-turrets",
		},
		unit =
		{
			count = 250,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 60
		},
		upgrade = true,
		order = "e-a-z"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-damage-2",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-damage-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret2",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret2",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret2",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret2",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret2",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret",
				modifier = 0.4
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret2",
				modifier = 0.4
			},
		},
		prerequisites =
		{
			"w93-modular-turrets-damage-1",
			"chemical-science-pack",
		},
		unit =
		{
			count = 375,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
			},
			time = 60
		},
		upgrade = true,
		order = "e-a-z"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-damage-3",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-damage-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret2",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret2",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret2",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret2",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret2",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret",
				modifier = 0.5
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret2",
				modifier = 0.5
			},
		},
		prerequisites =
		{
			"w93-modular-turrets-damage-2",
			"utility-science-pack",
		},
		unit =
		{
			count = 500,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
				{"utility-science-pack",1},
			},
			time = 60
		},
		upgrade = true,
		order = "e-a-z"
	},
	{
		type = "technology",
		name = "w93-modular-turrets-damage-4",
		icon = "__scattergun_turret__/graphics/technology/modular-turret-damage-tech.png",
		icon_size = 128,
		effects =
		{
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-hmg-turret2",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-gatling-turret2",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-lcannon-turret2",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-dcannon-turret2",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-hcannon-turret2",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret",
				modifier = 0.7
			},
			{
				type = "turret-attack",
				turret_id = "w93-rocket-turret2",
				modifier = 0.7
			},
		},
		prerequisites =
		{
			"w93-modular-turrets-damage-3",
			"space-science-pack",
		},
		unit =
		{
			count_formula = "2^(L-4)*1000",
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"military-science-pack", 1},
				{"utility-science-pack",1},
				{"space-science-pack", 1}
			},
			time = 60
		},
		upgrade = true,
		max_level = "infinite",
		order = "e-a-z"
	},
 })