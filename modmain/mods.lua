-- for client mod ActionQueue
AddComponentPostInit("actionqueuer", function(self)
    if self.AddActionList then
        self.AddActionList("allclick", "HACK")
        self.AddActionList("leftclick", "HACK")
        self.AddActionList("autocollect", "HACK")
        self.AddActionList("noworkdelay", "HACK")
    end
end)
