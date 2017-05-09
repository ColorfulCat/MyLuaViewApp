--
-- User: 封羽
-- Date: 2017/3/20 下午2:50
-- Desc: 通用工具类
--

local scrW, scrH = System:screenSize();
local r = scrW / 375;
local util = {}



function util:createView(bgColor, x, y, width, height)
    local view = View()
    view:frame(x, y, width or 0, height or 0)
    if (bgColor) then
        view:backgroundColor(bgColor)
    end
    return view
end

function util:createImage(url, x, y, width, height)
    local image = Image()
    image:frame(x, y, width, height)
    if (System:android()) then
        image:scaleType(ScaleType.FIT_XY)
    else
        image:scaleType(0)
    end
    if (url) then
        image:image(url)
    end
    return image
end

function util:createLabel(text, size, color, x, y, width, height, keep)
    local label = Label()
    label:frame(x, y, width or 0, height or 0)
    if (size) then
        label:fontSize(size)
    end
    if (color) then
        label:textColor(color)
    end
    if (text) then
        label:text(text)
    end

    if(not keep) then -- 是否保持不计算高宽
        label:adjustSize()
        local labelX, labelY, labelW, labelH = label:frame()
        label:frame(labelX, labelY, labelW, labelH)
    else
        if (label.ellipsize and System:android()) then
            label:ellipsize("END")
        end
    end
    return label
end

function util:resizeText(label)
    label:adjustSize()
    local labelX, labelY, labelW, labelH = label:frame()
    label:frame(labelX, labelY, labelW, labelH)
end

function util:setText(label, text, size, color)
    if (size) then
        label:fontSize(size)
    end
    if (color) then
        label:textColor(color)
    end
    if (text) then
        label:text(text)
    end
    label:adjustSize()
    local labelX, labelY, labelW, labelH = label:frame()
    label:frame(labelX, labelY, labelW, labelH)
end


-- table中包含某元素返回true
function util:tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function util:showUpAnimation(view, delay)
    if (view) then
        --内容弹出
        view:scale(0, 0)
        local scaleBack = Animation()
        scaleBack:duration(0.1)
        scaleBack:scale(1, 1)
        scaleBack:with(view)

        local scaleUp = Animation()
        scaleUp:duration(0.1)
        scaleUp:scale(1.1, 1.1)
        scaleUp:delay(delay)
        scaleUp:callback({
            onEnd = function()
                if (scaleBack) then
                    scaleBack:start()
                end
            end
        })
        scaleUp:with(view)
        scaleUp:start()
    end
end


function util:clickAnimation(view)
    if (view) then
        --内容弹出
        -- view:scale(0, 0)
        local scaleBack = Animation()
        scaleBack:duration(0.1)
        scaleBack:scale(1, 1)
        scaleBack:with(view)

        local scaleUp = Animation()
        scaleUp:duration(0.1)
        scaleUp:scale(0.8, 0.8)
        scaleUp:callback({
            onEnd = function()
                if (scaleBack) then
                    scaleBack:start()
                end
            end
        })
        scaleUp:with(view)
        scaleUp:start()
    end
end

function util:alphaAnimation(view, duration, alpha, delay, callback)
    if (view) then
        local fadeIn = Animation()
        fadeIn:duration(duration)
        fadeIn:alpha(alpha)
        fadeIn:with(view)
        fadeIn:delay(delay)
        fadeIn:callback({ onEnd = callback })
        fadeIn:start()
    end
end

function util:scaleAnimation(view, duration, scale, delay, callback)
    if (view) then
        local scaleUp = Animation()
        scaleUp:duration(duration)
        scaleUp:scale(scale, scale)
        scaleUp:with(view)
        scaleUp:delay(delay)
        --        if(scaleUp.interpolator) then
        --            scaleUp:interpolator(Interpolator.OVERSHOOT)
        --        end
        scaleUp:callback({ onEnd = callback })
        scaleUp:start()
    end
end

function util:scaleAnimationXY(view, duration, scaleX, scaleY, delay, callback)
    if (view) then
        local scaleUp = Animation()
        scaleUp:duration(duration)
        scaleUp:scale(scaleX, scaleY)
        scaleUp:with(view)
        scaleUp:delay(delay)
        --        if(scaleUp.interpolator) then
        --            scaleUp:interpolator(Interpolator.OVERSHOOT)
        --        end
        scaleUp:callback({ onEnd = callback })
        scaleUp:start()
    end
end

function util:translationAnimation(view, duration, translationX, translationY, delay, callback)
    if (view) then
        local translation = Animation()
        translation:duration(duration)
        translation:delay(delay)
        translation:translation(translationX, translationY)
--        if(translation.interpolator) then
--            translation:interpolator(Interpolator.OVERSHOOT)
--        end
        translation:with(view)
        translation:callback({ onEnd = callback })
        translation:start()
    end
end

--[[
    添加点击效果
]]
function util:addClickEffect(view, normalColor, pressedColor)
    if(System:android()) then
        if (view and view.effects) then
            view:effects(ViewEffect.CLICK)
        end
    else
        if(view and view.onTouch) then
            view:onTouch(function(event)
                print(event.id, event.pointer, event.action, event.x, event.y)
                if(event.action == TouchEvent.DOWN) then
                    view:backgroundColor(pressedColor or 0xefefef)
                    view:invalidate()
                elseif(event.action == TouchEvent.UP) then
                    view:backgroundColor(normalColor or 0xffffff)
                    view:invalidate()
                else
                    print(" === ")
                end

                return true;
            end)
        end
    end
end

function util:removeTableData(t)
  for i,v in ipairs(t) do table:remove(i) end
end

--function util:vibrate()
--    if(Vibrate) then
--        Vibrate() -- 默认震动
--    end
--end

return util
