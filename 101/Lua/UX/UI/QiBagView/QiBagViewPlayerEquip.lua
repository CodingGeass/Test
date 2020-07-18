if QiBagViewPlayerEquip==nil then 
    QiBagViewPlayerEquip={}
end
local public

function QiBagView:PlayerEquipInit(keys)
    public = keys.SrcForm;

    QiBagView["bag_player_eqiup_list"]=public:GetWidgetProxyByName("bag_player_eqiup_list");
    QiBagView:RefreshPlayerEquip()
end

--- 刷新玩家装备
function QiBagView:RefreshPlayerEquip()
    if  QiBagView["bag_player_eqiup_list"]==nil then 
        return
    end
    local actorID = LuaCallCs_Battle.GetHostActorID();

    local p_info=playerequipcontroller
    for i = 1, 6 do
        if playerequipcontroller[actorID]==nil then 
            return
        end
  
        if(playerequipcontroller[actorID][i] ~= nil) then  --有装备
            local item_data=QiData.item_data[playerequipcontroller[actorID][i]]
            local m_quality=item_data["m_quality"]
            local res_path="Texture/Sprite/"..playerequipcontroller[actorID][i]..".sprite"
            QiBagView["bag_player_eqiup_list"]:GetListElement(i-1):GetWidgetProxyByName("player_info_equip_image"):GetImage():SetRes(res_path)
            bagcontroller:SetImageWithQuality(QiBagView["bag_player_eqiup_list"]:GetListElement(i-1):GetWidgetProxyByName("player_info_equip_property_image"):GetImage(),m_quality,true)
        else
            QiBagView["bag_player_eqiup_list"]:GetListElement(i-1):GetWidgetProxyByName("player_info_equip_image"):GetImage():SetRes("Texture/Sprite/item_background.sprite")
            bagcontroller:SetImageWithQuality(QiBagView["bag_player_eqiup_list"]:GetListElement(i-1):GetWidgetProxyByName("player_info_equip_property_image"):GetImage(),nil,true)
        end
    end
end
-- 设置装备高亮
function QiBagView:SetEquipHighLight(index)
    for i = 1, 6 do
        local high_ligh_border=QiBagView["bag_player_eqiup_list"]:GetListElement(i-1):GetWidgetProxyByName("player_high_border_image")
        if high_ligh_border~=nil then 
            if i==index then 
                high_ligh_border:SetActive(true)
            else 
                high_ligh_border:SetActive(false)
            end
        end
    end
end
--- 选中物品
-- function detail description.
-- @tparam  type keys description
-- @author 
function func_bag_player_equip_select(keys)
    QiPrint("func_bag_player_equip_select",5)
    local SrcWidget = keys.SrcWidget;
    local actorID = LuaCallCs_Battle.GetHostActorID();
    -- TGCPrintTable(SrcWidget)
    local index = SrcWidget:GetIndexInBelongedList()
    QiPrint("solt index"..tostring(index),3)
    local solt_item_name=playerequipcontroller[actorID][index+1]
    -- bagcontroller:MsgItemInfo(solt_item_name)
    bagcontroller:SetSelectItem(actorID,1,solt_item_name,index+1)
end
