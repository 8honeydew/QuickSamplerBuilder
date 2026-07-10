local retval, sample_path = reaper.GetUserFileNameForRead("", "Choose a sample", "wav")

if retval then
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
else
    reaper.ShowMessageBox(
        "No sample selected.",
        "QuickSamplerBuilder",
        0
    )
end

reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()

