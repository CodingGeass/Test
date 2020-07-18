
if QiXiulianView==nil then
    QiXiulianView={}
    QiXiulianView.tween={}
end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiXiulianView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiXiulianView["xiulian_main_panel"]=public:GetWidgetProxyByName("xiulian_main_panel");

    QiXiulianView["xiulian_botton_list"]=public:GetWidgetProxyByName("xiulian_botton_list");
    QiXiulianView["xiulian_levelup_btn"]=public:GetWidgetProxyByName("xiulian_levelup_btn");
    QiXiulianView["xiulian_bottom_level_label"]=public:GetWidgetProxyByName("xiulian_bottom_level_label");

    QiXiulianView["xiulian_main_panel"]:SetActive(false)
end

--- 妖塔
function xiulian_view_show(aid,number_show)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then
        if number_show==0 then
            QiXiulianView["xiulian_main_panel"]:SetActive(false)
        else
            QiXiulianView["xiulian_main_panel"]:SetActive(true)
            QiXiulianView:AskForPlayerData()
        end
    end
end

function SendXiulianProperty(aid,index,record_level,p_name,p_value,p_cost)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then
        local schinese_table={
            PhysicalDmg="物理攻击力",
            MagicalDmg="魔法攻击力",
            PhysicalDef="护甲值",
            MagicalDef="魔法抗性",
            MaxHp="最大生命值",
            HpRegenRate="每秒生命值回复",
            PhysicalPenetration="物理穿透值",
            MagicalPenetration="法术穿透值",
            MaxMp="最大魔法值",
            CriticalDmgBonus="暴击伤害值",
            CriticalRate="暴击率",
            CoolDownTimeReduce="冷却时间缩短",
            ExpAddPercent="经验值获得速度",
            GoldAddPercent="金币获得速度",
        }
        local list_element=QiXiulianView["xiulian_botton_list"]:GetListElement(index-1)
        local des_label=list_element:GetWidgetProxyByName("xiulian_element_des_label")
        local price_label=list_element:GetWidgetProxyByName("xiulian_element_price_label")
        des_label:GetText():SetContent("<color=#33ccff>".."金币:"..tostring(schinese_table[p_name]).."</color>".."+"..tostring(p_value))
        price_label:GetText():SetContent(tostring(p_cost))
        if  QiXiulianView.tween[index]~=nil then 
            QiXiulianView.tween[index]:Cancel()
        end
        if record_level>index then 
            QiXiulianView.tween[index]=LuaCallCs_Tween.WidgetAlpha(list_element, 1,0.1)
        else 
            local alpha=0.5-0.1*(index-record_level)
            if alpha<0 then alpha=0 end
            QiXiulianView.tween[index]=LuaCallCs_Tween.WidgetAlpha(list_element, alpha,0.1)
        end
    end
end

-- 接受gameplay的数据
function SendXiulianData(aid,level,thislevel,level_data)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then
        QiXiulianView["xiulian_bottom_level_label"]:GetText():SetContent("您当前的<color=#33ccff>修炼等级</color>为[<color=#ffff00>"..tostring(level).."</color>]")
    end
end

function xiulian_level_up_btn(keys)
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="xiulian_level_up_btn",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

--- 寻求玩家数据
function QiXiulianView:AskForPlayerData() 
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="xiulian_info",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

function xiulian_view_create(keys)
    QiXiulianView:UIInit(keys)
end

function xiulian_view_close(keys)
    QiXiulianView["xiulian_main_panel"]:SetActive(false)
end