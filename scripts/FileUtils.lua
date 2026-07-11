-- Returns the folder containing the given file path.
function getFolder(path)

    return path:match("^(.*)[/\\]")

end


-- Returns all WAV files inside a folder.
function getWavFiles(folder)

    local files = {}

    local dirCommand = 'dir "' .. folder .. '" /b'

    local pipe = io.popen(dirCommand)

    if pipe then

        for file in pipe:lines() do

            if file:lower():match("%.wav$") then
                table.insert(files, file)
            end

        end

        pipe:close()

    end

    table.sort(files)

    return files

end