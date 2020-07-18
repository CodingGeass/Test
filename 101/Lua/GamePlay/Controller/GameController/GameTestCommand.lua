

function OnReceiveUGCCommand(playerId, JasonBuff)
    QiPrint("OnReceiveUGCCommand"..JasonBuff)
    local zip_msg=Split(JasonBuff,"|")
    --是压缩过的
    
    if JasonBuff==nil or JasonBuff=="" then 
        QiMsg("【错误】从UX接受到了空命令", 5)
        return
    end
    if #zip_msg>1 then 
        local fnam=zip_msg[1]
        if fnam=="bcmd" then
            PlayerController:ReciveBagCommand(zip_msg)
        elseif fnam=="console" then 
            GameController:ReciveConsoleCMD(zip_msg)
        elseif fnam=="select_item" then 
            DropItemController:PickItem(PlayerController["aidlist"][tonumber(zip_msg[2])])
        elseif fnam=="askpro" then 
            UnitController:AskHeroProperty(tonumber(zip_msg[2]),tonumber(zip_msg[3]))   
        elseif fnam=="kutong_info" then 
            QiYaota:SendPlayerInfo(PlayerController["aidlist"][tonumber(zip_msg[2])])
        elseif fnam=="kutong_start" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiYaota"]:StartRoom()
        elseif fnam=="boss_info" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiBossChallenge"]:SendPlayerInfo()
        elseif fnam=="boss_start" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiBossChallenge"]:StartChallenge()
        elseif fnam=="boss_changelevel" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiBossChallenge"]:ChangeBossLevel(tonumber(zip_msg[3]))
        elseif fnam=="xiulian_info" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiXiulian"]:SendPlayerInfo()
        elseif fnam=="xiulian_level_up_btn" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiXiulian"]:UpdateXiulian()
        elseif fnam=="quest_click" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiQuest"]:QuestUIClick()
        elseif fnam=="fate_askbtn" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiSuanming"]:PlayerChooseFate()
        elseif fnam=="fate_info" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiSuanming"]:SendSuanmingData()
        elseif fnam=="wish_btn_click" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiWish"]:AskWishBtnClick(tonumber(zip_msg[3]))
        elseif fnam=="ask_wish_data" then 
            PlayerController[PlayerController["aidlist"][tonumber(zip_msg[2])]]["QiWish"]:SendWishData()
        elseif fnam=="shop_buy_item" then 
            QiShop:ButItemByName(tonumber(zip_msg[2]),PlayerController["aidlist"][tonumber(zip_msg[2])],zip_msg[3])
        elseif fnam=="onlinegame_exit_btn" then 
            GameController:PlayerExitGame(PlayerController["aidlist"][tonumber(zip_msg[2])])
        end
    else
        local message=cjson.decode(JasonBuff)
        if message.fnam then 
            QiMsg("接收命令"..message.fnam, 5)
        end
        if message.fnam=="initcheck" then 
            --确保从UI返回消息后踩初始化
            GameController:GameInit()
        elseif message.fnam=="teleport" then 
            TeleportController:TeleportTo(message["aid"],message["e_name"])
        end
    end
   
end

function GameController:ReciveConsoleCMD(c_cmd)
    local aid=c_cmd[2]
    local data={}
    if #c_cmd>=4 then 
        for i=4,#c_cmd do
            data[i-3]=c_cmd[i]
        end
    end
    local cmd_name=c_cmd[3]
    if GameController[cmd_name]~=nil then 
        GameController[cmd_name](self,aid,data)
        QiMsg("找到测试命令GamePlay", 5)
    end
end


function GameController:drop(aid,data)
    local dropname=data[1]
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    local pos= sc.GetActorLogicPos(p_actor)
    if dropname~=nil then 
        DropItemController:CreateDrop(dropname,pos)
    --    sc.SpawnDropItem(dorpid,DOTA_TEAM_GOODGUYS,false,pos)
    end
end

function GameController:musicstate(aid,data)
    local state=data[1]
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    MusicController:SwitchState(tonumber(state))
end

function GameController:gold(aid,data)
    local gold=tonumber(data[1]) or 99999
    if gold~=nil then 
        local pid=PlayerController["aidlist"][tonumber(aid)]
        local p_actor=PlayerController[pid]["actor"]
        local p_hero=PlayerController:GetQiHero(pid)
        p_hero:AddGold(gold)
    end
end

function GameController:killpoint(aid,data)
    local killpoint=tonumber(data[1]) or 99999
    if killpoint~=nil then 
        local pid=PlayerController["aidlist"][tonumber(aid)]
        local p_actor=PlayerController[pid]["actor"]
        local p_hero=PlayerController:GetQiHero(pid)
        p_hero.killpoint=p_hero.killpoint+killpoint
    end
end
function GameController:nb(aid,data)
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    local p_hero=PlayerController:GetQiHero(pid)
    p_hero:AddGold("999999")
    QiMsg("赖皮模式ON",5)
    p_hero:SetExtraProperty("PhysicalDmg",50000)
    p_hero:SetExtraProperty("MagicalDmg",50000)
    p_hero:SetExtraProperty("PhysicalDef",500000)
    p_hero:SetExtraProperty("MagicalDef",500000)
    p_hero:SetExtraProperty("MoveSpeed",5000)

    p_hero:SetExtraProperty("MaxMp",50000)
    p_hero:SetExtraProperty("MaxHp",50000)
    p_hero:SetExtraProperty("BaseDamage",5000)
    p_hero:SetExtraProperty("MaxMp",50000)
    p_hero:SetExtraProperty("MpRegenRate",5000)
    p_hero:SetExtraProperty("HpRegenRate",5000)
