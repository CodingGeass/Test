if QiUnit==nil then 
    QiUnit={}
end
function QiUnit:new(o,unit,unit_name)
    o=o or {}
    o.unit=unit
    setmetatable(o,self)
    self.__index =self
    o.unit_name=unit_name
    o:InitPropertyByUnitName(unit_name)
    -- unit.QiUnit=o
    return o
end

-- 根据怪物属性初始化单位
function QiUnit:InitPropertyByUnitName(unit_name)
    if QiData.unit_property[unit_name] then 
        for k,v in pairs(QiData.unit_property[unit_name]) do
            local att_key_str="ActorAttribute_"..k
            local att_key=_G[att_key_str]
            if att_key and type(att_key)=="number" then 
                -- 有小数就会报错
                sc.SetActorSystemProperty(self.unit,att_key,math.floor(tonumber(v)))
            end
        end
        if QiData.unit_property[unit_name]["unit_model_scale"]~=nil then
            if unit_name=="unit_fb_2_jiulonglouluo" then
                QiPrint("unit_fb_2_jiulonglouluo"..tostring(tonumber(QiData.unit_property[unit_name]["unit_model_scale"])),3)
            end
            sc.SetActorMeshScale(self.unit,math.floor(tonumber(QiData.unit_property[unit_name]["unit_model_scale"])*1000))
        end
        --将血蓝设置到最大值
        sc.SetActorSystemProperty(self.unit,ActorAttribute_HP,sc.GetActorSystemProperty(self.unit,ActorAttribute_MaxHp))
        sc.SetActorSystemProperty(self.unit,ActorAttribute_MP,sc.GetActorSystemProperty(self.unit,ActorAttribute_MaxMp))
    else 
        QiPrint("cant find unit property",5)
    end
end

function QiUnit:SetProperty(actor,data)
    if actor~=nil then 
        local hp=data.hp or nil
        local attack=data.attack or nil
        local defence=data.phy_defence or nil
        local attackspeed=data.attackspeed or nil
        if hp~=nil then 
            hp=math.floor(hp)
            sc.SetActorSystemProperty(actor,ActorAttribute_MaxHp,hp)
            sc.SetActorSystemProperty(actor,ActorAttribute_HpRegenRate,math.floor(hp*0.01))
            sc.SetActorSystemProperty(actor,ActorAttribute_HP,sc.GetActorSystemProperty(actor,ActorAttribute_MaxHp))
        end
        if attack~=nil then 
            attack=math.floor(attack)
            sc.SetActorSystemProperty(actor,ActorAttribute_PhysicalDmg,attack)
            sc.SetActorSystemProperty(actor,ActorAttribute_MagicalDmg,attack)
        end
        if defence~=nil then 
            defence=math.floor(defence)
            sc.SetActorSystemProperty(actor,ActorAttribute_PhysicalDef,defence)
            sc.SetActorSystemProperty(actor,ActorAttribute_MagicalDef,defence)
        end
        if attackspeed~=nil then 
            attackspeed=math.floor(attackspeed)
            sc.SetActorSystemProperty(actor,ActorAttribute_AttackSpeedBonus,attackspeed)
        end
    end
end