if QiBagViewProperty==nil then 
    QiBagViewProperty={}
end
function QiBagView:PlayerPropertyInit(keys)
    public = keys.SrcForm;
    QiBagView["player_property_list"]=public:GetWidgetProxyByName("player_property_list");
    -- QiBagView:RefreshPlayerEquip()
    QiBagView["func_main_property_list"]=public:GetWidgetProxyByName("func_main_property_list");
    QiBagView["func_ass_property_list"]=public:GetWidgetProxyByName("func_ass_property_list");
    QiBagView:PropertyInit()
end

ActorAttribute_None =     0
-- [EnumDisplayName("物理攻击")]
ActorAttribute_PhysicalDmg =   1                     --物理攻击
-- [EnumDisplayName("法术攻击")]
ActorAttribute_MagicalDmg = 2                        --法术攻击
-- [EnumDisplayName("物理防御")]
ActorAttribute_PhysicalDef =   3                     --物理防御
-- [EnumDisplayName("法术防御")]
ActorAttribute_MagicalDef = 4                        --法术防御
-- [EnumDisplayName("最大生命值")]
ActorAttribute_MaxHp = 5                             --最大生命值
-- [EnumDisplayName("暴击率")]
ActorAttribute_CriticalRate = 6                      --暴击率
-- [EnumDisplayName("物理护甲穿透伤害")]
ActorAttribute_PhysicalPenetration = 7               --物理护甲穿透伤害
-- [EnumDisplayName("法术护甲穿透伤害")]
ActorAttribute_MagicalPenetration = 8               --法术护甲穿透伤害
-- [EnumDisplayName("物理吸血")]
ActorAttribute_PhysicalLifeSteal = 9                 --物理吸血
-- [EnumDisplayName("法术吸血")]
ActorAttribute_MagicalLifeSteal = 10                --法术吸血
-- [EnumDisplayName("抗暴击率")]
ActorAttribute_AntiCriticalRate = 11                 --抗暴击率
-- [EnumDisplayName("暴击伤害加成(万分比)")]
ActorAttribute_CriticalDmgBonus = 12                 --暴击伤害加成 (万分比)
-- [EnumDisplayName("真实伤害")]
ActorAttribute_TrueDmg = 13                          --真实伤害
-- [EnumDisplayName("真实减伤")]
ActorAttribute_TrueReduceDmg = 14                    --真实减伤
-- [EnumDisplayName("移动速度")]
ActorAttribute_MoveSpeed = 15                        --移动速度
-- [EnumDisplayName("生命恢复")]
ActorAttribute_HpRegenRate = 16                      --生命恢复
-- [EnumDisplayName("韧性(控制时间减少)")]
ActorAttribute_Tenacity = 17                         --韧性(控制时间减少)
-- [EnumDisplayName("攻速加成")]
ActorAttribute_AttackSpeedBonus = 18                 --攻速加成
-- [EnumDisplayName("冷却缩减")]
ActorAttribute_CoolDownTimeReduce = 19              --冷却缩减
-- [EnumDisplayName("内部保留")]
ActorAttribute_SightRange = 20                      --视野范围
-- [EnumDisplayName("命中率")]
ActorAttribute_HitRate = 21                          --命中率
-- [EnumDisplayName("闪避率")]
ActorAttribute_DodgeRate = 22                        --闪避率
-- [EnumDisplayName("伤害免疫率")]
ActorAttribute_DmgImmuneRate = 29                   --伤害免疫率
-- [EnumDisplayName("最终伤害加成")]
ActorAttribute_finalDmgBonus = 30                   --最终伤害加成
-- [EnumDisplayName("最大能量")]
ActorAttribute_MaxMp = 31                            --最大能量
-- [EnumDisplayName("能量回复")]
ActorAttribute_MpRegenRate = 32                      --能量回复
-- [EnumDisplayName("护甲穿透率")]
ActorAttribute_PhysicalPenetrationRate = 33          --护甲穿透率
-- [EnumDisplayName("法术穿透率")]
ActorAttribute_MagicalPenetrationRate = 34           --法术穿透率
-- [EnumDisplayName("基础伤害")]
ActorAttribute_BaseDamage = 36                       --基础伤害
-- [EnumDisplayName("ConfigID")]
ActorAttribute_ConfigID = 1000                      --ConfigID
-- [EnumDisplayName("角色类型(内置)")]
ActorAttribute_ActorType = 1002                      --角色类型
-- [EnumDisplayName("角色阵营")]
ActorAttribute_ActorCamp = 1003                      --角色阵营
-- [EnumDisplayName("ActorID")]
ActorAttribute_ActorID = 1004                        --ActorID
-- [EnumDisplayName("当前生命值")]
ActorAttribute_HP = 1005                            --当前生命值 
-- [EnumDisplayName("当前法术能量")]
ActorAttribute_MP = 1006                            --当前法术能量
-- [EnumDisplayName("玩家ID")]
ActorAttribute_PlayerID = 1007                      -- 玩家ID
-- [EnumDisplayName("视野半径")]
ActorAttribute_SightRadius = 1008                      --视野半径
-- [EnumDisplayName("英雄等级")]
ActorAttribute_Level = 1009           

