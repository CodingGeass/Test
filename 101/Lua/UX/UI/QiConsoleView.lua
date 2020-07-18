if QiConsoleView==nil then 
    QiConsoleView={}
    QiConsoleView.ShowNumber=10--显示个数
end

--- 主UI初始化
function QiConsoleView:UIInit(keys)
    QiPrint("QiConsoleView:UIInit()",3)
    public = keys.SrcForm;
    QiConsoleView["ConsoleList"]=public:GetWidgetProxyByName("ConsoleList");
      -- 中间提示窗口
    QiConsoleView["MainAlertPanel"]=public:GetWidgetProxyByName("MainAlertPanel");
    QiConsoleView["main_alert_backgounrd_image"]=public:GetWidgetProxyByName("main_alert_backgounrd_image");
    QiConsoleView["main_alert_text_label"]=public:GetWidgetProxyByName("main_alert_text_label");
    QiConsoleView["main_alert_ass_label"]=public:GetWidgetProxyByName("main_alert_ass_label");
    
    QiConsoleView["ui_back_image"]=public:GetWidgetProxyByName("ui_back_image");
    QiConsoleView["ui_mouse_image"]=public:GetWidgetProxyByName("ui_mouse_image");
    QiConsoleView["quest_alert_panel"]=public:GetWidgetProxyByName("quest_alert_panel");
    QiConsoleView["alert_text_label"]=public:GetWidgetProxyByName("alert_text_label");
    QiConsoleView["alert_text_panel"]=public:GetWidgetProxyByName("alert_text_panel");
    QiConsoleView["alerttween"]={}
    SetMouseAlertPos(false,120,620,LuaCallCs_Battle.GetHostActorID())
end

-- 设置鼠标提醒
function SetMouseAlertPos(show,x,y,text,aid)
    QiPrint("SetMoustAlert x:["..tostring(x).."] y:["..tostring(y).."]")
    local ux_aid = LuaCallCs_Battle.GetHostActorID();
    if ux_aid==aid then 
        if show==true then 
            QiConsoleView["quest_alert_panel"]:SetActive(true)
            QiConsoleView["ui_mouse_image"]:SetActive(true)
            if text~=nil then 
                QiConsoleView["alert_text_panel"]:SetActive(true)
                QiConsoleView["alert_text_label"]:GetText():SetContent(text)
            else
                QiConsoleView["alert_text_panel"]:SetActive(true)
            end
            QiConsoleView["quest_alert_panel"]:SetScreenPosition(x,y)
            for k,v in pairs(QiConsoleView["alerttween"]) do 
                v:Cancel()
            end 
            QiConsoleView["alerttween"]={}
            image_pos=QiConsoleView["ui_mouse_image"]:GetScreenPosition()
            image_pos.x=image_pos.x-54
            image_pos.y=image_pos.y+50
            QiConsoleView["alerttween"][#QiConsoleView["alerttween"]+1]=LuaCallCs_Tween.MoveToScreenPosition(QiConsoleView["ui_mouse_image"],image_pos.x,image_pos.y,1):SetLoopClamp():SetEase(TweenType.easeInQuad)
            QiConsoleView["alerttween"][#QiConsoleView["alerttween"]+1]=LuaCallCs_Tween.WidgetAlpha(QiConsoleView["ui_back_image"], 0,1):SetDelay(0.6):SetEase(TweenType.easeInQuad):SetLoopClamp()
            QiConsoleView["alerttween"][#QiConsoleView["alerttween"]+1]=LuaCallCs_Tween.ScaleLocal(QiConsoleView["ui_back_image"],1.5, 1.5,1):SetEase(TweenType.easeInQuad):SetLoopClamp()
        else
            QiConsoleView["quest_alert_panel"]:SetActive(false)
            QiConsoleView["ui_mouse_image"]:SetActive(false)
        end
    end
end

function QiConsoleView:SetAlertShowInfo(isshow,main_text,ass_text)
    QiConsoleView["MainAlertPanel"]:SetActive(isshow)
    if isshow==true then 
        QiConsoleView["main_alert_text_label"]:GetText():SetContent(main_text)
        QiConsoleView["main_alert_ass_label"]:GetText():SetContent(ass_text)
    end

end

--刷新UI
function QiConsoleView:RefreshUI()
    -- QiPrint("RefreshUI")
    if QiConsoleView["ConsoleList"]==nil then 
        return 
    end
    for i = consolecontroller.msgnum, 1,-1 do
        local label=QiConsoleView["ConsoleList"]:GetListElement(i-1):GetWidgetProxyByName("ConsoleLabel")
        if consolecontroller.msglist[i]["msg"]==nil then 
            label:GetText():SetContent("")
        else 
            label:GetText():SetContent(consolecontroller.msglist[i]["msg"])
        end
    end
end

function ConsoleUICreate(keys)
    QiPrint("ConsoleUIPrint",3)
    QiConsoleView:UIInit(keys)
end

