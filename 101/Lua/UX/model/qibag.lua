BAG_ITEM_TYPE_EQUIP=1 --装备类型
BAG_ITEM_TYPE_MATERIALS=2 --材料类型
BAG_ITEM_TYPE_QUEST=3 --任务
BAG_ITEM_CONSUMABLES=4 --消耗品

if qibag==nil then 
    qibag={}
    qibag.bag={}
    qibag.row=5--8行
    qibag.col=4--5列
    qibag.pid=nil
end

--- 新建背包
-- 
function qibag:new(o,pid)
    o=o or {}
    setmetatable(o,self)
    self.__index =self
    o.bag={}
    o.pid=pid
    o.selectItem=nil
    --初始化每个背包格子
    --类型
    for i=1,qibag.row*qibag.col do
        -- 行
        o.bag[i]={
            m_index=i,--格子索引
            m_itemTitle=nil,--装备名字
        }
    end
    return o
end

--返回一个bag的信息
function qibag:GetBagInfo()
    return self.bag
end

--设置选中的装备
function qibag:SetSelectItem(item_name,item_type)
    -- self.selectItem={item_name=item_name,item_type=item_type}
    -- QiBagView:ShowItemInfo()
end

-- 获得选中的装备信息
function qibag:GetSelectItem()
    return self.selectItem
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type index description
-- @treturn any description.
-- @author 
function qibag:GetSoltInfo(index)
    return self.bag[index]
end