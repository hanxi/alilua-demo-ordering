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
        upload_menu = function (menupaths)
            local uploadtime = os.time()
            conn = db.connect()
            for _,menupath in pairs(menupaths) do
                local res, err, errno, sqlstate = conn:add_menu(menupath, uploadtime)
                _print(menupath)
            end
            return "上传成功"
        end,
        ordering = function (user_name, dish_name, dish_price)
        end,
    },
}
local req = read_request_body()
jsonrpc_handle(json_decode(req), apis)

