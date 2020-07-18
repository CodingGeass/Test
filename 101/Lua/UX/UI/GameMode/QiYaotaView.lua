
if QiYaotaView==nil then
    QiYaotaView={}

end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiYaotaView:UIInit(keys)
    public = keys.SrcForm;
    -- 主panels
    QiYaotaView["yaota_main_panel"]=public:GetWidgetProxyByName("yaota_main_panel");
    --标题
    QiYaotaView["yaota_left_bottom_show_text"]=public:GetWidgetProxyByName("yaota_left_bottom_show_text");
    QiYaotaView["yaota_huanjin_shop_label"]=public:GetWidgetProxyByName("yaota_huanjin_shop_label");
    
    QiYaotaView["yaota_reward_list"]=public:GetWidgetProxyByName("yaota_reward_list");
    QiYaotaView["yaota_already_reward_list"]=public:GetWidgetProxyByName("yaota_already_reward_list");
    QiYaotaView["next_level_unit_info_list"]=public:GetWidgetProxyByName("next_level_unit_info_list");

    QiYaotaView["yaota_main_panel"]:SetActive(false)
    QiYaotaView["property_res"]={
        PhysicalDmg="<color=#1aff1a>每100秒</color><color=#33ccff>物理攻击</color>自动增加",
        MagicalDmg="<color=#1aff1a>每100秒</color><color=#33ccff>法术攻击</color>自动增加",
        PhysicalDef="<color=#1aff1a>每100秒</color><color=#33ccff>护甲值</color>自动增加",
        MagicalDef="<color=#1aff1a>每100秒</color><color=#33ccff>魔法抗性</color>自动增加",
        HpRegenRate="<color=#1aff1a>每100秒</color><color=#33ccff>生命值每秒恢复值</color>自动增加",
    }
end

--- 妖塔
function yaotaview_show(aid,number_show)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then 
        if number_show==0 then 
            QiYaotaView["yaota_main_panel"]:SetActive(false)
        else
            QiYaotaView["yaota_main_panel"]:SetActive(true)
            QiYaotaView:AskForPlayerData()
        end
    end
end

function QiYaotaView:AskForPlayerData()
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="kutong_info",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end


--- 发送妖塔data
function SendYaotaData(aid,level,reward_point,p1,p2)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if self_aid==aid then 
        local property_res=QiYaotaView["property_res"]
        QiYaotaView["yaota_left_bottom_show_text"]:GetText():SetContent("当前层数:"..tostring(level))
        -- QiYaotaView["yaota_huanjin_shop_label"]:GetText():SetContent("当前苦痛点数:"..tostring(reward_point))
        for k,v in pairs({p1,p2}) do 
            if v~="null" then
                QiYaotaView["yaota_reward_list"]:GetListElement(k-1):SetActive(true)
                local value_result=Split(v, "|")
                local p_name=value_result[1]
                local p_value=math.floor(tonumber(value_result[2])*100)
                local text_label=QiYaotaView["yaota_reward_list"]:GetListElement(k-1):GetWidgetProxyByName("yaota_reward_element_label")
                text_label:GetText():SetContent(property_res[p_name].." <color=#ffff00>"..tostring(p_value).."</color>")
            else 
                QiYaotaView["yaota_reward_list"]:GetListElement(k-1):SetActive(false)
            end
        end
    end
end

-- 发送妖塔已获得属性
function SendAreadyGetProperty(p1,p2,p3,p4,p5,aid)
    local recive_data={
        p1,p2,p3,p4,p5,
    }
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if self_aid==aid then 
        local show_text={
            "<color=#1aff1a>每100秒</color><color=#33ccff>物理攻击</color>自动增加",
            "<color=#1aff1a>每100秒</color><color=#33ccff>法术攻击</color>自动增加",
            "<color=#1aff1a>每100秒</color><color=#33ccff>护甲值</color>自动增加",
            "<color=#1aff1a>每100秒</color><color=#33ccff>魔法抗性</color>自动增加",
            "<color=#1aff1a>每100秒</color><color=#33ccff>生命值每秒恢复值</color>自动增加",
        }
        for k,v in pairs(recive_data) do 
            local element_label=QiYaotaView["yaota_already_reward_list"]:GetListElement(k-1):GetWidgetProxyByName("yaota_already_reward_listelement_label")
            element_label:GetText():SetContent(show_text[k].." "..tostring(recive_data[k]))
        end
    end
end

-- 受到下一层怪物数据
function SendNextUnitInfo(level,hp,attack,defence,fightpower,aid)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if self_aid==aid then
        local show_data={
            "<color=#74cce7>等级</color> <color=#cc0000>"..tostring(level).."</color>",
            "<color=#74cce7>战斗力</color> <color=#cc0000>"..tostring(fightpower).."</color>",
            "<color=#74cce7>生命值</color> "..tostring(hp),
            "<color=#74cce7>攻击力</color> "..tostring(attack),
            "<color=#74cce7>防御力</color> "..tostring(defence),
        }
        for k,v in pairs(show_data) do 
            local element_label=QiYaotaView["next_level_unit_info_list"]:GetListElement(k-1):GetWidgetProxyByName("next_level_unit_info_element_label")
            element_label:GetText():SetContent(show_data[k])
        end
    end
end

--- 下一层按钮
function YaotaNextLevelBtn(keys)
    QiPrint("YaotaNextLevelBtn")
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="kutong_start",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end


function view_create(keys)
    QiYaotaView:UIInit(keys)
end

function view_close(keys)
    QiYaotaView["yaota_main_panel"]:SetActive(false)
end