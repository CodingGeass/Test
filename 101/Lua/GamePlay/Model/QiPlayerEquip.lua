if QiPlayerEquip==nil then 
    QiPlayerEquip={}
    QiPlayerEquip.BaseProperty={
        PhysicalDmg=0,
        MagicalDmg=0,
        PhysicalDef=0,
        MagicalDef=0,
        CriticalRate=0,
        PhysicalPenetration=0,
        MagicalPenetration=0,
        PhysicalPenetrationRate=0,
        MagicalPenetrationRate=0,
        PhysicalLifeSteal=0,
        CriticalDmgBonus=0,
        TrueDmg	=0,
        TrueReduceDmg=0,
        MoveSpeed=0,
        HpRegenRate=0,
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
end

PLAYER_EQUIP_NUMBER=6--玩家可装备物品数量

--- 新建玩家装备
function QiPlayerEquip:new(o,actor,pid)
    o=o or {}
    setmetatable(o,self)
    self.__index =self
    o.equiplist={}
    o.pid=pid
    o.unit=actor
    o.aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID )
    for i=1,PLAYER_EQUIP_NUMBER do 
        o.equiplist[i]={
            equipname=nil,
            equiptype=i,
        }
    end
    return o
end

--- 获得装备物品的所有属性和
function QiPlayerEquip:GetAllEquipPropertyList()
    local e_property={
        PhysicalDmg=0,
        MagicalDmg=0,
        PhysicalDef=0,
        MagicalDef=0,
        CriticalRate=0,
        PhysicalPenetration=0,
        MagicalPenetration=0,
        PhysicalLifeSteal=0,
        CriticalDmgBonus=0,
        TrueDmg	=0,
        TrueReduceDmg=0,
        MoveSpeed=0,
        HpRegenRate=0,
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
    for k,v in pairs(self.equiplist) do 
        if v.equipname~=nil then 
            item_data=QiData.item_data[v.equipname]
            if item_data~=nil then 
                for kk,vv in pairs(item_data) do 
                    if e_property[kk] then 
                        --将装备的属性值加上去
                        e_property[kk]=e_property[kk]+vv
                    end
                end
            end
        end
    end
    return e_property
end

--- 装备物品
function QiPlayerEquip:EquipItem(item_name)
    local item_data=QiData.item_data[item_name]
    local equip_type=tonumber(item_data["m_itemtype"])
    -- QiPrint("EquipItem "..tostring(item_name).."equip_type "..tostring(equip_type))
    for k,v in pairs(self.equiplist) do 
        --空的
        if v["equiptype"]==equip_type then 
            if v.equipname~=nil then
                if equip_type~=BAG_SOLT_TYPE_WEAPON and equip_type~=BAG_SOLT_TYPE_FABAO then 
                    self:UnEquipItem(equip_type)
                else 
                    return false
                end
            end
            if v.equipname==nil then 
                v.equipname=item_name
                QiMsg("您装备上了"..tostring(QiData.item_data[item_name]["m_itemTitle"]),3)
                local eventName = StringId.new("AddEquip")
                sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],k,item_name} , eventName)
                self:RefreshProperty()
                return true
            else
                QiMsg("无法装备"..tostring(QiData.item_data[item_name]["m_itemTitle"]),3)
                return false
            end
        end
    end
    QiMsg("无法装备，装备栏已满")
    return false
end

function QiPlayerEquip:RefreshProperty()
    if PlayerController:GetQiHero(self.pid) then 
        PlayerController:GetQiHero(self.pid):RefreshProperty()
    end
end

function QiPlayerEquip:SetEquipSolt(index,name,type)
    self.equiplist[index]={
        equipname=name,
        equiptype=type,
    }
    self:RefreshProperty()
    local eventName = StringId.new("AddEquip")
    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],index,name} , eventName)
end

-- 移除指定index的装备
function QiPlayerEquip:RemoveEquipByIndex(index)
    self.equiplist[index]["equipname"]=nil
    self:RefreshProperty()
    local eventName = StringId.new("AddEquip")
    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],index,nil} , eventName)
end

-- 取下装备
function QiPlayerEquip:UnEquipItem(index)
    local equipname=self.equiplist[index].equipname
    if equipname==nil then 
        QiBottomAlert("无法操作，该槽位没有装备",nil,self.aid)
        -- QiMsg("无法操作，该槽位没有装备", 4)
        return
    end
    if index==1 or index==2 then 
        QiBottomAlert("无法取下成长武器或者修炼法宝",nil,self.aid)
        -- QiMsg("无法取下成长武器或者修炼法宝", 4)
        return
    end
    local e_title=QiData.item_data[equipname]["m_itemTitle"]
    --成功给背包添加物品
    if PlayerController:GetBag(self.pid):AddItemByName(equipname,1)~=false then 
        QiMsg("已取下装备["..e_title.."]", 4)
        self:RemoveEquipByIndex(index)
    end
end