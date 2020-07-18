if QiHero==nil then 
    QiHero={}
    QiHero.PercentTranslate={
        MaxHp="MaxHpPercentAdd",
        MaxMp="MaxMpPercentAdd",
        PhysicalDmg="PhysicalDmgPercentAdd",
        MagicalDmg="MagicalDmgPercentAdd",
        PhysicalDef="PhysicalDefPercentAdd",
        MagicalDef="MagicalDefPercentAdd",
        HpRegenRate="HpRegenRatePercentAdd",
        PhysicalLifeSteal="PhysicalLifeStealPercentAdd",
        PhysicalPenetration="PhysicalPenetrationPercentAdd",
        MagicalPenetration="MagicalPenetrationPercentAdd",
        CriticalRate="CriticalRatePercentAdd",
        CriticalDmgBonus="CriticalDmgBonusPercentAdd",
        AttackSpeedBonus="AttackSpeedBonusPercentAdd",
        DodgeRate="DodgeRatePercentAdd",
    }
    QiHero.KillPropertyTranslate={
        MaxHpKillAdd="MaxHp",
        MaxMpKillAdd="MaxMp",
        PhysicalDmgKillAdd="PhysicalDmg",
        MagicalDmgKillAdd="MagicalDmg",
        PhysicalDefKillAdd="PhysicalDef",
        MagicalDefKillAdd="MagicalDef",
        HpRegenRateKillAdd="HpRegenRate",
        PhysicalLifeStealKillAdd="PhysicalLifeSteal",
        PhysicalPenetrationKillAdd="PhysicalPenetration",
        MagicalPenetrationKillAdd="MagicalPenetration",
        CriticalRateKillAdd="CriticalRate",
        CriticalDmgBonusKillAdd="CriticalDmgBonus",
        AttackSpeedBonusKillAdd="AttackSpeedBonus",
        DodgeRateKillAdd="DodgeRate",
    }
    QiHero.SecPropertyTranslate={
        MaxHpSecAdd="MaxHp",
        MaxMpSecAdd="MaxMp",
        PhysicalDmgSecAdd="PhysicalDmg",
        MagicalDmgSecAdd="MagicalDmg",
        PhysicalDefSecAdd="PhysicalDef",
        MagicalDefSecAdd="MagicalDef",
        HpRegenRateSecAdd="HpRegenRate",
        PhysicalLifeStealSecAdd="PhysicalLifeSteal",
        PhysicalPenetrationSecAdd="PhysicalPenetration",
        MagicalPenetrationSecAdd="MagicalPenetration",
        CriticalRateSecAdd="CriticalRate",
        CriticalDmgBonusSecAdd="CriticalDmgBonus",
        AttackSpeedBonusSecAdd="AttackSpeedBonus",
        DodgeRateSecAdd="DodgeRate",
    }
    QiHero.herolist={
        [1163]={
            heroname="hero_sword_yidajianyi",
            weapon_type="sword",
            heroname_schinese="伊达剑意",
        },
        [1164]={
            heroname="hero_sword_zhaohanhen",
            weapon_type="cane",
            heroname_schinese="曌寒痕",
        },
        -- [1165]={
        --     heroname="hero_sword_zhaohanhen",
        --     weapon_type="spear",
        --     heroname_schinese="曌寒痕",
        -- },
        -- [1166]={
        --     heroname="hero_sword_zhaohanhen",
        --     weapon_type="dagger",
        --     heroname_schinese="曌寒痕",
        -- },
        -- [1167]={
        --     heroname="hero_sword_zhaohanhen",
        --     weapon_type="broadsword",
        --     heroname_schinese="曌寒痕",
        -- },
    }
    QiHero.SoulExp={
        [1]=160,
        [2]=298,
        [3]=446,
        [4]=524,
        [5]=613,
        [6]=713,
        [7]=825,
        [8]=950,
        [9]=1088,
        [10]=1240,
        [11]=1406,
        [12]=1585,
        [13]=1778,
        [14]=1984,
        [15]=2202,
    }
end

--- 新构造一个英雄
function QiHero:new(o,hero,pid)
    o=o or {}
    o.unit=hero
    setmetatable(o,self)
    self.__index =self
    o.pid=pid
    o.nowproperty=nil
    o.extra_property=nil
    o.cfgid=sc.GetActorSystemProperty(hero,ActorAttribute_ConfigID)
    o.aid=sc.GetActorSystemProperty(hero,ActorAttribute_ActorID )
    -- 击杀事件
    o.killfunc={}
    -- 自己死亡事件
    o.selfdiefunc={}
    o:RoleInit()
    o:HeroPropertyInit(pid)
    o:PlayerBasePropertyInit()
    sc.SetActorSystemProperty(hero,ActorAttribute_HP,sc.GetActorSystemProperty(hero,ActorAttribute_MaxHp))
    return o
