local artillery_train_name = "Senpais-Dora"
local MODNAME = "__Senpais_Dora__"

local dora_entity = util.table.deepcopy( data.raw["artillery-wagon"]["artillery-wagon"] )
dora_entity.name = artillery_train_name
dora_entity.icon = MODNAME .. "/graphics/dora.png"
dora_entity.icon_size = 32
dora_entity.icon_mipmap = nil
dora_entity.minable.result = artillery_train_name
dora_entity.max_health = 20000
dora_entity.weight = 20000
dora_entity.gun = "dora-gun"
dora_entity.turret_rotation_speed = 0.0003
dora_entity.turn_after_shooting_cooldown = 180
dora_entity.manual_range_modifier = 2
for i = 1, 16 do
	dora_entity.pictures.layers[1].filenames[i] = MODNAME .. "/graphics/artillery-wagon-base-" .. i .. ".png"
	dora_entity.pictures.layers[1].hr_version.filenames[i] = MODNAME .. "/graphics/hr-artillery-wagon-base-" .. i .. ".png"
end

local dora_gun = util.table.deepcopy( data.raw["gun"]["artillery-wagon-cannon"] )
dora_gun.name = "dora-gun"
dora_gun.order = "z[artillery]-b[dora]"
dora_gun.attack_parameters.ammo_category = "dora-shell"
dora_gun.attack_parameters.range = 10 * 32
dora_gun.attack_parameters.min_range = 3 * 32

local dora_ammo = util.table.deepcopy( data.raw["ammo"]["artillery-shell"] )
dora_ammo.name = "dora-shell"
dora_ammo.icon = MODNAME .. "/graphics/dora-shell.png"
dora_ammo.icon_size = 32
dora_ammo.icon_mipmap = nil
dora_ammo.ammo_type.category = "dora-shell"
dora_ammo.ammo_type.action.action_delivery.projectile = "dora-projectile"
dora_ammo.order = "d[explosive-cannon-shell]-e[dora]"

local dora_projectile = util.table.deepcopy( data.raw["artillery-projectile"]["artillery-projectile"] )
dora_projectile.name = "dora-projectile"
dora_projectile.chart_picture.filename = MODNAME .. "/graphics/dora-shoot-map-visualization.png"
dora_projectile.action =
{
    type = "direct",
    action_delivery =
    {
        type = "instant",
        target_effects =
        {
            {
                repeat_count = 250,
                type = "create-trivial-smoke",
                smoke_name = "nuclear-smoke",
                offset_deviation = { { - 1, -1 }, { 1, 1 } },
                slow_down_factor = 1,
                starting_frame = 3,
                starting_frame_deviation = 5,
                starting_frame_speed = 0,
                starting_frame_speed_deviation = 5,
                speed_from_center = 0.5,
                speed_deviation = 0.2
            },
            {
                type = "create-entity",
                entity_name = "explosion"
            },
            {
                type = "damage",
                damage =
                {
                    amount = 4000,
                    type = "explosion"
                }
            },
            {
                type = "create-entity",
                entity_name = "small-scorchmark",
                check_buildability = true,
            },
            {
                type = "nested-result",
                action =
                {
                    type = "area",
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 8000,
                    radius = 80,
                    action_delivery =
                    {
                        type = "projectile",
                        projectile = "dora-atomic-wave",
                        starting_speed = 0.25
                    }
                }
            }
        }
    }
}

local dora_atomic_wave =
{
    type = "projectile",
    name = "dora-atomic-wave",
    flags = { "not-on-map" },
    acceleration = 0,
    action =
    {
     	{
     		type = "direct",
     		action_delivery =
     		{
     			type = "instant",
     			target_effects =
     			{
     				{
     					type = "create-entity",
     					entity_name = "explosion"
     				}
     			}
     		}
     	},
    	{
    		type = "area",
    		radius = 7.5,
    		action_delivery =
    		{
    			type = "instant",
    			target_effects =
    			{
    				{
    					type = "damage",
    					damage =
    					{
    						amount = 2000,
    						type = "explosion"
    					}
    				},
    				{
	  					type = "destroy-cliffs",
	  					radius = 100,
	  					explosion = "explosion"
	  				}
    			}
    		}
    	}
    },
    animation = { filename = "__core__/graphics/empty.png", frame_count = 1, width = 1, height = 1, priority = "high" },
    shadow = { filename = "__core__/graphics/empty.png", frame_count = 1, width = 1, height = 1, priority = "high" }
}

local dora_item = util.table.deepcopy( data.raw["item-with-entity-data"]["artillery-wagon"] )
dora_item.name = artillery_train_name
dora_item.icon = MODNAME .. "/graphics/dora.png"
dora_item.icon_size = 32
dora_item.icon_mipmap = nil
dora_item.order = "a[train-system]-ia[dora]"
dora_item.place_result = artillery_train_name

local dora_recipe = util.table.deepcopy( data.raw["recipe"]["artillery-wagon"] )
dora_recipe.name = artillery_train_name
dora_recipe.ingredients =
{
    { "artillery-wagon", 1 },
	{ "engine-unit", 100 },
    { "iron-gear-wheel", 50 },
    { "steel-plate", 100 },
    { "pipe", 100 },
    { "advanced-circuit", 50 },
 	{ "processing-unit", 50 }
}
dora_recipe.result = artillery_train_name

local dora_ammo_recipe = util.table.deepcopy( data.raw["recipe"]["artillery-shell"] )
dora_ammo_recipe.name = "dora-shell"
dora_ammo_recipe.ingredients = { { "artillery-shell", 15 }, { "atomic-bomb", 20 }, { "explosives", 150 } }
dora_ammo_recipe.result = "dora-shell"

local dora_tech = util.table.deepcopy( data.raw["technology"]["artillery"] )
dora_tech.name = "dora"
dora_tech.icon = MODNAME .. "/graphics/dora-tech.png"
dora_tech.icon_size = 128
dora_tech.icon_mipmap = nil
dora_tech.effects = { { type = "unlock-recipe", recipe = artillery_train_name }, { type = "unlock-recipe", recipe = "dora-shell" } }
dora_tech.prerequisites = { "artillery" }
dora_tech.unit.count = 5000

table.insert( dora_tech.unit.ingredients, { "space-science-pack", 1 } )

data:extend{ { type = "ammo-category", name = "dora-shell" }, dora_entity, dora_gun, dora_ammo, dora_projectile, dora_atomic_wave, dora_item, dora_recipe, dora_ammo_recipe, dora_tech }