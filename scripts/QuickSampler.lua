-- Main script:
-- Select a sample folder, preview the detected note mappings, then
-- build (or add to) an RS5K instrument.

local scriptPath = debug.getinfo(1, "S").source:match("@?(.*[\\/])")

local FileUtils = dofile(scriptPath .. "FileUtils.lua")
local RS5K = dofile(scriptPath .. "RS5K.lua")
local NoteParser = dofile(scriptPath .. "NoteParser.lua")
local MidiUtils = dofile(scriptPath .. "MidiUtils.lua")
local Preview = dofile(scriptPath .. "Preview.lua")


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

if #files == 0 then
    reaper.ShowMessageBox(
        "No WAV files were found in:\n\n" .. folder,
        "Quick Sampler Builder",
        0
    )
    return
end

local mappings, invalidFiles = Preview.buildMappings(files, NoteParser, MidiUtils)
 
if #mappings == 0 then
    reaper.ShowMessageBox(
        "None of the WAV files in this folder could be mapped to a note.\n\n" ..
        "Expected filenames like C4.wav or C#4.wav.",
        "Quick Sampler Builder",
        0
    )
    return
end


-- Preview the detected mappings before touching the project at all.
local previewChoice = reaper.ShowMessageBox(
    Preview.formatSummary(mappings, invalidFiles) .. "\n\nBuild this instrument?",
    "Quick Sampler Builder - Preview",
    1  -- OK / Cancel
)
 
if previewChoice ~= 1 then
    return
end
 

-- Build the sampler instrument.
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local track, proceed = RS5K.prepareInstrumentTrack()

if not proceed then
    reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock("Build Quick Sampler instrument (cancelled)", -1)
    return
end

local loadedCount = 0
local fxFailures = {}

-- TODO:
-- Handle duplicate note mappings when adding samples.
-- Current behavior intentionally allows multiple RS5K instances on the
-- same note, which causes layering. The preview above flags duplicates
-- so the user can catch mistakes before building; a future version
-- could offer Replace/Layer/Cancel per duplicate instead.
for _, mapping in ipairs(mappings) do
    local fullPath = FileUtils.joinPath(folder, mapping.file)

    if RS5K.loadSampleIntoRS5K(track, fullPath, mapping.midi) then
        loadedCount = loadedCount + 1
    else
        table.insert(fxFailures, mapping.file)
    end
end

RS5K.refreshUI()
 
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock("Build Quick Sampler instrument", -1)
 
 
-- Report results.
local summary = "Loaded " .. loadedCount .. " sample(s) into the instrument."
 
if #fxFailures > 0 then
    summary = summary .. "\n\nCould not insert a sampler for " .. #fxFailures .. " file(s):\n" ..
        table.concat(fxFailures, "\n")
end
 
reaper.ShowMessageBox(summary, "Quick Sampler Builder", 0)
