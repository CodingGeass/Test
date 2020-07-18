
if QiSuanmingView==nil then
    QiSuanmingView={}
end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiSuanmingView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiSuanmingView["suanming_main_panel"]=public:GetWidgetProxyByName("suanming_main_panel");

    QiSuanmingView["fate_icon_border_image"]=public:GetWidgetProxyByName("fate_icon_border_image");
    QiSuanmingView["fate_icon_image"]=public:GetWidgetProxyByName("fate_icon_image");

    QiSuanmingView["fate_defualt_panel"]=public:GetWidgetProxyByName("fate_defualt_panel");
    QiSuanmingView["fate_show_panel"]=public:GetWidgetProxyByName("fate_show_panel");
    QiSuanmingView["fate_text_title"]=public:GetWidgetProxyByName("fate_text_title");
    QiSuanmingView["fate_text_desc"]=public:GetWidgetProxyByName("fate_text_desc");

    QiSuanmingView["suanming_main_panel"]:SetActive(false)
end

--- 妖塔
function suanming_view_show(aid,number_show)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then 
        if number_show==0 then 
            QiSuanmingView["suanming_main_panel"]:SetActive(false)
        else
            QiSuanmingView["suanming_main_panel"]:SetActive(true)
            QiSuanmingView:AskFateData()
        end
    end
end

-- 揭示命格
function fate_askfate_btn_click(keys)
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="fate_askbtn",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end


function QiSuanmingView:AskFateData()
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="fate_info",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end
function suanming_view_create(keys)
    QiSuanmingView:UIInit(keys)
end

function suanming_view_close(keys)
    QiSuanmingView["suanming_main_panel"]:SetActive(false)
end

function SendSuanmingData(title,des,quality,aid)
    QiPrint("SendSuanmingData  "..tostring(title)..tostring(des)..tostring(quality)..tostring(aid))
    if tonumber(aid)==LuaCallCs_Battle.GetHostActorID() then 
        if title==nil or des==nil then 
            QiSuanmingView["fate_show_panel"]:SetActive(false)
            QiSuanmingView["fate_defualt_panel"]:SetActive(true)
        else
            local quality_image={
                green="fate_quality_green",
                blue="fate_quality_blue",
                purple="fate_quality_purple",
                pink="fate_quality_pink",
                orange="fate_quality_orange",
            }
            if quality_image[quality]~=nil then 
                QiSuanmingView["fate_icon_image"]:GetImage():SetRes("Texture/Sprite/"..quality_image[quality]..".sprite")
                bagcontroller:SetImageWithQuality(QiSuanmingView["fate_text_title"]:GetText(),quality,false)
                bagcontroller:SetImageWithQuality(QiSuanmingView["fate_icon_border_image"]:GetImage(),quality,true)
            end
            QiSuanmingView["fate_show_panel"]:SetActive(true)
            QiSuanmingView["fate_defualt_panel"]:SetActive(false)
            QiSuanmingView["fate_text_title"]:GetText():SetContent(title)
            QiSuanmingView["fate_text_desc"]:GetText():SetContent(des)
        end
    end
end