SM_QUALITY_GREEN=1
SM_QUALITY_BLUE=2
SM_QUALITY_PURRPLE=3
SM_QUALITY_PINK=4
SM_QUALITY_ORANGE=5

if QiSuanming==nil then 
    QiSuanming={}
    QiSuanming[SM_QUALITY_GREEN]={}
    QiSuanming[SM_QUALITY_BLUE]={}
    QiSuanming[SM_QUALITY_PURRPLE]={}
    QiSuanming[SM_QUALITY_PINK]={}
    QiSuanming[SM_QUALITY_ORANGE]={}
end

function QiSuanming:DataInit()
    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="逃跑大师",
        des="在复杂战场中也能拥有极佳的生存能力，移动初始速度增加2000，闪避几率提高5%",
        func=function (role)
            role.base_property["MoveSpeed"]=role.base_property["MoveSpeed"]+2000
            role.base_property["DodgeRate"]=role.base_property["DodgeRate"]+500
        end,
    }
     
    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="盗亦有道",
        des="劫富济贫的侠客，击败单位时获额外获得5金币",
        func=function (role)
            role:AddKillFunc(function (k_role,kv_unit,kv_uaid)
                k_role.gold=k_role.gold+5
            end)
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="再续前缘",
        des="受到前世因果眷顾，当局游戏初始等级为3%",
        func=function (role)
            for i=1,3 do 
                if role.level<3 then 
                    role:AddLevel()
                end
            end
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="仙路飘渺",
        des="前世也是一名求道之人，增加500法术伤害和500物理伤害",
        func=function (role)
            role.base_property["PhysicalDmg"]=role.base_property["PhysicalDmg"]+500
            role.base_property["MagicalDmg"]=role.base_property["MagicalDmg"]+500
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="理财大师",
        des="每隔60秒获得当前财产5%的额外收入",
        func=function (role)
           sc.SetTimer(60*1000,0,0,function ()
                local add_gold=math.floor(role.gold*5/100)
                role:AddGold(add_gold)
           end,{})
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="纨绔子弟",
        des="家境优渥，初始金币增加3000",
        func=function (role)
            role:AddGold(3000)
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="元素亲和",
        des="天生适合修炼法术，法术伤害增幅25%",
        func=function (role)
            role.base_property["MagicalDmgPercentAdd"]=role.base_property["MagicalDmgPercentAdd"]+25
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="人剑合一",
        des="与兵器融为一体，物理伤害增幅25%",
        func=function (role)
            role.base_property["PhysicalDmgPercentAdd"]=role.base_property["PhysicalDmgPercentAdd"]+25
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="祥麟瑞兽",
        des="得到仙兽祝福，所有属性值增幅5%",
        func=function (role)
            role.base_property["PhysicalDmgPercentAdd"]=role.base_property["PhysicalDmgPercentAdd"]+5
            role.base_property["MagicalDmgPercentAdd"]=role.base_property["MagicalDmgPercentAdd"]+5
            role.base_property["PhysicalDefPercentAdd"]=role.base_property["PhysicalDefPercentAdd"]+5
            role.base_property["MagicalDefPercentAdd"]=role.base_property["MagicalDefPercentAdd"]+5
            role.base_property["HpRegenRatePercentAdd"]=role.base_property["HpRegenRatePercentAdd"]+5
        end,
    }

    QiSuanming[SM_QUALITY_GREEN][#QiSuanming[SM_QUALITY_GREEN]+1]={
        title="炼丹大师",
        des="初始击败数增加1000",
        func=function (role)
            role.killpoint= role.killpoint+1000
        end,
    }

    QiSuanming[SM_QUALITY_BLUE][#QiSuanming[SM_QUALITY_BLUE]+1]={
        title="琴心剑胆",
        des="曾是快意恩仇的侠客，初始攻击速度提高50%",
        func=function (role)
            role.base_property["AttackSpeedBonus"]= role.base_property["AttackSpeedBonus"]+5000
        end,
    }
    QiSuanming[SM_QUALITY_BLUE][#QiSuanming[SM_QUALITY_BLUE]+1]={
        title="撼世儒风",
        des="声震寰宇的墨客，经验获取速度增加30%",
        func=function (role)
            role.base_property["ExpAddPercent"]= role.base_property["ExpAddPercent"]+30
        end,
    }
    QiSuanming[SM_QUALITY_BLUE][#QiSuanming[SM_QUALITY_BLUE]+1]={
        title="富甲天下",
        des="曾经是富家一方的钱庄老板，金币获取速度提高30%",
        func=function (role)
            role.base_property["GoldAddPercent"]= role.base_property["GoldAddPercent"]+30
        end,
    }
    QiSuanming[SM_QUALITY_BLUE][#QiSuanming[SM_QUALITY_BLUE]+1]={
        title="龙族血统",
        des="天身的战士，每击败一个单位增加自身1点生命值",
        func=function (role)
            role.base_property["MaxHpKillAdd"]= role.base_property["MaxHpKillAdd"]+1
        end,
    }
    QiSuanming[SM_QUALITY_PURRPLE][#QiSuanming[SM_QUALITY_PURRPLE]+1]={
        title="刀刀烈火",
        des="自创烈火刀法，自身基础暴击率提高5%",
        func=function (role)
            role.base_property["CriticalRatePercentAdd"]= role.base_property["CriticalRatePercentAdd"]+30
        end,
    }
    QiSuanming[SM_QUALITY_PURRPLE][#QiSuanming[SM_QUALITY_PURRPLE]+1]={
        title="风花雪月",
        des="掌握独门奇功，自身物理攻击和法术攻击提高50%",
        func=function (role)
            role.base_property["PhysicalDmgPercentAdd"]= role.base_property["PhysicalDmgPercentAdd"]+50
            role.base_property["MagicalDmgPercentAdd"]= role.base_property["MagicalDmgPercentAdd"]+50
        end,
    }
    QiSuanming[SM_QUALITY_PURRPLE][#QiSuanming[SM_QUALITY_PURRPLE]+1]={
        title="醉生梦死",
        des="嗜酒如命的剑仙，增加自身300物理穿透值和50%攻击速度",
        func=function (role)
            role.base_property["PhysicalPenetration"]= role.base_property["PhysicalPenetration"]+300
            role.base_property["AttackSpeedBonus"]= role.base_property["AttackSpeedBonus"]+5000
        end,
    }
    QiSuanming[SM_QUALITY_PURRPLE][#QiSuanming[SM_QUALITY_PURRPLE]+1]={
        title="刀刀烈火",
        des="自创烈火刀法，自身基础暴击率提高5%",
        func=function (role)
            role.base_property["CriticalRatePercentAdd"]= role.base_property["CriticalRatePercentAdd"]+30
        end,
    }
    QiSuanming[SM_QUALITY_PINK][#QiSuanming[SM_QUALITY_PINK]+1]={
        title="摩诃无量",
        des="曾是圣人，修为深不可测。自身生命值提高100%",
        func=function (role)
            role.base_property["MaxHpPercentAdd"]= role.base_property["MaxHpPercentAdd"]+100
        end,
    }
    QiSuanming[SM_QUALITY_PINK][#QiSuanming[SM_QUALITY_PINK]+1]={
        title="幽界传人",
        des="修习幽界心法，物理与法术伤害穿透率提高12%",
        func=function (role)
            role.base_property["PhysicalPenetrationRate"]= role.base_property["PhysicalPenetrationRate"]+1200
            role.base_property["MagicalPenetrationRate"]= role.base_property["MaxHpPercentAdd"]+1200
        end,
    }
    QiSuanming[SM_QUALITY_PINK][#QiSuanming[SM_QUALITY_PINK]+1]={
        title="斗战胜佛",
        des="前世曾与圣人大战三百回合，暴击伤害提高75%",
        func=function (role)
            role.base_property["CriticalDmgBonus"]= role.base_property["CriticalDmgBonus"]+7500
        end,
    }
    QiSuanming[SM_QUALITY_PINK][#QiSuanming[SM_QUALITY_PINK]+1]={
        title="赤之旭光",
        des="每次死亡自身所有属性都会增幅5%",
        func=function (role)
            role:AddSelfDieunc(function (role)
                local add_table={
                    "MaxHp",
                    "PhysicalDmg",
                    "MagicalDmg",
                    "PhysicalDef",
                    "MagicalDef",
                }
                for k,v in pairs(add_table) do 
                    role.base_property[v]=math.floor( role.base_property[v]*5/100)+role.base_property[v]
                end
            end)
        end,
    }
    QiSuanming[SM_QUALITY_ORANGE][#QiSuanming[SM_QUALITY_ORANGE]+1]={
        title="老倒霉蛋",
        des="好像得不到运气之神的照顾。基础暴击率减少5%，暴击伤害减少50%，金币经验值获取速度降低50%,获得神秘效果非福",
        func=function (role)
            role.base_property["CriticalRate"]= role.base_property["CriticalRate"]-500
            role.base_property["CriticalDmgBonus"]= role.base_property["CriticalDmgBonus"]-5000
            role.base_property["ExpAddPercent"]= role.base_property["ExpAddPercent"]-50
            role.base_property["GoldAddPercent"]= role.base_property["GoldAddPercent"]-50
            sc.SetTimer(8000,0,0,function ()
                role.base_property["PhysicalDmg"]=math.floor( role.base_property["PhysicalDmg"]*1/100)+role.base_property["PhysicalDmg"]
                role.base_property["MagicalDmg"]=math.floor( role.base_property["MagicalDmg"]*1/100)+role.base_property["PhysicalDmg"]
                role.base_property["MaxHp"]=math.floor( role.base_property["MaxHp"]*1/100)+role.base_property["PhysicalDmg"]
            end,{})
        end,
    }
    QiSuanming[SM_QUALITY_ORANGE][#QiSuanming[SM_QUALITY_ORANGE]+1]={
        title="天才少年",
        des="年级轻轻便取得他人梦寐以求的成就。自身攻击速度变为200%，暴击率50%，暴击伤害300%，该数值无法改变。",
        func=function (role)
            role.lockdata["AttackSpeedBonus"]=20000
            role.lockdata["CriticalRate"]=5000
            role.lockdata["CriticalDmgBonus"]=30000
        end,
    }
