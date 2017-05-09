--
-- User: 封羽
-- Date: 2017/3/20 下午7:30
-- Desc: 导航栏通用模块
--
local util = require("util")
local constant = require("constant")
local bus = require("EventBus")

local scrW, scrH = constant.scrW, constant.scrH
local r = constant.r

local ui = {}

local cellW = scrW
local cellH = scrH


function ui:create(width, height)
    local cell = {}
    cellW = width or cellW
    cellH = height or cellH

    function cell:init()
        -- 标题栏
        cell.view = util:createView(constant.color.WHITE, 0, 0, cellW, cellH)
        cell.view:shadowPath();
        cell.view:masksToBounds(false);
        cell.view:shadowOffset(0, 0.5);
        cell.view:shadowRadius(0.5);
        cell.view:shadowOpacity(0.18);
        cell.view:shadowColor(0x00000);

        cell.menuView = util:createView(constant.color.WHITE, 0, 0, cellH, cellH)
        cell.menu = util:createImage("ball.png", cellH / 4, cellH / 4, cellH / 2, cellH / 2)
        util:addClickEffect(cell.menuView)
        cell.menuView:callback(function()
            util:clickAnimation(cell.menu)
            bus:post("toogleDrawer")
        end)
        cell.menuView:addView( cell.menu)

        cell.title = util:createLabel("AndroidCat", 14 * r, constant.color.BLUE, cellH, 0, cellW, cellH)
        cell.title:height(cellH)
        cell.title:textAlign(TextAlign.LEFT);
        cell.title:callback(function()
            Toast("欢迎来到AndroidCat")
        end)

        bus:register("setTitle", function(title)
            if(title) then
                if(title == "首页") then
                    cell.title:text("AndroidCat")
                else
                    cell.title:text(title)
                end
            end
        end)

        cell.divider = util:createView(constant.color.LIGHT_GREY, 0, cellH - r, cellW, r)

        cell.view:addView(cell.menuView)
        cell.view:addView(cell.title)
        cell.view:addView(cell.divider)
    end

    cell:init()
    return cell
end

return ui
