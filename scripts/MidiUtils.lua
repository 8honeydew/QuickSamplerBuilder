local MidiUtils = {}


-- Semitone offsets from C.
local noteOffsets = {
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


-- Converts a note name into a MIDI note number.
-- Example: "C1" -> 24
function MidiUtils.noteToMidi(note)
    local noteName, octave = note:match("^([A-G]#?)(%-?%d+)$")
    
    if not noteName or not octave then
        return nil
    end

    octave = tonumber(octave)
    return (octave + 1) * 12 + noteOffsets[noteName]
end


return MidiUtils
