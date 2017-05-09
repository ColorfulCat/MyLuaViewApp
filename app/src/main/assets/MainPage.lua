--
-- User: 封羽
-- Date: 2017/3/20 下午2:25
-- Desc: 程序主界面
--
local util = require("util")
local constant = require("constant")
local bus = require("EventBus")
local navigation = require("ViewNavigation")
local drawer = require("ViewDrawer")
local pageHome = require("PageHome")
local pageAbout = require("PageAbout")
local pageSetting = require("PageSetting")
local pageWebview = require("PageWebView")

local scrW, scrH = constant.scrW, constant.scrH
local r = constant.r

local ui = {}

local cellW = scrW
local cellH = scrH

print("scrW === "..scrW)

function ui:create(width, height)
    local cell = {}
    cellW = width or cellW
    cellH = height or cellH

    local NAV_HEIGHT = 48 * r

    function cell:init()

        cell.bg = util:createView(constant.color.LIGHT_GREY, 0, constant.statusHeight, cellW, cellH)

        -- 内容
        cell.content = util:createView(nil, 0, NAV_HEIGHT, cellW, cellH - NAV_HEIGHT)

        cell.page = pageHome:create(0, 0, cellW, cellH - NAV_HEIGHT)

        cell.webview = pageWebview:create(0,0,cellW, cellH)
        cell.webview.view:hidden(true)

        cell.content:addView(cell.page.view)

        bus:register("selectMenu", function(index)
            if (index == 1) then
                cell.page.view:removeFromSuper()
                cell.page = nil
                cell.page = pageHome:create(0, 0, cellW, cellH - NAV_HEIGHT)
                cell.content:addView(cell.page.view)
            elseif (index == 2) then
                cell.page.view:removeFromSuper()
                cell.page = nil
                cell.page = pageSetting:create(0, 0, cellW, cellH - NAV_HEIGHT)
                cell.content:addView(cell.page.view)
            elseif (index == 3) then
                cell.page.view:removeFromSuper()
                cell.page = nil
                cell.page = pageAbout:create(0, 0, cellW, cellH - NAV_HEIGHT)
                cell.content:addView(cell.page.view)
            end
        end)

        bus:register("openUrl", function(url)
          cell.webview:loadUrl(url)
          cell.webview.view:hidden(false)

          local translation = Animation()
          translation:duration(0.3)
          translation:translation(-cellW, 0)
          translation:with(cell.webview.view)
          translation:callback({ onEnd = function()

          end })
          translation:start()
        end)

        bus:register("closeUrl", function()
          cell.webview:loadUrl("", true)
          local translation = Animation()
          translation:duration(0.3)
          translation:translation(cellW, 0)
          translation:with(cell.webview.view)
          translation:callback({ onEnd = function()
            cell.webview.view:hidden(true)
          end })
          translation:start()
        end)

        -- 左侧菜单
        cell.drawer = drawer:create(0, NAV_HEIGHT, cellW, cellH - NAV_HEIGHT)

        -- 标题栏
        cell.navigation = navigation:create(cellW, NAV_HEIGHT)

        cell.bg:addView(cell.content)
        cell.bg:addView(cell.drawer.view)
        cell.bg:addView(cell.navigation.view)
        cell.bg:addView(cell.webview.view)
    end

    cell:init()
    return cell
end

return ui
