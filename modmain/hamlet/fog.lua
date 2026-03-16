table.insert(Assets, Asset("ATLAS", "images/overlays/fog.xml"))



----------------------------------------------------------------------------------------------------

AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then return end

    inst:AddComponent("tro_hamlet_fogspawner") --大雾生成
end)


local function OnStartFogGrog(inst, data)
    inst.components.grogginess:ProStartFoggrog()
end
local function OnStopFogGrog(inst, data)
    inst.components.grogginess:ProStopFoggrog()
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    inst:ListenForEvent("startfoggrog", OnStartFogGrog)
    inst:ListenForEvent("stopfoggrog", OnStopFogGrog)
end)

----------------------------------------------------------------------------------------------------
local GROGGINESS_DECAY_RATE = .01
AddComponentPostInit("grogginess", function(self)
    local OldAddGrogginess = self.AddGrogginess
    --雾气开始减速
    function self:ProStartFoggrog()
        self:SetDecayRate(0)                              --眩晕值不要减
        local old_knockouttestfn = self.knockouttestfn
        self.knockouttestfn = function() return false end --玩家不需要睡着
        OldAddGrogginess(self, 3)
        self.knockouttestfn = old_knockouttestfn
    end

    function self:ProStopFoggrog()
        self:SetDecayRate(GROGGINESS_DECAY_RATE)
    end
end)

----------------------------------------------------------------------------------------------------
local FogOver = require("widgets/fogover")
AddClassPostConstruct("screens/playerhud", function(self)
    Hooks.FnDecorator(self, "CreateOverlays", nil, function(retTab, self, owner, ...)
        -- 大雾
        self.fogover = self.overlayroot:AddChild(FogOver(owner))
        self.fogover:Hide()
        return retTab
    end)

    Hooks.FnDecorator(self, "SetMainCharacter", nil, function(retTab, self, maincharacter)
        if not maincharacter then return retTab end
        self.inst:ListenForEvent("tro_fogchange", function(inst, data) return self.fogover:OnFogStateChange() end, self.owner)
        return retTab
    end)
end)
