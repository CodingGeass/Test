
if QiWishView==nil then
    QiWishView={}

end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiWishView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiWishView["wish_main_panel"]=public:GetWidgetProxyByName("wish_main_panel");
    QiWishView["wish_left_iamge"]=public:GetWidgetProxyByName("wish_left_iamge");
    QiWishView["wish_title_panel_head_image"]=public:GetWidgetProxyByName("wish_title_panel_head_image");

    QiWishView["wish_select_alert_label"]=public:GetWidgetProxyByName("wish_select_alert_label");

    QiWishView["wish_before_show_des"]=public:GetWidgetProxyByName("wish_before_show_des");
    QiWishView["wish_before_show_des2"]=public:GetWidgetProxyByName("wish_before_show_des2");

    QiWishView["wish_right_bottom_btns_panel"]=public:GetWidgetProxyByName("wish_right_bottom_btns_panel");
    QiWishView["wish_choice_list"]=public:GetWidgetProxyByName("wish_choice_list");
    QiWishView["wish_main_panel"]:SetActive(false)
    
    -- 设置瑶的头像
    local icon1=LuaCallCs_Resource.GetHeroIcon(0, 505)
    local icon2=LuaCallCs_Resource.GetHeroIcon(2, 505)
    QiWishView["wish_left_iamge"]:GetImage():SetRes(icon2)
    QiWishView["wish_title_panel_head_image"]:GetImage():SetRes(icon1)
end

--- 妖塔
function wish_view_show(aid,number_show)
    QiPrint("wish_view_show "..tostring(aid),3)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then 
        if number_show==0 then 
            QiWishView["wish_main_panel"]:SetActive(false)
        else
            QiWishView["wish_main_panel"]:SetActive(true)
            QiWishView:AskWishData()
        end
    end
end

function wish_view_create(keys)
    QiWishView:UIInit(keys)
end

function wish_view_close(keys)
    QiWishView["wish_main_panel"]:SetActive(false)
end

function wish_btn_click(keys)
    local SrcWidget = keys.SrcWidget;
    local index = SrcWidget:GetIndexInBelongedList()
    local aid = LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="wish_btn_click",[2]=aid,[3]=index}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

-- 请求愿望数据
function QiWishView:AskWishData()
    local aid = LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="ask_wish_data",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end 

--
function SendWishData(aid,wish_state,d1,d2,d3,d4)
    if LuaCallCs_Battle.GetHostActorID()==aid then 
        if wish_state==0 then
            QiWishView["wish_select_alert_label"]:SetActive(true)
            QiWishView["wish_choice_list"]:SetActive(false)
            QiWishView["wish_select_alert_label"]:GetText():SetContent("距离下一次许愿机会到来还有"..tostring(d1).."秒") 
            QiWishView["wish_before_show_des"]:GetText():SetContent(tostring(d2))
            QiWishView["wish_before_show_des2"]:GetText():SetContent(tostring(d3))
        else
            QiWishView["wish_choice_list"]:SetActive(true)
            QiWishView["wish_before_show_des"]:GetText():SetContent("我将实现您的一个心愿")
            QiWishView["wish_before_show_des2"]:GetText():SetContent("")
            QiWishView["wish_select_alert_label"]:SetActive(false)
            local btn_text={
                d1,d2,d3,d4
            }
            for i=1,4 do
                local list_element=QiWishView["wish_choice_list"]:GetListElement(i-1)
                local wish_btn=list_element:GetWidgetProxyByName("wish_choice_btn")
                wish_btn:GetText():SetContent(btn_text[i])
            end
        end
    end
end