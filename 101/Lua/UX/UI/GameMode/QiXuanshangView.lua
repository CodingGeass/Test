
if QiXuanshangView==nil then
    QiXuanshangView={}

end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiXuanshangView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiXuanshangView["xuanshang_main_panel"]=public:GetWidgetProxyByName("xuanshang_main_panel");
  
    QiXuanshangView["xuanshang_main_panel"]:SetActive(false)
end

--- 妖塔
function xuanshang_view_show(aid,number_show)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then 
        if number_show==0 then 
            QiXuanshangView["xuanshang_main_panel"]:SetActive(false)
        else
            QiXuanshangView["xuanshang_main_panel"]:SetActive(true)
        end
    end
end

function xuanshang_view_create(keys)
    QiXuanshangView:UIInit(keys)
end

function xuanshang_view_close(keys)
    QiXuanshangView["xuanshang_main_panel"]:SetActive(false)
end