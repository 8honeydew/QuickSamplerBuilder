local RS5K = {}


-- RS5K named/normal parameter indices (found via TrackFX_GetNumParams
-- and community usage, since RS5K doesn't document these directly).
local PARAM_NOTE_RANGE_LOW = 3
local PARAM_NOTE_RANGE_HIGH = 4
local PARAM_MIDI_CHANNEL = 7
local PARAM_VELOCITY_LOW = 17
local PARAM_VELOCITY_HIGH = 18


-- Returns the instrument track, creating it if it doesn't exist yet.
local function getOrCreateInstrumentTrack()
    local track = reaper.GetTrack(0, 0)

    if track then
        return track
    end

    reaper.InsertTrackAtIndex(0, true)
    track = reaper.GetTrack(0, 0)

    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Quick Sampler Instrument", true)

    return track
end


-- Creates an RS5K instance, loads a sample, and maps it to a MIDI note.
function RS5K.loadSampleIntoRS5K(samplePath, midiNote)
    local track = getOrCreateInstrumentTrack()

    local fxIndex = reaper.TrackFX_AddByName(track, "ReaSamplOmatic5000", false, 1)

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

    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateArrange()

    return track, fxIndex
end


return RS5K
