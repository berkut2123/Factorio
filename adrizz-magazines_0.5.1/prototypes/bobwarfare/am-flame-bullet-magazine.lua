data:extend({
	--Extended Flame Bullet Magazine
	{
    type = "ammo",
    name = "ext-flame-bullet-magazine",
    icon = "__adrizz-magazines__/graphics/bobswarfare/ext-flame-bullet-magazine.png",
    icon_size = 32,
    subgroup = "bob-ammo",
    stack_size = 200,
    magazine_size = 40,
    ammo_type =
    {
      category = "bullet",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-gunshot"
          },
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion-gunshot"
            },
            {
              type = "damage",
              damage = { amount = 12, type = "physical"}
            },
            {
              type = "nested-result",
              action =
              {
                type = "area",
                radius = 3,
                action_delivery =
                {
                  type = "instant",
                  target_effects =
                  {
                    {
                      type = "damage",
                      damage = {amount = 12, type = "fire"}
                    },
                  }
                }
              }
            }
          }
        }
      }
    },
  },
  --Drum Flame Bullet Magazine
	{
    type = "ammo",
    name = "drum-flame-bullet-magazine",
    icon = "__adrizz-magazines__/graphics/bobswarfare/drum-flame-bullet-magazine.png",
    icon_size = 32,
    subgroup = "bob-ammo",
    stack_size = 200,
    magazine_size = 75,
    ammo_type =
    {
      category = "bullet",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-gunshot"
          },
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion-gunshot"
            },
            {
              type = "damage",
              damage = { amount = 12, type = "physical"}
            },
            {
              type = "nested-result",
              action =
              {
                type = "area",
                radius = 3,
                action_delivery =
                {
                  type = "instant",
                  target_effects =
                  {
                    {
                      type = "damage",
                      damage = {amount = 12, type = "fire"}
                    },
                  }
                }
              }
            }
          }
        }
      }
    },
  },
  --Saddle Flame Bullet Magazine
	{
    type = "ammo",
    name = "saddle-flame-bullet-magazine",
    icon = "__adrizz-magazines__/graphics/bobswarfare/saddle-flame-bullet-magazine.png",
    icon_size = 32,
    subgroup = "bob-ammo",
    stack_size = 200,
    magazine_size = 100,
    ammo_type =
    {
      category = "bullet",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          source_effects =
          {
            type = "create-entity",
            entity_name = "explosion-gunshot"
          },
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion-gunshot"
            },
            {
              type = "damage",
              damage = { amount = 12, type = "physical"}
            },
            {
              type = "nested-result",
              action =
              {
                type = "area",
                radius = 3,
                action_delivery =
                {
                  type = "instant",
                  target_effects =
                  {
                    {
                      type = "damage",
                      damage = {amount = 12, type = "fire"}
                    },
                  }
                }
              }
            }
          }
        }
      }
    },
  },
})