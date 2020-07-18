
if QiXiulian==nil then 
    QiXiulian={}
    QiXiulian.maxlevel=10
    QiXiulian.per_level_maxupdate=8
    QiXiulian.propertyList={}
    QiXiulian.CoseData={
        [1]=5,
        [2]=12,
        [3]=21,
        [4]=32,
        [5]=45,
        [6]=60,
        [7]=77,
        [8]=96,
        [9]=117,
        [10]=140,
    }
end

-- 每层奖励初始化
function QiXiulian:LevelDataInit()
    for i = 1,QiXiulian.maxlevel do
        QiXiulian.propertyList[i]={
            [1]={
                p_name="PhysicalDmg",
                p_value=QiData.smart_lua["player_phy_attack"][i]*0.4,
            },
            [2]={
                p_name="MagicalDmg",
                p_value=QiData.smart_lua["player_magic_attack"][i]*0.4,
            },
            [3]={
                p_name="PhysicalDef",
                p_value=QiData.smart_lua["player_armor_defence"][i]*0.4,
            },
            [4]={
                p_name="MagicalDef",
                p_value=QiData.smart_lua["player_magic_defence"][i]*0.4,
            },
            [5]={
                p_name="MaxHp",
                p_value=QiData.smart_lua["player_hp"][i]*0.4,
            },
        }
        -- 6号槽位
        if i%3==0 then 
            QiXiulian.propertyList[i][6]={
                p_name="PhysicalPenetration",
                p_value=20,
            }
        elseif i%3==1 then 
            QiXiulian.propertyList[i][6]={
                p_name="MagicalPenetration",
                p_value=20,
            }
        elseif i%3==2 then 
            QiXiulian.propertyList[i][6]={
                p_name="MaxMp",
                p_value=100,
            }
        end
        -- 7号槽位
        if i%3==0 then 
           --暴击伤害加15%
            QiXiulian.propertyList[i][7]={
                p_name="CriticalDmgBonus",
                p_value=1500,
            }
            -- 暴击率增加5%
        elseif i%3==1 then 
            QiXiulian.propertyList[i][7]={
                p_name="CriticalRate",
                p_value=500,
            }
        elseif i%3==2 then 
            QiXiulian.propertyList[i][7]={
                p_name="CoolDownTimeReduce",
                p_value=200,
            }
        end
        -- 8号槽位
        if i%2==0 then 
        --暴击伤害加15%
            QiXiulian.propertyList[i][8]={
                p_name="ExpAddPercent",
                p_value=25,
            }
            -- 暴击率增加5%
        elseif i%2==1 then 
            QiXiulian.propertyList[i][8]={
                p_name="GoldAddPercent",
                p_value=25,
            }
        end
        -- 设置升级价格
        for k,v in pairs( QiXiulian.propertyList[i]) do 
            v["p_cost"]=math.floor(QiXiulian.CoseData[i]*5*(1+i/2)*(1+k/8))
        end
    end
end

function QiXiulian:Init()
    QiXiulian:LevelDataInit()
end

--- 初始化
function QiXiulian:new(o,actor,pid)
    o=o or {}
    setmetatable(o,self)
    self.__index =self
    o.pid=pid
    o.unit=actor
    o.qihero=PlayerController:GetQiHero(pid)
    o.aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID )
    o.level=1
    o.thislevel_buyindex=1
    return o
end

function QiXiulian:SendPlayerInfo()
    local xiuliandata = self:ReturnXiulianData()
    local eventName = StringId.new("SendXiuLianData")
    sc.CallUILuaFunction(xiuliandata , eventName)
end

--- 获取修炼数据
function QiXiulian:ReturnYaotaData()
    local xiulian_data={
        self.aid,
        self.level,
        self.thislevel_buyindex,
    }
    return xiulian_data
end

function QiXiulian:SendPlayerInfo()
    local xiulian_data=self:ReturnYaotaData()
    local eventName = StringId.new("SendXiulianData")
    sc.CallUILuaFunction(xiulian_data , eventName)
    -- 依次发送每行单元格信息
    for i=1,QiXiulian.per_level_maxupdate do 
        local proerpty_data=QiXiulian.propertyList[self.level][i]
        local p_name=proerpty_data["p_name"]
        local p_value=proerpty_data["p_value"]
        local p_cost=proerpty_data["p_cost"]
        local eventName2 = StringId.new("SendXiulianProperty")
        local p_data={
            self.aid,
            i,
            self.thislevel_buyindex,
            p_name,
            p_value,
            p_cost,
        }
        sc.CallUILuaFunction(p_data , eventName2)
    end
end

--- 升级修炼项目
function QiXiulian:UpdateXiulian()
    if self.level>=QiXiulian.maxlevel and self.thislevel_buyindex>=QiXiulian.per_level_maxupdate then 
        QiBottomAlert("阁下修为惊人，在下已无力指导")
        return
    end

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

    local updata_data=QiXiulian.propertyList[self.level][self.thislevel_buyindex]
    local p_name=updata_data["p_name"]
    local p_value=updata_data["p_value"]
    local p_cost=updata_data["p_cost"]

    if self.qihero:CostGold(p_cost)==true then 
        self.qihero.base_property[p_name]=self.qihero.base_property[p_name]+p_value
        self.qihero:RefreshProperty()
        QiBottomAlert("<color=#33ccff>"..schinese_table[p_name].."</color>".."奖励".."<color=#ffff66>"..
                tostring(p_value).."</color>",nil,self.aid)
        self.thislevel_buyindex=self.thislevel_buyindex+1
        if self.thislevel_buyindex>QiXiulian.per_level_maxupdate then 
            self.level=self.level+1
            self.thislevel_buyindex=1
            QiBottomAlert("<color=#33ccff>".."修炼体悟".."</color>".."突破，解锁".."<color=#ffff66>"..
            tostring(self.level).."</color>".."阶修炼",nil,self.aid)
        end
        self:SendPlayerInfo()
    end

end

-- function QiXiulian