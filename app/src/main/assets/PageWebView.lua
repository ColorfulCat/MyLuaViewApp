--
-- User: 封羽
-- Date: 2017/3/24 下午8:37
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
        self.view = util:createView(constant.color.BLUE, cellW, 0, cellW, cellH)
        if(self.view.margin) then
          self.view:margin(cellW, 0, -cellW, -cellH)
        end
        self.webViewContainer = util:createView(nil, 0, 0, cellW, cellH)

        -- self.loadingView = LoadingIndicator()
        -- self.loadingView:frame((cellW -50 * r) / 2, (cellH - 50 * r) / 2, 50 * r, 50 * r)
        -- self.loadingView:color(constant.color.BLUE)

        self.close = util:createImage("kedaya.png", 10 * r, 10 * r, 48 * r, 48 * r)
        self.close:scale(0, 0)
        self.close:callback(function()
            bus:post("closeUrl")
        end)

        -- self.webViewContainer:addView(self.loadingView)
        self.view:addView(self.webViewContainer)
        self.view:addView(self.close)
    end

    function cell:loadUrl(url, close)
      if(self.webview) then
        self.webview:removeFromSuper()
        self.webview = nil
      end
      self.webview = WebView()
      self.webview:frame(0, 0, cellW, cellH)
      self.webview:loadUrl(url)
      self.webViewContainer:addView(self.webview)
      if(close) then
        self.close:scale(0, 0)
      else
        util:showUpAnimation(self.close, 0.5)
      end
    end

    function cell:destroy()
      if(self.webview) then
        self.webview:removeFromSuper()
        self.webview = nil
      end
      self.close:scale(0, 0)
    end

    cell:init()
    return cell
end

return ui
