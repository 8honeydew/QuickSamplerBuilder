function GetFolder(path)
    return path:match("^(.*)[/\\]")
end


function GetWavFiles(folder)

    local files = {}

    local command = 'dir "' .. folder .. '" /b'

    local pipe = io.popen(command)

    if pipe then

        for file in pipe:lines() do

            if file:lower():match("%.wav$") then
                table.insert(files, file)
            end

        end

        pipe:close()

    end

    return files

end