--
-- User: 封羽
-- Date: 2017/3/20 下午7:39
-- Desc:
--
local constant = {}

constant.scrW, constant.scrH = System:screenSize() -- 屏幕高宽
constant.r = constant.scrW / 375 -- 分辨率比例

constant.navigationHeight = 48 * constant.r

constant.statusHeight = 0 -- 25 * constant.r

if(System:ios()) then
  constant.scrH = constant.scrH - constant.statusHeight
end

constant.color = {
    BLACK = 0x000000,
    WHITE = 0xFFFFFF,
    GREY = 0xCCCCCC,
    LIGHT_GREY = 0xf4f4f4,

    BLUE = 0x1296db
}




return constant
