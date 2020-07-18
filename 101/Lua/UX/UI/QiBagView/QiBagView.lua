---玩家信息类UI，用于显示
if QiBagView==nil then
    QiBagView={}
    require "UI/QiBagView/QiBagViewBag.lua"
    require "UI/QiBagView/QiBagShowItem.lua"
    require "UI/QiBagView/QiBagViewPlayerEquip.lua"
    require "UI/QiBagView/QiBagViewProperty.lua"
end
local public
local bag_main_panel
BAG_FUNC_ELEMENT_DATA={
    [1]={
        textname="装  备",
    },
    [2]={
        textname="属  性",
    },
}

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiBagView:UIInit(keys)
    QiPrint("QiBagView:UIInit()",3)
    public = keys.SrcForm;
    QiBagView.funcindex=1
    --主panel
    QiBagView["bag_func_main_panel"]=public:GetWidgetProxyByName("bag_func_main_panel");
    -- 三个功能页面
    QiBagView["bag_switch_panel_1"]=public:GetWidgetProxyByName("bag_switch_panel_1");
    QiBagView["bag_switch_panel_2"]=public:GetWidgetProxyByName("bag_switch_panel_2");
    QiBagView["bag_switch_panel_3"]=public:GetWidgetProxyByName("bag_switch_panel_3");
    -- 三个页面初始化
    QiBagView:PlayerEquipInit(keys)
    QiBagView:ShowItemPanelInit(keys)
    QiBagView:PlayerPropertyInit(keys)
    QiBagView:BagPanelInit(keys)

    -- QiBagView["player_info_main_panel"]=public:GetWidgetProxyByName("player_info_main_panel");
    -- --左中右
    -- QiBagView["playerinfo_left_property_panel"]= public:GetWidgetProxyByName("playerinfo_left_property_panel");
    -- QiBagView["playerinfo_middel_property_panel"]= public:GetWidgetProxyByName("playerinfo_middel_property_panel");
    -- QiBagView["playerbag_right_panel"]=public:GetWidgetProxyByName("playerbag_right_panel");
    
    -- QiBagView["item_solt_list"]=public:GetWidgetProxyByName("item_solt_list");
    -- --装备信息
    -- QiBagView["ItemShowImage"]=public:GetWidgetProxyByName("ItemShowImage");
    -- QiBagView["ItemShowPropertyImage"]=public:GetWidgetProxyByName("ItemShowPropertyImage");

    -- QiBagView["ItemNameLabel"]=public:GetWidgetProxyByName("ItemNameLabel");
    -- QiBagView["ItemDescriptionLabel"]=public:GetWidgetProxyByName("ItemDescriptionLabel");
    -- -- 右侧背包
    -- QiBagView["bag_solts_main_list"]=public:GetWidgetProxyByName("bag_solts_main_list");
    -- -- 功能面板
    -- QiBagView["bag_btn_active"]=public:GetWidgetProxyByName("bag_btn_active");
    -- QiBagView["bag_btn_sell"]=public:GetWidgetProxyByName("bag_btn_sell");
    -- QiBagView["bag_btn_forge"]=public:GetWidgetProxyByName("bag_btn_forge");

    -- -- 左侧属性栏目
    -- QiBagView["player_property_list"]=public:GetWidgetProxyByName("player_property_list");
    QiBagView:BagViewElementInit(keys)
    QiBagView["bag_func_main_panel"]:SetActive(false)
end

