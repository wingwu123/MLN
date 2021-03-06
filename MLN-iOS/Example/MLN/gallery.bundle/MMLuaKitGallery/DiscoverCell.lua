---
--- Generated by MLN Team (http://www.immomo.com)
--- Created by MLN Team.
--- DateTime: 2019-09-05 12:05
---

local _class = {
    _name = "DiscoverCell",
    _version = "1.0"
}

---@public
function _class:new()
    local o = {}
    setmetatable(o, { __index = self })
    return o
end

---@public
function _class:setupCellSubviews(width)
    self.baseLayout = LinearLayout(LinearType.VERTICAL)
    self.baseLayout:width(width):height(MeasurementType.MATCH_PARENT)

    --图片
    local imageView = ImageView():width(width):height(width)
    imageView:contentMode(ContentMode.SCALE_ASPECT_FIT)
    imageView:lazyLoad(false)
    --imageView:addCornerMask(8,ColorConstants.White,RectCorner.ALL_CORNERS)
    self.imageView = imageView

    --布局图片上的小图标
    local imageViewLayout = LinearLayout(LinearType.HORIZONTAL)
    imageViewLayout:marginTop(-30):width(width):height(25):setGravity(Gravity.CENTER)
    self.imageViewLayout = imageViewLayout

    --标题
    local titleLabel = Label()
    titleLabel:marginTop(5):width(width):height(30)
    titleLabel:textColor(ColorConstants.Black):fontSize(14):setTextFontStyle(FontStyle.BOLD)
    self.titleLabel = titleLabel

    --更新内容提示
    local iconHeight = 15
    local updateLayout = LinearLayout(LinearType.HORIZONTAL)
    updateLayout:width(width):height(iconHeight)
    local imagesLayout = View():width(MeasurementType.WRAP_CONTENT):height(iconHeight)
    self.updateLayout = updateLayout

    self.iconViews = {}
    local iconView1 = ImageView()
    iconView1:width(iconHeight):height(iconHeight)
             :gone(true):lazyLoad(false):addCornerMask(iconHeight / 2, ColorConstants.White, RectCorner.ALL_CORNERS)
    table.insert(self.iconViews, iconView1)
    imagesLayout:addView(iconView1)

    local iconView2 = ImageView()
    iconView2:marginLeft(5):width(iconHeight):height(iconHeight)
             :gone(true):lazyLoad(false)
    table.insert(self.iconViews, iconView2)
    imagesLayout:addView(iconView2)

    local iconView3 = ImageView()
    iconView3:marginLeft(10):width(iconHeight):height(iconHeight)
             :gone(true):lazyLoad(false)
    table.insert(self.iconViews, iconView3)
    imagesLayout:addView(iconView3)

    local iconLabel = Label()
    iconLabel:marginLeft(5):width(MeasurementType.WRAP_CONTENT):height(iconHeight):fontSize(11)
    self.iconLabel = iconLabel
    updateLayout:addView(imagesLayout)
    updateLayout:addView(iconLabel)

    --添加显示
    self.baseLayout:addView(imageView):addView(imageViewLayout):addView(titleLabel):addView(updateLayout)
end

---@public
---@param count string
function _class:updateContentCountText(count)
    if not count then
        return
    end
    self.iconLabel:text(string.format("更新了%s篇内容", count))
end

---@public
---@vararg string 图标urlString
function _class:updateContentIcons(url)
    local iconView = self.iconViews[1]
    if url then
        iconView:gone(false)
        iconView:image(url)
    else
        iconView:gone(true)
    end
end

return _class