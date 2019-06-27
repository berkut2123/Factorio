data:extend({

	--- Big Electric Pole
	{
		type = "recipe",
		name = "bi_recipe_big_wooden_pole",
		normal =
		{
			enabled = false,
			ingredients = 
			{
			  {"wood", 5},    
			  {"small-electric-pole", 2},  
			},
		  result = "bi-big-wooden-pole"
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			{
			  {"wood", 10},    
			  {"small-electric-pole", 4},  
			},
		  result = "bi-big-wooden-pole"
		},	
		always_show_made_in = true,
		allow_decomposition = false,
	},
	
	--- Huge Wooden Pole	
	{
		type = "recipe",
		name = "bi_recipe_huge_wooden_pole",
		normal =
		{
			enabled = false,
			ingredients = 
			{
			  {"wood", 5}, 
			  {"concrete", 100},   			  
			  {"bi-big-wooden-pole", 6},  
			},
		  result = "bi-huge-wooden-pole"
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			{
			  {"wood", 10},  
			  {"concrete", 150},   				  
			  {"bi-big-wooden-pole", 10},  
			},
		  result = "bi-huge-wooden-pole"
		},	
		always_show_made_in = true,
		allow_decomposition = false,
	},
	
	--- Wooden Fence
	{
		type = "recipe",
		name = "bi_recipe_wooden_fence",
		normal =
		{
			enabled = true,
			ingredients = 
			{
			  {"wood", 2},
			},
			result = "bi-wooden-fence",
		},
		expensive =
		{
			enabled = true,
			ingredients = 
			{
			  {"wood", 4},
			},
			result = "bi-wooden-fence",
		},	
		always_show_made_in = true,
		allow_decomposition = false,
	},
  
	--- Wooden Rail
    {
		type = "recipe",
		name = "bi_recipe_rail_wood",	
		normal =
		{
			enabled = false,
			ingredients = 
			{		
				{"wood", 6},
				{"stone", 1},
				{"steel-plate", 1},
				{"iron-stick", 1},	  
			},
			result = "bi-rail-wood",
			result_count = 2,
			requester_paste_multiplier = 4
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			{			
				{"wood", 6},
				{"stone", 1},
				{"steel-plate", 1},			 
				{"iron-stick", 1},
			},
			result = "bi-rail-wood",
			result_count = 1,
			requester_paste_multiplier = 4
		},	
		always_show_made_in = true,
		allow_decomposition = false,
  },

 	--- Wooden Rail to Concrete Rail
    {
		type = "recipe",
		icon = "__Bio_Industries__/graphics/icons/rail-wood-to-concrete.png",
		icon_size = 32,
		name = "bi_recipe_rail_wood_to_concrete",	
		normal =
		{
			enabled = false,
			ingredients = 
			{		
				{"bi-rail-wood", 3},
				{"stone-brick", 10},
			},
			result = "rail",
			result_count = 2,
			requester_paste_multiplier = 4
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			{			
				{"bi-rail-wood", 2},
				{"stone-brick", 10},
			},
			result = "rail",
			result_count = 1,
			requester_paste_multiplier = 4
		},
		subgroup = "transport",
		order = "a[train-system]-aa1[rail-upgrade]",		
		always_show_made_in = true,
		allow_decomposition = false,
	}, 
	
	--- Wooden Bridge Rail
    {
		type = "recipe",
		name = "bi_recipe_rail_wood_bridge",	
		normal =
		{
			enabled = false,
			ingredients = 
			
			{	  
			  {"bi-rail-wood", 1},
			  {"steel-plate", 1},
			  {"wood", 32}
			},
			result = "bi-rail-wood-bridge",
			result_count = 2,
			requester_paste_multiplier = 4
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			
			{	  
			  {"bi-rail-wood", 1},
			  {"steel-plate", 1},
			  {"wood", 32}
			},
			result = "bi-rail-wood-bridge",
			result_count = 1,
			requester_paste_multiplier = 4
		},
		always_show_made_in = true,
		allow_decomposition = false,
  },

  	--- Power Rail
    {
		type = "recipe",
		name = "bi_rail_power",	
		normal =
		{
			enabled = false,
			ingredients = 
			{		
				{"rail", 2},
				{"copper-cable", 4},

			},
			result = "bi-rail-power",
			result_count = 2,
			requester_paste_multiplier = 4
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			{			
				{"rail", 1},
				{"copper-cable", 4},

			},
			result = "bi-rail-power",
			result_count = 1,
			requester_paste_multiplier = 4
		},	
		always_show_made_in = true,
		allow_decomposition = false,
  },

	--- Wood Pipe
    {
		type = "recipe",
		name = "bi_recipe_wood_pipe",
		normal =
		{
			energy_required = 1,
			enabled = true,
			ingredients = 
			{	  
			  {"copper-plate", 1},
			  {"wood", 8}
			},
		  result = "bi-wood-pipe",
		  result_count = 4,
		  requester_paste_multiplier = 15
		},
		expensive =
		{
			energy_required = 2,
			enabled = true,
			ingredients = 
			{	  
			  {"copper-plate", 1},
			  {"wood", 12}
			},
		  result = "bi-wood-pipe",
		  result_count = 4,
		  requester_paste_multiplier = 15
		},
		always_show_made_in = true,
		allow_decomposition = false,
  },
 	
  -- Wood Pipe to Ground
  {
		type = "recipe",
		name = "bi_recipe_pipe_to_ground_wood",
		normal =
		{
			energy_required = 2,
			enabled = true,
			ingredients = 
			{	  
			  {"copper-plate", 4},
			  {"bi-wood-pipe", 5}
			},
		  result = "bi-pipe-to-ground-wood",
		  result_count = 2,
		},
		expensive =
		{
			energy_required = 4,
			enabled = true,
			ingredients = 
			{	  
			  {"copper-plate", 5},
			  {"bi-wood-pipe", 6}
			},
		  result = "bi-pipe-to-ground-wood",
		  result_count = 2,
		},
		always_show_made_in = true,
		allow_decomposition = false,
  },

  	--- Rail to Power Pole
	{
		type = "recipe",
		name = "bi_recipe_power_to_rail_pole",
		normal =
		{
			enabled = false,
			ingredients = 
			{
			  {"copper-cable", 2},    
			  {"medium-electric-pole", 1},  
			},
		  result = "bi-power-to-rail-pole"
		},
		expensive =
		{
			enabled = false,
			ingredients = 
			{
			  {"copper-cable", 4},
			  {"medium-electric-pole", 1},  
			},
		  result = "bi-power-to-rail-pole"
		},
		always_show_made_in = true,	
		allow_decomposition = false,		
	},
	
	--- Large Wooden Chest
  {
    type = "recipe",
    name = "bi_recipe_large_wooden_chest",
	normal =
		{
			energy_required = 2,
			enabled = false,
			ingredients = 
			{	  
			  {"copper-plate", 16},
			  {"resin", 24},
			  {"wooden-chest", 8}
			},
		  result = "bi-large-wooden-chest",
		  result_count = 1,
		  requester_paste_multiplier = 4
		},
	expensive =
		{
			energy_required = 4,
			enabled = false,
			ingredients = 
			{	  
			  {"copper-plate", 24},
			  {"resin", 32},
			  {"wooden-chest", 8}
			},
		  result = "bi-large-wooden-chest",
		  result_count = 1,
		  requester_paste_multiplier = 4,
		},
		always_show_made_in = true,
		allow_decomposition = false,
  },
 
	--- Huge Wooden Chest
  {
    type = "recipe",
    name = "bi_recipe_huge_wooden_chest",
	normal =
		{
			energy_required = 2,
			enabled = false,
			ingredients = 
			{	  
			  {"iron-stick", 32},
			  {"stone-brick", 32},
			  {"bi-large-wooden-chest", 16}
			},
		  result = "bi-huge-wooden-chest",
		  result_count = 1,
		  requester_paste_multiplier = 4
		},
	expensive =
		{
			energy_required = 4,
			enabled = false,
			ingredients = 
			{	  
			  {"iron-stick", 48},
			  {"stone-brick", 48},
			  {"bi-large-wooden-chest", 16}
			},
		  result = "bi-huge-wooden-chest",
		  result_count = 1,
		  requester_paste_multiplier = 4,
		},
		always_show_made_in = true,
		allow_decomposition = false,
  }, 

  	--- Giga Wooden Chest
  {
    type = "recipe",
    name = "bi_recipe_giga_wooden_chest",
	normal =
		{
			energy_required = 4,
			enabled = false,
			ingredients = 
			{	  
			  {"steel-plate", 32},
			  {"concrete", 32},
			  {"bi-huge-wooden-chest", 16}
			},
		  result = "bi-giga-wooden-chest",
		  result_count = 1,
		  requester_paste_multiplier = 4
		},
	expensive =
		{
			energy_required = 6,
			enabled = false,
			ingredients = 
			{	  
			  {"steel-plate", 48},
			  {"concrete", 48},
			  {"bi-huge-wooden-chest", 16}
			},
		  result = "bi-giga-wooden-chest",
		  result_count = 1,
		  requester_paste_multiplier = 4,
		},
		always_show_made_in = true,
		allow_decomposition = false,
  }, 
  
  

 })

