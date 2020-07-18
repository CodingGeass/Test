if QiTeleportView==nil then 
    QiTeleportView={}
    QiTeleportView.rownum=3
    QiTeleportView.maxshownum=14 --3*5
end

--- 主UI初始化ui_teleport_create
function QiTeleportView:UIInit(keys)
    QiPrint("QiTeleportView:UIInit()",3)
    public = keys.SrcForm;

    QiTeleportView["teleport_main_panel"]=public:GetWidgetProxyByName("teleport_main_panel");
    QiTeleportView["teleport_list"]=public:GetWidgetProxyByName("teleport_list");
    QiTeleportView["teleport_close_btn"]=public:GetWidgetProxyByName("teleport_close_btn");
    for i =1, QiTeleportView.maxshownum do
        local element=QiTeleportView["teleport_list"]:GetListElement(i-1)
        local teleport_gold_border_image=element:GetWidgetProxyByName("teleport_gold_border_image")
        LuaCallCs_Tween.WidgetAlpha(teleport_gold_border_image, 0,1):SetEase(TweenType.easeInQuad):SetLoopPingPong()
        teleport_gold_border_image:SetActive(false)
    end
    -- ui_switch_open()
    ui_switch_open()
end

--- 刷新UI
function QiTeleportView:RefreshUI()
    QiPrint("RefreshUI")
    for i =1, QiTeleportView.maxshownum do
        if tabteleportcontroller.t_list[i] then 
            local area=tabteleportcontroller.area[tabteleportcontroller.t_list[i]]
            local label_str=area["schinese"]
            local element=QiTeleportView["teleport_list"]:GetListElement(i-1)
            local teleport_element_label=element:GetWidgetProxyByName("teleport_element_label")
            local short_des_element_label=element:GetWidgetProxyByName("shot_text_description_label")
            local icon_image=element:GetWidgetProxyByName("teleport_image_icon")
            icon_image:GetImage():SetRes("Texture/Sprite/teleport_image_"..tostring(i-1)..".sprite")
            teleport_element_label:GetText():SetContent(label_str)
            short_des_element_label:GetText():SetContent(area["short_des"])
        end
    end
end

-- 设置按钮金色状态
function SendTeleportBtnGoldBorder(aid,btnindex,isopen)
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if actorID==aid then 
        local element=QiTeleportView["teleport_list"]:GetListElement(btnindex-1)
        if element~=nil then 
            local icon_image=element:GetWidgetProxyByName("teleport_gold_border_image")
            local back_image=element:GetWidgetProxyByName("teleport_back_image")
            back_image:GetImage():SetRes("Texture/Sprite/teleport_image_btn_gold.sprite")
            icon_image:SetActive(isopen)
            if isopen==true then 
                back_image:GetImage():SetRes("Texture/Sprite/teleport_image_btn_gold.sprite")
            else 
                back_image:GetImage():SetRes("Texture/Sprite/teleport_image_btn_normal.sprite")
            end
        end
    end
end

--- UI开关
function ui_switch_open()
    QiPrint("ui_switch_open")
    QiTeleportView:RefreshUI()
    if QiTeleportView["teleport_main_panel"]==nil then 
        QiPrint("base_shop_player_in not init",3)
        return
    end
    QiTeleportView["teleport_main_panel"]:SetActive(not QiTeleportView["teleport_main_panel"]:IsActived())
    if QiTeleportView["teleport_main_panel"]:IsActived()==true then 
        uicontroller:btn_alert()
    else 
        uicontroller:btn_exit()
    end
end

--- 初始化
function ui_teleport_create(keys)
    QiPrint("ui_teleport_create")
    QiTeleportView:UIInit(keys)
end

--被点
function teleport_solt_elementselect(keys)
    local SrcWidget = keys.SrcWidget;
    local index = SrcWidget:GetIndexInBelongedList()
    if tabteleportcontroller.t_list[index+1]~=nil then
        uicontroller:btn_click()
        QiPrint("Teleport to:"..tabteleportcontroller.t_list[index+1])
        tabteleportcontroller:teleportto(tabteleportcontroller.t_list[index+1])
        QiTeleportView["teleport_main_panel"]:SetActive(false)
    end 
end