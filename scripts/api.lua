local db = require('db')
local apis = {
    demo = {
        add = function (a, b)
            return a+b
        end,
    },
    public = {
        get_last_menu_list = function ()
            conn = db.connect()
            local res, err, errno, sqlstate = conn:get_last_menu_list()
            if not res then
                res = ""
            end
            return json_encode(res)
        end,
        get_user_list = function ()
            conn = db.connect()
            local res, err, errno, sqlstate = conn:get_user_list()
            if not res then
                res = ""
            end
            return json_encode(res)
        end,
        get_user_order_list = function(menuid)
            conn = db.connect()
            local res, err, errno, sqlstate = conn:get_user_order_list(menuid)
            if not res then
                res = ""
            end
            return json_encode(res)
        end,
        upload_menu = function (menupaths)
            local uploadtime = os.time()
            conn = db.connect()
            for _,menupath in pairs(menupaths) do
                local res, err, errno, sqlstate = conn:add_menu(menupath, uploadtime)
            end
            return "上传成功"
        end,
        user_ordering = function (uid, dishname, dishprice, menuid)
            conn = db.connect()
            local res, err, errno, sqlstate = conn:add_user_order(uid, dishname, dishprice, menuid)
            return "下单成功"
        end,
        generate_csv = function ()
            conn = db.connect()
            local res, err, errno, sqlstate = conn:get_user_last_order_list()
            local csvdata = "姓名,菜名,价格\r\n"
            for k,v in pairs(res) do
                local data = sprintf("%s,%s,%g\r\n",v.name,v.dishname,v.dishprice)
                csvdata = csvdata .. data
            end
            return json_encode({data=csvdata})
        end,
    },
}
local req = read_request_body()
jsonrpc_handle(json_decode(req), apis)