end

-- 增加击杀事件
function QiHero:AddKillFunc(func)
    local kill_func_index=GetUniqueIndex("killfunc")
    self.killfunc[kill_func_index]=func
end

-- 增加自己死亡
function QiHero:AddSelfDieunc(func)
    local die_func_index=GetUniqueIndex("selfdiefunc")
    self.selfdiefunc[die_func_index]=func
end

-- 获取玩家战斗力
function QiHero:PlayerFightNumberText()
    local damage=self:PlayerFightNumber()
    if damage>10*10000 then 
        damage=tostring(math.floor(damage/10000)).."W"
    else 
        damage=tostring(math.floor(damage))
    end
    return damage
end
-- 获取玩家战斗力
function QiHero:PlayerFightNumber()
    local damage_point=self:GetDamageSimulate()
    local defence_point=self:GetDefenceSimulate()
    return (damage_point+defence_point)/2
end

-- 获取输出能力
function QiHero:GetDamageSimulate()
    -- 普通伤害
    local attack_damage=(self.nowproperty["AttackSpeedBonus"]/15000+1)*(self.nowproperty["BaseDamage"]+self.nowproperty["PhysicalDmg"])
    local cirt_percent=self.nowproperty["CriticalRate"]/100/100
    if cirt_percent>1 then cirt_percent=1 end 
    local cirt_add=(1-cirt_percent)*1+(cirt_percent*(self.nowproperty["CriticalDmgBonus"]/10000+1))
    attack_damage=attack_damage*cirt_add
    -- 技能伤害
    local damage=math.max(self.nowproperty["MagicalDmg"],self.nowproperty["PhysicalDmg"])
    damage=damage+math.max(self.nowproperty["PhysicalPenetration"],self.nowproperty["MagicalPenetration"])*5
    damage=damage*(1+self.level/3)

    local total_damage=attack_damage+damage
    return total_damage,attack_damage,damage
end

-- 获取防御能力
function QiHero:GetDefenceSimulate()
    local defence=math.max(self.nowproperty["PhysicalDef"],self.nowproperty["MagicalDef"])
    local armor_reduce=(defence/(defence+602))
    local denfence_value=self.nowproperty["MaxHp"]/(1-armor_reduce)
    return denfence_value
end

--- 玩家基础属性初始化
-- function detail description.
-- @tparam  type self description
-- @author 
function QiHero:PlayerBasePropertyInit()
    self.level=1
    self.exp=0
    self.gold=100
    self.killpoint=0--击杀数
    self.canselect=false
    self:SendPickItemInfo(nil,false)
    -- 每秒增加属性
    sc.SetTimer(1000, 0, 0 , function ()
        for k,v in pairs(QiHero.SecPropertyTranslate) do
            if self.nowproperty[k]>0 then 
                self.base_property[v]=self.base_property[v]+self.nowproperty[k]
            end
        end
        self:RefreshProperty()
        local eventName = StringId.new("UXSetFightPower")
        sc.CallUILuaFunction({self.aid,self:PlayerFightNumberText()} , eventName)
    end, {})
    sc.SetTimer(100, 0, 0 , function ()
        local have_item,item_name= DropItemController:HaveAvaliablePickItem(self.pid)
        if have_item==true then 
            if self.canselect==false then 
                QiMsg("找到可拾取物品",5)
                self.canselect=true
                self:SendPickItemInfo(item_name,self.canselect)
            end
        else 
            if self.canselect==true then 
                self.canselect=false
                self:SendPickItemInfo(item_name,self.canselect)
            end
        end
    end, {})
end

-- 增加击杀数
function QiHero:AddKillPoint()
    self.killpoint=self.killpoint+1
    local eventName = StringId.new("UXSetKillPoint")
    sc.CallUILuaFunction({self.aid,self:GetKillPoint()} , eventName)
end

-- 获得击杀数
function QiHero:GetKillPoint()
    return self.killpoint
end

function QiHero:SendPickItemInfo(itemname,can_pick)
    local eventName = StringId.new("SetSelectBtn")
    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],can_pick,itemname} , eventName)
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type exp description
-- @author 
function QiHero:AddExp(exp,level)
    local add_exp=math.floor(self:RewardRandom(self:GetExpByLevel(exp,level)))
    add_exp=math.floor(add_exp*(self.nowproperty["ExpAddPercent"]+100)/100)
    self.exp=self.exp+add_exp
    self:AddLevel()
    self:SyncExpInfo(add_exp)
    -- QiMsg("增加了经验值 当前为:"..tostring(self.exp),3,self.aid)
