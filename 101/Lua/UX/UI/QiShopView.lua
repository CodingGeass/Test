QISHOP_RIGHTSHOPLIST_SHOWNUMBER=10--右侧最大创建数量
if QiShopView==nil then
    QiShopView={}
    QiShopView["shopname"]=nil
    QiShopView["lastborderimage"]=nil
    QiShopView["clicktween"]={}
    QiShopView["selectitemname"]=nil
    QiShopView["stocknumber"]={}
end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiShopView:UIInit(keys)
    QiPrint("QiShopView UIInit",3)
    public = keys.SrcForm;
    QiShopView["init"]=true
    QiShopView["item_show_panel"]=public:GetWidgetProxyByName("item_show_panel");
    QiShopView["ItemNameLabel"]=public:GetWidgetProxyByName("ItemNameLabel");
    QiShopView["shop_showitem_price_label"]=public:GetWidgetProxyByName("shop_showitem_price_label");
    QiShopView["shop_buy_btn_click"]=public:GetWidgetProxyByName("shop_buy_btn_click");
    QiShopView["ItemShowPropertyImage"]=public:GetWidgetProxyByName("ItemShowPropertyImage");
    QiShopView["show_item_image"]=public:GetWidgetProxyByName("show_item_image");
    QiShopView["main_property_list"]=public:GetWidgetProxyByName("main_property_list");
    QiShopView["ass_property_list"]=public:GetWidgetProxyByName("ass_property_list");
    QiShopView["show_item_description"]=public:GetWidgetProxyByName("show_item_description");
    -- 主panel
    QiShopView["ShopMainPanel"]=public:GetWidgetProxyByName("ShopMainPanel");
    QiShopView["ShopTitleTextLabel"]=public:GetWidgetProxyByName("ShopTitleTextLabel");
    QiShopView["shop_item_list"]=public:GetWidgetProxyByName("shop_item_list");
    QiShopView["ShopMainPanel"]:SetActive(false)
end


function shop_init(shopname,state,aid)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if self_aid==aid then 
        if state==1 then 
            QiShopView["ShopMainPanel"]:SetActive(true)
            QiShopView:InitShopFromName(shopname)
        else 
            QiShopView["ShopMainPanel"]:SetActive(false)
        end
    end
end

-- 接受到商店存货数据
function SendShopIndexData(aid,shopname,index,now_stocknumber,stock_reamaintime,stock_time) 
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if QiShopView["shopname"]==shopname and self_aid==aid then 
        local list_element=QiShopView["shop_item_list"]:GetListElement(index-1)
        local stock_number=list_element:GetWidgetProxyByName("item_stock_number")
        local item_sell_black_borderimage=list_element:GetWidgetProxyByName("item_sell_black_borderimage")
        QiShopView["stocknumber"][index]=now_stocknumber
        -- if QiShopView["selectitemname"]==
        if now_stocknumber==0 then 
            item_sell_black_borderimage:SetActive(true)
            stock_number:SetActive(false)
        elseif now_stocknumber==-1 then
            item_sell_black_borderimage:SetActive(false)
            stock_number:SetActive(false)
        else
            item_sell_black_borderimage:SetActive(false)
            stock_number:SetActive(true)
            stock_number:GetText():SetContent(tostring(now_stocknumber))
        end
    end
end

--- 当窗口创建
function base_shop_onopen(keys)
    QiPrint("base_shop_onopen",3)
    QiShopView:UIInit(keys)
end

--- 关闭窗口单击
function base_shop_close_btn_click()
    if QiShopView["ShopMainPanel"]==nil then 
        QiPrint("base_shop_player_in not init",3)
        return
    end
    QiShopView["ShopMainPanel"]:SetActive(not QiShopView["ShopMainPanel"]:IsActived())
end

