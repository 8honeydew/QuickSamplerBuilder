local Preview = {}


-- Parses filenames into note/MIDI mappings using the given NoteParser
-- and MidiUtils modules.
-- Returns:
--   mappings: array of { note = "C3", midi = 48, file = "C3.wav" }, sorted by MIDI note
--   invalidFiles: array of filenames that could not be parsed into a valid note
function Preview.buildMappings(files, NoteParser, MidiUtils)
    local mappings = {}
    local invalidFiles = {}

    for _, file in ipairs(files) do
        local note = NoteParser.extractNote(file)
        local midi = note and MidiUtils.noteToMidi(note)

        if midi then
            table.insert(mappings, { note = note, midi = midi, file = file })
        else
            table.insert(invalidFiles, file)
        end
    end

    table.sort(mappings, function(a, b) return a.midi < b.midi end)

    return mappings, invalidFiles
end


-- Returns a set of MIDI note numbers that appear more than once in mappings.
local function findDuplicateNotes(mappings)
    local counts = {}
    local duplicates = {}

    for _, mapping in ipairs(mappings) do
        counts[mapping.midi] = (counts[mapping.midi] or 0) + 1
    end

    for midi, count in pairs(counts) do
        if count > 1 then
            duplicates[midi] = true
        end
    end

    return duplicates
end


-- Formats mappings, duplicates, and invalid files into a readable
-- summary string for a preview message box.
function Preview.formatSummary(mappings, invalidFiles)
    local duplicates = findDuplicateNotes(mappings)

    local singleLines = {}
    local duplicateLines = {}

    for _, mapping in ipairs(mappings) do
        local line = mapping.note .. " -> " .. mapping.file

        if duplicates[mapping.midi] then
            table.insert(duplicateLines, line)
        else
            table.insert(singleLines, line)
        end
    end

    local lines = { "Detected samples:", "" }

    for _, line in ipairs(singleLines) do
        table.insert(lines, line)
    end

    if #duplicateLines > 0 then
        table.insert(lines, "")
        table.insert(lines, "Duplicates (will layer on the same note):")
        for _, line in ipairs(duplicateLines) do
            table.insert(lines, line)
        end
    end

    if #invalidFiles > 0 then
        table.insert(lines, "")
        table.insert(lines, "Skipped (invalid filename):")
        for _, file in ipairs(invalidFiles) do
            table.insert(lines, file)
        end
    end

    return table.concat(lines, "\n")
end


return Preview