function QiBagView:BagViewElementInit(keys)
    QiBagView["func_highlight_image"]={}
    QiBagView["bag_right_element_list"]=public:GetWidgetProxyByName("bag_right_element_list");
    for i = 1, QiBagView["bag_right_element_list"]:GetElementAmount() do
        local list_element=QiBagView["bag_right_element_list"]:GetListElement(i-1)
        local element_data=BAG_FUNC_ELEMENT_DATA[i]
        local element_btn=list_element:GetWidgetProxyByName("bag_right_element_btn")
        local high_image=list_element:GetWidgetProxyByName("bag_right_element_light_image")
        high_image:SetActive(false)
        QiBagView["func_highlight_image"][#QiBagView["func_highlight_image"]+1]=high_image
        -- textname
        element_btn:GetText():SetContent(element_data["textname"])
    end
    InitFuncPanelByIndex(1)
end

-- 初始化功能页面
function InitFuncPanelByIndex(index)
    local panel_string="bag_switch_panel_"
    for i=1,QiBagView["bag_right_element_list"]:GetElementAmount() do 
        local panel_name=panel_string..tostring(i)
        if i==index then 
            QiBagView.funcindex=i
            QiBagView[panel_name]:SetActive(true)
            QiBagView["func_highlight_image"][i]:SetActive(true)
            if i==1 then 
                QiBagView:RefreshPlayerEquip()
                QiBagView:RefreshBag()
            elseif i==2 then 
                QiBagView:RefreshProperty()
            elseif i==3 then 
            end
            bagcontroller:SetSelectItem(LuaCallCs_Battle.GetHostActorID(),1,nil,-1)
        else
            QiBagView[panel_name]:SetActive(false)
            QiBagView["func_highlight_image"][i]:SetActive(false)
        end
    end
end

function bag_panel_open_switch()
    QiBagView["bag_func_main_panel"]:SetActive(not QiBagView["bag_func_main_panel"]:IsActived())
end

function bag_func_element_click(keys)
    local SrcWidget = keys.SrcWidget;
    local index = SrcWidget:GetIndexInBelongedList()
    QiPrint("solt index"..tostring(index),3)
    -- QiBagView["bag_switch_panel_1"]
    InitFuncPanelByIndex(index+1)
end


-- SetColor(BluePrint.UGC.UI.Core.Color(0.45, 0.45, 0.45, 1));
--UI创建
function ui_bag_create(keys)
    public=keys.SrcForm
    QiBagView:UIInit(keys)
    --隐藏 
    QiPrint("ui_bag_create",3)
    uicontroller:btn_alert()
    -- PrintTable(keys)
end



--UI关闭
function ui_bag_close(keys)
    QiPrint("ui_bag_close",3)
    uicontroller:btn_exit()
    local actorID = LuaCallCs_Battle.GetHostActorID();
	LuaCallCs_UI.UnRegisterGameEventListenerForLua(enGameEventForLua.Event_EquipChange, actorID, OnEquipChange);
end

-- function ability_test()
--     QiPrint("ability_test")
--     --直接调用API获得所有技能信息
--     -- PrintTable(LuaCallCs_Battle.GetAllSkillSlots(actorID))
--     local actorID = LuaCallCs_Battle.GetHostActorID();
--     --从0到64依次从index获取技能 
--     for index=0,64 do
--         local m_ability=LuaCallCs_Skill.GetSkillSlot(actorID, index)--@返回: struct SkillInfo(技能信息结构体)
--         --
--         if m_ability==nil then 
--             QiPrint("Not Find ability index:["..tostring(index).."]")
--         else
--             QiPrint("Find ability index:["..tostring(index).."]")
--             TGCPrintTable(m_ability)
--             local cur_ability_id=m_ability.curSkillID
--             QiPrint("curability id "..tostring(cur_ability_id),3)
--             local m_skill=LuaCallCs_Skill.GetSkillInfo(cur_ability_id)--@返回: struct SkillInfo(技能信息结构体)
--             TGCPrintTable(m_skill)
--         end
--     end
-- end

--
function OnEquipChange(changeParam)    
    QiPrint("OnEquipChange")
    TGCPrintTable(changeParam)
    -- QiBagView:RefreshBagInfo()
end

--统一刷新bag的信息
function QiBagView:RefreshBagInfo()
    QiBagView:RefreshBag()
    QiMainView:RefreshSmartBag()
    QiBagView:ShowItemInfo()
    QiBagView:RefreshProperty()
end

--当装备被选中
function OnEquipListSelectSoltChange(keys)
    uicontroller:btn_click()
    QiPrint("OnEquipListSelectSoltChange",3)
    -- TGCPrintTable(keys)
    for i = 1, QiBagView["item_solt_list"]:GetElementAmount() do
        if  QiBagView["item_solt_list"]:GetListElement(i-1)==keys.SrcForm then 
            QiPrint("item_solt_list same"..tostring(i))
        end
    end
end

--
function onsoltenable(keys)
    QiPrint("onsoltenable",3)
    -- TGCPrintTable(keys)
    -- SrcWidget:ListProxy
end





