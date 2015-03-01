local apis = {
    demo = {
        add = function (a, b)
            return a+b
        end,
    },
    public = {
        get_menu_src = function ()
            return img_path
        end,
    },
}

jsonrpc_handle(json_decode(read_request_body()), apis)

