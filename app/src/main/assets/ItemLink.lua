--
-- User: 封羽
-- Date: 2017/3/21 上午12:32
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


function ui:create(width, height)
    local cell = {}
    cellW = width or cellW
    cellH = height or cellH

    function cell:init()
        -- 标题栏
        cell.view = util:createView(nil, 0, 0, cellW, cellH)

        cell.iconLayout = util:createView(nil, 0, r, cellH, cellH - r)
        cell.iconLayout:backgroundColor(constant.color.LIGHT_GREY)
        cell.icon = util:createImage(imageUrl, 0, 0, cellH, cellH)
        cell.iconLayout:addView(cell.icon)

        cell.title = util:createLabel(titleText or "", 14 * r, constant.color.BLACK, cellH + 16 * r, 0, cellW-cellH -16 * r, cellH, true)
        cell.title:lineCount(2)
        cell.title:height(cellH)
        cell.title:textAlign(TextAlign.LEFT);

        cell.divider = util:createView(constant.color.LIGHT_GREY, 0, cellH - r, cellW, r)

        cell.view:addView(cell.iconLayout)
        cell.view:addView(cell.title)
        cell.view:addView(cell.divider)
        util:addClickEffect(cell.view)

    end

    function cell:layout(data, section, row)
        if(data) then
          cell.title:text(data.title or "")
          cell.icon:image("pipi.png") --data.user and data.user.avatar and data.user.avatar:len() > 0 and data.user.avatar or "pipi.png")
          if(data.originalUrl and data.originalUrl:len() > 0) then
            cell.view:callback(function()
                bus:post("openUrl", data.originalUrl)
            end)
          end
        end
    end


    cell:init()
    return cell
end

return ui
