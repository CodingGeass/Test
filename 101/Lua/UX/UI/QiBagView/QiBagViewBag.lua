if QiBagViewBag==nil then 
    QiBagViewBag={}
end
local public
function QiBagView:BagPanelInit(keys)
    public = keys.SrcForm;
    QiBagView:RefreshBag()
    QiBagView["bag_solts_main_list"]=public:GetWidgetProxyByName("bag_solts_main_list");
end
-- 刷新Bag
function QiBagView:RefreshBag()
    local aid = LuaCallCs_Battle.GetHostActorID();
    if QiBagView.funcindex==1 and QiBagView["bag_solts_main_list"]~=nil then 
        if bagcontroller[aid]~=nil and bagcontroller[aid]["bag"]~=nil then 
            for index,solt_data in pairs(bagcontroller[aid]["bag"]) do 
                -- QiPrint("RefreshBag:"..tostring(index),3)
                local item_element=QiBagView["bag_solts_main_list"]:GetListElement(index-1)
                if solt_data["itemname"]==nil then 
                    bagcontroller:SetImageWithQuality(item_element:GetWidgetProxyByName("bag_equip_bakground_image"):GetImage(),nil,true)
                    item_element:GetWidgetProxyByName("bag_euip_image"):GetImage():SetRes("Texture/Sprite/item_background.sprite")
                    item_element:GetWidgetProxyByName("bag_equipnumber_label"):GetText():SetContent("")
                else
                    local item_name=bagcontroller[aid]["bag"][index]["itemname"]
                    local item_num=bagcontroller[aid]["bag"][index]["number"]
                    local item_data=QiData.item_data[item_name]
                    local m_quality=item_data["m_quality"]
                    -- Texture/Sprite/item_ass_base_normal_3.sprite
                    local res_path="Texture/Sprite/"..item_data["item_name"]..".sprite"
                    QiPrint("bag res"..tostring(res_path))
                    local image_icon=item_element:GetWidgetProxyByName("bag_euip_image")
                    image_icon:GetImage():SetRes(res_path)
                    bagcontroller:SetImageWithQuality(item_element:GetWidgetProxyByName("bag_equip_bakground_image"):GetImage(),m_quality,true)
                    if item_num==1 then 
                        item_element:GetWidgetProxyByName("bag_equipnumber_label"):GetText():SetContent("")
                    else 
                        item_element:GetWidgetProxyByName("bag_equipnumber_label"):GetText():SetContent(tostring(item_num))
                    end
                end
            end
        end
    end
end

-- 设置背包物品高亮
function QiBagView:SetBagHighLight(index)
    for i = 1, 6 do
        local high_ligh_border=QiBagView["bag_solts_main_list"]:GetListElement(i-1):GetWidgetProxyByName("bag_high_border_image")
        if high_ligh_border~=nil then 
            if i==index then 
                high_ligh_border:SetActive(true)
            else 
                high_ligh_border:SetActive(false)
            end
        end
    end
end

--- function summary description.
-- function detail description.
-- @tparam  type keys description
-- @author 
function bag_solt_elementselect(keys)
    local SrcWidget = keys.SrcWidget;
    -- TGCPrintTable(SrcWidget)
    local index = SrcWidget:GetIndexInBelongedList()
    QiPrint("solt index"..tostring(index),3)
    local aid = LuaCallCs_Battle.GetHostActorID();
    local solt_item_name=bagcontroller[aid]["bag"][index+1]["itemname"]
    --背包不是空的
    bagcontroller:MsgItemInfo(solt_item_name)
    bagcontroller:SetSelectItem(aid,2,solt_item_name,index+1)
end
