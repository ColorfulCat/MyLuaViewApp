--
-- User: 封羽
-- Date: 2017/3/20 下午9:17
-- Desc: 左侧抽屉菜单布局
--

local util = require("util")
local constant = require("constant")
local bus = require("EventBus")

local itemMenu = require("ItemMenu")

local scrW, scrH = constant.scrW, constant.scrH
local r = constant.r

local ui = {}

local cellW = scrW
local cellH = scrH

local menuWidth = cellW * 2 / 3
local menuItemHeight = cellW / 6

function ui:create(x, y, width, height)
    local cell = {}
    cellW = width or cellW
    cellH = height or cellH

    cell.isOpen = false

    function cell:init()
        -- 标题栏
        cell.view = util:createView(nil, x, y, cellW, cellH)
        cell.view:shadowPath();
        cell.view:masksToBounds(false);
        cell.view:shadowOffset(0, 1);
        cell.view:shadowRadius(0.5);
        cell.view:shadowOpacity(0.18);
        cell.view:shadowColor(0x00000);

        cell.cover = util:createView(constant.color.BLACK, 0, 0, cellW, cellH)
        cell.cover:alpha(0)
        cell.cover:callback(function()
            cell.isOpen = false
            cell:close()
        end)
        --
        cell.menuLayout = util:createView(constant.color.WHITE, 0, 0, menuWidth, cellH)
        cell.menuLayout:x(-menuWidth)

        cell.headerView = util:createView(constant.color.WHITE, 0, 0, menuWidth, menuWidth)
        cell.headerImage = util:createImage("pikachu.png", menuWidth / 4, menuWidth / 4, menuWidth / 2, menuWidth / 2)
        cell.headerView:callback(function()
            util:clickAnimation(cell.headerImage)
            Toast("皮卡皮卡~")
        end)

        cell.headerView:addView(cell.headerImage)

        cell.divider = util:createView(constant.color.LIGHT_GREY, 0, menuWidth - r, menuWidth, r)

        cell.menu1 = itemMenu:create(1, 0, menuWidth, menuWidth, menuItemHeight, "首页", "kabi.png")
        cell.menu2 = itemMenu:create(2, 0, menuWidth + menuItemHeight, menuWidth, menuItemHeight, "设置", "setting.png")
        cell.menu3 = itemMenu:create(3, 0, menuWidth + menuItemHeight * 2, menuWidth, menuItemHeight, "关于", "kedaya.png")

        cell.menuLayout:addView(cell.headerView)
        cell.menuLayout:addView(cell.divider)
        cell.menuLayout:addView(cell.menu1.view)
        cell.menuLayout:addView(cell.menu2.view)
        cell.menuLayout:addView(cell.menu3.view)

        cell.view:addView(cell.cover)
        cell.view:addView(cell.menuLayout)
        cell.view:hidden(true)

        bus:register("selectMenuItem", function(index)
            if (index == 1) then
                cell.menu1.title:textColor(constant.color.BLUE)
                cell.menu2.title:textColor(constant.color.BLACK)
                cell.menu3.title:textColor(constant.color.BLACK)
            elseif (index == 2) then
                cell.menu1.title:textColor(constant.color.BLACK)
                cell.menu2.title:textColor(constant.color.BLUE)
                cell.menu3.title:textColor(constant.color.BLACK)
            elseif (index == 3) then
                cell.menu1.title:textColor(constant.color.BLACK)
                cell.menu2.title:textColor(constant.color.BLACK)
                cell.menu3.title:textColor(constant.color.BLUE)
            end
        end)

        bus:register("toogleDrawer", function()
            if (cell.isOpen) then
                cell:close()
            else
                cell:open()
            end
            cell.isOpen = not cell.isOpen
        end)
    end

    function cell:open()
        cell.view:hidden(false)
        cell.cover:hidden(false)
        util:alphaAnimation(cell.cover, 0.5, 0.3, 0, nil)
        util:translationAnimation(cell.menuLayout, 0.3, menuWidth, 0, 0, nil)
    end

    function cell:close()
        util:alphaAnimation(cell.cover, 0.1, 0, 0, function()
            cell.cover:hidden(true)
        end)
        util:translationAnimation(cell.menuLayout, 0.3, -menuWidth, 0, 0, function()
            cell.view:hidden(true)
        end)
    end

    cell:init()
    return cell
end

return ui
