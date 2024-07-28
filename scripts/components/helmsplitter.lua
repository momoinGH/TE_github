local function a(self, b, c)
    if c == true and b == true then
        self.inst:AddTag("helmsplitter")
    elseif c == true and b == false then
        self.inst:RemoveTag("helmsplitter")
    end
end;

local Helmsplitter = Class(function(self, inst)
    self.inst = inst;
    self.ready = true;
    self.damage = 10;
    self.onhelmsplit = nil
end, nil, {
    ready = a,
})

function Helmsplitter:SetOnHelmSplitFn(f)
    self.onhelmsplit = f
end;

function Helmsplitter:StartHelmSplitting(g)
    if g.sg then
        g.sg:PushEvent("start_helmsplit")
        return true
    end;
    return false
end;

function Helmsplitter:DoHelmSplit(g, h)
    if g.sg then
        g.sg:PushEvent("do_helmsplit")
    end;
    g.components.combat:DoSpecialAttack(self.damage, h, "strong", g.components.combat.damagemultiplier)
    if self.onhelmsplit then
        self.onhelmsplit(self.inst, g, h)
    end
end;

function Helmsplitter:StopHelmSplitting(g)
    if g.sg then
        g.sg:PushEvent("stop_helmsplit")
    end;
    self.ready = false
end;

return Helmsplitter
