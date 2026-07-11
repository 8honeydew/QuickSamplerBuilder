-- Main script:
-- Select a sample folder and automatically build an RS5K instrument.


local scriptPath = debug.getinfo(1, "S").source:match("@?(.*[\\/])")


-- Load project modules.
dofile(scriptPath .. "FileUtils.lua")
dofile(scriptPath .. "RS5K.lua")
dofile(scriptPath .. "NoteParser.lua")
dofile(scriptPath .. "MidiUtils.lua")


-- Ask user to select one sample from the sample folder.
reaper.ShowMessageBox(
    "Select any WAV file inside the folder you want to convert.\n\n" ..
    "The script will automatically load all WAV files in that folder.",
    "Quick Sampler Builder",
    0
)

local retval, samplePath =
    reaper.GetUserFileNameForRead("", "Choose a WAV file inside your sample folder", "wav")

if not retval then
    return
end


local folder = getFolder(samplePath)

local files = getWavFiles(folder)


-- Build the sampler instrument.
for _, file in ipairs(files) do

    local fullPath = folder .. "\\" .. file

    local note = extractNote(file)

    if not note then

        reaper.ShowMessageBox(
            "Could not determine the note from:\n\n" ..
            file ..
            "\n\nExpected filenames like:\nC4.wav\nC#4.wav",
            "Invalid Filename",
            0
        )

        goto continue
    end


    local midi = noteToMidi(note)

    loadSampleIntoRS5K(fullPath, midi)

    
    ::continue::

end
