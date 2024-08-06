local tabName = { "ham", "sw", "creeps", "frost", "windy", }
local overridebuild = {
    [tabName[1]] = "cook_pot_food_ham",
    [tabName[2]] = "cook_pot_food_sw"
}
local cookbook_atlas = {
    [tabName[1]] = "images/cookbook/cookbook_ham.xml",
    [tabName[2]] = "images/cookbook/cookbook_sw.xml",
    [tabName[3]] = "images/inventoryimages/creepindeep_cuisine.xml",
    [tabName[4]] = "images/inventoryimages/volcanoinventory.xml"
}
local inventoryitem_atlas = {
    [tabName[1]] = resolvefilepath("images/inventoryimages/cookpotfoods_ham.xml"),
    [tabName[2]] = resolvefilepath("images/inventoryimages/cookpotfoods_sw.xml"),
    [tabName[3]] = resolvefilepath(cookbook_atlas.creeps),
    [tabName[4]] = resolvefilepath(cookbook_atlas.frost)
}

local foods_tro = {
    [tabName[1]] = {
        feijoada = {
            test = function(cooker, names, tags)
                return tags.meat and (names.jellybug == 3) or (names.jellybug_cooked == 3) or
                    (names.jellybug and names.jellybug_cooked and names.jellybug + names.jellybug_cooked == 3)
            end,
            priority = 30,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_HUGE,
            perishtime = TUNING.PERISH_FASTISH,
            sanity = TUNING.SANITY_MED,
            cooktime = 3.5,
            card_def = {
                ingredients = { { "jellybug", 3 }, { "carrot", 1 } }
            }
        },

        steamedhamsandwich = {
            test = function(cooker, names, tags)
                return (names.meat or names.meat_cooked) and (tags.veggie and tags.veggie >= 2) and names.foliage
            end,
            priority = 5,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_LARGE,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_FAST,
            sanity = TUNING.SANITY_MED,
            cooktime = 2,
            card_def = {
                ingredients = { { "meat", 1 }, { "carrot", 2 }, { "foliage", 1 } }
            }
        },

        hardshell_tacos = {
            test = function(cooker, names, tags)
                return (names.weevole_carapace == 2) and tags.veggie
            end,
            priority = 1,
            foodtype = FOODTYPE.VEGGIE,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_SLOW,
            sanity = TUNING.SANITY_TINY,
            cooktime = 1,
            card_def = {
                ingredients = { { "weevole_carapace", 2 }, { "carrot", 2 } }
            }
        },

        gummy_cake = {
            test = function(cooker, names, tags)
                return (names.slugbug or names.slugbug_cooked) and tags.sweetener
            end,
            priority = 1,
            foodtype = FOODTYPE.MEAT,
            health = -TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_SUPERHUGE,
            perishtime = TUNING.PERISH_PRESERVED,
            sanity = -TUNING.SANITY_TINY,
            cooktime = 2,
            tags = { "honeyed" },
            card_def = {
                ingredients = { { "slugbug", 1 }, { "honey", 1 }, { "twigs", 2 } }
            }
        },

        tea = {
            test = function(cooker, names, tags)
                return tags.filter and tags.filter >= 2 and tags.sweetener and not tags.meat and not tags.veggie and
                    not tags.inedible
            end,
            priority = 25,
            foodtype = FOODTYPE.GOODIES,
            health = TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_SMALL,
            perishtime = TUNING.PERISH_ONE_DAY,
            sanity = TUNING.SANITY_LARGE,
            temperature = 40,
            temperatureduration = 10,
            cooktime = 0.5,
            tags = { "honeyed" },
            oneatenfn = function(inst, eater)
                if eater and eater.components.temperature then
                    local current_temp = eater.components.temperature:GetCurrent()
                    local new_temp = math.max(current_temp + 15, TUNING.STARTING_TEMP)
                    eater.components.temperature:SetTemperature(new_temp)
                end
                if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
                    if eater._tropicalbouillabaisse_speedmulttask ~= nil then
                        eater._tropicalbouillabaisse_speedmulttask:Cancel()
                    end
                    local debuffkey = "tropicalbouillabaisse"
                    eater._tropicalbouillabaisse_speedmulttask =
                        eater:DoTaskInTime(120, function(i)
                            i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                            i._tropicalbouillabaisse_speedmulttask = nil
                        end)
                    eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 17 / 12)
                end
            end,
            card_def = {
                ingredients = { { "piko_orange", 2 }, { "honey", 2 } }
            }
        },

        icedtea = {
            test = function(cooker, names, tags)
                return tags.filter and tags.filter >= 2 and tags.sweetener and tags.frozen
            end,
            priority = 30,
            foodtype = FOODTYPE.GOODIES,
            health = TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_SMALL,
            perishtime = TUNING.PERISH_FAST,
            sanity = TUNING.SANITY_LARGE,
            temperature = -40,
            temperatureduration = 10,
            cooktime = 0.5,
            tags = { "honeyed" },
            oneatenfn = function(inst, eater)
                if eater and eater.components.temperature then
                    local current_temp = eater.components.temperature:GetCurrent()
                    local new_temp = math.max(current_temp - 10, TUNING.STARTING_TEMP)
                    eater.components.temperature:SetTemperature(new_temp)
                end
                if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
                    if eater._tropicalbouillabaisse_speedmulttask ~= nil then
                        eater._tropicalbouillabaisse_speedmulttask:Cancel()
                    end
                    local debuffkey = "tropicalbouillabaisse"
                    eater._tropicalbouillabaisse_speedmulttask =
                        eater:DoTaskInTime(80, function(i)
                            i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                            i._tropicalbouillabaisse_speedmulttask = nil
                        end)
                    eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 23 / 18)
                end
            end,
            card_def = {
                ingredients = { { "piko_orange", 2 }, { "honey", 1 }, { "ice", 1 } }
            }
        },

        snakebonesoup = {
            test = function(cooker, names, tags)
                return tags.bone and tags.bone >= 2 and tags.meat and tags.meat >= 2
            end,
            priority = 20,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_LARGE,
            hunger = TUNING.CALORIES_MED,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_SMALL,
            cooktime = 1,
            card_def = {
                ingredients = { { "snake_bone", 2 }, { "meat", 2 } }
            }
        },

        nettlelosange = {
            test = function(cooker, names, tags)
                return tags.antihistamine and tags.antihistamine >= 3
            end,
            foodtype = FOODTYPE.GOODIES,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_MED,
            perishtime = TUNING.PERISH_FAST,
            sanity = TUNING.SANITY_TINY,
            antihistamine = 720,
            cooktime = .5,
            oneatenfn = function(inst, eater)
                if eater.components.hayfever ~= nil and eater.components.hayfever.fevervalue then
                    eater.components.hayfever.fevervalue = eater.components.hayfever.fevervalue - 19000
                end
            end,
            card_def = {
                ingredients = { { "cutnettle", 3 }, { "twigs", 1 } }
            }
        },

        meated_nettle = {
            test = function(cooker, names, tags)
                return (tags.antihistamine and tags.antihistamine >= 2) and (tags.meat and tags.meat >= 1) and
                    (not tags.monster or tags.monster <= 1) and not tags.inedible
            end,
            priority = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_FASTISH,
            sanity = TUNING.SANITY_TINY,
            antihistamine = 600,
            cooktime = 1,
            oneatenfn = function(inst, eater)
                if eater.components.hayfever ~= nil and eater.components.hayfever.fevervalue then
                    eater.components.hayfever.fevervalue = eater.components.hayfever.fevervalue - 16000
                end
            end,
            card_def = {
                ingredients = { { "cutnettle", 2 }, { "smallmeat", 2 } }
            }
        },

        -- 废案重现
        bubbletea = { -- 芋泥啵啵 Bubble Tea
            test = function(cooker, names, tags)
                return (names.seataro or names.seataro_cooked) and tags.filter and tags.dairy and tags.sweetener and
                    not tags.meat and not tags.monster and not tags.fish
            end,
            priority = 1,
            foodtype = FOODTYPE.GOODIES,
            health = TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_HUGE,
            perishtime = TUNING.PERISH_FASTISH,
            sanity = TUNING.SANITY_HUGE,
            temperature = -40,
            temperatureduration = 10,
            cooktime = .5,
            tags = { "honeyed" },
            card_def = {
                ingredients = { { "seataro", 1 }, { "piko_orange", 1 }, { "goatmilk", 1 }, { "honey", 1 } }
            }
        },

        frenchonionsoup = { -- 法式洋葱汤 French Onion Soup
            test = function(cooker, names, tags)
                return tags.meat and (names.onion or names.onion_cooked) and (names.tomato or names.tomato_cooked) and
                    not tags.fish and not tags.inedible
            end,
            priority = 35, -- 比海鲜杂烩高一点
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_LARGE,
            hunger = TUNING.CALORIES_HUGE + TUNING.CALORIES_SMALL,
            perishtime = TUNING.PERISH_FASTISH,
            sanity = TUNING.SANITY_MEDLARGE,
            cooktime = .75,
            isMasterfood = true,
            card_def = {
                ingredients = { { "smallmeat", 1 }, { "onion", 1 }, { "tomato", 1 }, { "twigs", 1 } }
            }
        },

        lotuschips = { -- 莲藕汤 Lotus Root Soup
            test = function(cooker, names, tags)
                return ((names.lotus_flower1 and names.lotus_flower1 > 1) or
                    (names.lotus_flower1_cooked and names.lotus_flower1_cooked > 1) or
                    (names.lotus_flower1 and names.lotus_flower1_cooked)) and not tags.fish
            end,
            priority = 5,
            foodtype = FOODTYPE.VEGGIE,
            health = TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_MEDSMALL,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_MEDLARGE * 2,
            cooktime = .5,
            card_def = {
                ingredients = { { "lotus_flower1", 2 }, { "ice", 1 }, { "twigs", 1 } }
            }
        },

        poi = { -- 芋泥 Poi
            test = function(cooker, names, tags)
                return ((names.seataro or 0) + (names.seataro_cooked or 0)) >= 2 and
                    ((names.seataro or 0) + (names.seataro_cooked or 0) + (names.potato or 0) +
                        (names.potato_cooked or 0) + (names.sweet_potato or 0) + (names.sweet_potato_cooked or 0)) >
                    2 and not tags.meat and not tags.monster and not tags.fish
            end,
            priority = 1,
            foodtype = FOODTYPE.VEGGIE,
            health = TUNING.HEALING_MEDLARGE,
            hunger = TUNING.CALORIES_LARGE + TUNING.CALORIES_MED,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_TINY,
            cooktime = 2,
            card_def = {
                ingredients = { { "seataro", 3 }, { "ice", 1 } }
            }
        }

        -- slaw = { -- 茴香沙拉 Slaw -- 游戏里获得不了茴香就先不加入
        -- 	test = function(cooker, names, tags) return (names.fennel or names.fennel_cooked) and not tags.meat and tags.veggie and tags.veggie >= 0.5 and not tags.inedible end,
        -- 	priority = 1,
        -- 	foodtype = FOODTYPE.VEGGIE,
        -- 	health = TUNING.HEALING_SMALL,
        -- 	hunger = TUNING.CALORIES_MED,
        -- 	perishtime = TUNING.PERISH_SLOW,
        -- 	sanity = TUNING.SANITY_TINY,
        -- 	cooktime = 1,
        --     floater = {"med", nil, 0.68},
        --     card_def = {ingredients = {{"fennel", 2}, {"carrot", 2}} },
        -- },

    },

    [tabName[2]] = {
        bisque = {
            test = function(cooker, names, tags)
                return names.limpets and names.limpets == 3 and tags.frozen
            end,
            priority = 30,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_HUGE,
            hunger = TUNING.CALORIES_MEDSMALL,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_TINY,
            cooktime = 1,
            card_def = {
                ingredients = { { "limpets", 3 }, { "ice", 1 } }
            }
        },

        butterflymuffin_sw = {
            test = function(cooker, names, tags)
                return names.butterfly_tropical_wings and not tags.meat and tags.veggie
            end,
            priority = 1,
            weight = 1,
            foodtype = FOODTYPE.VEGGIE,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_SLOW,
            sanity = TUNING.SANITY_TINY,
            cooktime = 2,
            card_def = {
                ingredients = { { "butterfly_tropical_wings", 1 }, { "carrot", 2 }, { "twigs", 1 } }
            }
        },

        -- californiaroll_sw = {
        --     test = function(cooker, names, tags)
        --         return
        --             (names.seaweed or 0) == 2 and (tags.fish and tags.fish >= 1)
        --     end,
        --     priority = 20,
        --     weight = 1,
        --     foodtype = FOODTYPE.MEAT,
        --     health = TUNING.HEALING_MED,
        --     hunger = TUNING.CALORIES_LARGE,
        --     perishtime = TUNING.PERISH_MED,
        --     sanity = TUNING.SANITY_SMALL,
        --     cooktime = .5,
        --     potlevel = "high",
        --     floater = {"med", 0.05, {0.65, 0.6, 0.65}},
        --     card_def = {ingredients = {{"seaweed", 2}, {"fishmeat_small", 2}} },
        -- },

        caviar = {
            test = function(cooker, names, tags)
                return (names.roe or names.roe_cooked == 3) and tags.veggie
            end,
            priority = 20,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_SMALL,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_LARGE,
            cooktime = 2,
            card_def = {
                ingredients = { { "roe", 3 }, { "carrot", 1 } }
            }
        },

        coffee = {
            test = function(cooker, names, tags)
                return names.coffeebeans_cooked and
                    (names.coffeebeans_cooked == 4 or
                        (names.coffeebeans_cooked == 3 and (tags.dairy or tags.sweetener)))
            end,
            priority = 30,
            weight = 1,
            foodtype = FOODTYPE.GOODIES,
            health = TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_TINY,
            sanity = -TUNING.SANITY_TINY,
            perishtime = TUNING.PERISH_MED,
            cooktime = .5,
            tags = {},
            oneatenfn = function(inst, eater)
                if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then
                    if eater._coffee_speedmulttask ~= nil then
                        eater._coffee_speedmulttask:Cancel()
                    end
                    local debuffkey = "coffee"
                    eater._coffee_speedmulttask = eater:DoTaskInTime(240, function(i)
                        i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                        i._coffee_speedmulttask = nil
                    end)
                    eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 11 / 6)
                end
            end,
            card_def = {
                ingredients = { { "coffeebeans_cooked", 4 } }
            }
        },

        jellyopop = {
            test = function(cooker, names, tags)
                return tags.jellyfish and tags.frozen and tags.inedible
            end,
            priority = 20,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_SMALL,
            perishtime = TUNING.PERISH_SUPERFAST,
            sanity = 0,
            temperature = -40,
            temperatureduration = 10,
            cooktime = 0.5,
            card_def = {
                ingredients = { { "jellyfish", 1 }, { "ice", 1 }, { "twigs", 2 } }
            }
        },

        lobsterbisque_sw = {
            test = function(cooker, names, tags)
                return (names.lobster_dead or names.lobster_dead_cooked or names.lobster_land) and tags.frozen
            end,
            priority = 30,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_HUGE,
            hunger = TUNING.CALORIES_MED,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_SMALL,
            cooktime = 0.5,
            potlevel = "high",
            floater = { "med", 0.05, { 0.65, 0.6, 0.65 } },
            card_def = {
                ingredients = { { "lobster_land", 1 }, { "ice", 3 } }
            }
        },

        lobsterdinner_sw = {
            test = function(cooker, names, tags)
                return (names.lobster_dead or names.lobster_dead_cooked or names.lobster_land) and names.butter and
                    (tags.meat == 1.0) and (tags.fish == 1.0) and not tags.frozen
            end,
            priority = 25,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_HUGE,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_SLOW,
            sanity = TUNING.SANITY_HUGE,
            cooktime = 1,
            potlevel = "high",
            floater = { "med", 0.05, { 0.65, 0.6, 0.65 } },
            card_def = {
                ingredients = { { "lobster_land", 1 }, { "butter", 1 }, { "carrot", 2 } }
            }
        },

        musselbouillabaise = {
            test = function(cooker, names, tags)
                return names.mussel and names.mussel == 2 and tags.veggie and tags.veggie >= 2
            end,
            priority = 30,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_MED,
            cooktime = 2,
            tags = { "masterfood" },
            -- card_def = {ingredients = {{"mussel", 2}, {"carrot", 2}} }, -- Runar: 大厨也读不出专属食谱卡
            isMasterfood = true -- Runar:热带大厨料理标记
        },

        sharkfinsoup = {
            test = function(cooker, names, tags)
                return names.shark_fin
            end,
            priority = 20,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_LARGE,
            hunger = TUNING.CALORIES_SMALL,
            perishtime = TUNING.PERISH_MED,
            sanity = -TUNING.SANITY_SMALL,
            -- naughtiness = 10, -- 失效 -- Runar: 让我想起了某个处心积虑的营销，遂放弃还原这个效果
            cooktime = 1,
            card_def = {
                ingredients = { { "shark_fin", 1 }, { "ice", 2 }, { "twigs", 1 } }
            }
        },

        sweetpotatosouffle = {
            test = function(cooker, names, tags)
                return names.sweet_potato and names.sweet_potato == 2 and tags.egg and tags.egg >= 2
            end,
            priority = 30,
            weight = 1,
            foodtype = FOODTYPE.VEGGIE,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_MED,
            cooktime = 2,
            tags = { "masterfood" },
            -- card_def = {ingredients = {{"sweet_potato", 2}, {"bird_egg", 2}} },
            isMasterfood = true
        },

        tropicalbouillabaisse = {
            test = function(cooker, names, tags)
                return (names.fish3 or names.fish3_cooked) and (names.fish4 or names.fish4_cooked) and
                    (names.fish5 or names.fish5_cooked) and tags.veggie
            end,
            priority = 35,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = TUNING.HEALING_MED,
            hunger = TUNING.CALORIES_LARGE,
            perishtime = TUNING.PERISH_MED,
            sanity = TUNING.SANITY_MED,
            cooktime = 2,
            oneatenfn = function(inst, eater)
                eater:AddDebuff("buff_moistureimmunity", "buff_moistureimmunity") -- 免疫潮湿
                if eater and eater.components.temperature then                    -- 瞬时降温（不确定sw是不是这个逻辑）
                    local current_temp = eater.components.temperature:GetCurrent()
                    local new_temp = math.max(current_temp - 8, TUNING.STARTING_TEMP)
                    eater.components.temperature:SetTemperature(new_temp)
                end
                if eater ~= nil and eater:IsValid() and eater.components.locomotor ~= nil then -- 基础移速+3（设计上），不确定跟咖啡是否独立，但原本就是这么写的，以后想办法把加速搞到一个函数里面免得叠到起飞
                    if eater._tropicalbouillabaisse_speedmulttask ~= nil then
                        eater._tropicalbouillabaisse_speedmulttask:Cancel()
                    end
                    local debuffkey = "tropicalbouillabaisse"
                    eater._tropicalbouillabaisse_speedmulttask =
                        eater:DoTaskInTime(60, function(i)
                            i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey)
                            i._tropicalbouillabaisse_speedmulttask = nil
                        end)
                    eater.components.locomotor:SetExternalSpeedMultiplier(eater, debuffkey, 1.5)
                end
            end,
            card_def = {
                ingredients = { { "fish3", 1 }, { "fish4", 1 }, { "fish5", 1 }, { "carrot", 1 } }
            }
        }

    },

    [tabName[3]] = {
        sponge_cake = {
            test = function(cooker, names, tags)
                return tags.dairy and tags.sweetener and tags.sponge and tags.sponge >= 2 and not tags.meat
            end,
            foodtype = FOODTYPE.GOODIES,
            health = 0,
            hunger = 25,
            sanity = 50,
            perishtime = TUNING.PERISH_SUPERFAST,
            cooktime = .5,
            tags = { "honeyed" },
            card_def = {
                ingredients = { { "sponge_piece", 2 }, { "goatmilk", 1 }, { "honey", 1 } }
            }
        },

        fish_n_chips = {
            test = function(cooker, names, tags)
                return tags.fish and tags.fish >= 2 and tags.veggie and tags.veggie >= 2
            end,
            priority = 10,
            health = 25,
            hunger = 42.5,
            sanity = 10,
            perishtime = TUNING.PERISH_FAST,
            cooktime = 1,
            card_def = {
                ingredients = { { "fish_fillet", 2 }, { "potato", 2 } }
            }
        },

        tuna_muffin = {
            test = function(cooker, names, tags)
                return tags.fish and tags.fish >= 1 and tags.sponge and tags.sponge >= 1 and not tags.twigs
            end,
            priority = 5,
            health = 0,
            hunger = 32.5,
            sanity = 10,
            perishtime = TUNING.PERISH_MED,
            cooktime = 2,
            card_def = {
                ingredients = { { "fish_fillet", 1 }, { "sponge_piece", 1 }, { "carrot", 2 } }
            }
        },

        tentacle_sushi = {
            test = function(cooker, names, tags)
                return tags.tentacle and tags.tentacle > 1 and tags.sea_veggie and tags.fish >= 0.5 and not tags.twigs
            end,
            health = 35,
            hunger = 5,
            sanity = 5,
            perishtime = TUNING.PERISH_MED,
            cooktime = 2,
            card_def = {
                ingredients = { { "trinket_12", 2 }, { "fish_fillet", 2 } }
            }
        },

        flower_sushi = {
            test = function(cooker, names, tags)
                return tags.flower and tags.sea_veggie and tags.fish and tags.fish >= 1 and not tags.twigs
            end,
            health = 10,
            hunger = 5,
            sanity = 30,
            perishtime = TUNING.PERISH_MED,
            cooktime = 2,
            card_def = {
                ingredients = { { "sea_petals", 1 }, { "seagrass_chunk", 1 }, { "fish_fillet", 2 } }
            }
        },

        fish_sushi = {
            test = function(cooker, names, tags)
                return tags.tentacle and tags.veggie >= 1 and tags.fish and tags.fish >= 1 and not tags.twigs
            end,
            health = 5,
            hunger = 50,
            sanity = 0,
            perishtime = TUNING.PERISH_MED,
            cooktime = 2,
            card_def = {
                ingredients = { { "trinket_12", 1 }, { "fish_fillet", 1 }, { "seagrass_chunk", 2 } }
            }
        },

        seajelly = {
            test = function(cooker, names, tags)
                return tags.sea_jelly and tags.sea_jelly > 1 and names.saltrock and names.saltrock > 1 and not tags.meat
            end,
            health = 20,
            hunger = 40,
            sanity = 3,
            perishtime = TUNING.PERISH_SLOW,
            cooktime = 2,
            card_def = {
                ingredients = { { "jelly_cap", 2 }, { "saltrock", 2 } }
            }
        },

        fish_gazpacho = {
            test = function(cooker, names, tags)
                return (names.fish_fillet or names.fish_fillet_cooked) and tags.veggie and tags.veggie >= 1 and
                    tags.frozen and tags.frozen >= 2
            end,
            priority = 35, -- or 10?
            health = TUNING.HEALING_MED - TUNING.HEALING_SMALL,
            hunger = TUNING.CALORIES_LARGE,
            sanity = TUNING.SANITY_SUPERTINY,
            perishtime = TUNING.PERISH_FAST,
            cooktime = 1,
            card_def = {
                ingredients = { { "fish_fillet", 1 }, { "seagrass_chunk", 1 }, { "ice", 2 } }
            }
        }
    },

    [tabName[4]] = {
        fruityjuice = {
            test = function(cooker, names, tags)
                return names.blueberries_cooked and names.blueberries_cooked == 2 and names.foliage and tags.frozen or
                    names.blueberries and names.blueberries == 2 and names.foliage and tags.frozen
            end,
            priority = 1,
            weight = 1,
            foodtype = FOODTYPE.VEGGIE,
            health = TUNING.HEALING_MED,
            perishtime = TUNING.PERISH_FAST,
            hunger = TUNING.CALORIES_LARGE,
            sanity = TUNING.SANITY_TINY,
            cooktime = 2,
            tags = {},
            card_def = {
                ingredients = { { "blueberries", 2 }, { "foliage", 2 } }
            }
        }
    },

    [tabName[5]] = {
        peach_smoothie = {
            test = function(cooker, names, tags)
                return
                    (names.peach or names.grilled_peach) and (names.peach or names.grilled_peach) >= 2 and tags.dairy and
                    tags.sweetener and not tags.meat and not tags.egg and not tags.inedible and not tags.monster
            end,
            priority = 100,
            weight = 1,
            foodtype = FOODTYPE.GOODIES,
            health = 10,
            hunger = 65,
            sanity = 10,
            perishtime = TUNING.PERISH_MED,
            tags = { "honeyed" },
            card_def = {
                ingredients = { { "peach", 2 }, { "goatmilk", 1 }, { "honey", 1 } }
            }
        },

        peach_kabobs = {
            test = function(cooker, names, tags)
                return (names.peach or names.grilled_peach) and names.twigs and tags.veggie and tags.veggie >= 1 and
                    tags.meat and tags.meat >= 1 and not tags.egg and not tags.monster
            end,
            priority = 100,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = 3,
            hunger = 75,
            sanity = 5,
            perishtime = TUNING.PERISH_MED,
            card_def = {
                ingredients = { { "peach", 1 }, { "carrot", 1 }, { "meat", 1 }, { "twigs", 1 } }
            }
        },

        peachy_meatloaf = {
            test = function(cooker, names, tags)
                return
                    (names.peach or names.grilled_peach) and (names.peach or names.grilled_peach) >= 2 and tags.meat and
                    tags.meat >= 2 and not tags.egg
            end,
            priority = 100,
            weight = 1,
            foodtype = FOODTYPE.MEAT,
            health = 10,
            hunger = 80,
            sanity = 5,
            perishtime = TUNING.PERISH_SLOW,
            card_def = {
                ingredients = { { "peach", 2 }, { "meat", 2 } }
            }
        },

        caramel_peach = {
            test = function(cooker, names, tags)
                return
                    (names.peach or names.grilled_peach) and tags.sweetener and tags.sweetener >= 2 and names.twigs and
                    not tags.meat and not tags.egg and not tags.monster
            end,
            priority = 100,
            weight = 1,
            foodtype = FOODTYPE.GOODIES,
            health = 40,
            hunger = 45,
            sanity = 5,
            perishtime = TUNING.PERISH_SLOW,
            tags = { "honeyed" },
            card_def = {
                ingredients = { { "peach", 1 }, { "honey", 2 }, { "twigs", 1 } }
            }
        },

        -- Runar: 没有适配调味的必要
        -- peach_juice_bottle_green = {
        --     test = function(cooker, names, tags)
        --         return
        --             (names.peach or names.grilled_peach) and (names.peach or names.grilled_peach) >= 2 and tags.sweetener and
        --                 tags.water and not tags.meat and not tags.egg and not tags.monster
        --     end,
        --     priority = 100,
        --     weight = 1,
        --     foodtype = FOODTYPE.GOODIES,
        --     health = 15,
        --     hunger = 35,
        --     sanity = 5,
        --     tags = { "honeyed" },
        --     card_def = {ingredients = {{"peach", 2}, {"honey", 1}, {"full_bottle_green", 1} } },
        -- },

        -- potion_bottle_green = {
        --     test = function(cooker, names, tags)
        --         return tags.peachy and tags.goddessmagic and tags.loaf and (names.peach or names.grilled_peach)
        --     end,
        --     priority = 100,
        --     weight = 1,
        --     foodtype = FOODTYPE.GOODIES,
        --     health = 75,
        --     hunger = 75,
        --     sanity = 75,
        --     card_def = {ingredients = {{"peach", 1}, {"peach_juice_bottle_green", 1}, {"peachy_meatloaf", 1}, {"magicpowder", 1} } },
        -- },

        peach_custard = {
            test = function(cooker, names, tags)
                return (names.peach or names.grilled_peach) and tags.egg and tags.sweetener and
                    (names.peach or names.grilled_peach) >= 2 and not names.twigs and not tags.meat and
                    not tags.monster
            end,
            priority = 100,
            weight = 1,
            foodtype = FOODTYPE.GOODIES,
            health = 20,
            hunger = 62,
            sanity = 5,
            perishtime = TUNING.PERISH_SLOW,
            card_def = {
                ingredients = { { "peach", 2 }, { "honey", 1 }, { "bird_egg", 1 } }
            }
        }
    }

}

for tabIdx, foodTab in pairs(foods_tro) do
    for foodName, foodDef in pairs(foodTab) do
        foodDef.name = foodName
        foodDef.basename = foodName
        foodDef.weight = foodDef.weight or 1
        foodDef.priority = foodDef.priority or 0
        foodDef.foodtype = foodDef.foodtype or FOODTYPE.MEAT -- for creep
        foodDef.overridebuild = overridebuild[tabIdx]
        foodDef.floater = foodDef.floater or { "small", 0.05, 0.7 }
        foodDef.mod = true
        -- foodDef.cookbook_tex = foodName..".tex"
        foodDef.cookbook_atlas = cookbook_atlas[tabIdx] or ("images/inventoryimages/" .. foodName .. ".xml")
        foodDef.atlasname = foodDef.atlasname or inventoryitem_atlas[tabIdx] or
        "images/inventoryimages/" .. foodName .. ".xml"
        if foodDef.oneatenfn then
            foodDef.oneat_desc = STRINGS.UI.COOKBOOK[string.upper(foodName)]
        end
    end
end

return foods_tro
