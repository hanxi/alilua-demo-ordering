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

function _M.strcheck(str)
    return string.gsub(str,"['\"]",function (x) return x..x end)
end

function _M:get_user_list()
    return self.db:query("select uid,name from user")
end

function _M:get_user_order_list(menuid)
    return self.db:query("select uid,dishname,dishprice from userorder where menuid="..tonumber(menuid))
end

function _M:get_user_last_order_list()
    return self.db:query("select name, dishname , dishprice from userorder join user on userorder.uid=user.uid where menuid=(select max(uploadtime) from menu)")
end

function _M:get_last_menu_list()
    return self.db:query("select menupath,uploadtime from menu where uploadtime=(select max(uploadtime) from menu) limit 5")
end

function _M:add_menu(menupath, uploadtime)
    menupath = self.strcheck(menupath)
    uploadtime = tonumber(uploadtime)
    return self.db:query(sprintf("insert into menu(menupath,uploadtime) values ('%s','%d')",menupath,uploadtime))
end

function _M:add_user_order(uid, dishname, dishprice, menuid)
    uid = tonumber(uid)
    dishname = self.strcheck(dishname)
    dishprice = tonumber(dishprice)
    menuid = tonumber(menuid)
    local res = self.db:query(sprintf("select id from userorder where uid=%d and menuid=%d",uid,menuid))
    if #res==0 then
        return self.db:query(sprintf("insert into userorder(uid,dishname,dishprice,menuid) value ('%d','%s','%g','%d')",uid,dishname,dishprice,menuid))
    else
        return self.db:query(sprintf("update userorder set dishname='%s', dishprice='%s' where uid=%d and menuid=%d",dishname,dishprice,uid,menuid))
    end
end

return _M