end

function QiHero:RewardRandom(value)
    return value*RandomInt(80,120)/100
end

-- 同步经验信息
function QiHero:SyncExpInfo(add_exp)
    local eventName = StringId.new("SyncExp")
    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],self.level,self.exp,QiData.exp_data[self.level]["level_up_exp"],add_exp} , eventName)
end

function QiHero:GetExpByLevel(exp,level)
    local s_level=self.level
    local level_diff=level-s_level
    if level_diff<0 then 
        level_diff=level_diff*-1
        if QiData.exp_data[level] then 
            local reduce=(100-QiData.exp_data[level]["exp_level_reduce"])/100
            return exp*reduce
        end
    else
        return exp
    end
    return exp
end

function QiHero:AddLevel()
    if self.exp>QiData.exp_data[self.level]["level_up_exp"] then 
        self:ForceAddLevel()
        sc.SetActorSystemProperty(self.unit,1009,self.level)
        QiMsg("恭喜玩家到达了等级["..tostring(self.level).."]",3)
    end
end

function QiHero:ForceAddLevel()
    sc.AddSoulExp( self.unit,QiHero.SoulExp[self.level],0) 
    self.level=self.level+1
    self.exp=0
end
--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type gold description
-- @author 
function QiHero:AddGold(gold,random_gold)
    if gold then 
        if random_gold==false then 
        else 
            gold=math.floor(gold*(self.nowproperty["GoldAddPercent"]+100)/100)
            gold=math.floor(self:RewardRandom(gold))
        end
        if gold >0 then 
            sc.AddCoin(self.unit,gold,true,true,1)
        end
        -- QiMsg("获得了金币"..tostring(gold),3)
        self.gold=self.gold+math.floor(gold)
        self:SyncGoldInfo(gold)
        local eventName = StringId.new("UXSetGold")
        sc.CallUILuaFunction({self.aid,self:GetGold()} , eventName)
    end
end

--- 小号金币
function QiHero:CostGold(gold,show)
    gold=math.floor(gold)
    if gold and gold>0 then 
        if self.gold>gold then 
            self.gold=self.gold-gold
            sc.PlayCustomSound(MUSIC_BACKGROUND_EVENT,StringId.new("Sound/ui_sound_gold_buy.ogg"),1)
            local eventName = StringId.new("UXSetGold")
            sc.CallUILuaFunction({self.aid,self:GetGold()} , eventName)
            return true
        else 
            local gold_need=gold-self.gold
            if show~=false then 
                QiBottomAlert("<color=#33ccff>金币不足</color>，还需<color=#ffff66>"..
                tostring(gold_need).."</color>",nil,self.aid)
            end
            return false,gold_need
        end
    end
    return false
end

--- 消耗杀敌数
function QiHero:CostKillPoint(killpoint,show)
    killpoint=math.floor(killpoint)
    if killpoint and killpoint>0 then 
        if self.killpoint>killpoint then 
            self.killpoint=self.killpoint-killpoint
            sc.PlayCustomSound(MUSIC_BACKGROUND_EVENT,StringId.new("Sound/ui_sound_gold_buy.ogg"),1)
            local eventName = StringId.new("UXSetKillPoint")
            sc.CallUILuaFunction({self.aid,self:GetKillPoint()} , eventName)
            return true
        else 
            local needkillpoint=killpoint-self.killpoint
            if show~=false then 
                QiBottomAlert("<color=#33ccff>击败数不足</color>，还需<color=#ffff66>"..
                tostring(needkillpoint).."</color>",nil,self.aid)
            end
            return false,needkillpoint
        end
    end
    return false
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type gold description
-- @author 
function QiHero:GetGold()
    local gold=math.floor(self.gold)
    return gold
end

-- 同步经验信息
function QiHero:SyncGoldInfo(add_gold)
    local eventName = StringId.new("SyncGold")
    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],add_gold} , eventName)
end

-- 设置额外属性
function QiHero:ModifyExtraProperty(p_name,p_value)
    if self.extra_property[p_name] then
        self.extra_property[p_name]=self.extra_property[p_name]+p_value
        self:RefreshOneProperty(p_name)
        return self.extra_property[p_name]
    end
    QiMsg("ModifyExtraProperty 找不到"..tostring(p_name),5)
    return nil
end

