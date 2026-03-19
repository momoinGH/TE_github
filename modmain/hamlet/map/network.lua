local topology_save = nil --只能通过hook拿到topology_save
local storygen = nil
local old_buildstory = BuildStory
BuildStory = function(tasks, story_gen_params, level)
    topology_save, storygen = old_buildstory(tasks, story_gen_params, level)
    return topology_save, storygen
end

local make_cities = require("map/tro_city_builder")
local function GlobalPostPopulateAfter(retTab, self, entities, width, height)
    if topology_save and storygen then
        print("Building porkland cities!")
        make_cities(entities, topology_save, width, height)

        topology_save = nil
        storygen = nil
    end


    -- 标记点替换为洞穴裂缝
    if entities["vampirebatcave_potential"] then
        local ents = entities["vampirebatcave_potential"]
        entities["vampirebatcave"] = {}
        local num = 6
        for i = 1, num do
            if #ents > 0 then
                local rand = math.random(1, #ents)
                local save_data = { x = ents[rand].x, z = ents[rand].z }
                table.insert(entities["vampirebatcave"], save_data)
                table.remove(ents, rand)
            end
        end
        entities["vampirebatcave_potential"] = nil
    end

    -- 替换为随机雕像
    print("替换randomruin为随机雕像")
    if entities["randomruin"] then
        for i, ent in ipairs(entities["randomruin"]) do
            local save_data = { x = ent.x, z = ent.z }
            if math.random(1, 2) == 1 then
                entities["pig_ruins_idol"] = entities["pig_ruins_idol"] or {}
                table.insert(entities["pig_ruins_idol"], save_data)
            else
                entities["pig_ruins_plaque"] = entities["pig_ruins_plaque"] or {}
                table.insert(entities["pig_ruins_plaque"], save_data)
            end
        end
        entities["randomruin"] = nil
    end

    -- 替换为随机遗物
    print("替换randomrelic为随机遗物")
    if entities["randomrelic"] then
        for i, ent in ipairs(entities["randomrelic"]) do
            local relic = "relic_" .. tostring(math.random(1, 3))
            local save_data = { x = ent.x, z = ent.z }
            entities[relic] = entities[relic] or {}
            table.insert(entities[relic], save_data)
        end
        entities["randomrelic"] = nil
    end

    -- 替换为随机雕像
    print("替换randomdust为随机雕像")
    if entities["randomdust"] then
        for i, ent in ipairs(entities["randomdust"]) do
            local save_data = { x = ent.x, z = ent.z }
            if math.random(1, 2) == 1 then
                entities["pig_ruins_pig"] = entities["pig_ruins_pig"] or {}
                table.insert(entities["pig_ruins_pig"], save_data)
            else
                entities["pig_ruins_ant"] = entities["pig_ruins_ant"] or {}
                table.insert(entities["pig_ruins_ant"], save_data)
            end
        end
        entities["randomdust"] = nil
    end



    return retTab
end

Hooks.FnDecorator(Graph, "GlobalPostPopulate", nil, GlobalPostPopulateAfter)
