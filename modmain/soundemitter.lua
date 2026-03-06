local SoundRedirectMap = {}

local old_play = SoundEmitter.PlaySound
function SoundEmitter.PlaySound(self, name, ...)
    return old_play(self, SoundRedirectMap[name] or name, ...)
end

local old_playp = SoundEmitter.PlaySoundWithParams
function SoundEmitter.PlaySoundWithParams(self, name, ...)
    return old_playp(self, SoundRedirectMap[name] or name, ...)
end

-- 重新映射音效
function RemapSound(name, alias)
    SoundRedirectMap[name] = alias
end