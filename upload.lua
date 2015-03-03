
function write_file(file_name)
    if file_name then
        local fname = '/uploadfile/'..random_string()..file_name
        local fpath = __root..fname
        if eio.exists(fpath) then
            eio.unlink(fpath)
        end
        local fh,en,e = eio.open(fpath, 'w')
        if fh then
            while true do
                local chunk = read_request_body()
                if file_name and chunk then
                    fh:write(chunk)
                else
                    break;
                end
            end
            fh:close()
        else
            _print(fh,en,e)
        end
        return fname
    end
end

function parse_query()
    local query = headers['query']:sub(2)
    local _kv = explode(query, '&')
    local qkv = {}
    for i,s in ipairs(_kv) do
        local t = explode(s, '=')
        qkv[t[1]] = t[2]
    end
    return qkv
end

local qkv = parse_query()

local file_name = qkv['file_name']
local fname = write_file(file_name)
print(fname)

