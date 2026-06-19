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
local function Update(inst, self)
    for _, player in ipairs(AllPlayers) do
        if TroInHamletFogImple(player) then --在哈姆雷特区域，不在小房子里
            PlayerStartFog(self, player)
        else
            PlayerStopFog(self, player)
        end

        local can_resist = TroCanResistHamletFog(player)
        if self.grog_players[player.GUID] and (can_resist or not self.in_fog_players[player.GUID]) then
            --正在减速的玩家能抵抗
            player:PushEvent("stopfoggrog")
            self.grog_players[player.GUID] = nil
        elseif not self.grog_players[player.GUID] and self.in_fog_players[player.GUID] and not can_resist then
            player:PushEvent("startfoggrog")
            self.grog_players[player.GUID] = true
        end
    end
end

-- 哈姆雷特大雾生成
local FogSpawner = Class(function(self, inst)
    self.inst = inst

    self.in_fog_players = {} --在起雾范围的玩家
    self.grog_players = {}   --正在减速的玩家

    inst:DoPeriodicTask(0.2, Update, 0.2, self)
end)


return FogSpawner
