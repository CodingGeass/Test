
if QiYaota==nil then 
    QiYaota={}
    QiYaota.roomlist={
        [1]={
            name="s1_yaota_pos_1",
            index=601,
            isuse=false,
            pid=-1,
        },
        [2]={
            name="s1_yaota_pos_2",
            index=602,
            isuse=false,
            pid=-1,
        },
    }
    QiYaota.MonsterData={}
    QiYaota.MonsterTierNext=8--每8层划分一个Tier 8*1296
    QiYaota.RewardList={
        "PhysicalDmg",
        "MagicalDmg",
        "PhysicalDef",
        "MagicalDef",
        "HpRegenRate",
    }
end

function QiYaota:Init()
    for i =1,100 do 
        QiYaota.MonsterData[i]="unit_fb_1_huayao"
    end
end

--- 新建背包
function QiYaota:new(o,actor,pid)
    o=o or {}
    setmetatable(o,self)
    self.__index =self
    o.pid=pid
    o.unit=actor
    o.qihero=PlayerController:GetQiHero(pid)
    o.aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID )
    o.reward_point=0--苦难点数
    o.level=1
    --保存累计的属性增加值
    o.property_add_list={
        PhysicalDmg=0,
        MagicalDmg=0,
        PhysicalDef=0,
        MagicalDef=0,
        HpRegenRate=0,
    }
    o.this_floor_reward={}-- 当前层数奖励.
    sc.SetTimer(10000, 0, 0 , function ()
        for k,v in pairs(o.property_add_list) do 
            o.qihero.base_property[k]=o.qihero.base_property[k]+math.floor(v*10)
            -- 发送刷新数据请求
            -- local eventName = StringId.new("BagRefreshProperty")
            -- sc.CallUILuaFunction({o.aid} , eventName)
            -- BagRefreshProperty(aid)
            -- UnitController:AskHeroProperty(o.aid,_G["ActorAttribute_"..k])
        end
        -- 向UI发送刷新数据
        o.qihero:RefreshProperty()
        -- BagRefreshProperty(aid)
    end, {})
    o:MakeThisFloorRreward()
    return o
end

function QiYaota:GetTierAndPropertyAdd()
    local tier=math.floor(self.level/QiYaota.MonsterTierNext+1)
    local proerptyadd=self.level%QiYaota.MonsterTierNext*10
    proerptyadd=proerptyadd/100+1
    return tier,proerptyadd
end

