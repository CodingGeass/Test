if item_func==nil then 
    item_func={}
end
-- 每秒获得50金币，持续60秒。
function item_func:item_func_killshop_jubaopen(pid)
    QiPrint("item_func_killshop_jubaopen["..tostring(pid).."]")
    local buff_id=600121
    local qhero=PlayerController[pid]["QiHero"]
    sc.BuffAction(qhero.unit,qhero.unit,true,true,buff_id,0,0)
    sc.SetTimer(1000,0,60,function ()
        qhero:AddGold(50)
    end,{})
end
-- 增加50%的物理与魔法攻击力，持续60秒。
function item_func:item_func_killshop_langyaoneidan(pid)
    QiPrint("item_func_killshop_langyaoneidan"..tostring(pid))
    local buff_id=600123
    local qhero=PlayerController[pid]["QiHero"]
    sc.BuffAction(qhero.unit,qhero.unit,true,true,buff_id,0,0)
    local phy_add=math.floor(qhero.base_property["PhysicalDmg"]*0.5)
    local magic_add=math.floor(qhero.base_property["MagicalDmg"]*0.5)
    qhero.extra_property["PhysicalDmg"]=qhero.extra_property["PhysicalDmg"]+phy_add
    qhero.extra_property["MagicalDmg"]=qhero.extra_property["MagicalDmg"]+magic_add
    sc.SetTimer(1000*60,0,1,function ()
        qhero.extra_property["PhysicalDmg"]=qhero.extra_property["PhysicalDmg"]-phy_add
        qhero.extra_property["MagicalDmg"]=qhero.extra_property["MagicalDmg"]-magic_add
    end,{})
end
-- 增加30%生命值和30%护甲值 ，持续60秒。
function item_func:item_func_killshop_buquzhanhun(pid)
    QiPrint("item_func_killshop_buquzhanhun"..tostring(pid))
    local buff_id=600124
    local qhero=PlayerController[pid]["QiHero"]
    sc.BuffAction(qhero.unit,qhero.unit,true,true,buff_id,0,0)
    local hp_add=math.floor(qhero.base_property["MaxHp"]*0.5)
    local armor_add=math.floor(qhero.base_property["PhysicalDef"]*0.5)
    qhero.extra_property["MaxHp"]=qhero.extra_property["MaxHp"]+hp_add
    qhero.extra_property["PhysicalDef"]=qhero.extra_property["PhysicalDef"]+armor_add
    sc.SetTimer(1000*60,0,1,function ()
        qhero.extra_property["MaxHp"]=qhero.extra_property["MaxHp"]-hp_add
        qhero.extra_property["PhysicalDef"]=qhero.extra_property["PhysicalDef"]-armor_add
    end,{})
end
-- 自身每秒恢复最大生命值的3%血量，持续60秒。
function item_func:item_func_killshop_yaowangding(pid)
    QiPrint("item_func_killshop_yaowangding"..tostring(pid))
    local buff_id=600120
    local qhero=PlayerController[pid]["QiHero"]
    sc.BuffAction(qhero.unit,qhero.unit,true,true,buff_id,0,0)
    sc.SetTimer(1000,0,60,function ()
        local maxhp=sc.GetActorSystemProperty(qhero.unit,ActorAttribute_MaxHp)
        local regen_hp=math.floor(maxhp*0.03)
        local set_hp=sc.GetActorSystemProperty(qhero.unit,ActorAttribute_HP)+regen_hp
        if set_hp>=maxhp then 
            set_hp=maxhp
        end
        sc.SetActorSystemProperty(qhero.unit,ActorAttribute_HP,set_hp)
    end,{})
end
-- 使自身获得20%的所有伤害减免和10%的所有伤害增加，持续60秒。
function item_func:item_func_killshop_jiulongtianshu(pid)
    QiPrint("item_func_killshop_jiulongtianshu"..tostring(pid))
    local buff_id=600125
    local qhero=PlayerController[pid]["QiHero"]
    sc.BuffAction(qhero.unit,qhero.unit,true,true,buff_id,0,0)
    qhero.extra_property["finalDmgBonus"]=qhero.extra_property["finalDmgBonus"]+1000
    qhero.extra_property["DmgImmuneRate"]=qhero.extra_property["DmgImmuneRate"]+1000
    sc.SetTimer(1000*60,0,1,function ()
        qhero.extra_property["finalDmgBonus"]=qhero.extra_property["finalDmgBonus"]-1000
        qhero.extra_property["DmgImmuneRate"]=qhero.extra_property["DmgImmuneRate"]-1000
    end,{})
end
-- ActorAttribute_finalDmgBonus

-- 永久获得当前属性值[5%]的额外生命
function item_func:item_func_killshop_tianshou(pid)
    QiPrint("item_func_killshop_tianshou"..tostring(pid))
    local qhero=PlayerController[pid]["QiHero"]
    qhero.base_property["MaxHp"]=qhero.base_property["MaxHp"]+math.floor(qhero.base_property["MaxHp"]*0.05)
end

-- 永久获得当前属性值[5%]的额外物理攻击力
function item_func:item_func_killshop_ziyan(pid)
    QiPrint("item_func_killshop_ziyan"..tostring(pid))
    local qhero=PlayerController[pid]["QiHero"]
    qhero.base_property["PhysicalDmg"]=qhero.base_property["PhysicalDmg"]+math.floor(qhero.base_property["PhysicalDmg"]*0.05)
end
-- 永久获得当前属性值[5%]的额外魔法攻击力
function item_func:item_func_killshop_linxiao(pid)
    QiPrint("item_func_killshop_linxiao"..tostring(pid))
    local qhero=PlayerController[pid]["QiHero"]
    qhero.base_property["MagicalDmg"]=qhero.base_property["MagicalDmg"]+math.floor(qhero.base_property["MagicalDmg"]*0.05)
end
-- 永久获得当前属性值[5%]的额外护甲
function item_func:item_func_killshop_xuantian(pid)
    QiPrint("item_func_killshop_xuantian"..tostring(pid))
    local qhero=PlayerController[pid]["QiHero"]
    qhero.base_property["PhysicalDef"]=qhero.base_property["PhysicalDef"]+math.floor(qhero.base_property["PhysicalDef"]*0.05)
end

-- 永久获得当前属性值[5%]的额外魔法抗性
function item_func:item_func_killshop_xuling(pid)
    QiPrint("item_func_killshop_xuling"..tostring(pid))
    local qhero=PlayerController[pid]["QiHero"]
    qhero.base_property["MagicalDef"]=qhero.base_property["MagicalDef"]+math.floor(qhero.base_property["MagicalDef"]*0.05)
end