Hooks.FnDecorator(GLOBAL, "PlayFootstep", function(inst)
    return nil, inst:TroGetSWBoat() --海难小船时不播放走路音效
end)
