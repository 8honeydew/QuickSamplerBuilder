local NoteParser = {}


-- Extracts a note name from a WAV filename.
-- Example: "C#4.wav" -> "C#4"
function NoteParser.extractNote(filename)
    return filename:match("^([A-G]#?%d+)%.wav$")
end


return NoteParser
