local artillery_train_name = "Senpais-Dora"
local MODNAME = "__Senpais_Dora__"
local table_deepcopy = util.table.deepcopy
local sounds = require("__base__/prototypes/entity/demo-sounds")

local dora_entity = table_deepcopy(data.raw["artillery-wagon"]["artillery-wagon"])
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

local dora_gun = table_deepcopy(data.raw["gun"]["artillery-wagon-cannon"])
dora_gun.name = "dora-gun"
dora_gun.order = "z[artillery]-b[dora]"
dora_gun.attack_parameters.ammo_category = "dora-shell"
dora_gun.attack_parameters.range = 10 * 32
dora_gun.attack_parameters.min_range = 3.5 * 32

local dora_ammo = table_deepcopy(data.raw["ammo"]["artillery-shell"])
dora_ammo.name = "dora-shell"
dora_ammo.icon = MODNAME .. "/graphics/dora-shell.png"
dora_ammo.icon_size = 32
dora_ammo.icon_mipmap = nil
dora_ammo.ammo_type.category = "dora-shell"
dora_ammo.ammo_type.action.action_delivery.projectile = "dora-projectile"
dora_ammo.order = "d[explosive-cannon-shell]-e[dora]"

local dora_projectile = table_deepcopy(data.raw["artillery-projectile"]["artillery-projectile"])
dora_projectile.name = "dora-projectile"
dora_projectile.chart_picture.filename = MODNAME .. "/graphics/dora-shoot-map-visualization.png"
dora_projectile.action = {
    type = "direct",
    action_delivery = {
        type = "instant",
        target_effects = {
            {
                type = "set-tile",
                tile_name = "nuclear-ground",
                radius = 120,
                apply_projection = true,
                tile_collision_mask ={"water-tile"}
            },
            {
                type = "create-entity",
                entity_name = "nuke-explosion"
            },
            {
                type = "destroy-cliffs",
                radius = 90,
                explosion = "explosion"
            },
            {
                type = "camera-effect",
                effect = "screen-burn",
                duration = 60,
                ease_in_duration = 5,
                ease_out_duration = 60,
                delay = 0,
                strength = 6,
                full_strength_max_distance = 200,
                max_distance = 800
            },
            {
                type = "play-sound",
                sound = sounds.nuclear_explosion(0.9),
                play_on_target_position = false,
                max_distance = 1000,
                audible_distance_modifier = 10
            },
            {
                type = "play-sound",
                sound = sounds.nuclear_explosion_aftershock(0.4),
                play_on_target_position = false,
                max_distance = 1000,
                audible_distance_modifier = 3
            },
            {
                type = "damage",
                damage = {amount = 4000, type = "explosion"}
            },
            {
                type = "create-entity",
                entity_name = "huge-scorchmark",
                check_buildability = true,
            },
            {
                type = "invoke-tile-trigger",
                repeat_count = 1,
            },
            {
                type = "destroy-decoratives",
                include_soft_decoratives = true,
                include_decals = true,
                invoke_decorative_trigger = true,
                decoratives_with_trigger_only = false,
                radius = 70
            },
            {
                type = "create-decorative",
                decorative = "nuclear-ground-patch",
                spawn_min_radius = 23,
                spawn_max_radius = 24,
                spawn_min = 150,
                spawn_max = 200,
                apply_projection = true,
                spread_evenly = true
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 2500,
                    radius = 70,
                    action_delivery = {
                        type = "projectile",
                        projectile = "dora-atomic-ground-zero",
                        starting_speed = 0.6 * 0.8,
                        starting_speed_deviation = 0.075
                    }
                }
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 2500,
                    radius = 175,
                    action_delivery = {
                        type = "projectile",
                        projectile = "dora-atomic-wave",
                        starting_speed = 0.5 * 0.7,
                        starting_speed_deviation = 0.075
                    }
                }
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    show_in_tooltip = false,
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 2500,
                    radius = 130,
                    action_delivery = {
                        type = "projectile",
                        projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
                        starting_speed = 0.5 * 0.7,
                        starting_speed_deviation = 0.075,
                    }
                }
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    show_in_tooltip = false,
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 1750,
                    radius = 40,
                    action_delivery ={
                        type = "projectile",
                        projectile = "atomic-bomb-wave-spawns-fire-smoke-explosion",
                        starting_speed = 0.5 * 0.65,
                        starting_speed_deviation = 0.075,
                    }
                }
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    show_in_tooltip = false,
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 1750,
                    radius = 80,
                    action_delivery = {
                        type = "projectile",
                        projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
                        starting_speed = 0.5 * 0.65,
                        starting_speed_deviation = 0.075,
                    }
                }
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    show_in_tooltip = false,
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 750,
                    radius = 130,
                    action_delivery = {
                        type = "projectile",
                        projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
                        starting_speed = 0.5 * 0.65,
                        starting_speed_deviation = 0.075,
                    }
                }
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    show_in_tooltip = false,
                    target_entities = false,
                    trigger_from_target = true,
                    repeat_count = 50,
                    radius = 80,
                    action_delivery = {
                        type = "instant",
                        target_effects ={{
                            type = "create-entity",
                            entity_name = "nuclear-smouldering-smoke-source",
                            tile_collision_mask = {"water-tile"}
                        }}
                    }
                }
            }
        }
    }
}
dora_projectile.smoke = {{
    name = "smoke-fast",
    deviation = {0.15, 0.15},
    frequency = 1,
    position = {0, 1},
    slow_down_factor = 1,
    starting_frame = 3,
    starting_frame_deviation = 5,
    starting_frame_speed = 0,
    starting_frame_speed_deviation = 5
}}

