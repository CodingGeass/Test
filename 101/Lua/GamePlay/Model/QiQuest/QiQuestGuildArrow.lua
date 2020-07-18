-- 初始化 
function QiQuest:GuildArrowInit()
    local target_post=nil
    if self.quest_type==QUEST_TYPE_MEETNPC or self.quest_type==QUEST_TYPE_KILLUNIT or self.quest_type==QUEST_TYPE_CUSTOMCHECK then 
        local unit,q_pos,q_forward,q_distance=self:GetQuestTargetPos()
        local now_questid=self.quest_id
        local actor = sc.SpawnActor(sc.GameObject_Nil, sc.GetActorLogicPos(self.unit),  VInt3.new(-180+RandomInt(360), 0, -180+RandomInt(360)) , DUMMY_CFG_ID, 1, DOTA_TEAM_GOODGUYS, true, false,1)
        local actorID = sc.GetActorSystemProperty(actor,1004)
        local u_object=sc.GetUnityObjectFromActorRoot(actor)
        -- QUEST_ARROW_PARTICLE_PATH
        local particle=nil
        local timer_id
        local guildcheck=function ()
            if self.quest_id~=now_questid then 
                sc.KillTimer(timer_id)
                if SpawnController.UnitListByActorId[u_actor_id] then 
                    local highlight_index=self:GetAreaHighLightIndexByAearInde(SpawnController.UnitListByActorId[u_actor_id]["area"])
                    self:SetTeleportGoldState(highlight_index,false)
                end
                if particle~=nil then 
                    sc.TriggerParticleEnd(particle)
                    particle=nil
                end
                sc.KillActor(actor,true,true,actor)
            else
                unit,q_pos,q_forward,q_distance=self:GetQuestTargetPos()
                -- 玩家与任务怪物在同一个区域
                if unit and sc.IsAlive(unit)==true then 
                    local u_actor_id=sc.GetActorSystemProperty(unit,1004)
                    if SpawnController.UnitListByActorId[u_actor_id] then 
                        local c_pos=sc.GetActorLogicPos(self.unit)
                        local t_pos=sc.GetActorLogicPos(unit)
                        if  twoPointToDistance(c_pos.x,c_pos.z,t_pos.x,t_pos.z)<=4000 then 
                            if particle~=nil then 
                                sc.TriggerParticleEnd(particle)
                                particle=nil
                            end
                        else 
                            local highlight_index=self:GetAreaHighLightIndexByAearInde(SpawnController.UnitListByActorId[u_actor_id]["area"])
                            self:SetTeleportGoldState(highlight_index,true)
                            -- 玩家与目标在同一个区域
                            if PlayerController[self.pid]["area_index"]==tonumber(SpawnController.UnitListByActorId[u_actor_id]["area"]) then
                                if particle==nil then
                                    -- 没有就创建特效
                                    particle=sc.TriggerParticleStart(QUEST_ARROW_PARTICLE_PATH, QUEST_ARROW_PARTICLE_PATH, QUEST_ARROW_PARTICLE_PATH, 
                                        actor, false, u_object, VInt3.new(0, 500,0), VInt3.new(0, 0,0),VInt3.new(1, 1,1), false,true)
                                end
                                self:SendGoldMainBtn(self.aid,1,false)
                            else
                                self:SendGoldMainBtn(self.aid,1,true)
                                if particle~=nil then
                                    sc.TriggerParticleEnd(particle)
                                    particle=nil
                                end
                            end
                            local c_forward=VInt3.new(c_pos.x-t_pos.x,c_pos.y-t_pos.y,c_pos.z-t_pos.z)
                            c_forward=c_forward:Normalize(1000)
                            sc.TeleportActor(actor,sc.GameObject_Nil,c_pos,c_forward)
                        end
                    else
                        unit,q_pos,q_forward,q_distance=self:GetQuestTargetPos()
                    end
                else
                    -- unit,q_pos,q_forward,q_distance=self:GetQuestTargetPos()
                end
            end
        end
        timer_id=sc.SetTimer(30, 0, 0 , guildcheck, {})
    end
end

