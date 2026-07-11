local scriptPath = debug.getinfo(1, "S").source:match("@?(.*[\\/])")

dofile(scriptPath .. "FileUtils.lua")
dofile(scriptPath .. "RS5K.lua")
dofile(scriptPath .. "NoteParser.lua")
dofile(scriptPath .. "MidiUtils.lua")


local retval, samplePath =
    reaper.GetUserFileNameForRead("", "Choose Sample", "wav")

if not retval then
    return
end

local folder = GetFolder(samplePath)

local files = GetWavFiles(folder)

for _, file in ipairs(files) do

    local fullPath = folder .. "\\" .. file

    LoadSampleIntoRS5K(fullPath)

end