
if QiShadiView==nil then
    QiShadiView={}
end
local public
--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiShadiView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiShadiView["shadi_main_panel"]=public:GetWidgetProxyByName("shadi_main_panel");
    QiShadiView["shadi_main_panel"]:SetActive(false)
end

--- 妖塔
function shadi_view_show(aid,number_show)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then 
        if number_show==0 then 
            QiShadiView["shadi_main_panel"]:SetActive(false)
        else
            QiShadiView["shadi_main_panel"]:SetActive(true)
        end
    end
end

function shadi_view_create(keys)
    QiShadiView:UIInit(keys)
end

function shadi_view_close(keys)
    QiShadiView["shadi_main_panel"]:SetActive(false)
end