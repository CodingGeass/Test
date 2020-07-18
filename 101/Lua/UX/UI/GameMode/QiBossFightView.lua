
if QiBossFightView==nil then
    QiBossFightView={}

end
local public

--- UI初始化，获得控件绑定至变量中，方便后面使用
function QiBossFightView:UIInit(keys)
    public = keys.SrcForm;
    QiBossFightView.canopen=true
    -- 主panels
    QiBossFightView["bossfight_main_panel"]=public:GetWidgetProxyByName("bossfight_main_panel");
    QiBossFightView["boss_fight_middle_left_text"]=public:GetWidgetProxyByName("boss_fight_middle_left_text");
    QiBossFightView["boss_fight_reward_list"]=public:GetWidgetProxyByName("boss_fight_reward_list");
    QiBossFightView["boss_fight_choose_head_image"]=public:GetWidgetProxyByName("boss_fight_choose_head_image");
    
    QiBossFightView["boss_unit_name_label"]=public:GetWidgetProxyByName("boss_unit_name_label");
    QiBossFightView["boss_fight_bottom_text"]=public:GetWidgetProxyByName("boss_fight_bottom_text");
    QiBossFightView["boss_fight_bottom_start_btn"]=public:GetWidgetProxyByName("boss_fight_bottom_start_btn");
    QiBossFightView["boss_fight_middle_center_reward_lebel"]=public:GetWidgetProxyByName("boss_fight_middle_center_reward_lebel");
    
    QiBossFightView["boss_drop_info_text_panel"]=public:GetWidgetProxyByName("boss_drop_info_text_panel");
    
    QiBossFightView["boss_drop_item_title_label"]=public:GetWidgetProxyByName("boss_drop_item_title_label");
    QiBossFightView["item_image"]=public:GetWidgetProxyByName("item_image");
    QiBossFightView["item_background_image"]=public:GetWidgetProxyByName("item_background_image");
    QiBossFightView["dropitem_main_property_list"]=public:GetWidgetProxyByName("dropitem_main_property_list");
    QiBossFightView["dropitem_ass_property_list"]=public:GetWidgetProxyByName("dropitem_ass_property_list");

    QiBossFightView["bossfight_main_panel"]:SetActive(false)
end

--- 妖塔
function bossfight_view_show(aid,number_show)
    local self_aid=LuaCallCs_Battle.GetHostActorID()
    if tonumber(aid)==self_aid then 
        if number_show==0 then 
            QiBossFightView["bossfight_main_panel"]:SetActive(false)
        else
            QiBossFightView["bossfight_main_panel"]:SetActive(true)
            bossfight_askdata()
        end
    end
end

function SendRefreshtime(aid,time,can_open)
    QiBossFightView.canopen=can_open
    if QiBossFightView.canopen==false then 
        QiBossFightView["boss_fight_bottom_start_btn"]:GetText():SetContent("<color=#33ccff>挑战次数耗尽</color>")
    else
        QiBossFightView["boss_fight_bottom_start_btn"]:GetText():SetContent("<color=#33ccff>进入幽界之井</color>") 
    end
    QiBossFightView["boss_fight_bottom_text"]:GetText():SetContent(
        "BOSS奖励和挑战次数<color=#33ccff>刷新</color>剩余时间 <color=#ffff00>["
        ..tostring(time).."]</color>")
end

