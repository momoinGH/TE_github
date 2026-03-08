--渡渡鸟数量控制
_G.SEABEACH_AMOUNT = {
    doydoy = 0,
}

-- 蜜箱里会刷出的东西
ANTCHEST_PRESERVATION = {
    honey = true,
    royal_jelly = true,
    nectar_pod = true,
    pollen_item = true,
}
GLOBAL.ANTCHEST_PRESERVATION = ANTCHEST_PRESERVATION

-- 是否在哈姆雷特雾气中
function TroInHamlteFogImple(inst)
    return TheWorld.state.israining                                           --下雨
        and TheWorld.state.moisture > 500                                     --潮湿度，雨越下越小，这个值要看着效果调整
        and TheWorld.state.issummer                                           --夏天当潮湿季用
        and inst:IsInHamletArea()                                             --在哈姆雷特区域
        and not TheWorld.Map:TroIsWorldOut(inst.Transform:GetWorldPosition()) --不在虚空小房子里或虚空洞穴里
end

GLOBAL.TroInHamlteFogImple = TroInHamlteFogImple

-- 是否可以抵抗哈姆雷特雾气
function TroCanResistHamletFog(player)
    if player:HasTag("playerghost") then
        return true
    end
    if player.components.inventory then
        return player.components.inventory:EquipHasTag("clearfog")
    elseif player.replica.inventory then
        return player.replica.inventory:EquipHasTag("clearfog")
    end
end