--- 点击了UI界面
function QiQuest:QuestUIClick()
    local unit,q_pos,q_forward,q_distance=self:GetQuestTargetPos()
    if unit~=nil then 
        local u_actor_id=sc.GetActorSystemProperty(unit,1004)
        local highlight_index=self:GetAreaHighLightIndexByAearInde(SpawnController.UnitListByActorId[u_actor_id]["area"])
        if PlayerController[self.pid]["area_index"]~=SpawnController.UnitListByActorId[u_actor_id]["area"] then 
            -- 不在同一个区域
            TeleportController:TeleportTo(self.aid,TeleportController.t_list[highlight_index])
        else 
            sc.RealMoveToActor(self.unit,unit)
            -- 在同一个区域
        end
    end
    local eventName = StringId.new("QuestUIClick")
    sc.CallUILuaFunction({
        self.aid,
    },eventName)
end

function QiQuest:SetGuildInfo(show,x,y,textinfo)
    local eventName = StringId.new("SetMouseAlertPos")
    sc.CallUILuaFunction({
        show,
        x,
        y,
        textinfo,
        self.aid,
    },eventName)
end

-- 设置传送页面闪光状态
function QiQuest:SetTeleportGoldState(index,state)
    local refresh_flag=false
    if self.GuildHighlightAear[index]~=nil then 
        if self.GuildHighlightAear[index]~=state then 
            self.GuildHighlightAear[index]=state
            refresh_flag=true
        end
    end
    if refresh_flag==true then 
        self:RefreshTeleportGoldState()
    end
end

-- 刷新传送页面金色状态
function QiQuest:RefreshTeleportGoldState()
    local eventName = StringId.new("SendTeleportBtnGoldBorder")
    for k,v in pairs(self.GuildHighlightAear) do 
        sc.CallUILuaFunction({self.aid,k,v} , eventName)
    end
end

function QiQuest:SetQuestHightLgiht(show)
    local eventName = StringId.new("SetQuestHightLgiht")
    sc.CallUILuaFunction({show,self.aid} , eventName)

end
function QiQuest:GetAreaHighLightIndexByAearInde(c_index)
    for k,v in pairs(TeleportController.t_list) do 
        if TeleportController.area[v] then 
            if TeleportController.area[v]["index"]==c_index then 
                return k 
            end
        end
    end
    return -1
end

-- 设置主界面按钮亮起
function QiQuest:SendGoldMainBtn(aid,index,isgold)
    local eventName = StringId.new("SendMainBtnGoldBorder")
    sc.CallUILuaFunction({self.aid,index,isgold} , eventName)
end

-- 获取任务目标地点
function QiQuest:GetQuestTargetPos()
    local s_pos=sc.GetActorLogicPos(self.unit)
    if self.quest_type==QUEST_TYPE_MEETNPC or self.quest_type==QUEST_TYPE_KILLUNIT  or self.quest_type==QUEST_TYPE_CUSTOMCHECK then 
        -- 返回所有满足需要的单位
        local actors={}
        for aid,data in pairs(SpawnController.UnitListByActorId) do 
            local cfg_id=data["unit_config_id"]
            for q_index,q_target_id in pairs(self.target_ids) do 
                if tonumber(cfg_id)==tonumber(q_target_id) then 
                    actors[#actors+1]=sc.GetActorByObjID(aid)
                end
            end
        end

        local distance=999999
        local unit=nil
        local forward=nil
        local c_pos=nil

        for k,v in pairs(actors) do
            if v and sc.IsAlive(v) then 
                local u_pos=sc.GetActorLogicPos(v)
                local check_distance=twoPointToDistance(s_pos.x,s_pos.z,u_pos.x,u_pos.z)
                -- 最近距离的单位优先级最高
                if check_distance<distance then
                    unit=v
                    distance=check_distance
                    forward=VInt3.new(u_pos.x-s_pos.x,u_pos.y-s_pos.y,u_pos.z-s_pos.z)
                end
            end
        end

        if unit~=nil then
            c_pos=sc.GetActorLogicPos(unit)
        end
        
        local return_forward=nil
        if forward~=nil then 
            return_forward=forward:Normalize(1000)
        end
        
        return unit,c_pos,return_forward,distance
    end
end


