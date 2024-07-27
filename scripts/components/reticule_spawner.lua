local function a(self)
    for b, c in ipairs({ "task", "timeout_task" }) do
        if self[c] then
            self[c]:Cancel()
            self[c] = nil
        end
    end
end;

local ReticuleSpawner = Class(function(self, e)
    self.inst = e;
    self.time = 2;
    self.type = "aoe"
    self.ping = nil;
    self.task = nil
end)

function ReticuleSpawner:OnCastAoeSpelled()
    if not self.ping then return end

    a(self)
    self.task = self.ping:DoTaskInTime(self.time or 2, function()
        self:KillRet()
        self.task = nil
    end)
end

function ReticuleSpawner:Setup(h, i)
    self.type = h or "aoe"
    self.time = i or 2
end;

function ReticuleSpawner:Spawn(j)
    if self.task then
        self.task:Cancel()
        self.task = nil;
        self:KillRet()
    end;
    self.ping = SpawnAt("reticule" .. self.type, j)
    self.timeout_task = self.inst:DoTaskInTime(4, function()
        print("ReticuleSpawner: Timeouted!")
        self:Interrupt()
    end)
end;

function ReticuleSpawner:KillRet()
    if self.ping then
        self.ping:KillFX()
        self.ping = nil
    end;
end;

function ReticuleSpawner:Interrupt()
    a(self)
    self:KillRet()
end;

return ReticuleSpawner
