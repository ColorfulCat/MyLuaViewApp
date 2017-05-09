--
-- User: 封羽
-- Date: 2017/2/27 下午9:08
-- Desc: 事件订阅发布总线
-- 优点: 解决容易造成高耦合的模块间通信问题，采用统一的事件总线管理
-- 缺点: 简易实现，不支持命名空间隔离，不支持同参数名，注册事件不宜过多，不支持复用场合……待优化
--
local bus = {}
local events = {}
-- 注册事件
function bus:register(eventKey, callback)
    if (not events) then
        events = {}
    end
    events[eventKey] = callback
end

-- 执行事件, 传入变长参数
function bus:post(eventKey, ...)
    if (events and events[eventKey]) then
        events[eventKey](...)
        return true
    else
        return false
    end
end

-- 移除注册事件
function bus:remove(eventKey)
    if (events and events[eventKey]) then
        events[eventKey] = nil
        return true
    else
        return false
    end
end

-- 是否有该注册事件
function bus:has(eventKey)
    if (events and events[eventKey]) then
        return true
    end
    return false
end

-- 清空
function bus:clear()
    -- todo
    events = nil
    events = {}
end

return bus
