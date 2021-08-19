


local SoundSys = Cyan.System()
--[[
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!



System in control of sound handling.

Sounds will be automatically grouped together depending on their
filename.
`main` stands for main sounds,
`bg` stands for background sounds.
(background sounds can vary in volume)
usually the main sounds will be the loudest.


For example:

`boom_main1.ogg`, `boom_main2.ogg`, `boom_bg1.ogg`, `boom_bg2.ogg`.
In this scenario, whenever `boom` is envoked,
either main1 or main2 will play, and BOTH bg (background) sounds will be played.

each soundGroup is represented by this:

exampleSoundGroup {
    mainSounds = { };
    backgroundSounds = { }
}

]]

local sounds = require("src.misc.sound")



-- Hasher to each sound group by KW
local soundGroups = { }


local availableSourceClones = {
    -- hasher of:
    --  {  [src] = set()   }
    -- to allow us to play the same sound
    -- multiple times at the same time
}


for k,src in pairs(sounds) do
    if k:find("_") then
        local s = k:find("_")
        local groupName = k:sub(1,s-1)
        assert(groupName:len()>0, "Wtf? started with an _ ?? sound_TREE_push not working")

        -- Construction
        soundGroups[groupName] = soundGroups[groupName] or {
            mainSounds = { };
            backgroundSounds = { }
        }

        availableSourceClones[src] = Tools.set()

        local group = soundGroups[groupName]

        if k:sub(s+1,s+2)=="bg" then
            table.insert(group.backgroundSounds, src)  
        else
            assert(k:sub(s+1,s+4) == "main", "wrong sound filetype for `".. k .."`.\n See SoundSys")
            table.insert(group.mainSounds, src)
        end
    else
        error("Incorrect format for sound file: ".. k .."\n See misc/sounds/init.lua")
    end
end



local rand_choice = Tools.rand_choice
local sin = math.sin
local rand = love.math.random
local play = love.audio.play


-- Tables { [src_name] : number }
-- that keep track of the original pitch and volume of sources
local originalVolumes = { } 
local originalPitches = { }


local function getFreeSource(src)
    if not src:isPlaying() then
        return src
    else
        local srcSet = availableSourceClones[src]
        assert(srcSet, "srcSet was nil, why? (src: " .. tostring(src) .." )")
        for _, clone in ipairs(srcSet.objects) do
            if not clone:isPlaying() then
                return clone
            end
        end
        local newSrcClone = src:clone()
        availableSourceClones[src]:add(newSrcClone)
        return newSrcClone
    end
end



local max = math.max
local min = math.min

local function playSound(src, vol, pitch, vol_v, p_v)
    src = getFreeSource(src)
    vol = min(1, vol + vol_v * sin( rand() * 3.14 )) * CONSTANTS.SFX_VOLUME
    src:setVolume(vol)
    src:setPitch (pitch + (p_v) * sin(rand()*3.14))
    
    play( src )
end





function SoundSys:sound(sound, volume, pitch,
                        volume_variance,  pitch_variance)
    --[[
        sound : string
        volume : 0 no sound   ->   1 max vol
        volume_variance : 0.2 => sound vol will vary by 0.2 (default 0)
        pitch_variance  : 0.1 => pitch will vary by 0.1     (default 0)
    ]]
    volume = volume or 1
    pitch = pitch or 1
    volume_variance = volume_variance or 0
    pitch_variance = pitch_variance or 0

    if soundGroups[sound] then
        local group = soundGroups[sound]
        playSound( rand_choice(group.mainSounds), volume, pitch, volume_variance, pitch_variance)
        for _,src in ipairs(group.backgroundSounds) do
            playSound(src, volume, pitch, volume_variance, pitch_variance )
        end
    else
        if not sounds[sound] then
            error("Missing sound : "..sound)
        end
        playSound(sounds[sound], volume, pitch, volume_variance, pitch_variance)
    end
end




local current_music = nil
local current_music_type = nil
local current_music_volmod = nil -- The current world sound modifier
        -- (We need this because some songs are different in volume.)


local worldTypes = require("src.misc.worldGen.worldTypes._worldTypes")


local function changeMusic(music_str)
    assert(sounds[music_str], "unknown music:  "..music_str)
    local src = sounds[music_str]

    current_music_type = music_str
    
    if current_music then
        current_music:stop()
    end

    current_music = src
    src:setLooping(true)
    local volmod = current_music_volmod or 1
    src:setVolume(CONSTANTS.MUSIC_VOLUME or volmod)
    love.audio.play(src)
end


function SoundSys:update(dt)
    if current_music then
        local volmod = current_music_volmod or 1
        current_music:setVolume(CONSTANTS.MUSIC_VOLUME * volmod)
        if CONSTANTS.paused then
            current_music:pause()
        else
            if not current_music:isPlaying() then
                current_music:resume()
            end
        end
    end
end



function SoundSys:newWorld(world,_)
    local wtable = worldTypes[world.type][world.tier]
    if wtable.music and wtable.music ~= current_music_type then
        changeMusic(wtable.music)
        current_music_volmod = wtable.music_volmod or 1
    end
end