-- 设置额外属性
function QiHero:SetExtraProperty(p_name,p_value)
    if self.extra_property[p_name] then
        self.extra_property[p_name]=p_value
        self:RefreshOneProperty(p_name)
        return self.extra_property[p_name]
    end
    QiMsg("SetExtraProperty 找不到"..tostring(p_name),5)
    return nil
end

-- 获得额外属性
function QiHero:GetExtraProperty(p_name)
    if self.extra_property[p_name] then
        return self.extra_property[p_name]
    end
    QiMsg("GetExtraProperty 找不到"..tostring(p_name),5)
    return nil
end


--- 英雄属性初始化
function QiHero:HeroPropertyInit(pid)
    QiPrint("actor set System property",3)
    self.base_property={
        PhysicalDmg=20,
        MagicalDmg=20,
        PhysicalDef=10,
        MagicalDef=10,
        CriticalRate=500,
        PhysicalPenetration=0,
        PhysicalPenetrationRate=0,
        MagicalPenetrationRate=0,
        MagicalPenetration=0,
        PhysicalLifeSteal=0,
        MagicalLifeSteal=0,
        CriticalDmgBonus=15000,
        TrueDmg=0,
        TrueReduceDmg=0,
        MoveSpeed=4500,
        HpRegenRate=100,
        Tenacity=0,
        AttackSpeedBonus=0,
        CoolDownTimeReduce=0,
        HitRate=0,
        DodgeRate=0,
        DmgImmuneRate=0,
        finalDmgBonus=0,
        MaxMp=1000,
        MaxHp=100,
        BaseDamage=20,
        ExpAddPercent=0,
        GoldAddPercent=0,
        MpRegenRate=1000000,
        -- 百分比放大属性类 顶部有映射表
        MaxHpPercentAdd=0,
        MaxMpPercentAdd=0,
        PhysicalDmgPercentAdd=0,
        MagicalDmgPercentAdd=0,
        PhysicalDefPercentAdd=0,
        MagicalDefPercentAdd=0,
        HpRegenRatePercentAdd=0,
        PhysicalLifeStealPercentAdd=0,
        PhysicalPenetrationPercentAdd=0,
        MagicalPenetrationPercentAdd=0,
        CriticalRatePercentAdd=0,
        CriticalDmgBonusPercentAdd=0,
        AttackSpeedBonusPercentAdd=0,
        DodgeRatePercentAdd=0,

        -- 击杀击杀属性类
        MaxHpKillAdd=0,
        MaxMpKillAdd=0,
        PhysicalDmgKillAdd=0,
        MagicalDmgKillAdd=0,
        PhysicalDefKillAdd=0,
        MagicalDefKillAdd=0,
        HpRegenRateKillAdd=0,
        PhysicalLifeStealKillAdd=0,
        PhysicalPenetrationKillAdd=0,
        MagicalPenetrationKillAdd=0,
        CriticalRateKillAdd=0,
        CriticalDmgBonusKillAdd=0,
        AttackSpeedBonusKillAdd=0,
        DodgeRateKillAdd=0,

        -- 每秒增加属性类
        MaxHpSecAdd=0,
        MaxMpSecAdd=0,
        PhysicalDmgSecAdd=0,
        MagicalDmgSecAdd=0,
        PhysicalDefSecAdd=0,
        MagicalDefSecAdd=0,
        HpRegenRateSecAdd=0,
        PhysicalLifeStealSecAdd=0,
        PhysicalPenetrationSecAdd=0,
        MagicalPenetrationSecAdd=0,
        CriticalRateSecAdd=0,
        CriticalDmgBonusSecAdd=0,
        AttackSpeedBonusSecAdd=0,
        DodgeRateSecAdd=0,
    }
    self.lockdata={

    }
    self.extra_property={
        PhysicalDmg=0,
        MagicalDmg=0,
        PhysicalDef=0,
        MagicalDef=0,
        CriticalRate=0,
        PhysicalPenetration=0,
        MagicalPenetration=0,
        PhysicalLifeSteal=0,
        CriticalDmgBonus=0,
        TrueDmg=0,
        TrueReduceDmg=0,
        MoveSpeed=0,
        HpRegenRate=1,
        Tenacity=0,
        AttackSpeedBonus=0,
        CoolDownTimeReduce=0,
        HitRate=0,
        DodgeRate=0,
        DmgImmuneRate=0,
        finalDmgBonus=0,
        MaxMp=0,
        MaxHp=0,
        MpRegenRate=0,
        BaseDamage=0,
        ExpAddPercent=0,
        GoldAddPercent=0,
    }
    self:RefreshProperty()
    if TEST_ABILIT_MODE==true then 
        for i=1,12 do 
            sc.AddSoulExp( self.unit,9999,0) 
        end
    end
    -- --当前生命值 
    -- sc.SetActorSystemProperty(PlayerController[0]["actor"],ActorAttribute_HP,100000)
    -- sc.SetActorSystemProperty(PlayerController[0]["actor"],ActorAttribute_MagicalDef,100000)
    -- sc.SetActorSystemProperty(PlayerController[0]["actor"],ActorAttribute_finalDmgBonus,100000)
    -- sc.SetActorSystemProperty(PlayerController[0]["actor"],ActorAttribute_MoveSpeed,10000)
    -- sc.SetActorSystemProperty(PlayerController[0]["actor"],ActorAttribute_PhysicalDmg,10000)
    --删除自带技能
    -- sc.AddSoulExp(self.unit,100000,0)
    for i=5,11 do 
        sc.DelSkill(PlayerController[pid]["actor"],i)
    end
    -- sc.SetSkillLevel (PlayerController[pid]["actor"],1, 2)
    -- sc.SetSkillLevel (PlayerController[pid]["actor"],1, 3)
    -- sc.SetSkillLevel (PlayerController[pid]["actor"],1, 1)
    sc.AddSkill(PlayerController[pid]["actor"],69930,1,5)
    -- sc.AddSkill(PlayerController[pid]["actor"],10710,1,5)
    -- sc.AddSkill(PlayerController[pid]["actor"],15210,1,6)
    -- sc.AddSkill(PlayerController[pid]["actor"],15230,1,7)
    -- sc.AddSkill(PlayerController[pid]["actor"],11430,1,8)
