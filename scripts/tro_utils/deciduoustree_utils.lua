-- 处理毒桦栗树相关逻辑，因为这个树精没有血量只能砍树，所以需要做一些处理才能让单位被触手攻击后去砍

local SUGGESTTARGET_MUST_TAGS = { "_combat", "_health" }
local SUGGESTTARGET_CANT_TAGS = { "INLIMBO" }
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

---在attacked事件里调用这个，返回值为true就表示攻击的是树根，告诉自己和同伴要砍的树，在brain里配合BrainCommon.NodeAssistLeaderDoAction使用
local function OnAttackedByDecidRoot(inst, attacker, friend_must_tags, friend_cant_tags)
    if not (attacker and attacker.prefab == "deciduous_root" and attacker.owner ~= nil) then
        return false
    end

    friend_cant_tags = friend_cant_tags or {}
    table.troinserttable_unique(friend_cant_tags, SUGGESTTARGET_CANT_TAGS)
    local ents
    if friend_must_tags then
        table.troinserttable_unique(friend_must_tags, SUGGESTTARGET_MUST_TAGS)
        local x, y, z = inst.Transform:GetWorldPosition()
        ents = TheSim:FindEntities(x, y, z, SpringCombatMod(SHARE_TARGET_DIST) * .5, friend_must_tags, friend_cant_tags)
    else
        friend_must_tags = SUGGESTTARGET_MUST_TAGS
        ents = {}
        if inst:HasTags(friend_must_tags) and not inst:HasOneOfTags(friend_cant_tags) then
            table.insert(ents, inst)
        end
    end

    if #ents <= 0 then
        return false
    end

    local num_helpers = 0
    for _, v in ipairs(ents) do
        if not v.components.health:IsDead() then
            v:PushEvent("suggest_tree_target", { tree = attacker })
            v.tree_target = attacker --直接赋值，不监听事件也行
            num_helpers = num_helpers + 1
            if num_helpers >= MAX_TARGET_SHARES then
                break
            end
        end
    end

    return true
end


return {
    OnAttackedByDecidRoot = OnAttackedByDecidRoot
}