local dora_atomic_ground_zero = {
    type = "projectile",
    name = "dora-atomic-ground-zero",
    flags = {"not-on-map"},
    acceleration = 0,
    speed_modifier = {1.0, 0.707},
    action = {
        {
            type = "area",
            radius = 3,
            ignore_collision_condition = true,
            action_delivery = {
                type = "instant",
                target_effects = {
                    type = "damage",
                    vaporize = true,
                    lower_distance_threshold = 0,
                    upper_distance_threshold = 350,
                    lower_damage_modifier = 10,
                    upper_damage_modifier = 0.10,
                    damage = {amount = 1000, type = "explosion"}
                }
            }
        }
    },
    animation = nil,
    shadow = nil
}

local dora_atomic_wave = {
    type = "projectile",
    name = "dora-atomic-wave",
    flags = {"not-on-map"},
    acceleration = 0,
    speed_modifier = {1.0, 0.707},
    action = {{
        type = "area",
        radius = 3,
        ignore_collision_condition = true,
        action_delivery = {
            type = "instant",
            target_effects = {
                type = "damage",
                vaporize = false,
                lower_distance_threshold = 0,
                upper_distance_threshold = 350,
                lower_damage_modifier = 10,
                upper_damage_modifier = 1,
                damage = {amount = 4000, type = "explosion"}
            }
        }
    }},
    animation = {filename = "__core__/graphics/empty.png", frame_count = 1, width = 1, height = 1, priority = "high"},
    shadow = {filename = "__core__/graphics/empty.png", frame_count = 1, width = 1, height = 1, priority = "high"}
}

local dora_item = table_deepcopy(data.raw["item-with-entity-data"]["artillery-wagon"])
dora_item.name = artillery_train_name
dora_item.icon = MODNAME .. "/graphics/dora.png"
dora_item.icon_size = 32
dora_item.icon_mipmap = nil
dora_item.order = "a[train-system]-ia[dora]"
dora_item.place_result = artillery_train_name

local dora_recipe = table_deepcopy(data.raw["recipe"]["artillery-wagon"])
dora_recipe.name = artillery_train_name
dora_recipe.ingredients = {
    {"artillery-wagon", 1},
    {"engine-unit", 100},
    {"iron-gear-wheel", 50},
    {"steel-plate", 100},
    {"pipe", 100},
    {"advanced-circuit", 50},
    {"processing-unit", 50}
}
dora_recipe.result = artillery_train_name

local dora_ammo_recipe = table_deepcopy(data.raw["recipe"]["artillery-shell"])
dora_ammo_recipe.name = "dora-shell"
dora_ammo_recipe.ingredients = {{"artillery-shell", 15}, {"atomic-bomb", 20}, {"explosives", 150}}
dora_ammo_recipe.result = "dora-shell"

local dora_tech = table_deepcopy(data.raw["technology"]["artillery"])
dora_tech.name = "dora"
dora_tech.icon = MODNAME .. "/graphics/dora-tech.png"
dora_tech.icon_size = 128
dora_tech.icon_mipmap = nil
dora_tech.effects = {{type = "unlock-recipe", recipe = artillery_train_name}, {type = "unlock-recipe", recipe = "dora-shell"}}
dora_tech.prerequisites = {"artillery"}
dora_tech.unit.count = 5000

table.insert(dora_tech.unit.ingredients, {"space-science-pack", 1})

data:extend{{type = "ammo-category", name = "dora-shell"}, dora_entity, dora_gun, dora_ammo, dora_projectile, dora_atomic_ground_zero, dora_atomic_wave, dora_item, dora_recipe, dora_ammo_recipe, dora_tech}