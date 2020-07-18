if QiFateRoomView==nil then
    QiFateRoomView={}
end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiFateRoomView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiFateRoomView["fateroom_main_panel"]=public:GetWidgetProxyByName("fateroom_main_panel");
    QiFateRoomView["fateroom_main_panel"]:SetActive(false)
end

--- 妖塔
function fateroom_view_show(aid,number_show)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then 
        if number_show==0 then
            QiFateRoomView["fateroom_main_panel"]:SetActive(false)
        else
            QiFateRoomView["fateroom_main_panel"]:SetActive(true)
        end
    end
end

function fateroom_view_create(keys)
    QiFateRoomView:UIInit(keys)
end

function fateroom_view_close(keys)
    QiFateRoomView["fateroom_main_panel"]:SetActive(false)
end

function fate_askfate_btn_click(keys)
    
end
