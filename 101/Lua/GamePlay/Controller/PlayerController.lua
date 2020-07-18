if PlayerController==nil then 
    PlayerController={}
    PlayerController.respawn_entityname="player_respawn_pos"
    PlayerController["aidlist"]={}
    PlayerController["liangong"]={
        [0]="player_farmrroom_pos_1",
        [1]="player_farmrroom_pos_2",
        [2]="player_farmrroom_pos_3",
        [3]="player_farmrroom_pos_4",
    }
    PlayerController.nowplayer=0
    for i=0,GAME_MAX_PLAYER-1 do 
        PlayerController[i]={}
        PlayerController[i]["pid"]=i
        PlayerController[i]["ugcpid"]=-1
        PlayerController[i]["actor"]=nil 
        PlayerController[i]["actorid"]=nil 
        PlayerController[i]["QiHero"]=nil
        PlayerController[i]["QiBag"]={}
        PlayerController[i]["QiPlayerEquip"]={}
        PlayerController[i]["camp"]=nil
        PlayerController[i]["QiBossChallenge"]=nil
        PlayerController[i]["QiXiulian"]=nil
        PlayerController[i]["QiWish"]={}
        PlayerController[i]["QiQuest"]={}
        PlayerController[i]["QiYaota"]={}
        PlayerController[i]["QiSuanming"]={}
        PlayerController[i]["player"]={}
        PlayerController[i]["area_index"]=99
    end
end

function PlayerController:GetPlayerIdByActor(actor)
    for i=0,GAME_MAX_PLAYER-1 do 
        if PlayerController[i]["actor"]==actor then 
            return i 
        end
    end
    return -1
end

