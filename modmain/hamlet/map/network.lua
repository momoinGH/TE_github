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










    return retTab
end

Hooks.FnDecorator(Graph, "GlobalPostPopulate", nil, GlobalPostPopulateAfter)
