local neutral_flags = {"not-repairable", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map", "placeable-neutral"}
  
  data:extend({
  
	{
	type = "trivial-smoke",
	name = "shield-effect",
	flags = neutral_flags, --{"not-blueprintable", "not-on-map", "placeable-off-grid"},
	duration = 45,
	fade_in_duration = 5,
	fade_away_duration = 35,
	spread_duration = 0,
	start_scale = 1,
	end_scale = 1,
	cyclic = true,
	affected_by_wind = false,
	movement_slow_down_factor = 0.5,
	show_when_smoke_off = true,
	render_layer = "wires-above",
	animation =
	{
	  width = 400,
	  height = 400,
	  frame_count = 1,
	  shift = {0, -0.03},
	  priority = "high",
	  animation_speed = 0.05,
	  scale= 0.26,
	  filename = "__Turret-Shields__/graphics/shield-effect.png",
	  flags = { "smoke" }
	  }
	},-------------------------------------------------------------------------------------------------------------------------------
	{
	type = "trivial-smoke",
	name = "shield-effect-big",
	flags = neutral_flags, --{"not-blueprintable", "not-on-map", "placeable-off-grid"},
	duration = 45,
	fade_in_duration = 5,
	fade_away_duration = 35,
	spread_duration = 0,
	start_scale = 1,
	end_scale = 1,
	cyclic = true,
	affected_by_wind = false,
	movement_slow_down_factor = 0.5,
	show_when_smoke_off = true,
	render_layer = "wires-above",
	animation =
	  {
	  width = 400,
	  height = 400,
	  frame_count = 1,
	  shift = {0.05, 0.2},
	  priority = "high",
	  animation_speed = 0.05,
	  scale= 0.32,
	  filename = "__Turret-Shields__/graphics/shield-effect.png",
	  flags = { "smoke" }
	  }
	},-------------------------------------------------------------------------------------------------------------------------------
	{
	type = "smoke-with-trigger",
	name = "shield-effect-alternate",
	icon = "__base__/graphics/icons/biter-spawner.png",
	icon_size = 32,
	flags = neutral_flags, --{"not-repairable", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map", "placeable-neutral"},
	order="b-b-g",
	duration = 40,
	fade_in_duration = 0,
	fade_away_duration = 0,
	spread_duration = 0,
	start_scale = 1,
	end_scale = 1,
	cyclic = false,
	affected_by_wind = false,
	movement_slow_down_factor = 0,
	show_when_smoke_off = true,
	render_layer = "wires",
	random_animation_offset = false,
	color = { r = 1, g = 1, b = 1, a=1 },
	animation =
		{
		variation_count = 0,
		filename = "__Turret-Shields__/graphics/shield-effect-alternate.png",
		line_length = 9,
		width = 217,
		height = 217,
		frame_count = 9,
		animation_speed = 0.3,
		scale = 0.62,
		direction_count = 1,
		run_mode = "forward",
		shift = {-0.02, 0.93},
		priority = "extra-high",
		},
	},-------------------------------------------------------------------------------------------------------------------------------
	{
	type = "smoke-with-trigger",
	name = "shield-effect-alternate2",
	icon = "__base__/graphics/icons/biter-spawner.png",
	icon_size = 32,
	flags = neutral_flags, --{"not-repairable", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map"},
	order="b-b-g",
	duration = 40,
	fade_in_duration = 0,
	fade_away_duration = 0,
	spread_duration = 0,
	start_scale = 1,
	end_scale = 1,
	cyclic = false,
	affected_by_wind = false,
	movement_slow_down_factor = 0,
	show_when_smoke_off = true,
	render_layer = "wires",
	random_animation_offset = false,
	color = { r = 1, g = 1, b = 1, a=1 },
	animation =
		{
			
	  variation_count = 0,
	  filename = "__Turret-Shields__/graphics/shield-effect-alternate2.png",
		line_length = 9,
		width = 217,
		height = 217,
		frame_count = 9,
		animation_speed = 0.3,
		scale = 0.62,
		direction_count = 1,
		run_mode = "forward",
		shift = {-0.02, 0.93},
		priority = "extra-high",
		},
	},-------------------------------------------------------------------------------------------------------------------------------
	{
	type = "smoke-with-trigger",
	name = "shield-effect-alternate-big",
	icon = "__base__/graphics/icons/biter-spawner.png",
	icon_size = 32,
	flags = neutral_flags, --{"not-repairable", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map"},
	order="b-b-g",
	duration = 40,
	fade_in_duration = 0,
	fade_away_duration = 0,
	spread_duration = 0,
	start_scale = 1,
	end_scale = 1,
	cyclic = false,
	affected_by_wind = false,
	movement_slow_down_factor = 0,
	show_when_smoke_off = true,
	render_layer = "wires",
	random_animation_offset = false,
	color = { r = 1, g = 1, b = 1, a=1 },
	animation =
		{
			
	  variation_count = 0,
	  filename = "__Turret-Shields__/graphics/shield-effect-alternate.png",
		line_length = 9,
		width = 217,
		height = 217,
		frame_count = 9,
		animation_speed = 0.3,
		scale = 0.78,
		direction_count = 1,
		run_mode = "forward",
		shift = {0.02, 1.18},
		priority = "extra-high",
		},
	},-------------------------------------------------------------------------------------------------------------------------------
	{
	type = "smoke-with-trigger",
	name = "shield-effect-alternate-big2",
	icon = "__base__/graphics/icons/biter-spawner.png",
	icon_size = 32,
	flags = neutral_flags, --{"not-repairable", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map"},
	order="b-b-g",
	duration = 40,
	fade_in_duration = 0,
	fade_away_duration = 0,
	spread_duration = 0,
	start_scale = 1,
	end_scale = 1,
	cyclic = false,
	affected_by_wind = false,
	movement_slow_down_factor = 0,
	show_when_smoke_off = true,
	render_layer = "wires",
	random_animation_offset = false,
	color = { r = 1, g = 1, b = 1, a=1 },
	animation =
		{
			
	  variation_count = 0,
	  filename = "__Turret-Shields__/graphics/shield-effect-alternate2.png",
		line_length = 9,
		width = 217,
		height = 217,
		frame_count = 9,
		animation_speed = 0.3,
		scale = 0.78,
		direction_count = 1,
		run_mode = "forward",
		shift = {0.02, 1.18},
		priority = "extra-high",
	},
  },-------------------------------------------------------------------------------------------------------------------------------
  })


