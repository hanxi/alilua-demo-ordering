local routes = {}
routes['^/(.*).(jpg|gif|png|css|js|ico|swf|flv|mp3|mp4|woff|eot|ttf|otf|svg)$'] = function()
    header('Cache-Control: max-age=864000')
    sendfile(headers.uri)
end

routes['^/user/:user_id'] = function(r)
    print('User ID: ', r.user_id)
end

routes['^/user/:user_id/:post(.+)'] = function(r)
    print('User ID: ', r.user_id)
    print(' Post: ', r.post)
end

routes['^/(.*)'] = function(r)
    dofile('/scripts/index.lua')
end

routes['^/scripts/:file(.*)'] = function(r)
    dofile('/scripts/'..r.file..'.lua')
end

--[[
others you want :)
]]

-- if the 3rd argument is a path, then router will try to get local lua script file first
local ok, err, arg = router(headers.uri, routes, '/')
if not ok then
    header('HTTP/1.1 404 Not Found')
    echo('File Not Found!')
end

