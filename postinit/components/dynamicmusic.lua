local soundremap = {

    shipwrecked = {
        ["dontstarve/music/music_epicfight"] = "dontstarve_DLC002/music/music_epicfight_season_1",
        ["dontstarve/music/music_epicfight_winter"] = "dontstarve_DLC002/music/music_epicfight_season_2",
        ["dontstarve_DLC001/music/music_epicfight_spring"] = "dontstarve_DLC002/music/music_epicfight_season_3",
        ["dontstarve_DLC001/music/music_epicfight_summer"] = "dontstarve_DLC002/music/music_epicfight_season_4",
        --Working
        ["dontstarve/music/music_work"] = "dontstarve_DLC002/music/music_work_season_1",
        ["dontstarve/music/music_work_winter"] = "dontstarve_DLC002/music/music_work_season_2",
        ["dontstarve_DLC001/music/music_work_spring"] = "dontstarve_DLC002/music/music_work_season_3",
        ["dontstarve_DLC001/music/music_work_summer"] = "dontstarve_DLC002/music/music_work_season_4",
        --dawndusk
        ["dontstarve/music/music_dawn_stinger"] = "dontstarve_DLC002/music/music_dawn_stinger",
        ["dontstarve/music/music_dusk_stinger"] = "dontstarve_DLC002/music/music_dusk_stinger",
        --Danger
        ["dontstarve/music/music_danger"] = "dontstarve_DLC002/music/music_danger_season_1",
        ["dontstarve/music/music_danger_winter"] = "dontstarve_DLC002/music/music_danger_season_2",
        ["dontstarve_DLC001/music/music_danger_spring"] = "dontstarve_DLC002/music/music_danger_season_3",
        ["dontstarve_DLC001/music/music_danger_summer"] = "dontstarve_DLC002/music/music_danger_season_4",
    },

    hamlet = {
        ["dontstarve/music/music_epicfight"] = "dontstarve_DLC003/music/fight_epic_1",
        ["dontstarve/music/music_epicfight_winter"] = "dontstarve_DLC003/music/fight_epic_2",
        ["dontstarve_DLC001/music/music_epicfight_spring"] = "dontstarve_DLC003/music/fight_epic_3",
        ["dontstarve_DLC001/music/music_epicfight_summer"] = "dontstarve_DLC003/music/fight_epic_4",
        --Working
        ["dontstarve/music/music_work"] = "dontstarve_DLC003/music/working_1",
        ["dontstarve/music/music_work_winter"] = "dontstarve_DLC003/music/working_2",
        ["dontstarve_DLC001/music/music_work_spring"] = "dontstarve_DLC003/music/working_1",
        ["dontstarve_DLC001/music/music_work_summer"] = "dontstarve_DLC003/music/working_3",
        --dawndusk
        ["dontstarve/music/music_dawn_stinger"] = "dontstarve_DLC003/music/dawn_stinger_1_temperate",
        ["dontstarve/music/music_dusk_stinger"] = "dontstarve_DLC003/music/dusk_stinger_1_temperate",
        --Danger
        ["dontstarve/music/music_danger"] = "dontstarve_DLC003/music/fight_1",
        ["dontstarve/music/music_danger_winter"] = "dontstarve_DLC003/music/fight_2",
        ["dontstarve_DLC001/music/music_danger_spring"] = "dontstarve_DLC003/music/fight_3",
        ["dontstarve_DLC001/music/music_danger_summer"] = "dontstarve_DLC003/music/fight_4",
    }
}


-- for k, v in pairs(soundremap.shipwrecked) do
--     TroRemapSound(k, v)
-- end

local BUSYTHEMES = nil
local StopBusy = nil
AddComponentPostInit("dynamicmusic", function(self, inst)
    ------------------------------Adding Climate Music---------------------------------
    local _activatedplayer
    if not BUSYTHEMES then
        local OnPlayerActivated = Hooks.GetEventCallback(inst, "playeractivated", inst, "scripts/components/dynamicmusic.lua")
        local StartPlayerListeners = OnPlayerActivated and Hooks.FindUpvalue(OnPlayerActivated, "StartPlayerListeners")
        local StartBusy = StartPlayerListeners and Hooks.FindUpvalue(StartPlayerListeners, "StartBusy")
        BUSYTHEMES = StartBusy and Hooks.FindUpvalue(StartBusy, "BUSYTHEMES")
        if not BUSYTHEMES then
            print("dynamicmusic组件hook失败，没有拿到BUSYTHEMES")
            return --放弃了，后面代码不执行了
        end

        BUSYTHEMES.ROG = BUSYTHEMES.FOREST
        BUSYTHEMES.SHIPWRECCKED = table.count(BUSYTHEMES) + 1
        BUSYTHEMES.HAMLET = table.count(BUSYTHEMES) + 1
        BUSYTHEMES.VOLCANO = table.count(BUSYTHEMES) + 1
    end

    if not StopBusy then
        local OnEnableDynamicMusic = Hooks.GetEventCallback(inst, "enabledynamicmusic")
        StopBusy = Hooks.FindUpvalue(OnEnableDynamicMusic, "StopBusy")
    end

    local function MusicReDirect()
        if _activatedplayer then
            if StopBusy then
                StopBusy()
            end
            if _activatedplayer:IsInHamletArea() then
                -- print "in hamlet"
                BUSYTHEMES.FOREST = BUSYTHEMES.HAMLET
                for k, v in pairs(soundremap.hamlet) do
                    TroRemapSound(k, v)
                end
            elseif _activatedplayer:IsInShipwreckedArea() then
                -- print "in shipwrecked"
                BUSYTHEMES.FOREST = BUSYTHEMES.SHIPWRECCKED
                for k, v in pairs(soundremap.shipwrecked) do
                    TroRemapSound(k, v)
                end
            else
                -- print "in neither"
                BUSYTHEMES.FOREST = BUSYTHEMES.ROG
                for k, v in pairs(soundremap.shipwrecked) do
                    TroRemapSound(k, nil)
                end
            end
        end
    end

    self.inst:ListenForEvent("playeractivated", function(src, player)
        if player and _activatedplayer ~= player then
            player:ListenForEvent("changearea", MusicReDirect)
            player:DoTaskInTime(1, MusicReDirect) --initialise
        end
        _activatedplayer = player
    end)
    self.inst:ListenForEvent("playerdeactivated", function(src, player)
        if player then
            player:RemoveEventCallback("changearea", MusicReDirect)
            if _activatedplayer == player then
                _activatedplayer = nil
            end
        end
    end)
end)
