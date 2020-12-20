


local PATH = "assets/sounds"
--[[

Loads all SFX and music into a table.

SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!



The catch:
If a sound file has the string `LONG` in it's name,
it is registered as a sound file that is too long
to be loaded into memory.
(Do this for music files, SFX can be loaded into mem)





`SoundSys` will manage grouping together sounds:

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


local newSound = love.audio.newSource


local function sound_TREE_push(PATH, tabl)
    for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
        if fname:sub(1,1) ~= "_" then

            local proper_name = fname:gsub("%.%w+", "")

            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)

            if info.type == "directory" then
                sound_TREE_push(fname, tabl)
            else
                if fname:find("LONG") then
                    tabl[proper_name:gsub("LONG", "")] = newSound(PATH.."/"..fname)
                else
                    tabl[proper_name] = newSound(fname, "static")
                end
            end
        end
    end
    return tabl
end



local sounds = {  }



sound_TREE_push(PATH, sounds)


return sounds
