--
-- User: 封羽
-- Date: 2017/3/20 下午11:59
-- Desc:
--

local util = require("util")
local constant = require("constant")
local bus = require("EventBus")
local itemLink = require("ItemLink")

local scrW, scrH = constant.scrW, constant.scrH
local r = constant.r

local ui = {}

local cellW = scrW
local cellH = scrH

local itemHeight = 88 * r

function ui:create(x, y, width, height)
    local cell = {}
    cellW = width or cellW
    cellH = height or cellH

    cell.dataList = {}
    cell.pageIndex = 1
    cell.pageLimit = 25

    cell.isLoading = false

    function cell:getData(offset, limit,  params)
      self.isLoading = true
      local http = Http()
      print("HTTP GET : http://api.xitu.io/resources/gold/android?order=time&offset="..offset.."&limit="..limit)
      http:get("http://api.xitu.io/resources/gold/android?order=time&offset="..offset.."&limit="..limit, function(response)
          if (response) then
              print("callback successful")
              local data = Json:toTable(tostring(response:data()))
              if(data) then
                for i=1, #data do
                  table.insert(self.dataList, data[i])
                end
                self.collectionView:reload()
              else
                Toast("data is nil")
              end
          else
              print("callback failed")
              Toast("callback failed")
          end
          self.isLoading = false
      end)
    end

    function cell:init()
        -- 标题栏
        self.view = util:createView(constant.color.WHITE, 0, 0, cellW, cellH)

        self.collectionView = RefreshCollectionView {
            Section = {
                SectionCount = function(section)
                    if(self.dataList and #self.dataList > 0) then
                      print("#self.dataList = "..#self.dataList)
                      return #self.dataList;
                    end
                    return 0;
                end,
                RowCount = function(section)
                    return 1;
                end
            },
            Cell = {
                Id = function(section, row)
                    return 'default';
                end,
                default = {
                    Init = function(cell)
                        cell.view = itemLink:create(cellW, itemHeight)
                    end,
                    Layout = function(cell, section, row)
                        print("layout !!!")
                        cell.view:layout(self.dataList[section], section, row)
                    end,
                    Size = function(section, row)
                        return cellW, itemHeight;
                    end,
                    Callback = function(cell, section, row)
                    end
                }
            },
            Callback = {
                PullDown = function()
                    print("PullDown");
                    if (self.collectionView:isRefreshing()) then
                        self.collectionView:stopRefreshing()
                        print("refreshData")
                        -- util:removeTableData(self.dataList)
                        self.dataList = nil
                        self.dataList = {}
                        self.pageIndex = 1
                        self:getData((self.pageIndex - 1) * self.pageLimit, self.pageLimit)
                    end
                end,
                Scrolling = function(section, row, visibleCount)
                  print("scrolling section = "..section)
                  print("scrolling visibleCount = "..visibleCount)
                  print("scrolling row = "..row)
                  print("scrolling #self.dataList = "..#self.dataList)
                  if(not self.isLoading and section > (#self.dataList - 10)) then
                    self.pageIndex = self.pageIndex + 1
                    print("load more "..self.pageIndex);
                    self:getData((self.pageIndex - 1) * self.pageLimit, self.pageLimit)
                  else
                    print("not load more");
                  end
                  if(section > 10) then
                    if(not self.backToTopView:isShow()) then
                      self.backToTopView:hidden(false)
                    end
                  else
                    if(self.backToTopView:isShow()) then
                      self.backToTopView:hidden(true)
                    end
                  end

                end,
                ScrollEnd = function(section, row)
                end
            }
        };

        self.collectionView:frame(0, 0, cellW, cellH);

        self.backToTopView = util:createView(nil, cellW - 50 * r,cellH - 100 * r, 48 * r, 48 * r)
        self.backToTop = util:createImage("arrow.png", 10 * r, 10 * r, 28 * r, 28 * r)
        self.backToTopView:addView(cell.backToTop)
        self.backToTopView:callback(function()
          util:clickAnimation(self.backToTop)
          if(System:android()) then
            self.collectionView:scrollToCell(1, 1, 0, false)
          else
            self.collectionView:scrollToCell(1, 1, 0, true)
          end
        end)
        self.backToTopView:hidden(true)

        self.view:addView(cell.collectionView)
        self.view:addView(cell.backToTopView)
        print("getData")
        self:getData((self.pageIndex - 1) * self.pageLimit, self.pageLimit)
    end

    cell:init()
    return cell
end

return ui
