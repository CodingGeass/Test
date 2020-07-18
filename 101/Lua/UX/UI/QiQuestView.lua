
if QiQuestView==nil then
    QiQuestView={}

end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiQuestView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiQuestView.LastHightImage=nil
    QiQuestView["QuestMainPanel"]=public:GetWidgetProxyByName("QuestMainPanel");
    QiQuestView["maintween"]={}
    QiQuestView["QuestTitle"]=public:GetWidgetProxyByName("QuestTitle");
    --标题
    QiQuestView["QuestDescription"]=public:GetWidgetProxyByName("QuestDescription");
    QiQuestView["quest_rect_highlight_back_image"]=public:GetWidgetProxyByName("quest_rect_highlight_back_image");
    LuaCallCs_Tween.WidgetAlpha(QiQuestView["quest_rect_highlight_back_image"], 0,1):SetEase(TweenType.easeInQuad):SetLoopPingPong()
    questcontroller:newquest(LuaCallCs_Battle.GetHostActorID())
    -- QiQuestView["quest_alert_panel"]:SetScreenPosition(0, 500);
end

--- 设置任务高光
function SetQuestHightLgiht(show,aid)
    local ux_aid = LuaCallCs_Battle.GetHostActorID();
    if ux_aid==aid  then 
        if show==true then 
            QiQuestView["quest_rect_highlight_back_image"]:SetActive(true)
        else 
            QiQuestView["quest_rect_highlight_back_image"]:SetActive(false)
        end
    end
end

--- 设置任务数据
function QiQuestView:SetQuest(aid,title,des)
    local ux_aid = LuaCallCs_Battle.GetHostActorID();
    if ux_aid==aid then
        QiQuestView["QuestTitle"]:GetText():SetContent(title)
        QiQuestView["QuestDescription"]:GetText():SetContent(des)
    end
end

--- 入口
function qi_quest_create(keys)
    public=keys.SrcForm
    QiQuestView:UIInit(keys)
end

function qi_quest_destroy()
end
-- 点击任务
function quest_back_btn_click()
    QiPrint("quest_back_btn_click")
    for k,v in pairs(QiQuestView["maintween"]) do 
        v:Cancel()
    end
    QiQuestView["maintween"]={}
    QiQuestView["maintween"][#QiQuestView["maintween"]+1]=LuaCallCs_Tween.WidgetAlpha(QiQuestView["QuestMainPanel"], 0.4,0.01):SetEase(TweenType.easeInQuad)
    QiQuestView["maintween"][#QiQuestView["maintween"]+1]=LuaCallCs_Tween.WidgetAlpha(QiQuestView["QuestMainPanel"], 1,0.5):SetDelay(0.05):SetEase(TweenType.easeInQuad)

    QiQuestView["QuestMainPanel"]=public:GetWidgetProxyByName("QuestMainPanel");
    QiQuestView["maintween"]={}
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="quest_click",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end