function PlayerController:SwtichHero(pid,cfg,skin)
    local p_actor=PlayerController[pid]["actor"]
    local p_hero=PlayerController:GetQiHero(pid)
    local pos= sc.GetActorLogicPos(p_actor)
    local actor = sc.SpawnActor( sc.GameObject_Nil , pos, VInt3.new(-180+RandomInt(360), 0, -180+RandomInt(360)) , 
        tonumber(cfg), 0, PlayerController[pid]["camp"] , false, true,tonumber(2))
    local ugc_pid =PlayerController[pid]["ugcpid"]
    sc.UGCDisconnectActorFromPlayer(p_actor)
    local send_data= {
        playerid=ugc_pid,
        cfg=tonumber(cfg),
        skin=tonumber(skin),
        pid=pid,
    }
    sc.UGCSwitchCaptain(ugc_pid, actor)
    sc.UGCSendMsg("SwtichHero",send_data)
    sc.UGCSwitchCaptain(ugc_pid, actor)

    -- PlayerController:InitPlayerInfo(ugc_pid,pid)
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @author 
function PlayerController:GetAllPlayerActor()
    local player_list={}
    for i=0,GAME_MAX_PLAYER-1 do 
        if  PlayerController[i]["actor"]~=nil then 
            player_list[#player_list+1]=PlayerController[i]["actor"]
        end
    end
    return player_list
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @author 
function PlayerController:GetAllPlayerAearIndex()
    local area_list={}
    for i=0,GAME_MAX_PLAYER-1 do 
        if  PlayerController[i]["area_index"]~=nil then 
            area_list[#area_list+1]=PlayerController[i]["area_index"]
        end
    end
    return area_list
end

--- 获得一个代码中通用的PID，默认第一个玩家是0
function PlayerController:GetPlayerPID()
    local p_num=PlayerController.nowplayer
    PlayerController.nowplayer=PlayerController.nowplayer+1
    return p_num
end

function PlayerController:AIDToPID(aid)
end

-- 初始化一个玩家的数据
function PlayerController:PlayerInit(playerid)
    QiMsg("初始化玩家数据"..tostring(playerid),4)
    -- 防止多次初始化
    if PlayerController[playerid] ==nil then 
        PlayerController[playerid]=0 
    else
        return
    end
    print("PlayerController:PlayerInit"..tostring(playerid))
    -- ===============玩家id===============
    local pid=PlayerController:GetPlayerPID(playerid)--默认玩家0
    PlayerController.respawn_entityname="player_respawn_pos"
    QiMsg("正在初始化玩家数据[pid].."..tostring(pid), 5)
    if PlayerController[pid]["ugcpid"]~=-1 then 
        QiPrint("PlayerInit Error AreadyInit",3)
        return
    end
    PlayerController:InitPlayerInfo(playerid,pid)
    PlayerController:InitQiModel(playerid,pid)
    -- QiPrint("player send bag")
    -- local eventName = StringId.new("qibag_recivebagInfo")
    -- sc.CallUILuaFunction({"item_dragger_1_sadljkjasldjaslkdja",1,5} , eventName)
end

function PlayerController:InitPlayerInfo(playerid,pid)
    PlayerController[playerid]=pid
    PlayerController[pid]["ugcpid"]=playerid
    PlayerController[pid]["actor"]= sc.GetControlActorByPlayerID(playerid)
    PlayerController[pid]["actorid"]= sc.GetActorSystemProperty(PlayerController[pid]["actor"],ActorAttribute_ActorID)
    PlayerController[pid]["camp"]=sc.GetActorSystemProperty(PlayerController[pid]["actor"],ActorAttribute_ActorCamp  )
    PlayerController[pid]["player"]=sc.GetPlayerByID(playerid)
    -- local actors = sc.GetActorsByPlayer(PlayerController[pid]["player"])
    -- local a_list={}
    -- sc.TraverseActorArray(actors, function (actor)
    --     a_list[#a_list+1]=actor
    -- end)
    -- sc.UGCSwitchCaptain(playerid, a_list[#a_list])
    QiMsg("获取ugcid"..tostring(playerid).."pid"..tostring(pid).."aid"..tostring(PlayerController[pid]["actorid"]), 5)
    PlayerController["aidlist"][PlayerController[pid]["actorid"]]=pid
    QiMsg("设置出生点"..tostring(playerid),4) 
    --设置玩家出生点
    sc.ActorConfigSpawn(Entity[PlayerController.respawn_entityname]["m_binderObj"]);--44
    sc.SpawnPlayer(Entity[PlayerController.respawn_entityname]["position"],Entity[PlayerController.respawn_entityname]["forward"],
    Entity[PlayerController.respawn_entityname]["m_binderObj"],DOTA_TEAM_GOODGUYS, pid);
    -- sc.SpawnPlayer(Entity[PlayerController.respawn_entityname]["position"],Entity[PlayerController.respawn_entityname]["forward"],
    -- Entity[PlayerController.respawn_entityname]["m_binderObj"],DOTA_TEAM_GOODGUYS, 1);
end

function PlayerController:InitQiModel(playerid,pid)
    --初始化英雄
    QiMsg("初始化装备栏"..tostring(playerid),4)
    PlayerController[pid]["QiPlayerEquip"]=QiPlayerEquip:new(PlayerController[pid]["QiPlayerEquip"],PlayerController[pid]["actor"],pid)
    QiMsg("初始化背包"..tostring(playerid),4)
    PlayerController[pid]["QiBag"]=QiBag:new(PlayerController[pid]["QiBag"],PlayerController[pid]["actor"],pid)
    QiMsg("初始化英雄"..tostring(playerid),4)
    PlayerController[pid]["QiHero"]=QiHero:new(PlayerController[pid]["QiHero"],PlayerController[pid]["actor"],pid)
    QiMsg("初始化任务"..tostring(playerid),4)
    PlayerController[pid]["QiQuest"]=QiQuest:new(PlayerController[pid]["QiQuest"],PlayerController[pid]["actor"],pid)
    QiMsg("初始化妖塔"..tostring(playerid),4)
    PlayerController[pid]["QiYaota"]=QiYaota:new(PlayerController[pid]["QiYaota"],PlayerController[pid]["actor"],pid)
    PlayerController[pid]["QiBossChallenge"]=QiBossChallenge:new(PlayerController[pid]["QiBossChallenge"],PlayerController[pid]["actor"],pid)
    PlayerController[pid]["QiXiulian"]=QiXiulian:new(PlayerController[pid]["QiXiulian"],PlayerController[pid]["actor"],pid)
    PlayerController[pid]["QiSuanming"]=QiSuanming:new(PlayerController[pid]["QiSuanming"],PlayerController[pid]["actor"],pid)
    PlayerController[pid]["QiWish"]=QiWish:new(PlayerController[pid]["QiWish"],PlayerController[pid]["actor"],pid)
end

function PlayerController:GetNearPlayer(actor)
    local now_pos=sc.GetActorLogicPos(actor)
    local near_player=nil
    local max_distance=999999
    for i=0,GAME_MAX_PLAYER-1 do 
        if PlayerController[i]["actor"]~=nil then 
            local t_pos=sc.GetActorLogicPos(PlayerController[i]["actor"])
            local target_dis= twoPointToDistance(now_pos.x,now_pos.z,t_pos.x,t_pos.z)
            if target_dis<max_distance then 
                max_distance=target_dis
                near_player=PlayerController[i]["actor"]
            end
        end
    end
    return near_player,max_distance
end

--- 获得背包
function PlayerController:GetBag(pid)
    return PlayerController[pid]["QiBag"]
end

--- 获取装备
function PlayerController:GetPlayerEquip(pid)
    return PlayerController[pid]["QiPlayerEquip"]
end

--- 获取QiHero
function PlayerController:GetQiHero(pid)
    return PlayerController[pid]["QiHero"]
end

--- 获取QiQuest
function PlayerController:GetQiQuest(pid)
    return PlayerController[pid]["QiQuest"]
end

--- 
function PlayerController:SkillInit(pid)
    
    
end

---收到bag操作命令
function PlayerController:ReciveBagCommand(zipmsg)
    local aid=tonumber(zipmsg[2])
    local cs=zipmsg[3]
    local pid=PlayerController["aidlist"][aid]
    -- local item_str=message.item
    local select_type=tonumber(zipmsg[4])
    local select_item=zipmsg[5]
    local index=tonumber(zipmsg[6])
    if cs=="bag_use" then 
        if select_type==2 then 
            PlayerController:GetBag(pid):EquipItem(index)
        elseif select_type==1 then 
            PlayerController:GetPlayerEquip(pid):UnEquipItem(index)
        end
    elseif cs=="bag_sell" then 
        PlayerController:GetBag(pid):SellItem(index)
    end
end

-- function PlayerController:AskPlayerInfo()
--     sc.UGCSendMsg(msgName, table)
-- end