---根据商店名字初始化商店
function QiShopView:InitShopFromName(shop_name)
    QiShopView["shopname"]=shop_name
    if  QiShopView["lastborderimage"]~=nil then 
        QiShopView["lastborderimage"]:SetActive(false)
        QiShopView["lastborderimage"]=nil
    end
    QiShopView["stocknumber"]={}
    QiShopView["item_show_panel"]:SetActive(false)
    QiShopView["selectitemname"]=nil
    local shop_title,shop_data=qishop:GetShopInfo(shop_name)
    QiShopView["ShopTitleTextLabel"]:GetText():SetContent(shop_title)
    for i=1,QISHOP_RIGHTSHOPLIST_SHOWNUMBER do
        local list_element=QiShopView["shop_item_list"]:GetListElement(i-1)
        local shop_item_data=shop_data[i]
        if shop_item_data==nil then 
            list_element:SetActive(false)
        else 
            list_element:SetActive(true)
            local item_name=shop_item_data["sell_item_name"]
            local price_data=shop_item_data["sell_price"]
            local price_str=qishop:FormatPriceString(price_data)
            list_element:GetWidgetProxyByName("item_price_label"):GetText():SetContent(tostring(price_str))
            local item_data=QiData.item_data[item_name]
            local m_equipDesc=item_data["m_equipDesc"] or ""
            local m_quality=item_data["m_quality"]
            local m_itemTitle=item_data.m_itemTitle
            local m_equipIconPath="Texture/Sprite/"..item_name..".sprite"
            if m_itemTitle then 
                list_element:GetWidgetProxyByName("item_text_title_label"):GetText():SetContent(m_itemTitle)
                bagcontroller:SetImageWithQuality(list_element:GetWidgetProxyByName("item_text_title_label"):GetText(),m_quality,false)
                list_element:GetWidgetProxyByName("item_text_description_label"):GetText():SetContent(m_equipDesc)
                list_element:GetWidgetProxyByName("item_image"):GetImage():SetRes(m_equipIconPath)
                bagcontroller:SetImageWithQuality(list_element:GetWidgetProxyByName("item_image_border"):GetImage(),m_quality,true)
            end
        end
       
    end
end
-- 物品点击
function shop_item_click(keys)
    local SrcWidget = keys.SrcWidget;
 
    local index = SrcWidget:GetIndexInBelongedList()
    local list_element=QiShopView["shop_item_list"]:GetListElement(index)

    LuaCallCs_Tween.WidgetAlpha(list_element, 0.4,0.01):SetEase(TweenType.easeInQuad)
    LuaCallCs_Tween.WidgetAlpha(list_element, 1,0.5):SetDelay(0.05):SetEase(TweenType.easeInQuad)
    local border_image=list_element:GetWidgetProxyByName("shop_item_highlight_image")
    border_image:SetActive(true)
    if QiShopView["lastborderimage"]~=nil then 
        QiShopView["lastborderimage"]:SetActive(false)
    end
    QiShopView["lastborderimage"]=border_image
    local shop_title,shop_data=qishop:GetShopInfo(QiShopView["shopname"])
    local shop_item_data=shop_data[index+1]
    if QiShopView["stocknumber"][index+1]>0 or QiShopView["stocknumber"][index+1]==-1 then
        QiShopView["shop_buy_btn_click"]:SetActive(true)
    else 
        QiShopView["shop_buy_btn_click"]:SetActive(false)
    end
    local item_name=shop_item_data["sell_item_name"]
    QiPrint("shopitemclick"..tostring(item_name))
    QiShopView:ShowItemInfo(shop_item_data,item_name)
end

--- 显示物品的信息
-- function detail description.
-- @tparam  type self description
-- @tparam  type m_itemTitle description
-- @author item_data
function QiShopView:ShowItemInfo(shop_item_data,item_name)
    QiShopView["selectitemname"]=item_name
    local aid = LuaCallCs_Battle.GetHostActorID();
    local item_data=QiData.item_data[item_name]

    QiShopView["item_show_panel"]:SetActive(true)
    local m_equipDesc=item_data["m_equipDesc"] or ""
    local m_quality=item_data["m_quality"]
    local m_equipIconPath="Texture/Sprite/"..item_name..".sprite"
    local m_itemTitle=item_data.m_itemTitle
    if m_itemTitle then 
        QiShopView["ItemNameLabel"]:GetText():SetContent(m_itemTitle)
        bagcontroller:SetImageWithQuality(QiShopView["ItemNameLabel"]:GetText(),m_quality,false)
        local price_data=shop_item_data["sell_price"]
        local price_str=qishop:FormatPriceString(price_data)
        QiShopView["show_item_description"]:GetText():SetContent(m_equipDesc)
        -- 物品图标
        bagcontroller:SetImageWithQuality(QiShopView["ItemShowPropertyImage"]:GetImage(),m_quality,true)
        QiShopView["show_item_image"]:GetImage():SetRes(m_equipIconPath)
        local main_data,ass_data=bagcontroller:GetMainAndAssProperty(item_name)
        -- 设置主属性
        -- TGCPrintTable(main_data)
        -- TGCPrintTable(ass_data)
        for i=1,2 do 
            local list_element=QiShopView["main_property_list"]:GetListElement(i-1)
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
            local list_element=QiShopView["ass_property_list"]:GetListElement(i-1)
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
    end

end

--- 商店购买按钮
function shop_buy_btn_click(keys)
    local aid = LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="shop_buy_item",[2]=aid,[3]=QiShopView["selectitemname"]}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end