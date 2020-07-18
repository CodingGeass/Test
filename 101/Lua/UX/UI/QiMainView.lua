---玩家信息类UI，用于显示
if QiMainView==nil then
    QiMainView={
        Baglist=nil,
    }
    QiMainView.smartitemlist={}
    QiMainView.canpick=true
    QiMainView.smart_item_tween_handle={}
    for i=1,6 do 
        QiMainView.smart_item_tween_handle[i]={}
    end
    QiMainView.WeaponGrowTween={}
    QiMainView.initdone=false
end
local public

--- 主UI初始化
function QiMainView:UIInit(keys)
    QiPrint("QiMainView:UIInit()",3)
    public = keys.SrcForm;

    QiMainView["Baglist"]=public:GetWidgetProxyByName("Baglist");
    QiMainView["SelectPanel"]=public:GetWidgetProxyByName("SelectPanel");
    -- QiMainView["SelectPanel"]:SetActive(false)
    QiMainView["pick_item_image"]=public:GetWidgetProxyByName("pick_item_image");
    QiMainView["pick_item_property_img"]=public:GetWidgetProxyByName("pick_item_property_img");
    QiMainView["text_pick_item"]=public:GetWidgetProxyByName("text_pick_item");
    QiMainView["pick_item_label"]=public:GetWidgetProxyByName("pick_item_label");
    QiMainView["grow_weapon_number_label"]=public:GetWidgetProxyByName("grow_weapon_number_label");
   
    for i=1,6 do 
        local animation_weight_handle=QiMainView["Baglist"]:GetListElement(i-1):GetWidgetProxyByName("image_border_gold")
        QiMainView.smart_item_tween_handle[i][#QiMainView.smart_item_tween_handle[i]+1]=LuaCallCs_Tween.WidgetAlpha(animation_weight_handle, 0, 1):SetDelay(0.11):SetEase(TweenType.easeInOutQuart)
    end
    LuaCallCs_Tween.WidgetAlpha(QiMainView["grow_weapon_number_label"], 0, 1):SetEase(TweenType.easeInOutQuart)
    QiMainView.initdone=true
end


function WeaponGrow(aid,number)
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if actorID==aid then
        for k,v in pairs(QiMainView.WeaponGrowTween) do 
            v:Cancel()
        end
        QiMainView:HighLightSolt(1,true)
        QiMainView.WeaponGrowTween={}
        QiMainView["grow_weapon_number_label"]:GetText():SetContent(tostring(number))
        QiMainView.WeaponGrowTween[#QiMainView.WeaponGrowTween+1]=LuaCallCs_Tween.WidgetAlpha(QiMainView["grow_weapon_number_label"], 1,0.1)
        QiMainView.WeaponGrowTween[#QiMainView.WeaponGrowTween+1]=LuaCallCs_Tween.WidgetAlpha(QiMainView["grow_weapon_number_label"], 0, 1):SetDelay(0.11):SetEase(TweenType.easeInOutQuart)
    end
end
--刷新迷你背包
function QiMainView:RefreshSmartBag()
    -- 如果打开了装备界面一并刷新
    if QiBagView.funcindex==1 then 
        QiBagView:RefreshPlayerEquip()
    end
    -- RefreshSmartBag
    QiPrint("RefreshSmartBag")
    local actorID = LuaCallCs_Battle.GetHostActorID();
    local p_info=playerequipcontroller
    for i = 1, 6 do
        QiMainView:HighLightSolt(i)
        if playerequipcontroller[actorID]~=nil and     QiMainView.initdone==true        then 
            QiMainView.smartitemlist[i]=playerequipcontroller[actorID][i]
            if(playerequipcontroller[actorID][i] ~= nil) then  --有装备
                local item_data=QiData.item_data[playerequipcontroller[actorID][i]]
                -- local item_data=QiData[]
                local m_quality=item_data["m_quality"]
                local res_path="Texture/Sprite/"..playerequipcontroller[actorID][i]..".sprite"
                -- local equioInfo = LuaCallCs_Equip.GetEquipInfo(bagEquipInfo[i].m_equipID)
                QiMainView["Baglist"]:GetListElement(i-1):GetWidgetProxyByName("item_image"):GetImage():SetRes(res_path)
                -- local item_name=bagcontroller:GetQiItemNameByEquipID(bagEquipInfo[i].m_equipID)
                bagcontroller:SetImageWithQuality(QiMainView["Baglist"]:GetListElement(i-1):GetWidgetProxyByName("item_property_img"):GetImage(),m_quality,true)
            else
                QiMainView["Baglist"]:GetListElement(i-1):GetWidgetProxyByName("item_image"):GetImage():SetRes("Texture/Sprite/item_background.sprite")
                bagcontroller:SetImageWithQuality(QiMainView["Baglist"]:GetListElement(i-1):GetWidgetProxyByName("item_property_img"):GetImage(),nil,true)
            end
        end
    end
end

-- 高亮smart背包格子
function QiMainView:HighLightSolt(i,isforce)
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if QiMainView.smartitemlist[i]==nil then 
        return 
    end
    if ((QiMainView.smartitemlist[i]==nil or QiMainView.smartitemlist[i]~=playerequipcontroller[actorID][i] ) and playerequipcontroller[actorID][i]~=nil) or isforce==true then
        for k,v in pairs(QiMainView.smart_item_tween_handle[i]) do 
            v:Cancel()
        end
        local animation_weight_handle=QiMainView["Baglist"]:GetListElement(i-1):GetWidgetProxyByName("image_border_gold")
        QiMainView.smart_item_tween_handle[i][#QiMainView.smart_item_tween_handle[i]+1]=LuaCallCs_Tween.WidgetAlpha(animation_weight_handle, 1,0.1)
        QiMainView.smart_item_tween_handle[i][#QiMainView.smart_item_tween_handle[i]+1]=LuaCallCs_Tween.WidgetAlpha(animation_weight_handle, 0, 1):SetDelay(0.11):SetEase(TweenType.easeInOutQuart)
    end
end

--UI创建
function OnMainUICreate(keys)
    QiMainView:UIInit(keys)
    public=keys.SrcForm
    --隐藏 
    -- public:Hide()
    -- QiPrint("OnMainUICreate",3)
    -- PrintTable(keys)
end

function fast_pick_item_btn()
    if QiMainView.canpick==true then 
        local message = {[1]="select_item",[2]=LuaCallCs_Battle.GetHostActorID()}
        passp =  massage_zip(message)
        LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
    end
end

function SetSelectBtn(aid,can_pick,itemname)
    if aid==LuaCallCs_Battle.GetHostActorID() then 
        if can_pick==false then
            QiMainView["SelectPanel"]:SetActive(can_pick)
        end
        if can_pick==true and can_pick~= QiMainView.canpick then 
            QiMainView["SelectPanel"]:SetActive(true)
            local item_data=QiData.item_data[itemname]
            local m_quality=item_data["m_quality"]
            local res_path="Texture/Sprite/"..itemname..".sprite"
            -- local equioInfo = LuaCallCs_Equip.GetEquipInfo(bagEquipInfo[i].m_equipID)
            QiMainView["pick_item_image"]:GetImage():SetRes(res_path)
            -- local item_name=bagcontroller:GetQiItemNameByEquipID(bagEquipInfo[i].m_equipID)
            bagcontroller:SetImageWithQuality(QiMainView["pick_item_property_img"]:GetImage(),m_quality,true)
            local m_itemTitle=item_data["m_itemTitle"]
            QiMainView["pick_item_label"]:GetText():SetContent(m_itemTitle)
            bagcontroller:SetImageWithQuality(QiMainView["pick_item_label"]:GetText(),m_quality,false)
        end
    end
    QiMainView.canpick=can_pick
end

--UI关闭
function OnMainUIClose(keys)
    -- QiPrint("OnMainUIClose",3)
end

function console_btn_click(keys)
    -- QiPrint("console btn click",3)
end

--- 选中物品
-- function detail description.
-- @tparam  type keys description
-- @author 
function smart_bag_solt_select(keys)
    -- QiPrint("smart_bag_solt_select",5)
    -- local SrcWidget = keys.SrcWidget;
    -- local actorID = LuaCallCs_Battle.GetHostActorID();
    -- -- TGCPrintTable(SrcWidget)
    -- local index = SrcWidget:GetIndexInBelongedList()
    -- QiPrint("solt index"..tostring(index),3)
    -- local solt_item_name=playerequipcontroller[actorID][index+1]
    -- bagcontroller:MsgItemInfo(solt_item_name)
    -- bagcontroller:SetSelectItem(actorID,1,solt_item_name,index+1)
end
