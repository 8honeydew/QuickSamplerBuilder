local NOTE_OFFSETS = {
    C = 0,
    ["C#"] = 1,
    D = 2,
    ["D#"] = 3,
    E = 4,
    F = 5,
    ["F#"] = 6,
    G = 7,
    ["G#"] = 8,
    A = 9,
    ["A#"] = 10,
    B = 11
}

function NoteToMidi(note)
    local note_name, octave = note:match("^([A-G]#?)(%-?%d+)$")
    octave = tonumber(octave)

    return (octave + 1) * 12 + NOTE_OFFSETS[note_name]
end

reaper.ShowConsoleMsg("C4 -> " .. NoteToMidi("C4") .. "\n")
reaper.ShowConsoleMsg("A4 -> " .. NoteToMidi("A4") .. "\n")
reaper.ShowConsoleMsg("F#3 -> " .. NoteToMidi("F#3") .. "\n")