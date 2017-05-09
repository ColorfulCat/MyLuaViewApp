--
-- User: 封羽
-- Date: 2017/3/20 下午10:14
-- Desc: 菜单按钮
--

local util = require("util")
local constant = require("constant")
local bus = require("EventBus")

local scrW, scrH = constant.scrW, constant.scrH
local r = constant.r

local ui = {}

local cellW = scrW
local cellH = scrH


function ui:create(index, x, y, width, height, titleText, imageUrl)
    local cell = {}
    cellW = width or cellW
    cellH = height or cellH

    function cell:init()
        -- 标题栏
        cell.view = util:createView(nil, x, y, cellW, cellH)

        cell.icon = util:createImage(imageUrl, cellH / 4, cellH / 4, cellH / 2, cellH / 2)

        local titleColor
        if(1 == index) then
            titleColor = constant.color.BLUE
        else
            titleColor = constant.color.BLACK
        end
        cell.title = util:createLabel(titleText or "", 16 * r, titleColor, cellH, 0, cellW, cellH)
        cell.title:height(cellH)
        cell.title:textAlign(TextAlign.CENTER);

        cell.divider = util:createView(constant.color.LIGHT_GREY, 0, cellH - r, cellW, r)

        cell.view:addView(cell.icon)
        cell.view:addView(cell.title)
        cell.view:addView(cell.divider)
        util:addClickEffect(cell.view)
        cell.view:callback(function()
            bus:post("toogleDrawer")
            bus:post("setTitle", titleText)
            bus:post("selectMenu", index)
            bus:post("selectMenuItem", index)
        end)
    end

    cell:init()
    return cell
end

return ui


