
local public
function QiBagView:ShowItemPanelInit(keys)
    public = keys.SrcForm;
    QiBagView["ItemNameLabel"]=public:GetWidgetProxyByName("ItemNameLabel");
    QiBagView["show_item_btn_1"]=public:GetWidgetProxyByName("show_item_btn_1");
    QiBagView["show_item_btn_2"]=public:GetWidgetProxyByName("show_item_btn_2");
    QiBagView["ItemShowPropertyImage"]=public:GetWidgetProxyByName("ItemShowPropertyImage");

    QiBagView["show_item_image"]=public:GetWidgetProxyByName("show_item_image");

    QiBagView["main_property_list"]=public:GetWidgetProxyByName("main_property_list");
    QiBagView["ass_property_list"]=public:GetWidgetProxyByName("ass_property_list");

    QiBagView["item_show_panel"]=public:GetWidgetProxyByName("item_show_panel");
    QiBagView["item_show_panel"]:SetActive(false)
end

function QiBagView:RefreshItemShow()
    QiBagView:ShowItemInfo()
end


--- 显示物品的信息
-- function detail description.
-- @tparam  type self description
-- @tparam  type m_itemTitle description
-- @author item_data
function QiBagView:ShowItemInfo()
    local aid = LuaCallCs_Battle.GetHostActorID();
    local select_info= bagcontroller:GetSelectItem(aid)
    if select_info==nil then return end
    local type=select_info.select_type
    local item_data=QiData.item_data[select_info.select_item]
    if item_data~=nil then 
        QiBagView["item_show_panel"]:SetActive(true)
        local m_equipDesc=item_data["m_equipDesc"] or ""
        m_equipDesc=m_equipDesc..bagcontroller:GetPropertyDesc(select_info.select_item)
        local m_quality=item_data["m_quality"]
        local m_equipIconPath="Texture/Sprite/"..select_info.select_item..".sprite"
        local m_itemTitle=item_data.m_itemTitle
        if m_itemTitle then 
            QiBagView["ItemNameLabel"]:GetText():SetContent(m_itemTitle)
            bagcontroller:SetImageWithQuality(QiBagView["ItemNameLabel"]:GetText(),m_quality,false)
            if type==1 then 
                -- 是装备栏目
                QiBagView["show_item_btn_1"]:SetActive(true)
                QiBagView["show_item_btn_1"]:GetText():SetContent("取下")
                QiBagView["show_item_btn_2"]:SetActive(false)
            elseif type==2 then 
                QiBagView["show_item_btn_1"]:SetActive(true)
                if item_data["m_itemtype"]>0 then
                    QiBagView["show_item_btn_1"]:GetText():SetContent("装备")
                else
                    QiBagView["show_item_btn_1"]:GetText():SetContent("使用")
                end
                QiBagView["show_item_btn_2"]:SetActive(true)
            elseif type==3 then 
                QiBagView["show_item_btn_1"]:SetActive(true)
                QiBagView["show_item_btn_1"]:GetText():SetContent("购买")
                QiBagView["show_item_btn_2"]:SetActive(false)
            end
        end
        if m_equipDesc then 
            -- 物品图标
            bagcontroller:SetImageWithQuality(QiBagView["ItemShowPropertyImage"]:GetImage(),m_quality,true)
            QiBagView["show_item_image"]:GetImage():SetRes(m_equipIconPath)
            local main_data,ass_data=bagcontroller:GetMainAndAssProperty(select_info.select_item)
            -- 设置主属性
            -- TGCPrintTable(main_data)
            -- TGCPrintTable(ass_data)
            for i=1,2 do 
                local list_element=QiBagView["main_property_list"]:GetListElement(i-1)
                if main_data[i]==nil then 
                    -- 没有要显示的
                    list_element:SetActive(false)
                else 
                    list_element:SetActive(true)
                    local text_label=list_element:GetWidgetProxyByName("main_property_list_element_label")
                    local property_name=main_data[i][1]
                    local property_value=main_data[i][2]
                    local property_name_schinese=bagcontroller["localized"][property_name] or property_name
                    local label_text=property_name_schinese.." + "..tostring(property_value)
                    text_label:GetText():SetContent(label_text)
                end
            end
            -- 设置副属性
            for i=1,3 do 
                local list_element=QiBagView["ass_property_list"]:GetListElement(i-1)
                if ass_data[i]==nil then 
                    -- 没有要显示的
                    list_element:SetActive(false)
                else 
                    list_element:SetActive(true)
                    local text_label=list_element:GetWidgetProxyByName("ass_property_list_element_label")
                    local property_name=ass_data[i][1]
                    local property_value=ass_data[i][2]
                    local property_name_schinese=bagcontroller["localized"][property_name] or property_name
                    local label_text=property_name_schinese.." + "..tostring(property_value)
                    text_label:GetText():SetContent(label_text)
                end
            end
            -- local list_element=QiBagView["bag_right_element_list"]:GetListElement(i-1)
            -- for k,v in pairs()
            -- -- 物品描述
            -- QiBagView["ItemDescriptionLabel"]:GetText():SetContent(m_equipDesc)
            -- bagcontroller:SetImageWithQuality(QiBagView["ItemDescriptionLabel"]:GetText(),m_quality,false)
            -- QiBagView["ItemDescriptionLabel"]:GetText():SetContent(m_equipDesc)
        end
    else
        QiBagView["item_show_panel"]:SetActive(false)
    end
end

--- 点击使用/装备按钮
function btn_event_use()
    local aid = LuaCallCs_Battle.GetHostActorID();
    bagcontroller:SendBagCommand(aid,"bag_use")
    uicontroller:btn_click()
    bagcontroller:SetSelectItem(LuaCallCs_Battle.GetHostActorID(),1,nil,-1)


end

--- 点击出售
function bag_btn_sell()
    local aid = LuaCallCs_Battle.GetHostActorID();
    bagcontroller:SendBagCommand(aid,"bag_sell")
    uicontroller:btn_click()
    bagcontroller:SetSelectItem(LuaCallCs_Battle.GetHostActorID(),1,nil,-1)
end

--- 点击合成
function bag_btn_forge()
    local aid = LuaCallCs_Battle.GetHostActorID();
    bagcontroller:SendBagCommand(aid,"bag_forge")
    uicontroller:btn_click()
    bagcontroller:SetSelectItem(LuaCallCs_Battle.GetHostActorID(),1,nil,-1)

end