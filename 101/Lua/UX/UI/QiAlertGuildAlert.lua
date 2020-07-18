local public

if QiAlertGuildAlert==nil then 
    QiAlertGuildAlert={}
end
function QiAlertGuildAlert:Init(keys)
    QiPrint("qi_alert_ui_init")
    public = keys.SrcForm;
    QiAlertGuildAlert.msg_alert_tween={}
    --主panel
    QiAlertGuildAlert["alert_mid_bottom_list"]=public:GetWidgetProxyByName("alert_mid_bottom_list");
    
    QiAlertGuildAlert["guild_alert_man_panel"]=public:GetWidgetProxyByName("guild_alert_man_panel");
    QiAlertGuildAlert["victor_image"]=public:GetWidgetProxyByName("victor_image");
    QiAlertGuildAlert["lose_image"]=public:GetWidgetProxyByName("lose_image");
    -- QiAlertGuildAlert[show_list]=
    QiAlertGuildAlert["attack_panel"]=public:GetWidgetProxyByName("attack_panel");
    QiAlertGuildAlert["attack_text_label"]=public:GetWidgetProxyByName("attack_text_label");
    
    QiAlertGuildAlert["blood_image"]=public:GetWidgetProxyByName("blood_image");
   
    QiAlertGuildAlert["victor_image"]:SetActive(false)
    QiAlertGuildAlert["lose_image"]:SetActive(false)
    QiAlertGuildAlert.attackpanel_tween=LuaCallCs_Tween.WidgetAlpha(QiAlertGuildAlert["attack_panel"], 0,2):SetLoopPingPong():SetEase(TweenType.easeInOutQuart)
    QiAlertGuildAlert.alert_image_tween={LuaCallCs_Tween.WidgetAlpha(QiAlertGuildAlert["blood_image"], 0,0.1)}
end

-- 红色屏幕闪一下
function ShowBloodAlert()
    for k,v in pairs( QiAlertGuildAlert.alert_image_tween) do
        v:Cancel()
    end
     QiAlertGuildAlert.alert_image_tween[#QiAlertGuildAlert.alert_image_tween+1]=LuaCallCs_Tween.WidgetAlpha(QiAlertGuildAlert["blood_image"], 1,0.1)
     QiAlertGuildAlert.alert_image_tween[#QiAlertGuildAlert.alert_image_tween+1]=LuaCallCs_Tween.WidgetAlpha(QiAlertGuildAlert["blood_image"], 0,1):SetDelay(0.11)
end

--- function summary description.
-- function detail description.
-- @tparam  type type description
-- @author 
function ShowGameUIFunc(ui_type,is_show)
    if ui_type==1 then
        QiAlertGuildAlert["victor_image"]:SetActive(is_show)
        QiAlertGuildAlert["lose_image"]:SetActive(false)
    elseif ui_type==2 then 
        QiAlertGuildAlert["lose_image"]:SetActive(is_show)
        QiAlertGuildAlert["victor_image"]:SetActive(true)
    end
end

--- 设置进攻信息
function SetAttackUnitNumInfoPanel(unit_num)
    if unit_num==0 then
        QiAlertGuildAlert["attack_panel"]:SetActive(false)
        AttackInfoView["row"]:GetText():SetColor(BluePrint.UGC.UI.Core.Color(1, 1, 1, 1));
        AttackInfoView["mainpane_bg_image"]:GetImage():SetColor(BluePrint.UGC.UI.Core.Color(1, 1, 1, 1));

        
    elseif unit_num>0 then 
        -- if  QiAlertGuildAlert.attackpanel_tween~=nil then 
        --     QiAlertGuildAlert.attackpanel_tween:Cancel()
        -- end
        -- QiAlertGuildAlert.attackpanel_tween=nil
        -- QiAlertGuildAlert.attackpanel_tween=LuaCallCs_Tween.WidgetAlpha(QiAlertGuildAlert["attack_panel"],0,2):SetLoopPingPong():SetEase(TweenType.easeInOutQuart)
        AttackInfoView["row"]:GetText():SetColor(BluePrint.UGC.UI.Core.Color(1, 0, 0, 1));
        AttackInfoView["mainpane_bg_image"]:GetImage():SetColor(BluePrint.UGC.UI.Core.Color(1, 0, 0, 1));
        QiAlertGuildAlert["attack_panel"]:SetActive(true)
        QiAlertGuildAlert["attack_text_label"]:GetText():SetContent("请速度<color=#ffff00>回城支援</color>！敌军数量[<color=#cc0000>"..tostring(unit_num)..tostring("</color>]"))
    end
end

function qi_alert_ui_init(keys)
    QiAlertGuildAlert:Init(keys)
end

--刷新UI
function QiAlertGuildAlert:RefreshUI()
    for k,v in pairs(QiAlertGuildAlert.msg_alert_tween) do 
        v:Cancel()
    end
    -- QiPrint("RefreshUI")
    if QiAlertGuildAlert["alert_mid_bottom_list"]==nil then 
        return 
    end
    for i = alertcontroller.msgnum, 1,-1 do
        local label=QiAlertGuildAlert["alert_mid_bottom_list"]:GetListElement(i-1):GetWidgetProxyByName("guild_alert_mid_label")
        if alertcontroller.msglist[i]["msg"]==nil then 
            -- label:GetText():SetContent("")
            QiAlertGuildAlert["alert_mid_bottom_list"]:GetListElement(i-1):SetActive(false)
        else
            local element=QiAlertGuildAlert["alert_mid_bottom_list"]:GetListElement(i-1)
            if alertcontroller.msglist[i]["first"]==true then
                alertcontroller.msglist[i]["first"]=false
                element:SetAlpha(1)
                QiAlertGuildAlert.msg_alert_tween[#QiAlertGuildAlert.msg_alert_tween+1]=LuaCallCs_Tween.WidgetAlpha(element, 0.8, 1):SetEase(TweenType.easeInOutBounce)
            else
                element:SetAlpha(0.8)
                if alertcontroller.msglist[i]["remain_time"]<=1 then 
                    QiAlertGuildAlert.msg_alert_tween[#QiAlertGuildAlert.msg_alert_tween+1]=LuaCallCs_Tween.WidgetAlpha(element, 0, 1):SetEase(TweenType.easeInOutBounce)
                end
            end
            QiAlertGuildAlert["alert_mid_bottom_list"]:GetListElement(i-1):SetActive(true)
            label:GetText():SetContent(alertcontroller.msglist[i]["msg"])
        end
    end
end
