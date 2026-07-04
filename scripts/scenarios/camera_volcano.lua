require("mathutil")

local zoomdistance = 100
local distToFinish = 10 --Distance to volcano where you reach max zoom
local distToStart = 65  --Distance from the volcano where you start to zoom
local distToStart_SQ = distToStart * distToStart
local distToFinish_SQ = distToFinish * distToFinish
local distToLerpOver = distToStart_SQ - distToFinish_SQ
local percentFromPlayer = 1

local function Update(inst)
    if not TheWorld.components.volcanomanager then
        return
    end
    -- local closest = TheWorld.components.volcanomanager:GetClosestVolcano()
    -- if closest and closest == inst then
    --     local player = FindClosestPlayerToInst(inst, distToStart)

    --     if player then
    --         TheCamera:SetControllable(false)
    --         local distToTarget = inst:GetDistanceSqToInst(player)
    --         percentFromPlayer = (distToTarget - distToFinish_SQ) / distToLerpOver
    --         --print("percentFromPlayer is " .. percentFromPlayer)
    --         if percentFromPlayer >= 0 and percentFromPlayer <= 1 then
    --             local camDist = Lerp(zoomdistance, inst.prevCamDist, percentFromPlayer)
    --             TheCamera:SetDistance(camDist)
    --             TheCamera:Apply()
    --         elseif percentFromPlayer < 0 then
    --             TheCamera:SetDistance(zoomdistance)
    --             TheCamera:Apply()
    --         end
    --     else
    --         --print("out of range")
    --         if not TheCamera:IsControllable() then
    --             TheCamera:SetDistance(inst.prevCamDist)
    --             TheCamera:SetHeadingTarget(inst.prevCamAngle)
    --             TheCamera:Apply()
    --         end
    --         TheCamera:SetControllable(true)
    --         inst.prevCamAngle = TheCamera:GetHeadingTarget()
    --         inst.prevCamDist = TheCamera:GetDistance()
    --     end
    -- end
end

local function OnLoad(inst, scenariorunner)
    inst.updatetask = inst:DoPeriodicTask(0.05, Update)
    inst.prevCamDist = 30
    inst.prevCamAngle = 45
end

return
{
    OnLoad = OnLoad,
}