-- 生成当前层数奖励
function QiYaota:MakeThisFloorRreward()
    self.this_floor_reward={}
    for k,v in pairs(QiYaota.RewardList) do 
        self.this_floor_reward[v]=0
    end
    local tier,pro_add=self:GetTierAndPropertyAdd()
    local reward1=QiYaota.RewardList[math.random(1,#QiYaota.RewardList)]
    local reward2=QiYaota.RewardList[math.random(1,#QiYaota.RewardList)]
    for k,v in pairs({reward1,reward2}) do 
        if v=="PhysicalDmg" then 
            self.this_floor_reward["PhysicalDmg"]=self.this_floor_reward["PhysicalDmg"]+math.floor(QiData.smart_lua["player_phy_attack"][tier]*pro_add)*0.004+0.01
        elseif v=="MagicalDmg" then 
            self.this_floor_reward["MagicalDmg"]=self.this_floor_reward["MagicalDmg"]+math.floor(QiData.smart_lua["player_magic_attack"][tier]*pro_add)*0.004+0.01
        elseif v=="PhysicalDef" then 
            self.this_floor_reward["PhysicalDef"]=self.this_floor_reward["PhysicalDef"]+math.floor(QiData.smart_lua["player_armor_defence"][tier]*pro_add)*0.004+0.01
        elseif v=="MagicalDef" then 
            self.this_floor_reward["MagicalDef"]=self.this_floor_reward["MagicalDef"]+math.floor(QiData.smart_lua["player_magic_defence"][tier]*pro_add)*0.004+0.01
        elseif v=="HpRegenRate" then 
            self.this_floor_reward["HpRegenRate"]=self.this_floor_reward["HpRegenRate"]+math.floor(QiData.smart_lua["player_hp"][tier]*pro_add)*0.004*0.01+0.01
        end
    end
    return self.this_floor_reward
end

function QiYaota:SendPlayerInfo(pid)
    local h_yaota=PlayerController[pid]["QiYaota"]
    local yaota_data=h_yaota:ReturnYaotaData()
    local eventName = StringId.new("SendYaotaData")
    sc.CallUILuaFunction(yaota_data , eventName)
    h_yaota:SendAreadyGetProperty()
    h_yaota:SendNextUnitInfo()
end

-- 获得已得到属性
function QiYaota:SendAreadyGetProperty()
    local eventName = StringId.new("SendAreadyGetProperty")
    sc.CallUILuaFunction({
        self.property_add_list["PhysicalDmg"],
        self.property_add_list["MagicalDmg"],
        self.property_add_list["PhysicalDef"],
        self.property_add_list["MagicalDef"],
        self.property_add_list["HpRegenRate"],
        self.aid,
    } , eventName)
end


-- 发送下层怪物属性
function QiYaota:SendNextUnitInfo()
    local attack,defence,hp,attackspeed,fightpower=self:GetUnitInfo()
    local eventName = StringId.new("SendNextUnitInfo")
    sc.CallUILuaFunction({
        self.level,
        hp,
        attack,
        defence,
        fightpower,
        self.aid,
    } , eventName)

end
function QiYaota:ReturnYaotaData()
    local p1="null"
    local p2="null"
    for k,v in pairs(self.this_floor_reward) do
        if v==0 then 
            self.this_floor_reward[k]=nil 
        end
    end
    for k,v in pairs(self.this_floor_reward) do
        if p1=="null" then 
            p1=tostring(k).."|"..tostring(v) 
        elseif p2=="null" then 
            p2=tostring(k).."|"..tostring(v) 
        end
    end
    local y_data={
        self.aid,
        self.level,
        self.reward_point,
        p1,
        p2,
    }
    return y_data
end

-- 获取一个可用的妖塔空间index
function QiYaota:GetAvaliableRoom()
    local check_list=copy_table(QiYaota.roomlist)
    for k,v in pairs(check_list) do
        for pid,index in pairs(PlayerController:GetAllPlayerAearIndex()) do 
            if v["index"]==index then
                check_list[k]=nil
            end
        end
    end
    -- 返回选择好了的数据
    for k,v in pairs(check_list) do 
        return v
    end
    return nil
end

-- 房间开始
function QiYaota:StartRoom()
    local room_data=self:GetAvaliableRoom()
    if room_data~=nil then 
    -- 设置玩家区域
        TeleportController:SetPlayerArea(self.pid,room_data["index"])
        sc.TeleportActor(self.unit,sc.GameObject_Nil,Entity[room_data["name"]]["pos"],Entity[room_data["name"]]["forward"])
        self:UnitInitByLevel(self.level,room_data)
    else
        QiBottomAlert("房间已满",nil,self.aid)
        QiMsg("房间已满", 1, self.aid)
    end
end

-- 初始化怪物
function QiYaota:UnitInitByLevel(level,room_data)
    local unit_name="unit_fb_yaota_monster_"..tostring(level)
    --设置刷怪数量
    local spawn_num=12 
    if level%10==0 then 
        spawn_num=1 
    end
    local actor_list={}
    for i=1,spawn_num do 
        local spawn_pos=FindRandomPoint(Entity[room_data["name"]]["pos"],4000)
        actor_list[#actor_list+1]=SpawnUnit(unit_name,spawn_pos,{},"normal")
    end
    self:SetUnitData(actor_list)
    local yaota_timer
    local yaota_check_func=function ()
        if  PlayerController[self.pid]["area_index"]==room_data["index"] then
            local is_unit_all_die=true
            -- 将死了的单位从列表中剔除
            for k,v in pairs(actor_list) do 
                if v==nil or sc.IsActorEqualNull(v)==true or sc.IsActorDead(v)==true then 
                    actor_list[k]=nil
                end
            end

            for k,v in pairs(actor_list) do 
                is_unit_all_die=false 
            end
            --所有单位击杀 副本结束
            if is_unit_all_die==true then 
                sc.KillTimer(yaota_timer)

                self:YaotaComplte(level,room_data)
            end
        else
            self:YaotaFail()
            for k,v in pairs(actor_list) do
                sc.RecycleActor(v,0) 
            end
            sc.KillTimer(yaota_timer)
        end
        -- if 
    end
    -- 
    yaota_timer=sc.SetTimer(1000, 0, 0 , yaota_check_func, {})
end

function QiYaota:GetUnitInfo()
       
    local tier,pro_add=self:GetTierAndPropertyAdd()
    local attack=QiData.smart_lua["player_underattack_phy"][tier]*pro_add*0.03
    local attackspeed=tier*3000
    local defence=QiData.smart_lua["unit_armor_defence"][tier]*pro_add
    local hp=QiData.smart_lua["player_dps_defence"][tier]*10*pro_add

    local armor_reduce=(defence/(defence+602))
    local denfence_value=hp/(1-armor_reduce)
    local attack_value=(1+attackspeed/12000)*attack
    -- local fightpower=attack*
    return attack,defence,hp,attackspeed,(denfence_value+attack_value)/2
end

--- 设置妖塔怪物属性
function QiYaota:SetUnitData(u_list)
    local attack,defence,hp,attackspeed,fightpower=self:GetUnitInfo()
    for k,v in pairs(u_list) do 
        QiUnit:SetProperty(v,{hp=hp,attack=attack,defence=defence,attackspeed=attackspeed})
    end
end


-- 妖塔完成
function QiYaota:YaotaComplte(level,room_data)
    self.level=self.level+1
    if self.level>=100 then 
        self.level=100 
    end
    local property_res={
        PhysicalDmg="奖励<color=#1aff1a>每100秒</color><color=#33ccff>物理攻击</color>增加",
        MagicalDmg="奖励<color=#1aff1a>每100秒</color><color=#33ccff>法术攻击</color>增加",
        PhysicalDef="奖励<color=#1aff1a>每100秒</color><color=#33ccff>护甲值</color>增加",
        MagicalDef="奖励<color=#1aff1a>每100秒</color><color=#33ccff>魔法抗性</color>增加",
        HpRegenRate="奖励<color=#1aff1a>每100秒</color><color=#33ccff>血量每秒恢复值</color>增加",
    }
    -- 应用属性奖励
    for k,v in pairs(self.this_floor_reward) do 
        if tonumber(v)~=0 then 
            QiBottomAlert(property_res[k]..tostring(math.floor(v*100)),nil,self.aid)
        end
        self.property_add_list[k]= self.property_add_list[k]+v
    end
    QiBottomAlert("恭喜你完成了["..tostring(self.level).."]层挑战",nil,self.aid)
    self:MakeThisFloorRreward()
    QiMsg("恭喜你完成了["..tostring(self.level).."]层挑战", 5, self.aid)
    self:UnitInitByLevel(self.level,room_data)
end

-- 妖塔失败
function QiYaota:YaotaFail()
    QiMsg("您放弃了挑战，任务失败", 5, self.aid)
end