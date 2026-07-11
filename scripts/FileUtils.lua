local FileUtils = {}


-- Returns the folder containing the given file path (no trailing slash).
function FileUtils.getFolder(path)
    return path:match("^(.*)[/\\]")
end


-- Returns all WAV filenames inside a folder, sorted alphabetically.
function FileUtils.getWavFiles(folder)
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


return FileUtils