end
-- 刷怪命令
function GameController:spawn(aid,data)
    local spawnname=data[1]
    if spawnname~=nil then 
        local pid=PlayerController["aidlist"][tonumber(aid)]
        local p_actor=PlayerController[pid]["actor"]
        local p_hero=PlayerController:GetQiHero(pid)
        local pos= sc.GetActorLogicPos(p_actor)
        SpawnUnit(spawnname,pos,{},"ai")
    end
end

-- 刷怪命令
function GameController:cfg(aid,data)
    local cfgid=tonumber(data[1])
    local skin=tonumber(data[2]) or 1
    if cfgid~=nil then 
        local pid=PlayerController["aidlist"][tonumber(aid)]
        local p_actor=PlayerController[pid]["actor"]
        local p_hero=PlayerController:GetQiHero(pid)
        local pos= sc.GetActorLogicPos(p_actor)
        local actor = sc.SpawnActor( sc.GameObject_Nil , pos, VInt3.new(-180+RandomInt(360), 0, -180+RandomInt(360)) , 
            cfgid, 1, DOTA_TEAM_BADGUYS, false, true,skin)
        AINormal:MakeInstance( actor, {} )
    end
end

-- 刷怪命令
function GameController:hcfg(aid,data)
    local cfgid=tonumber(data[1])
    local skin=tonumber(data[2]) or 1
    if cfgid~=nil then 
        local pid=PlayerController["aidlist"][tonumber(aid)]
        local p_actor=PlayerController[pid]["actor"]
        local p_hero=PlayerController:GetQiHero(pid)
        local pos= sc.GetActorLogicPos(p_actor)
        local actor = sc.SpawnActor( sc.GameObject_Nil , pos, VInt3.new(-180+RandomInt(360), 0, -180+RandomInt(360)) , 
            cfgid, 0, DOTA_TEAM_BADGUYS, false, true,skin)
        AINormal:MakeInstance( actor, {} )
    end
end

-- 测试命令
function GameController:temp(aid,data)
    -- local scale=tonumber(data[1])
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    local actor_id=sc.GetActorSystemProperty(p_actor,ActorAttribute_ActorID)
    local actor_id2=sc.GetActorSystemProperty(sc.GetActorByObjID(actor_id),ActorAttribute_ActorID)
    QiMsg("actorid1["..tostring(actor_id).."]".."actorid2["..tostring(actor_id2).."]", 1)
end

function GameController:emitsound(aid,data)
    local music_name=tostring(data[1])
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    local p_hero=PlayerController:GetQiHero(pid)
    sc.PlayCustomSound(1,StringId.new("Sound/"..music_name),-1)
end

function GameController:attackrow(aid,data)
    local row=tonumber(data[1])
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    local p_hero=PlayerController:GetQiHero(pid)
    SpawnController.nowwave=row
    SpawnController.nextwavetime=10
end

-- 刷怪命令
function GameController:level(aid,data)
    local level=tonumber(data[1])
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    local p_hero=PlayerController:GetQiHero(pid)
    p_hero.exp=999999
    p_hero:AddLevel()
end
-- 设置任务
function GameController:setquest(aid,data)
    local quest=tostring(data[1])
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    local p_hero=PlayerController:GetQiHero(pid)
    local p_quest=PlayerController:GetQiQuest(pid)
    p_quest:InitQuestData(quest)
end
-- 测试突破
function GameController:icon(aid,data)
    local iconname=tostring(data[1])
    local eventName = StringId.new("image_test")
    sc.CallUILuaFunction({iconname} , eventName)
    -- local pid=PlayerController["aidlist"][tonumber(aid)]
    -- local p_actor=PlayerController[pid]["actor"]
    -- MainAlert(aid,alerttext,"一段用于测试弹出效果的文字",10)
end
-- 设置任务
function GameController:mainalert(aid,data)
    local alerttext=tostring(data[1])
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    MainAlert(aid,alerttext,"一段用于测试弹出效果的文字",10)
end
-- 设置英雄
function GameController:sethero(aid,data)
    local cfg=tostring(data[1])
    local skin=tonumber(data[2]) or 1
    local pid=PlayerController["aidlist"][tonumber(aid)]
    local p_actor=PlayerController[pid]["actor"]
    if cfg~=nil then 
        PlayerController:SwtichHero(pid,cfg,skin)
    end
end

function GameController:gameend(aid,data)
    local is_su=tonumber(data[1])
    if is_su==0 then 
        is_su=false 
    else 
        is_su=true
    end
    GameController:GameEnd(is_su)
end

function GameController:random(aid,data)
    local count=tonumber(data[1])
    QiBottomAlert("测试循环 次数"..tostring(count),nil,self.aid)
    for i=1,count do 
        sc.RangedRand(1, 100)
    end
end

function GameController:resetfate(aid,data)
    local pid=PlayerController["aidlist"][tonumber(aid)]
    PlayerController[pid]["QiSuanming"].choosedata=nil
    PlayerController[pid]["QiSuanming"]:PlayerChooseFate()
end

function GameController:buff(aid,data)
    local buffid=tonumber(data[1])
    local pid=PlayerController["aidlist"][tonumber(aid)]
    if buffid~=nil then 
        local p_actor=PlayerController[pid]["actor"]
        sc.BuffAction(p_actor,p_actor,true,true,tonumber(buffid),0,0)
    end
end