function SendBossChallengeData(aid,level,reward_json,pname,pvalue)
    local SChineseRewardList={
       PhysicalDmg="总<color=#33ccff>物理伤害</color>增幅",
       MagicalDmg="总<color=#33ccff>法术伤害</color>增幅",
       PhysicalDef="总<color=#33ccff>护甲值</color>增幅",
       MagicalDef="总<color=#33ccff>法术抗性</color>增幅",
       HpRegenRate="总<color=#33ccff>血量每秒恢复</color>增幅",
       PhysicalLifeSteal="总<color=#33ccff>物理吸血</color>增幅",
       PhysicalPenetration="总<color=#33ccff>物理穿透</color>增幅",
       MagicalPenetration="总<color=#33ccff>魔法穿透</color>增幅",
       CriticalRate="总<color=#33ccff>暴击率</color>增幅",
       CriticalDmgBonus="总<color=#33ccff>暴击伤害</color>增幅",
       AttackSpeedBonus="总<color=#33ccff>攻击速度</color>增幅",
       DodgeRate="总<color=#33ccff>闪避率</color>增幅",
    }
    local cfg_table={
        [7168]=168,
        [7615]=615,
        [7503]=503,
        [7616]=616,
        [7685]=189,
        [7504]=504,
        [7182]=182,
        [7121]=121,
        [7171]=171,
        [7529]=529,
    }

    local reward_list_table={
        [1]="item_ring_bossfight_o1",
        [2]="tiem_hat_o2",
        [3]="item_clothes_o3",
        [4]="item_ring_o3",
        [5]="item_clothes_o5",
        [6]="item_ring_o6",
        [7]="item_shoe_o7",
        [8]="item_ring_o8",
        [9]="item_clothes_o9",
        [10]="item_ring_nireng_o10",
    }
    QiBossFightView["boss_fight_middle_center_reward_lebel"]:GetText():SetContent("奖励:"..SChineseRewardList[pname].." <color=#ffff00>"..tostring(pvalue) .."%</color>")
    if tonumber(aid)==LuaCallCs_Battle.GetHostActorID() then
        local unit_name="unit_fb_bossfight_"..tostring(level)
        local reward_list=json.decode(reward_json)
        local cfg_id=tonumber(QiData.unit_property[unit_name]["unit_config_id"])
        cfg_id=cfg_table[cfg_id] or cfg_id
        QiPrint("cfg_id"..tostring(cfg_id),3)
        local fight_power=QiData.unit_property[unit_name]["fightpower"]
        if fight_power>100000 then 
            fight_power=math.floor(fight_power/10000)+"W"
        else 
            fight_power=tostring(fight_power)
        end
        QiBossFightView["boss_unit_name_label"]:GetText():SetContent(QiData.unit_property[unit_name]["unit_name_schinese"].."   [<color=#ff0000>"..tostring(fight_power).."</color>]")
        local item_name=reward_list_table[level]
        -- 设置掉落物
        local item_data=QiData.item_data[item_name]
        if item_data~=nil then 
            QiBossFightView["boss_drop_info_text_panel"]:SetActive(true)
            local m_quality=item_data["m_quality"]
            local m_equipIconPath="Texture/Sprite/"..item_name..".sprite"
            local m_itemTitle=item_data.m_itemTitle
            if m_itemTitle then 
                QiBossFightView["boss_drop_item_title_label"]:GetText():SetContent(m_itemTitle)
                bagcontroller:SetImageWithQuality(QiBossFightView["boss_drop_item_title_label"]:GetText(),m_quality,false)

                QiBossFightView["item_image"]:GetImage():SetRes(m_equipIconPath)
                local main_data,ass_data=bagcontroller:GetMainAndAssProperty(item_name)
                for i=1,2 do 
                    local list_element=QiBossFightView["dropitem_main_property_list"]:GetListElement(i-1)
                    if main_data[i]==nil then 
                        -- 没有要显示的
                        list_element:SetActive(false)
                    else 
                        list_element:SetActive(true)
                        local text_label=list_element:GetWidgetProxyByName("dropitem_main_property_label")
                        local property_name=main_data[i][1]
                        local property_value=main_data[i][2]
                        local property_name_schinese=bagcontroller["localized"][property_name] or property_name
                        local label_text=property_name_schinese.." + "..tostring(property_value)
                        
                    end
                end
                -- 设置副属性
                for i=1,3 do 
                    local list_element=QiBossFightView["dropitem_ass_property_list"]:GetListElement(i-1)
                    if ass_data[i]==nil then 
                        -- 没有要显示的
                        list_element:SetActive(false)
                    else 
                        list_element:SetActive(true)
                        local text_label=list_element:GetWidgetProxyByName("dropitem_ass_property_label")
                        local property_name=ass_data[i][1]
                        local property_value=ass_data[i][2]
                        local property_name_schinese=bagcontroller["localized"][property_name] or property_name
                        local label_text=property_name_schinese.." + "..tostring(property_value)
                        text_label:GetText():SetContent(label_text)
                    end
                end
            end
        else 
            QiBossFightView["boss_drop_info_text_panel"]:SetActive(false)
        end
        local icon=LuaCallCs_Resource.GetHeroIcon(2, cfg_id)
        QiPrint("icon"..tostring(icon),3)
        QiBossFightView["boss_fight_middle_left_text"]:GetText():SetContent("难度:"..tostring(level))
        QiBossFightView["boss_fight_choose_head_image"]:GetImage():SetRes(icon)
        local set_num=0
        for k,v in pairs(reward_list) do 
            local label=QiBossFightView["boss_fight_reward_list"]:GetListElement(set_num):GetWidgetProxyByName("boss_fight_reward_list_label")
            set_num=set_num+1
            label:GetText():SetContent(SChineseRewardList[k].." <color=#ffff00>"..tostring(v) .."%</color>")
        end
    end
end
-- -- 发送
-- function SendPlayerReward(aid)
-- end

function bossfight_view_create(keys)
    QiBossFightView:UIInit(keys)
end

function bossfight_view_close(keys)
    QiBossFightView["bossfight_main_panel"]:SetActive(false)
end

function bossfight_next_levelbtn()
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="boss_changelevel",[2]=aid,[3]=1}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

function bossfight_pre_levelbtn()
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="boss_changelevel",[2]=aid,[3]=0}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

function bossfight_start()
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="boss_start",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

function bossfight_askdata()
    local aid=LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="boss_info",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end