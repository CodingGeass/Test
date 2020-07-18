UNIT_NPC_MEET_DISTANCE=2000

if UnitController==nil then 
    UnitController={}
    UnitController["npcnearlist"]={}
end

function UnitController:Init()
end

-- 设置具有NPC属性
function UnitController:SetNPC(npc_actor)
    local actorid=sc.GetActorSystemProperty(npc_actor,1004)
    local cfg_id=sc.GetActorSystemProperty(npc_actor,1000)
    UnitController["npcnearlist"][actorid]={}
    local npc_timer=sc.SetTimer(100, 0, 0 , function ()
        local now_npcnearlist={}
        if npc_actor==nil or  sc.IsActorDead(npc_actor)==true then 
            if npc_timer then 
                sc.KillTimer(npc_timer)
            end
        end
       for index,p_actor in pairs(PlayerController:GetAllPlayerActor()) do 
            local p_actorid=sc.GetActorSystemProperty(p_actor,1004)
            local player_pos=sc.GetActorLogicPos(p_actor)
            local npc_pos=sc.GetActorLogicPos(npc_actor)
            local distance=twoPointToDistance(player_pos.x,player_pos.z,npc_pos.x,npc_pos.z)

            --进入NPC范围
            if distance<=UNIT_NPC_MEET_DISTANCE then 
                now_npcnearlist[p_actorid]=true
            end
            -- QiMsg("player_pos"..tostring(player_pos.x).."|"..tostring(player_pos.y).."|"..tostring(player_pos.z))
            -- QiMsg("npc_pos"..tostring(npc_pos.x).."|"..tostring(npc_pos.y).."|"..tostring(npc_pos.z))
        end
        for kk,vv in pairs(now_npcnearlist) do 
            if UnitController["npcnearlist"][actorid][kk]==nil then 
                UnitController["npcnearlist"][actorid][kk]=true
                QiMsg(tostring(kk).."玩家进入NPC附近"..tostring(cfg_id))
                UnitController:NpcUnitIn(npc_actor,sc.GetActorByObjID(kk))
            end
        end

        for kk,vv in pairs(UnitController["npcnearlist"][actorid]) do 
            if now_npcnearlist[kk]==nil then 
                QiMsg(tostring(kk).."玩家离开NPC附近"..tostring(cfg_id))
                UnitController:NpcUnitOut(npc_actor,sc.GetActorByObjID(kk))
            end
        end
        UnitController["npcnearlist"][actorid]=now_npcnearlist
    end, {})
end

-- NPC周围有玩家进入事件
function UnitController:NpcUnitIn(n_actor,u_actor)
    local cfg_id=sc.GetActorSystemProperty(n_actor,1000)
    local pid=PlayerController:GetPlayerIdByActor(u_actor)
    if pid~=-1 then 
        PlayerController:GetQiQuest(pid):NpcIn(n_actor)
    end
    if quest_func["in_"..tostring(cfg_id)]~=nil then 
        quest_func["in_"..tostring(cfg_id)](self,n_actor,u_actor)
    end
end

-- NPC周围有玩家离开事件
function UnitController:NpcUnitOut(n_actor,u_actor)
    local cfg_id=sc.GetActorSystemProperty(n_actor,1000)
    local pid=PlayerController:GetPlayerIdByActor(u_actor)
    if pid~=-1 then 
        PlayerController:GetQiQuest(pid):NpcOut(n_actor)
    end
    if quest_func["out_"..tostring(cfg_id)]~=nil then 
        quest_func["out_"..tostring(cfg_id)](self,n_actor,u_actor)
    end
end

-- NPC周围有玩家离开事件
function UnitController:AskHeroProperty(aid,property_id)
    local pid=PlayerController["aidlist"][aid]
    local actor= PlayerController[pid]["actor"]
    local p_value=sc.GetActorSystemProperty(actor,property_id)
    local eventName = StringId.new("SendPropertyValue")
    sc.CallUILuaFunction({aid,property_id,p_value} , eventName)
end

