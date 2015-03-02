echo(__root)
local sock = cosocket.tcp()
local host = "192.168.16.234"
local port = 8989
local r,e = sock:connect(host,port)
r,e =  sock:send("hello")
rts, err = dotemplate("/index.html")
