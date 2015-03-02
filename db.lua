local _M = {}
local mt = { __index = _M }
function _M.connect()
    local db = mysql:new()
    local db_ok, err, errno, sqlstate
    if db then
        db_ok, err, errno, sqlstate = db:connect({
                        host = "localhost",
                        port = 3306,
                        pool_size = 256,
                        database = "menudb",
                        user = "develop",
                        password = "qwerasdf"})
    end
    if not db_ok then
        print_error("conncet mysql error",db_ok,err,errno,sqlstate)
        return
    end
    return setmetatable({ db = db }, mt)
end

function _M:get_user_list()
    return self.db:query("select uid,name from user")
end

function _M:get_last_menu_list()
    return self.db:query("select menupath from menu where uploadtime=(select max(uploadtime) from menu) limit 5")
end

function _M:add_menu(menupath, uploadtime)
    menupath = string.gsub(uploadtime,"['\"]",function (x) return x..x end)
    uploadtime = tonumber(uploadtime)
    return self.db:query(sprintf("insert into menu(menupath,uploadtime) values ('%s','%d')",menupath,uploadtime))
end
return _M

