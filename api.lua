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
        upload_menu = function (image_datas)
            local uploadtime = os.time()
            conn = db.connect()
            for _,image in pairs(image_datas) do
                local names = explode(image.name,".")
                local suffix = names[#names]
                local menu_name = random_string()
                local menupath = "/menu/"..menu_name.."."..suffix
                local res, err, errno, sqlstate = conn:add_menu(menupath, uploadtime)

                local menu_path = __root..menupath
                _print(menu_path)
            end
        end,
        ordering = function (user_name, dish_name, dish_price)
        end,
    },
}
local req,r = read_request_body()
_print(type(req),req,type(r),r)
jsonrpc_handle(json_decode(req), apis)

