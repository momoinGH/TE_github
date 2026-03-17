local function GlobalPostPopulateAfter(retTab, root, entities, width, height)
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
    if entities["randomruin"] then
        for i, ent in ipairs(entities["randomruin"]) do
            local save_data = { x = ent.x, z = ent.z }
            if math.random(1, 2) == 1 then
                table.insert(entities["pig_ruins_idol"], save_data)
            else
                table.insert(entities["pig_ruins_plaque"], save_data)
            end
        end
        entities["randomruin"] = nil
    end

    -- 替换为随机遗物
    if entities["randomrelic"] then
        for i, ent in ipairs(entities["randomrelic"]) do
            local relic = "relic_" .. tostring(math.random(1, 3))
            local save_data = { x = ent.x, z = ent.z }
            table.insert(entities[relic], save_data)
        end
        entities["randomrelic"] = nil
    end

    -- 替换为随机雕像
    if entities["randomdust"] then
        for i, ent in ipairs(entities["randomdust"]) do
            local save_data = { x = ent.x, z = ent.z }
            if math.random(1, 2) == 1 then
                table.insert(entities["pig_ruins_pig"], save_data)
            else
                table.insert(entities["pig_ruins_ant"], save_data)
            end
        end
        entities["randomdust"] = nil
    end



    return retTab
end

Hooks.FnDecorator(Graph, "GlobalPostPopulate", nil, GlobalPostPopulateAfter)
