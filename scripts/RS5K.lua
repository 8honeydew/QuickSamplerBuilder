-- Creates the instrument track if it does not already exist.
function getOrCreateInstrumentTrack()

    local track = reaper.GetTrack(0, 0)

    if track then
        return track
    end


    reaper.InsertTrackAtIndex(0, true)

    track = reaper.GetTrack(0, 0)

    reaper.GetSetMediaTrackInfo_String(
        track,
        "P_NAME",
        "Quick Sampler Instrument",
        true
    )

    return track

end


-- Creates an RS5K instance, loads a sample, and maps it to a MIDI note.
function loadSampleIntoRS5K(samplePath, midiNote)
    
    local track = getOrCreateInstrumentTrack()


    local fxIndex = reaper.TrackFX_AddByName(
        track, 
        "ReaSamplOmatic5000", 
        false, 
        1
    )


    local success = reaper.TrackFX_SetNamedConfigParm(
        track,
        fxIndex,
        "FILE0",
        samplePath
    )


    reaper.TrackFX_SetNamedConfigParm(
        track,
        fxIndex,
        "DONE",
        ""
    )


    local normalizedNote = midiNote / 127


    -- Set note range.

    reaper.TrackFX_SetParamNormalized(
        track,
        fxIndex,
        3,
        normalizedNote
    )


    reaper.TrackFX_SetParamNormalized(
        track,
        fxIndex,
        4,
        normalizedNote
    )


    -- Allow all MIDI channels.

    reaper.TrackFX_SetParamNormalized(
        track,
        fxIndex,
        7,
        0
)

    -- Allow full velocity range.

    reaper.TrackFX_SetParamNormalized(
        track,
        fxIndex,
        17,
        0
    )

    
    reaper.TrackFX_SetParamNormalized(
        track,
        fxIndex,
        18,
        1
    )

    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateArrange()

    return track, fxIndex

end