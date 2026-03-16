local SoundRedirectMap = {}

local old_play = SoundEmitter.PlaySound
function SoundEmitter.PlaySound(self, name, ...)
    return old_play(self, SoundRedirectMap[name] or name, ...)
end

local old_playp = SoundEmitter.PlaySoundWithParams
function SoundEmitter.PlaySoundWithParams(self, name, ...)
    return old_playp(self, SoundRedirectMap[name] or name, ...)
end

-- 重新映射音效，TODO 这个和RemapSoundEvent有什么区别，RemapSoundEvent能实现这个功能吗
function TroRemapSound(name, alias)
    SoundRedirectMap[name] = alias
end
