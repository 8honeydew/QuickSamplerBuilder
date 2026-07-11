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
