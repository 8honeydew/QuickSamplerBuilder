local FileUtils = {}


-- Returns the folder containing the given file path (no trailing slash).
function FileUtils.getFolder(path)
    return path:match("^(.*)[/\\]")
end


-- Joins a folder path and filename using the current OS's separator.
function FileUtils.joinPath(folder, file)
    local separator = package.config:sub(1, 1)
    return folder .. separator .. file
end


-- Returns all WAV filenames inside a folder, sorted alphabetically.
-- Uses Reaper's own file enumeration, so this works on any OS Reaper runs on.
function FileUtils.getWavFiles(folder)
    local files = {}
    local index = 0
 
    while true do
        local file = reaper.EnumerateFiles(folder, index)
        if not file then break end
 
        if file:lower():match("%.wav$") then
            table.insert(files, file)
        end
 
        index = index + 1
    end
 
    table.sort(files)
    return files
end


return FileUtils
