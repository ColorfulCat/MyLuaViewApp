--
-- User: 封羽
-- Date: 2017/3/22 下午8:56
-- Desc:
--

local util = require("util")
local constant = require("constant")
local bus = require("EventBus")

local scrW, scrH = constant.scrW, constant.scrH
local r = constant.r

local ui = {}

local cellW = scrW
local cellH = scrH

function ui:create(x, y, width, height)
    local cell = {}
    cellW = width or cellW
    cellH = height or cellH

    function cell:init()
        -- 标题栏
        cell.view = util:createView(constant.color.WHITE, 0, 0, cellW, cellH)

        cell.logo = util:createImage("pipi.png", cellW / 4, cellW / 4, cellW / 2, cellW / 2)
        cell.logo:callback(function()
            util:clickAnimation(cell.logo)
            Toast("PI PI~")
        end)

        cell.title = util:createLabel("设置界面", 16 * r, constant.color.BLUE, 0, cellW, cellW, 18 * r, true)
        cell.title:textAlign(TextAlign.CENTER);

        cell.desc = util:createLabel("暂时没啥东西好设置的", 13 * r, constant.color.BLACK, 0, cellW + 30 * r, cellW, 16 * r, true)
        cell.desc:textAlign(TextAlign.CENTER);

        cell.view:addView(cell.logo)
        cell.view:addView(cell.title)
        cell.view:addView(cell.desc)
    end

    cell:init()
    return cell
end

return ui
