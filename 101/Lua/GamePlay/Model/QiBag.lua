BAG_ITEM_TYPE_EQUIP=1 --装备类型
BAG_ITEM_TYPE_MATERIALS=2 --材料类型
BAG_ITEM_TYPE_QUEST=3 --任务
BAG_ITEM_CONSUMABLES=4 --消耗品

BAG_SOLT_TYPE_WEAPON=1--武器
BAG_SOLT_TYPE_FABAO=2-- 法宝
BAG_SOLT_TYPE_CLOTHES=3 --衣服
BAG_SOLT_TYPE_PANT=4 --裤子
BAG_SOLT_TYPE_SHOE=5 --鞋子
BAG_SOLT_TYPE_OTHER=6 --首饰

if QiBag==nil then 
    QiBag={}
    QiBag.bag={}
    QiBag.row=4--8行
    QiBag.col=4--5列
    QiBag.pid=nil
end

--- 新建背包
-- 
function QiBag:new(o,actor,pid)
    o=o or {}
    setmetatable(o,self)
    self.__index =self
    o.bag={}
    o.pid=pid
    o.unit=actor
    o.aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID )
    o.selectItem=nil
    --初始化每个背包格子
    --类型
    for i=1,QiBag.row*QiBag.col do
        -- 行
        o.bag[i]={
            m_index=i,--格子索引
            m_itemTitle=nil,--装备名字
            m_number=0,
        }
    end
    o:AddItemByName("item_hat_baicao_n1",1)
    return o
end

--返回一个bag的信息
function QiBag:GetBagInfo()
    return self.bag
end

--设置选中的装备
function QiBag:SetSelectItem(item_name,item_type)
    -- self.selectItem={item_name=item_name,item_type=item_type}
    -- QiBagView:ShowItemInfo()
end

-- 获得选中的装备信息
function QiBag:GetSelectItem()
    return self.selectItem
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type index description
-- @treturn any description.
-- @author 
function QiBag:GetSoltInfo(index)
    return self.bag[index]
end

function QiBag:EquipItem(index)
    -- self.bag[index]={
    --     m_index=i,--格子索引
    --     m_itemTitle=nil,--装备名字
    --     m_number=0,
    -- }
    if self.bag[index]["m_itemTitle"]==nil then 
        QiMsg("无法装备，没有物品",4)
        return
    end
    local item_name=self.bag[index]["m_itemTitle"]
    if PlayerController:GetPlayerEquip(self.pid):EquipItem(item_name)==true then 
        self:RemoveItem(index)
    else
    end
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type index description
-- @author 
function QiBag:SellItem(index)
    if index then 
        local itemname=self.bag[index]["m_itemTitle"]
        self:RemoveItem(index)
        local item_data=QiData.item_data[itemname]
        if item_data~=nil then 
            local item_level=tonumber(item_data["m_equiplevel"])
            if item_level~=nil then 
                local gold=math.floor(math.pow(1.5, item_level)*100)
                if gold>0 then 
                    if gold>10000 then 
                        gold=10000 
                    end
                    sc.PlayCustomSound(MUSIC_BACKGROUND_EVENT,StringId.new("Sound/ui_sound_gold_buy.ogg"),1)
                    QiBottomAlert("您出售了["..QiBag:GetQualityNameByItemName(itemname).."]获得了"..tostring(gold).."金币",nil,self.aid)
                    PlayerController:GetQiHero(self.pid):AddGold(gold,false)
                end
            end
        end
    end
end

function QiBag:GetQualityNameByItemName(itemname)
    local item_data=QiData.item_data[itemname]
    if item_data~=nil then 
        if item_data["m_quality"]=="white" then 
            return "<color=#d9d9d9>"..item_data["m_itemTitle"].."</color>"
        elseif item_data["m_quality"]=="green" then 
            return "<color=#66ff66>"..item_data["m_itemTitle"].."</color>"
        elseif item_data["m_quality"]=="blue" then 
            return "<color=#33ccff>"..item_data["m_itemTitle"].."</color>"
        elseif item_data["m_quality"]=="purple" then 
            return "<color=#9966ff>"..item_data["m_itemTitle"].."</color>"
        elseif item_data["m_quality"]=="pink" then 
            return "<color=#ff00ff>"..item_data["m_itemTitle"].."</color>"
        elseif item_data["m_quality"]=="orange" then 
            return "<color=#ff8c1a>"..item_data["m_itemTitle"].."</color>"
        end
    else
        return name 
    end
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type index description
-- @author 
function QiBag:RemoveItem(index)
    if index and self.bag[index] then 
        self.bag[index]={
                m_index=index,--格子索引
                m_itemTitle=nil,--装备名字
                m_number=0,
        }
        self:SetBag(index,nil,0)
    end
end

--- 根据名字添加装备
-- function detail description.
-- @tparam  type self description
-- @tparam  type itemname description
-- @tparam  type num description
-- @author 
function QiBag:AddItemByName(itemname,num)
    num=num or 1
    --获取装备数据
    local item_data=QiData.item_data[itemname]
    if item_data==nil then 
        QiPrint("AddItemError not find Item data"..itemname,3)
        return
    end
    --类型
    local m_itemtype=tonumber(item_data["m_itemtype"])
    if m_itemtype==-1 then 
        if item_func[itemname]~=nil then 
            item_func[itemname](nil,self.pid)
        end
        return
    end
    local e_title=item_data["m_itemTitle"]
    local msg_str="您获得了["..e_title.."]".."X"..tostring(num)

    --是否可堆叠
    local stackable=true
    if m_itemtype>0 then 
        stackable=false 
    end
    
    --如果可以堆叠先遍历一遍堆叠设置
    if stackable==true then 
        --遍历背包里内容
        for index,solt_data in pairs(self.bag) do
            --这个格子是空的
            if solt_data["m_itemTitle"]==itemname then 
                --为装备格设置装备信息
                solt_data["m_num"]=solt_data["m_num"]+1
                self:SetBag(index,solt_data["m_itemTitle"],solt_data["m_num"])
                QiMsg(msg_str, 4)
                return solt_data
            end
        end
    end
    
    --遍历背包
    for index,solt_data in pairs(self.bag) do
        --这个格子是空的
        if solt_data["m_itemTitle"]==nil then 
            --为装备格设置装备信息
            solt_data["m_num"]=num
            solt_data["m_itemTitle"]=itemname
            self:SetBag(index,solt_data["m_itemTitle"],solt_data["m_num"])
            QiMsg(msg_str, 4)
            return solt_data
        end
    end
    QiMsg("无法取下，背包已满")
    --- 背包满了
    return false
end

function QiBag:SetBag(solt_index,itemname,number)
    local eventName = StringId.new("SetBag")
    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],solt_index,itemname,number} , eventName)
end
