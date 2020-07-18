if QiBossChallenge==nil then 
    QiBossChallenge={}
    QiBossChallenge.BossName="unit_fb_bossfight_"
    QiBossChallenge.levelmax=10
    QiBossChallenge.roomlist={
        [1]={
            name="s1_boss_pos_1",
            index=701,
            isuse=false,
            pid=-1,
        },
        [2]={
            name="s1_boss_pos_2",
            index=702,
            isuse=false,
            pid=-1,
        },
    }
    QiBossChallenge.AotuRefreshTime=180
    QiBossChallenge.RewardList={
        "PhysicalDmg",
        "MagicalDmg",
        "PhysicalDef",
        "MagicalDef",
        "HpRegenRate",
        "PhysicalLifeSteal",
        "PhysicalPenetration",
        "MagicalPenetration",
        "CriticalRate",
        "CriticalDmgBonus",
        "AttackSpeedBonus",
        "DodgeRate",
    }
end

--初始化
function QiBossChallenge:init()
end

function QiBossChallenge:SendPlayerInfo()
    local yaota_data=self:ReturnChallenge()
    local eventName = StringId.new("SendBossChallengeData")
    sc.CallUILuaFunction(yaota_data , eventName)
end
-- 发送刷新时间
function QiBossChallenge:SendRefreshtime()
    local eventName = StringId.new("SendRefreshtime")
    sc.CallUILuaFunction({self.aid,self.refresh_time_remain,self.can_start_challenge} , eventName)
end

function QiBossChallenge:ReturnChallenge()
    local y_data={
        self.aid,
        self.level,
        cjson.encode(self.reward_list),
        self.floor_reward_list[self.level]["pname"],
        self.floor_reward_list[self.level]["pvalue"],
    }
    return y_data
end

function QiBossChallenge:ChangeBossLevel(change_level)
    if change_level==0 then 
        self.level=self.level-1 
    elseif change_level==1 then 
        self.level=self.level+1 
    end
    if self.level<=0 then 
        self.level=1
    elseif self.level>QiBossChallenge.levelmax then 
        self.level=QiBossChallenge.levelmax
    end
    self:SendPlayerInfo()
    return self.level
end

--- 新建背包
function QiBossChallenge:new(o,actor,pid)
    o=o or {}
    setmetatable(o,self)
    self.__index =self
    o.pid=pid
    o.unit=actor
    o.aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID )
    o.level=1
    o.reward_list={}
    for k,v in pairs(QiBossChallenge.RewardList) do 
        o.reward_list[v]=0
    end
    o.refresh_time_remain=QiBossChallenge.AotuRefreshTime
    o.floor_reward_list={}
    o.can_start_challenge=true
    o.su_fight_time=0
    o:MakeAllFloorReward()
    sc.SetTimer(1000, 0, 0 , function ()
        o.refresh_time_remain=o.refresh_time_remain-1
        o:SendRefreshtime()
        --刷新时间
        if o.refresh_time_remain<0 then 
            o.refresh_time_remain=QiBossChallenge.AotuRefreshTime
            o.can_start_challenge=true
            o:MakeAllFloorReward()
            o:SendPlayerInfo()
        end
    end, {})
    return o
end

-- 生成所有层数奖励
function QiBossChallenge:MakeAllFloorReward()
    for i=1,QiBossChallenge.levelmax do
        self.floor_reward_list[i]={
            pname=QiBossChallenge.RewardList[RandomInt(1,#QiBossChallenge.RewardList)],
            pvalue=i+5,
        }
    end
end

--- 获取一个可用的妖塔空间index
function QiBossChallenge:GetAvaliableRoom()
    local check_list=copy_table(QiBossChallenge.roomlist)
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

--- 开启挑战
function QiBossChallenge:StartChallenge()
    if self.can_start_challenge==true then 
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
    else 
        QiBottomAlert("挑战机会冷却中，过一会再来吧",nil,self.aid)
    end
end


-- 初始化怪物
function QiBossChallenge:UnitInitByLevel(level,room_data)
    local unit_name=QiBossChallenge.BossName..tostring(level)
    --设置刷怪数量

    local actor=nil 
    local spawn_pos=Entity[room_data["name"]]["pos"]
    actor=SpawnUnit(unit_name,spawn_pos,{},"normal")
    local boss_timer
    local boss_check_func=function ()
        if  PlayerController[self.pid]["area_index"]==room_data["index"] then
                if actor==nil or sc.IsActorEqualNull(actor)==true or sc.IsActorDead(actor)==true then 
                    sc.KillTimer(boss_timer)
                    self:BossComplte(level,room_data)
                end
        else
            self:BossFail()
            sc.RecycleActor(actor,0) 
            sc.KillTimer(boss_timer)
        end
    end
    -- 
    boss_timer=sc.SetTimer(1000, 0, 0 , boss_check_func, {})
end

-- BOSS完成 
function QiBossChallenge:BossComplte(level,room_data)
    -- 奖励实装
    local f_reward=self.floor_reward_list[level]
    self.reward_list[f_reward["pname"]]=self.reward_list[f_reward["pname"]]+f_reward["pvalue"]
    -- QiMsg("恭喜挑战成功了["..tostring(self.level).."]难度BOSS", 5, self.aid)
    local SChineseRewardList={
        PhysicalDmg="<color=#b1cce7>总物理伤害增幅</color>",
        MagicalDmg="<color=#b1cce7>总法术伤害增幅</color>",
        PhysicalDef="<color=#b1cce7>总护甲值增幅</color>",
        MagicalDef="<color=#b1cce7>总法术抗性增幅</color>",
        HpRegenRate="<color=#b1cce7>总生命每秒恢复增幅</color>",
        PhysicalLifeSteal="<color=#b1cce7>总物理生命汲取增幅</color>",
        PhysicalPenetration="<color=#b1cce7>总物理穿透增幅</color>",
        MagicalPenetration="<color=#b1cce7>总魔法穿透增幅</color>",
        CriticalRate="<color=#b1cce7>总暴击率增幅</color>",
        CriticalDmgBonus="<color=#b1cce7>总暴击伤害增幅</color>",
        AttackSpeedBonus="<color=#b1cce7>总攻击速度增幅</color>",
        DodgeRate="<color=#b1cce7>总闪避率增幅</color>",
     }
    self.su_fight_time=self.su_fight_time+1
    QiBottomAlert("恭喜挑战成功了["..tostring(self.level).."]难度BOSS",nil,self.aid)
    QiBottomAlert(SChineseRewardList[f_reward["pname"]].."   "..tostring(f_reward["pvalue"]).."",nil,self.aid)
    self.can_start_challenge=false
end

-- 妖塔失败
function QiBossChallenge:BossFail()
    QiMsg("您放弃了挑战，此次挑战不计入挑战次数，您可以继续挑战", 5, self.aid)
end