-- Main script:
-- Select a sample folder and automatically build an RS5K instrument.

local scriptPath = debug.getinfo(1, "S").source:match("@?(.*[\\/])")

local FileUtils = dofile(scriptPath .. "FileUtils.lua")
local RS5K = dofile(scriptPath .. "RS5K.lua")
local NoteParser = dofile(scriptPath .. "NoteParser.lua")
local MidiUtils = dofile(scriptPath .. "MidiUtils.lua")


-- Ask user to select one sample from the sample folder.
reaper.ShowMessageBox(
    "Select any WAV file inside the folder you want to convert.\n\n" ..
    "The script will automatically load all WAV files in that folder.",
    "Quick Sampler Builder",
    0
)

local retval, samplePath = reaper.GetUserFileNameForRead("", "Choose a WAV file inside your sample folder", "wav")

if not retval then
    return
end

local folder = FileUtils.getFolder(samplePath)
local files = FileUtils.getWavFiles(folder)


-- Build the sampler instrument.
for _, file in ipairs(files) do
    local fullPath = folder .. "\\" .. file
    local note = NoteParser.extractNote(file)

    if not note then
        reaper.ShowMessageBox(
            "Could not determine the note from:\n\n" .. file ..
            "\n\nExpected filenames like:\nC4.wav\nC#4.wav",
            "Invalid Filename",
            0
        )
        goto continue
    end

    local midi = MidiUtils.noteToMidi(note)
    RS5K.loadSampleIntoRS5K(fullPath, midi)

    ::continue::
end
