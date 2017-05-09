--
-- User: 封羽
-- Date: 2017/3/20 下午2:25
-- Desc: 程序主入口
--
print("start main.lua")
local constant = require("constant")

app = {}  -- 要全局，不然iOS会被回收- -
app.currentIndex = 1
function app:init()
    if(app.inited) then return end
    --- main code
    local mainPage = require("MainPage")
    app.view = mainPage:create()

    app.inited = true
end

function app:onShowAction()
    print('onShowAction')
end

function app:onHideAction()
    print('onHideAction')
end




app.init()
