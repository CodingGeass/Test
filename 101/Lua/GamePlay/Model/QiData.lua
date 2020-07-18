if QiData==nil then 
    QiData={}
    QiData.SkinData={
        [1163]=0,-- 伊达剑意
        [1164]=0,-- 曌寒痕
        [1165]=0,-- 殁兵韬
        [1166]=0,-- 孙行者
    }

    QiData.PropertySchinese={
        PhysicalDmg="物理伤害",
        MagicalDmg="法术伤害",
        PhysicalDef="护甲值",
        MagicalDef="魔抗值",
        CriticalRate="暴击率",
        PhysicalPenetration="物理穿透",
        MagicalPenetration="魔法穿透",
        PhysicalLifeSteal="物理吸血",
        CriticalDmgBonus="暴击伤害",
        TrueDmg	="真实伤害",
        TrueReduceDmg	="真实伤害抗性",
        MoveSpeed="移动速度",
        HpRegenRate	="血量恢复值",
        Tenacity	="坚韧值",
        AttackSpeedBonus	="攻击速度",
        CoolDownTimeReduce="冷却时间缩短",
        HitRate="命中率",
        DodgeRate="躲避率",
        DmgImmuneRate	="伤害减免",
        finalDmgBonus	="伤害增加",
        MaxMp="最大魔法值",
        MaxHp="最大生命值",
        MpRegenRate="魔法恢复速率",
        BaseDamage="基础伤害",
        ExpAddPercent	="经验值增加",
        GoldAddPercent="金币增加",
        PhysicalPenetrationRate="护甲穿透率",
        MagicalPenetrationRate="法术穿透率",
        MagicalLifeSteal="法术吸血",
        -- 百分比放大属性类 顶部有映射表
        MaxHpPercentAdd="生命值<color=#ffff33>百分比增加</color>",
        MaxMpPercentAdd="法力值<color=#ffff33>百分比增加</color>",
        PhysicalDmgPercentAdd="全局物理伤害<color=#ffff33>百分比增加</color>",
        MagicalDmgPercentAdd="全局法术伤害<color=#ffff33>百分比增加</color>",
        PhysicalDefPercentAdd="全局护甲值<color=#ffff33>百分比增加</color>",
        MagicalDefPercentAdd="全局法术抗性<color=#ffff33>百分比增加</color>",
        HpRegenRatePercentAdd="全局每秒回血<color=#ffff33>百分比增加</color>",
        PhysicalLifeStealPercentAdd="全局物理吸血<color=#ffff33>百分比增加</color>",
        PhysicalPenetrationPercentAdd="全局物理穿透<color=#ffff33>百分比增加</color>",
        MagicalPenetrationPercentAdd="全局魔法穿透<color=#ffff33>百分比增加</color>",
        CriticalRatePercentAdd="全局暴击伤害率<color=#ffff33>百分比增加</color>",
        CriticalDmgBonusPercentAdd="全局暴击伤害<color=#ffff33>百分比增加</color>",
        AttackSpeedBonusPercentAdd="全局攻击速度<color=#ffff33>百分比增加</color>",
        DodgeRatePercentAdd="全局躲避率<color=#ffff33>百分比增加</color>",

        -- 击杀击杀属性类
        MaxHpKillAdd="<color=#0099ff>击败增加</color>生命值",
        MaxMpKillAdd="<color=#0099ff>击败增加</color>法力值",
        PhysicalDmgKillAdd="<color=#0099ff>击败增加</color>物理伤害",
        MagicalDmgKillAdd="<color=#0099ff>击败增加</color>法术伤害",
        PhysicalDefKillAdd="<color=#0099ff>击败增加</color>护甲值",
        MagicalDefKillAdd="<color=#0099ff>击败增加</color>法术抗性",
        HpRegenRateKillAdd="<color=#0099ff>击败增加</color>血量恢复",
        PhysicalLifeStealKillAdd="<color=#0099ff>击败增加</color>物理吸血",
        PhysicalPenetrationKillAdd="<color=#0099ff>击败增加</color>物理穿透",
        MagicalPenetrationKillAdd="<color=#0099ff>击败增加</color>法术穿透",
        CriticalRateKillAdd="<color=#0099ff>击败增加</color>暴击率",
        CriticalDmgBonusKillAdd="<color=#0099ff>击败增加</color>暴击伤害",
        AttackSpeedBonusKillAdd="<color=#0099ff>击败增加</color>攻击速度",
        DodgeRateKillAdd="<color=#0099ff>击败增加</color>闪避率",

        -- 每秒增加属性类
        MaxHpSecAdd="<color=#00ff55>每秒</color>生命值增加",
        MaxMpSecAdd="<color=#00ff55>每秒</color>法力值增加",
        PhysicalDmgSecAdd="<color=#00ff55>每秒</color>物理伤害增加",
        MagicalDmgSecAdd="<color=#00ff55>每秒</color>法术伤害增加",
        PhysicalDefSecAdd="<color=#00ff55>每秒</color>护甲值增加",
        MagicalDefSecAdd="<color=#00ff55>每秒</color>法术抗性增加",
        HpRegenRateSecAdd="<color=#00ff55>每秒</color>血量恢复增加",
        PhysicalLifeStealSecAdd="<color=#00ff55>每秒</color>物理吸血增加",
        PhysicalPenetrationSecAdd="<color=#00ff55>每秒</color>物理穿透增加",
        MagicalPenetrationSecAdd="<color=#00ff55>每秒</color>法术穿透增加",
        CriticalRateSecAdd="<color=#00ff55>每秒</color>暴击率增加",
        CriticalDmgBonusSecAdd="<color=#00ff55>每秒</color>暴击伤害增加",
        AttackSpeedBonusSecAdd="<color=#00ff55>每秒</color>攻击速度增加",
        DodgeRateSecAdd="<color=#00ff55>每秒</color>躲避率增加",
    }
