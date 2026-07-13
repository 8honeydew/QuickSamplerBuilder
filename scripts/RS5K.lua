local RS5K = {}


local TRACK_NAME = "Quick Sampler Instrument"

-- RS5K named/normal parameter indices (found via TrackFX_GetNumParams
-- and community usage, since RS5K doesn't document these directly).
local PARAM_NOTE_RANGE_LOW = 3
local PARAM_NOTE_RANGE_HIGH = 4
local PARAM_MIDI_CHANNEL = 7
local PARAM_VELOCITY_LOW = 17
local PARAM_VELOCITY_HIGH = 18

-- reaper.ShowMessageBox(type=3) button return values.
local MB_YES = 6
local MB_NO = 7


-- Finds a track by name in the current project, or nil if none exists.
local function findTrackByName(name)
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
 
        if trackName == name then
            return track
        end
    end
 
    return nil
end


-- Removes all FX from a track, so a rebuild starts from a clean slate.
local function clearTrackFX(track)
    for i = reaper.TrackFX_GetCount(track) - 1, 0, -1 do
        reaper.TrackFX_Delete(track, i)
    end
end


-- Asks the user what to do when the instrument track already exists.
-- Returns "replace", "add", or "cancel".
local function askReplaceOrAdd()
    local choice = reaper.ShowMessageBox(
        "A \"" .. TRACK_NAME .. "\" track already exists.\n\n" ..
        "Yes = Replace it (deletes existing samples, rebuilds from scratch)\n" ..
        "No = Add to it (keeps existing samples, adds these on top)\n" ..
        "Cancel = Stop without changing anything",
        "Quick Sampler Builder",
        3  -- Yes / No / Cancel
    )
 
    if choice == MB_YES then
        return "replace"
    elseif choice == MB_NO then
        return "add"
    else
        return "cancel"
    end
end


-- Finds or creates the instrument track. If it already exists, asks the
-- user whether to replace or add to it. Call this ONCE per run, before
-- loading any samples -- not once per sample.
-- Returns track, proceed (proceed is false if the user cancelled).
function RS5K.prepareInstrumentTrack()
    local track = findTrackByName(TRACK_NAME)
 
    if not track then
        reaper.InsertTrackAtIndex(0, true)
        track = reaper.GetTrack(0, 0)
        reaper.GetSetMediaTrackInfo_String(track, "P_NAME", TRACK_NAME, true)
        return track, true
    end
 
    local choice = askReplaceOrAdd()
 
    if choice == "cancel" then
        return nil, false
    end
 
    if choice == "replace" then
        clearTrackFX(track)
    end
 
    return track, true
end


-- Creates an RS5K instance on the given track, loads a sample, and maps
-- it to a single MIDI note. Returns false if RS5K could not be inserted.
function RS5K.loadSampleIntoRS5K(track, samplePath, midiNote)
    local fxIndex = reaper.TrackFX_AddByName(track, "ReaSamplOmatic5000", false, 1)
   
    if fxIndex < 0 then
        return false
    end

    reaper.TrackFX_SetNamedConfigParm(track, fxIndex, "FILE0", samplePath)
    reaper.TrackFX_SetNamedConfigParm(track, fxIndex, "DONE", "")

    local normalizedNote = midiNote / 127

    -- Set note range (single note per sample, so low and high match).
    reaper.TrackFX_SetParamNormalized(track, fxIndex, PARAM_NOTE_RANGE_LOW, normalizedNote)
    reaper.TrackFX_SetParamNormalized(track, fxIndex, PARAM_NOTE_RANGE_HIGH, normalizedNote)

    -- Allow all MIDI channels.
    reaper.TrackFX_SetParamNormalized(track, fxIndex, PARAM_MIDI_CHANNEL, 0)

    -- Allow full velocity range.
    reaper.TrackFX_SetParamNormalized(track, fxIndex, PARAM_VELOCITY_LOW, 0)
    reaper.TrackFX_SetParamNormalized(track, fxIndex, PARAM_VELOCITY_HIGH, 1)

    return true
end


-- Refreshes Reaper's UI. Call this ONCE after all samples are loaded,
-- not once per sample.
function RS5K.refreshUI()
    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateArrange()
end


return RS5K