end

-- 算命系统初始化
function QiSuanming:Init()
    QiSuanming:DataInit()
end
-- 算命系统
function QiSuanming:new(o,actor,pid)
    o=o or {}
    setmetatable(o,self)
    self.__index =self
    o.pid=pid
    o.unit=actor
    o.choosedata=nil
    o.aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID )
    o.roll_startnumber=1 -- roll点最低点数
    o.roll_endnumber=100
    return o
end

-- 发送算命数据
function QiSuanming:SendSuanmingData()
    local eventName = StringId.new("SendSuanmingData")
    local title,des,quality
    if self.choosedata~=nil then 
        title=self.choosedata["title"]
        des=self.choosedata["des"]
        quality=self.choosedata["quality"]
    end
    sc.CallUILuaFunction({title,des,quality,self.aid} , eventName)
end

-- 玩家选择命运
function QiSuanming:PlayerChooseFate()
    -- 当前没有命运
    if self.choosedata==nil then
        local changse_data={
            [SM_QUALITY_GREEN]=55,
            [SM_QUALITY_BLUE]=80,
            [SM_QUALITY_PURRPLE]=95,
            [SM_QUALITY_PINK]=99,
            [SM_QUALITY_ORANGE]=100,
        }
        local quality_data={
            [SM_QUALITY_GREEN]="green",
            [SM_QUALITY_BLUE]="blue",
            [SM_QUALITY_PURRPLE]="purple",
            [SM_QUALITY_PINK]="pink",
            [SM_QUALITY_ORANGE]="orange",
        }
        local rollnumber=math.random(self.roll_startnumber,self.roll_endnumber)
        local choose_level=SM_QUALITY_GREEN -- 选中随机池
        for i=SM_QUALITY_GREEN,SM_QUALITY_ORANGE do 
            if rollnumber<=changse_data[i] then 
                choose_level=i
                break
            end
        end
        QiPrint("fate rollnumber["..tostring(rollnumber).."] choose_level ["..tostring(choose_level).."]",3)
        choose_level=choose_level
        -- 应用选择数据
        self.choosedata=QiSuanming[choose_level][math.random(1,#QiSuanming[choose_level])]
        self.choosedata["func"](PlayerController[self.pid]["QiHero"])
        self.choosedata["quality"]=quality_data[choose_level]
        self:SendSuanmingData()
    end
end