end

--- 开发者自定义数据初始化
function QiData:Init()
    QiPrint("QiData:Init()")
    local j_parse=cjson or json
    if LUA_SYSTEM_TYPE==2 then 
        require "Lua/GamePlay/outjson/item_data.lua"
        require "Lua/GamePlay/outjson/unit_property.lua"
        require "Lua/GamePlay/outjson/unit_attack_property.lua"
        require "Lua/GamePlay/outjson/fb_1_3.lua"
        require "Lua/GamePlay/outjson/fb_4_6.lua"
        require "Lua/GamePlay/outjson/fb_7_9.lua"
        require "Lua/GamePlay/outjson/fb_10_12.lua"
        require "Lua/GamePlay/outjson/fb_boss_chanllenge.lua"
        require "Lua/GamePlay/outjson/fb_yaota_100.lua"
        require "Lua/GamePlay/outjson/quest_data.lua"
        require "Lua/GamePlay/outjson/exp_data.lua"
        require "Lua/GamePlay/outjson/smart_luadata.lua"
        require "Lua/GamePlay/outjson/shop_data.lua"

        --gameplay
    else
        require "Lua/UX/outjson/item_data.lua"
        require "Lua/UX/outjson/unit_property.lua"
        require "Lua/UX/outjson/unit_attack_property.lua"
        require "Lua/UX/outjson/fb_1_3.lua"
        require "Lua/UX/outjson/fb_4_6.lua"
        require "Lua/UX/outjson/fb_7_9.lua"
        require "Lua/UX/outjson/fb_10_12.lua"
        require "Lua/UX/outjson/fb_boss_chanllenge.lua"
        require "Lua/UX/outjson/fb_yaota_100.lua"
        require "Lua/UX/outjson/quest_data.lua"
        require "Lua/UX/outjson/exp_data.lua"
        require "Lua/UX/outjson/smart_luadata.lua"
        require "Lua/UX/outjson/shop_data.lua"
        --UX
    end

    QiData.unit_cfg_data={}
    QiData.unit_property=j_parse.decode(JSON_DATA_UNIT_PROPERTY)
    QiData.quest_data=j_parse.decode(JSON_DATA_QUEST_DATA)
    QiData.item_data=j_parse.decode(JSON_DATA_ITEM_DATA)
    QiData.unit_attack_property=j_parse.decode(JSON_DATA_UNIT_ATTACK_PROPERTY)
    QiData.JSON_DATA_FB_1_3=j_parse.decode(JSON_DATA_FB_1_3)
    QiData.JSON_DATA_FB_4_6=j_parse.decode(JSON_DATA_FB_4_6)
    QiData.JSON_DATA_FB_7_9=j_parse.decode(JSON_DATA_FB_7_9)
    QiData.JSON_DATA_FB_10_12=j_parse.decode(JSON_DATA_FB_10_12)
    QiData.JSON_DATA_FB_BOSS_CHANLLENGE=j_parse.decode(JSON_DATA_FB_BOSS_CHANLLENGE)
    QiData.JSON_DATA_FB_YAOTA_100=j_parse.decode(JSON_DATA_FB_YAOTA_100)
    QiData.exp_data=j_parse.decode(JSON_DATA_EXP_DATA)
    QiData.smart_lua=j_parse.decode(JSON_DATA_SMART_LUADATA)
    QiData.shop_data=j_parse.decode(JSON_DATA_SHOP_DATA)

    QiData.item_data_list={}
    for k,v in pairs(QiData.item_data) do 
        QiData.item_data_list[#QiData.item_data_list+1]=v
    end

    QiData:FormatUnitData()
    QiData:FormatAttackData()
    QiData:FormatQuestData()
    QiData:FormatExpData()
    QiData:SmartluaInit()
    QiData:FormatShopData()
end

-- 格式化商店数据
function QiData:FormatShopData()
    QiData.shoplist={}
    for k,v in pairs(QiData.shop_data) do
        local shopname=v["shopname"]
        if QiData.shoplist[shopname]==nil then 
            QiData.shoplist[shopname]={}
        end
        QiData.shoplist[shopname][tonumber(v["sell_index"])]=v
    end
end

function QiData:SmartluaInit()
    QiData.smartdatalist={
        "player_hp",
        "player_mp",
        "unit_armor_defence",
        "unit_magic_defence",
        "player_armor_defence",
        "player_magic_defence",
        "player_phy_attack",
        "player_magic_attack",
        "player_underattack_magic",
        "player_underattack_phy",
        "player_dps_defence", --玩家对怪物物理秒伤计算怪物防御
        "player_dps_defence_phy",
        "player_dps_defence_magic",
    }
end

--- 
function QiData:GetPHP(level)
    return QiData.smart_lua["player_hp"][level]
end
function QiData:GetPUnderAttack(level)
    return QiData.smart_lua["player_underattack_phy"][level]
end


-- function QiData:GetPPhyAttack(level)
--- 
function QiData:GetPDPS(level)
    return QiData.smart_lua["player_dps_defence"][level]
end
---
function QiData:UPHYDefence(level)
    return QiData.smart_lua["unit_armor_defence"][level]
end

function QiData:UMagicDefence(level)
    return QiData.smart_lua["unit_magic_defence"][level]
end
-- 设置皮肤ID
function QiData:GetSkinIdByConfigID(cfg)
    QiPrint("GetSkinIdByConfigID"..tostring(cfg))
    if QiData.SkinData[tonumber(cfg)] then 
        QiPrint("retrun"..tostring(QiData.SkinData[tonumber(cfg)]))
        return QiData.SkinData[tonumber(cfg)]
    else 
        QiPrint("retrun1")
        return 1
    end
end

--- 格式化经验数据
function QiData:FormatExpData()
    local exp_data={}
    for k,v in pairs(QiData.exp_data) do 
        for kk,vv in pairs(v) do
            if kk=="level" then 
                exp_data[tonumber(vv)]=v
            end
        end
    end
    QiData.exp_data=exp_data
end

--- 格式化任务格式
function QiData:FormatQuestData()
    local quest_data={}
    for k,v in pairs(QiData.quest_data) do 
        for kk,vv in pairs(v) do
            if kk=="quest_id" then 
                quest_data[vv]=v
            end
        end
    end
    QiData.quest_data=quest_data
end


function QiData:GetUnitNameByCfgID(cfg_id)
    if QiData.unit_cfg_data[cfg_id]~=nil then 
        return QiData.unit_cfg_data[cfg_id]["unit_name"]
    end
    return nil
end

function QiData:GetCfgIDByUnitName(unit_name)
    if QiData.unit_property[unit_name]~=nil then
        return QiData.unit_property[unit_name]["unit_config_id"]
    end
    return nil
end
--- 格式化导入的json数据 单位信息
function QiData:FormatUnitData()
    local unit_data={}
    local unit_cfg_data={}--用cfg作为index
    --unit data合集
    local u_data_index_table={
        QiData.unit_property,
        QiData.JSON_DATA_FB_1_3,
        QiData.JSON_DATA_FB_4_6,
        QiData.JSON_DATA_FB_7_9,
        QiData.JSON_DATA_FB_10_12,
        QiData.JSON_DATA_FB_BOSS_CHANLLENGE,
        QiData.JSON_DATA_FB_YAOTA_100,
    }
    for k,v in pairs(u_data_index_table) do 
        for col,row in pairs(v) do
            local u_name=row["unit_name"]
            if u_name~=nil then
                -- QiPrint("Add unit data "..u_name)
                unit_data[u_name]={}
                for k,v in pairs(row) do 
                    unit_data[row["unit_name"]][k]=v
                end
            end
            local unit_config_id=row["unit_config_id"]
            if unit_config_id~=nil then
                unit_cfg_data[unit_config_id]={}
                for k,v in pairs(row) do 
                    unit_cfg_data[unit_config_id][k]=v
                end
            end
        end
    end
    QiPrint("Formatunitdata")
    -- PrintTable(unit_data)
    QiData.unit_property=unit_data
    QiData.unit_cfg_data=unit_cfg_data

    for k,v in pairs(QiData.unit_property) do 
        QiPrint(k)
        if v["PhysicalDef"]~=nil then 
            local defence=v["PhysicalDef"] or 0
            local armor_reduce=(defence/(defence+602))
            local denfence_value=v["MaxHp"]/(1-armor_reduce)

            local attack=(1+v["AttackSpeedBonus"]/12000)*v["PhysicalDmg"]
            QiData.unit_property[k]["fightpower"]=math.floor((attack+defence)/2)
        end
    end
end

--- 格式化导入的json数据 进攻怪物数据
function QiData:FormatAttackData()
    QiPrint("FormatAttackData",3)
    local attack_data={}
    for col,row in pairs(QiData.unit_attack_property) do 
        local attack_round=tonumber(row["attack_round"])
        if attack_round~=nil then 
            if attack_data[attack_round]==nil then 
                attack_data[attack_round]={}
            end

            attack_data[attack_round][#attack_data[attack_round]+1]={}
            local add_data=attack_data[attack_round][#attack_data[attack_round]]
            for k,v in pairs(row) do 
                add_data[k]=v
            end
        end
    end
    -- for k,v in pairs(attack_data) do 
    --     for kk,vv in pairs(v) do 
    --         for kkk,vvv in pairs(vv) do 
    --             print(kkk)
    --             print(vvv)
    --         end
    --     end
    -- end
    QiData.unit_attack_property=attack_data
    -- PrintTable(attack_data)
end


function QiData:SetStringByItemColor(str,itemname)
    if QiData.item_data[itemname]== nil then 
        return str 
    else 
        local quality=QiData.item_data[itemname]["m_quality"]
        return QiData:SetStrinColorByQuality(str,quality)
    end
end
function QiData:SetStrinColorByQuality(str,quality)
    if quality=="white" then 
    elseif quality=="green" then 
        return "<color=#66ff66>"..str.."</color>"
    elseif quality=="blue" then 
        return "<color=#00ccff>"..str.."</color>"
    elseif quality=="purple" then 
        return "<color=#cc00ff>"..str.."</color>"
    elseif quality=="pink" then 
        return "<color=#ff66ff>"..str.."</color>"
    elseif quality=="orange" then 
        return "<color=#ff9900>"..str.."</color>"
    end
    return str
end