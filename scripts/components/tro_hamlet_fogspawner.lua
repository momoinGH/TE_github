-- 哈姆雷特大雾生成
local FogSpawner = Class(function(self, inst)
    self.inst = inst

    self.in_fog_players = {} --在起雾范围的玩家
    self.grog_players = {}   --正在减速的玩家

    inst:StartUpdatingComponent(self)
end)

local function PlayerStopFog(self, player)
    if self.in_fog_players[player.GUID] then
        self.in_fog_players[player.GUID] = nil
        player:TroSetPlayerClassifiedNetVar("tro_fog", false) --玩家客户端会推送tro_fogchange事件
    end
end

local function PlayerStartFog(self, player)
    if not self.in_fog_players[player.GUID] then
        self.in_fog_players[player.GUID] = true
        player:TroSetPlayerClassifiedNetVar("tro_fog", true)
    end
end

-- 检查每个玩家是否应该起雾
function FogSpawner:OnUpdate(dt)
    for _, player in ipairs(AllPlayers) do
        if TroInHamlteFogImple(player) then --在哈姆雷特区域，不在小房子里
            PlayerStartFog(self, player)
        else
            PlayerStopFog(self, player)
        end

        if self.grog_players[player.GUID] or (self.in_fog_players[player] and not self.grog_players[player.GUID]) then
            --刷新抵抗情况
            local can_resist = TroCanResistHamletFog(player)
            if can_resist == self.grog_players[player.GUID] then
                if can_resist then
                    player:PushEvent("stopfoggrog")
                    self.grog_players[player.GUID] = nil
                else
                    player:PushEvent("startfoggrog")
                    self.grog_players[player.GUID] = true
                end
            end
        end
    end
end

return FogSpawner