PROPERTY_LIST={}
PROPERTY_LIST_MAIN={}
PROPERTY_LIST_ASS={}

PROPERTY_LIST[#PROPERTY_LIST+1]="MaxHp"
PROPERTY_LIST[#PROPERTY_LIST+1]="MaxMp"
PROPERTY_LIST[#PROPERTY_LIST+1]="HpRegenRate"
PROPERTY_LIST[#PROPERTY_LIST+1]="MpRegenRate"
PROPERTY_LIST[#PROPERTY_LIST+1]="PhysicalDmg"
PROPERTY_LIST[#PROPERTY_LIST+1]="MagicalDmg"
PROPERTY_LIST[#PROPERTY_LIST+1]="BaseDamage"
PROPERTY_LIST[#PROPERTY_LIST+1]="finalDmgBonus"
PROPERTY_LIST[#PROPERTY_LIST+1]="PhysicalDef"
PROPERTY_LIST[#PROPERTY_LIST+1]="MagicalDef"
PROPERTY_LIST[#PROPERTY_LIST+1]="CriticalRate"
PROPERTY_LIST[#PROPERTY_LIST+1]="CriticalDmgBonus"
PROPERTY_LIST[#PROPERTY_LIST+1]="PhysicalLifeSteal"
PROPERTY_LIST[#PROPERTY_LIST+1]="MagicalLifeSteal"
PROPERTY_LIST[#PROPERTY_LIST+1]="PhysicalPenetration"
PROPERTY_LIST[#PROPERTY_LIST+1]="MagicalPenetration"
PROPERTY_LIST[#PROPERTY_LIST+1]="AttackSpeedBonus"
PROPERTY_LIST[#PROPERTY_LIST+1]="MoveSpeed"
PROPERTY_LIST[#PROPERTY_LIST+1]="DodgeRate"
PROPERTY_LIST[#PROPERTY_LIST+1]="CoolDownTimeReduce"
PROPERTY_LIST[#PROPERTY_LIST+1]="PhysicalPenetrationRate"
PROPERTY_LIST[#PROPERTY_LIST+1]="MagicalPenetrationRate"

PROPERTY_LIST_MAIN[#PROPERTY_LIST_MAIN+1]="MaxHp"
PROPERTY_LIST_MAIN[#PROPERTY_LIST_MAIN+1]="MaxHp"
PROPERTY_LIST_MAIN[#PROPERTY_LIST_MAIN+1]="PhysicalDmg"
PROPERTY_LIST_MAIN[#PROPERTY_LIST_MAIN+1]="MagicalDmg"
PROPERTY_LIST_MAIN[#PROPERTY_LIST_MAIN+1]="PhysicalDef"
PROPERTY_LIST_MAIN[#PROPERTY_LIST_MAIN+1]="MagicalDef"
PROPERTY_LIST_MAIN[#PROPERTY_LIST_MAIN+1]="BaseDamage"

PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="HpRegenRate"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MpRegenRate"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="finalDmgBonus"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalRate"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalDmgBonus"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalLifeSteal"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalLifeSteal"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalPenetration"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalPenetration"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="AttackSpeedBonus"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MoveSpeed"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="DodgeRate"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CoolDownTimeReduce"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalPenetrationRate"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalPenetrationRate"
 -- 百分比放大属性类 顶部有映射表
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalDmgPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalDmgPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalDefPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalDefPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="HpRegenRatePercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalLifeStealPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalPenetrationPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalPenetrationPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalRatePercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalDmgBonusPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="AttackSpeedBonusPercentAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="DodgeRatePercentAdd"
-- 击杀击杀属性类
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalDmgKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalDmgKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalDefKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalDefKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="HpRegenRateKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalLifeStealKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalPenetrationKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalPenetrationKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalRateKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalDmgBonusKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="AttackSpeedBonusKillAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="DodgeRateKillAdd"

-- 每秒增加属性类
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalDmgSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalDmgSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalDefSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalDefSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="HpRegenRateSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalLifeStealSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="PhysicalPenetrationSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="MagicalPenetrationSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalRateSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="CriticalDmgBonusSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="AttackSpeedBonusSecAdd"
PROPERTY_LIST_ASS[#PROPERTY_LIST_ASS+1]="DodgeRateSecAdd"


PROPERTY_INDEX_TABLE={
    [5]="MaxHp",
    [31]="MaxMp",
    [16]="HpRegenRate",
    [32]="MpRegenRate",
    [1]="PhysicalDmg",
    [2]="MagicalDmg",
    [36]="BaseDamage",
    [30]="finalDmgBonus",
    [3]="PhysicalDef",
    [4]="MagicalDef",
    [6]="CriticalRate",
    [12]="CriticalDmgBonus",
    [9]="PhysicalLifeSteal",
    [10]="MagicalLifeSteal",
    [7]="PhysicalPenetration",
    [8]="MagicalPenetration",
    [18]="AttackSpeedBonus",
    [15]="MoveSpeed",
    [22]="DodgeRate",
    [19]="CoolDownTimeReduce",
    [33]="PhysicalPenetrationRate",
    [34]="MagicalPenetrationRate",
}

function SendPropertyValue(aid,proid,value)
    -- 根据返回的属性ID计算显示文字
    -- local pro_local_name=tostring(proid)..":"
    -- if PROPERTY_INDEX_TABLE[tonumber(proid)] and PROPERTY_RES[PROPERTY_INDEX_TABLE[tonumber(proid)]] then
    --     pro_local_name=PROPERTY_RES[PROPERTY_INDEX_TABLE[tonumber(proid)]]..tostring(":")
    -- end
    local key_name=PROPERTY_INDEX_TABLE[tonumber(proid)]
    for k,v in pairs(PROPERTY_LIST_MAIN) do 
        if v==key_name then 
            local list_element=QiBagView["func_main_property_list"]:GetListElement(k-1)
            local key_label=list_element:GetWidgetProxyByName("porperty_main_key_value")
            key_label:GetText():SetContent(tostring(value))
        end
    end
    for k,v in pairs(PROPERTY_LIST_ASS) do 
        if v==key_name then 
            local list_element=QiBagView["func_ass_property_list"]:GetListElement(k-1)
            local key_label=list_element:GetWidgetProxyByName("porperty_ass_key_value")
            key_label:GetText():SetContent(tostring(value))
        end
    end
    -- pro_local_name=pro_local_name..tostring(value)
    -- 根据返回的属性ID计算设置文字的位置
    -- for k,v in pairs(PROPERTY_LIST) do 
    --     local propertyid=_G["ActorAttribute_"..v]
    --     if tonumber(propertyid)==tonumber(proid) then 
    --         QiBagView["player_property_list"]:GetListElement(k-1):GetWidgetProxyByName("player_proerpty_element_label"):GetText():SetContent(pro_local_name)
    --     end
    -- end
end

--属性初始化
function QiBagView:PropertyInit()
    for i=1,10 do 
        local list_element=QiBagView["func_main_property_list"]:GetListElement(i-1)
        if list_element~=nil then 
            if PROPERTY_LIST_MAIN[i]~=nil then 
                local s_chinese=bagcontroller["localized"][PROPERTY_LIST_MAIN[i]] or PROPERTY_LIST_MAIN[i]
                local key_label=list_element:GetWidgetProxyByName("porperty_main_key_label")
                key_label:GetText():SetContent(s_chinese)
            else
                list_element:SetActive(false)
            end
        end
    end
    for i=1,20 do 
        local list_element=QiBagView["func_ass_property_list"]:GetListElement(i-1)
        if list_element~=nil then 
            if PROPERTY_LIST_ASS[i]~=nil then 
                local s_chinese=bagcontroller["localized"][PROPERTY_LIST_ASS[i]] or PROPERTY_LIST_ASS[i]
                local key_label=list_element:GetWidgetProxyByName("porperty_ass_key_label")
                key_label:GetText():SetContent(s_chinese)
            else
                list_element:SetActive(false)
            end
        end
    end
end

-- 刷新属性值
function QiBagView:RefreshProperty()
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if QiBagView.funcindex==2 then 
        for k,v in pairs(PROPERTY_LIST) do 
            local propertyid=_G["ActorAttribute_"..v]
            if propertyid then 
                local msg=massage_zip({
                    "askpro",
                    actorID,
                    propertyid,
                })
                LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(msg);
            end
        end
    end
end

function BagRefreshProperty(aid)
    if aid == LuaCallCs_Battle.GetHostActorID() and QiBagView.funcindex==3 then
        QiBagView:RefreshProperty()
    end
end
