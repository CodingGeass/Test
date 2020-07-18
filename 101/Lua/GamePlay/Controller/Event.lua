-- 游戏引擎事件管理
if Event==nil then 
    Event={}
end
--- 部分事件初始化
function Event:EventInit()
    QiPrint("EventInit",3)
end

function Event:UpdateLogic()
    QiPrint("UpdateLogic")
end

--- 每帧触发事件
function Event:GameUpdateLogicEventNode()
    QiPrint("QiGameUpdate")
end

--- 准备关卡数据
function Event:FightPrepare()
    QiPrint("FightPrepare")
end

--- 开始关卡
function Event:FightStart()
    QiPrint("FightStart",3)
    -- sc.SetTimer(1000, 1, 8 , OnTimer, {})
    -- sc.SetTimer(1000, 0, 0 , ConsoleTimer, {})
end

--- 角色生存事件
function Event:ActorStartFight()

end

--- Actor死亡事件
-- function detail description.
-- @tparam  type src 死亡源
-- @tparam  type atker 攻击者
-- @tparam  type orignalAtker 原始攻击者 (塔杀死目标的话， 原始攻击者就是塔. 逻辑攻击者就是玩家)
-- @tparam  type logicAtker 逻辑攻击者
-- @tparam  type bImmediateRevive 是否为立即复活 (复活甲会传True)
-- @author  
function Event:ActorDead(victim,attacker,orignalAtker,logicAtker,bImmediateRevive)
    QiPrint("actor_dead")
    -- local
    local victim_pos=sc.GetActorLogicPos(victim)
    local victim_actorid=sc.GetActorSystemProperty(victim,1004)
    local attacker_actorid=sc.GetActorSystemProperty(attacker,1004)
    local victim_cfgid=sc.GetActorSystemProperty(victim,1000)
    sc.TerminateMove(victim)
    local pid=PlayerController["aidlist"][attacker_actorid]
    for i=0,GAME_MAX_PLAYER-1 do 
        if PlayerController[i]["actor"]==victim then 
            PlayerController[i]["area_index"]=99
            PlayerController[i]["QiHero"]:roledie(attacker)
            QiPrint("Player dies ["..tostring(i).."]".."reset area_index")
        end
    end
    -- 基地炸了
    if victim_cfgid==9146  then 
        GameController:GameEnd(false)
    end
    -- 撸死了最终BOSS
    if victim_cfgid==1109  then 
        GameController:GameEnd(true)
    end
    -- 判断是我们玩家杀死了怪物
    if pid~=nil then 
        -- 让单位停止移动并播放死亡动画
        sc.RealMovePosition(victim,sc.GetActorLogicPos(victim))
        sc.PlayActorAnimation(victim, StringId.new("Dead"), 0, 0, false,false, false)
        local unit_data=SpawnController:GetUnitDataByAID(victim_actorid)
        if unit_data~=nil then 
            sc.RecycleActor(victim,5000)
            PlayerController:GetQiQuest(pid):KillUnitFunc(unit_data["unit_config_id"])
            local qihero= PlayerController[pid]["QiHero"]
            qihero:GrowWeaponKill(1)
            qihero:AddKillPoint()
            qihero:KillActor(victim,victim_actorid)
            local u_tier=unit_data["unit_tier"]
            --进行经验奖励相关
            if unit_data["unit_exp_tier"] then 
                local exp_add=unit_data["unit_exp_tier"]*QiData.exp_data[u_tier]["base_exp"]
                local gold_add=unit_data["unit_gold_tier"]*QiData.exp_data[u_tier]["level_base_gold"]
                qihero:AddExp(exp_add,u_tier)
                qihero:AddGold(gold_add,u_tier)
            end
            -- 进行掉落数据相关
            if unit_data["DropList"]~=nil then 
                -- 读取每条掉落数据
                local drop_data=Split(tostring(unit_data["DropList"]), "&")
                for __,drop_data_row in pairs(drop_data) do 
                    local drop_row_info=Split(drop_data_row,"|")
                    local drop_num=tonumber(drop_row_info[1])
                    local drop_changce=tonumber(drop_row_info[2])
                    if drop_changce~=nil and drop_changce>=math.random(100) then 
                        DropItemController:CreateDropByDropID(drop_num,victim_pos)
                    end
                end
            end
        end
    end
end