end
-- 玩家死亡
function QiHero:roledie(attacker)
    for k,v in pairs(self.selfdiefunc) do 
        v(self)
    end
end

function QiHero:KillActor(actor,aid)
    -- 调用所有击杀函数
    for k,v in pairs(self.killfunc) do
        v(self,actor,aid)
    end
    for k,v in pairs(QiHero.KillPropertyTranslate) do
        if self.nowproperty[k]>0 then 
            -- 增加属性
            self.base_property[v]=self.base_property[v]+self.nowproperty[k]
        end
    end
end

-- 刷新英雄属性
function QiHero:RefreshProperty()
    local equip_property=PlayerController:GetPlayerEquip(self.pid):GetAllEquipPropertyList()
    self.nowproperty=copy_table(self.base_property)
    -- 加上装备属性
    for k,v in pairs(equip_property) do 
        if self.nowproperty[k] then 
            self.nowproperty[k]=self.nowproperty[k]+v
        end
    end
    -- 加上额外属性
    for k,v in pairs(self.extra_property) do 
        if self.nowproperty[k] then 
            self.nowproperty[k]=self.nowproperty[k]+v
        end
    end
    -- 加上增幅属性
    if PlayerController[self.pid]["QiBossChallenge"] then 
        local percent_add_table=PlayerController[self.pid]["QiBossChallenge"].reward_list
        for k,v in pairs(percent_add_table) do
            if self.nowproperty[k] then 
                local addnem=QiHero.PercentTranslate[k]
                -- local add_value=v+
                -- 计算玩家自身装备的属性加成
                local now_palyer_add_percent=self.nowproperty[addnem] or 0
                local add_value=v+now_palyer_add_percent
                self.nowproperty[k]=math.floor(self.nowproperty[k]*(100+add_value)/100)
            end
        end
    end
    -- 如有锁定值
    for k,v in pairs(self.lockdata) do 
        if self.nowproperty[k]~=nil then 
            self.nowproperty[k]=v 
        end
    end
    for k,v in pairs(self.nowproperty) do 
        local att_key_str="ActorAttribute_"..k
        local att_key=_G[att_key_str]
        if att_key then 
            sc.SetActorSystemProperty(self.unit,att_key,math.floor(v))
        end
    end
end

function QiHero:RefreshOneProperty(p_name)
    local equip_property=PlayerController:GetPlayerEquip(self.pid):GetAllEquipPropertyList()
    self.nowproperty=copy_table(self.base_property)
    -- 加上装备属性
    if self.nowproperty[p_name] and equip_property[p_name] then 
        self.nowproperty[p_name]=self.nowproperty[p_name]+equip_property[p_name]
    end
    -- 加上额外属性
    if self.nowproperty[p_name] and self.extra_property[p_name] then 
        self.nowproperty[p_name]=self.nowproperty[p_name]+self.extra_property[p_name]
    end
    local att_key_str="ActorAttribute_"..p_name
    local att_key=_G[att_key_str]
    if att_key then 
        sc.SetActorSystemProperty(self.unit,att_key,math.floor(self.nowproperty[p_name]))
    end
end