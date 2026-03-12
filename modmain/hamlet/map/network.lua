-- 标记点替换为洞穴裂缝
local function GlobalPostPopulateAfter(retTab, root, entities, width, height)
    local ents = entities["vampirebatcave_potential"]
    if not ents then
        return retTab
    end

    entities["vampirebatcave"] = {}
    local num = 6

    -- 控制蝙蝠洞穴的密度，不过现在还没有世界生成设置的功能
    -- I didn't want to use the same multiply system, so I'm translating it here.
    -- if current_gen_params and current_gen_params["vampirebatcave"] then
    --     if current_gen_params["vampirebatcave"] == 0 then
    --         num = 0
    --     elseif current_gen_params["vampirebatcave"] == 2 then
    --         num = num * 3
    --     elseif current_gen_params["vampirebatcave"] == 1.5 then
    --         num = num * 2
    --     elseif current_gen_params["vampirebatcave"] == 0.5 then
    --         num = math.ceil(num / 2)
    --     end
    -- end

    for i = 1, num do
        if #ents > 0 then
            local rand = math.random(1, #ents)
            local save_data = { x = ents[rand].x, z = ents[rand].z }
            table.insert(entities["vampirebatcave"], save_data)
            table.remove(ents, rand)
        end
    end


    entities["vampirebatcave_potential"] = nil
    return retTab
end

Hooks.FnDecorator(Graph, "GlobalPostPopulate", nil, GlobalPostPopulateAfter)