--- 技能使用事件
-- function detail description.
-- @tparam  type src 使用者
-- @tparam  type target 目标
-- @tparam  type slot 技能槽位
-- @tparam  type skill_Id 技能ID
-- @author 
function Event:UseSkill(caster,target,slot,skill_Id)
    -- if skill_Id==15210 then 
    --     local c_pos=sc.GetActorLogicPos(caster)
    --     local base_dis=2000
    --     local base_forward=VInt3.new(1000,0,0)
    --     local radio=12000
    --     local attack_pos_func=function (caster,pos)
    --         -- pos= VInt3.new(pos.x,pos.y+500,pos.z)
    --         local s1=StringId.new("Prefab_Skill_Effects/Common_Effects/PVE_talent/rizhita_zhaohuan_zhangkong.prefab")
    --         local u_object=sc.GetUnityObjectFromActorRoot(caster)
    --         local particle=sc.TriggerParticleStart (s1, s1, s1,
    --         caster, false, u_object, pos, VInt3.new(0, 0,0),VInt3.new(-5000,-5000,-5000), true,true)
    --         sc.SetTimer(5000, 1, 1, function ()
    --             sc.TriggerParticleEnd (particle)
    --         end, {})
    --     end
    --     local actors = sc.GetActorsInRange(caster, c_pos, radio, false)
    --     sc.TraverseActorArray(actors,function (actor)
    --         if sc.GetActorSystemProperty(actor,ActorAttribute_ActorCamp)==DOTA_TEAM_BADGUYS then 
    --             local aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID)
    --             if aid~=nil and SpawnController.UnitListByActorId[aid] then 
    --                 sc.BuffAction(actor,caster,true,true,15229001,15220001,0)
    --             end
    --         end
    --     end)
    --     local func_num={
    --         [1]=1,
    --         [2]=2,
    --         [3]=3,
    --         [4]=4,
    --         [5]=5,
    --     }
    --     for i=1,5 do 
    --         local func_num_final=func_num[i] 
    --         for j=1,func_num_final do 
    --             local dir_per=360/func_num_final
    --             -- c_pos+
    --             local sim_dir=dir_rotation(base_forward,dir_per*j)
    --             local posvalue=VInt3.new(sim_dir.x*(i-1)*4, sim_dir.y*(i-1)*4,sim_dir.z*(i-1)*4)
    --             attack_pos_func(caster,posvalue)
    --         end
    --     end
    --     -- QiPrint("UseSkill")
    -- elseif skill_Id==15220 then 
    --     local c_pos=sc.GetActorLogicPos(caster)
    -- end
end


--- 触发器触发事件
-- function detail description.
-- @tparam  type trigger description
-- @tparam  type gameObject description
-- @tparam  type bEnterOrLeave description
-- @tparam  type src description
-- @author 
function Event:OnShapeTriggerEvent(trigger,gameObject,bEnterOrLeave,src)
end

--Gameplay Lua接收逻辑图发送的事件
function OnRecvUGCMsg(eventName, data) 
    print("OnRecvUGCMsgLua")
    print(eventName)
    --接受startup.gl中的playeridstartup_playerid_init 
    if tostring(eventName) == "startup_playerid_init" then
        QiMsg("GamePlayer收到初始化请求",4)
        print("OnRecvUGCMsgLua event"..tostring(data.playerid).." | "..tostring(data.heroid).." | "..tostring(data.index))
        local playerids=data.playerids
        for k,v in pairs(playerids) do 
            print(tostring(k).."|".."playerids|"..tostring(v))
            PlayerController:PlayerInit(v)
        end
    elseif tostring(eventName) == "switchheroinit" then
        PlayerController:InitPlayerInfo(tonumber(data.playerid),tonumber(data.pid))
    end
end

function Event:OnReceiveAgeCustomEvent(action, intArr, stringArr)
    local strVal=stringArr:At(0)
    local caster = sc.GetAgeActorRoot(action,0)
    local target = sc.GetAgeActorRoot(action,1)
    if strVal~=nil then
        strVal=strVal:ToString():AsCStr()
        if _G[strVal]~=nil then 
            _G[strVal]({action=action,intArr=intArr,stringArr=stringArr,caster=caster,target=target})
        end
    end
    --获取functionName
    -- local functionName = sc.GetAGERefParam(action,StringId.new("functionName"),22):ToString():AsCStr()
    -- if functionName == "functionA" then
    --     print("TestCase1"..functionName)
    --     local actorA = sc.GetAgeActorRoot(action,0)
    --     local actorB = sc.GetAgeActorRoot(action,1)
    --     local CfgIdA = sc.GetActorSystemProperty(actorA,1000)
    --     local CfgIdB = sc.GetActorSystemProperty(actorB,1000)
    --     print("cfgIDA"..CfgIdA)
    --     print("cfgIDB"..CfgIdB)
    --     local Pos = sc.GetAGERefParam(action,StringId.new("Pos"),29)
    --     print("x", Pos.x)
    --     print("y", Pos.y)
    --     print("z", Pos.z)
    --     local UObject = sc.GetAgeGameObject(action,3)
    --     print(UObject)
    -- elseif functionName == "functionB" then
    --   print("TestCase2"..functionName)
    --   --获取UnityObject
    --     local intVal = intArr:At(0)
    --     local strVal = stringArr:At(0)
    --     print(action)
    --     print("IntArr:", intVal)
    --     print("StrVal:", strVal:ToString():AsCStr())
    -- end
end