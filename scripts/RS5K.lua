function LoadSampleIntoRS5K(sample_path)
    
    reaper.InsertTrackAtIndex(0, true)

    local track = reaper.GetTrack(0, 0)

    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Piano", true)

    local fx_index = reaper.TrackFX_AddByName(track, "ReaSamplOmatic5000", false, 1)

    local success = reaper.TrackFX_SetNamedConfigParm(
        track,
        fx_index,
        "FILE0",
        sample_path
    )

    reaper.TrackFX_SetNamedConfigParm(
        track,
        fx_index,
        "DONE",
        ""
    )

    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateArrange()
end
