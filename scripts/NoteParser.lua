function ExtractNote(filename)
    return filename:match("^(.-)%.")
end

local tests = {
    "C4.wav",
    "D#3.wav",
    "A2.wav"
}

for _, filename in ipairs(tests) do
    local note = ExtractNote(filename)
    reaper.ShowConsoleMsg(filename .. " -> " .. note .. "\n")
end 

