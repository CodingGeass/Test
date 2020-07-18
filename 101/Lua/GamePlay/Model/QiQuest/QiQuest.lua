QUEST_TYPE_MEETNPC=1
QUEST_TYPE_KILLUNIT=2
QUEST_TYPE_CUSTOMCHECK=5

QUEST_START_ID="Q00001"

QUEST_ARROW_PARTICLE_PATH=StringId.new("Prefab_Skill_Effects/Common_Effects/chuchang_zhishi_03.prefab")

if QiQuest==nil then 
    QiQuest={}
end

function QiQuest:new(o,hero,pid)
    o=o or {}
    o.unit=hero
    setmetatable(o,self)
    self.__index =self
    o.pid=pid
    o.aid=sc.GetActorSystemProperty(hero,ActorAttribute_ActorID )
    o.killunitdata={}
    o.quest_type=QUEST_TYPE_MEETNPC
    
    o.GuildHighlightAear={}
    for k,v in pairs(TeleportController.t_list) do 
        o.GuildHighlightAear[k]=false
    end

    o:InitQuestData(QUEST_START_ID)
    o:StartQuestCheckTimer()
    return o
end

--- 开启任务完成检测计时器
function QiQuest:StartQuestCheckTimer()
    sc.SetTimer(1000, 0, 0 , function ()
        if self.quest_type==QUEST_TYPE_CUSTOMCHECK then 
            if quest_func[self.quest_id]~=nil then 
                if quest_func[self.quest_id](self,self.pid)==true then 
                    self:Complete()
                end
            end
        end
    end,{})
end

-- 初始化questID
function QiQuest:InitQuestData(quest_id)
    QiMsg("任务开始"..tostring(quest_id),5,self.aid)
    self.quest_id=quest_id
    local quest_data=QiData.quest_data[quest_id]
    self.quest_data=quest_data

    if quest_data==nil then 
        QiPrint("Error quest cant find id"..tostring(quest_id),3)
        return
    end

    -- 重置高亮状态
    self:SendGoldMainBtn(self.aid,1,false)
    for k,v in pairs(self.GuildHighlightAear) do 
        self:SetTeleportGoldState(k,false)
    end
    local quest_type=tonumber(quest_data["quest_type"])
    local quest_next_id=quest_data["quest_next_id"]
    local quest_data_1=quest_data["quest_data_1"]
    local quest_data_2=quest_data["quest_data_2"]
    local quest_data_3=quest_data["quest_data_3"]
    self.quest_type=quest_type
    self.target_ids={}

    if quest_type==QUEST_TYPE_MEETNPC then 
        self.target_ids={QiData:GetCfgIDByUnitName(self.quest_data["quest_data_1"])}
    elseif quest_type==QUEST_TYPE_KILLUNIT then
        self:ParseUnitKillData(quest_data)
     elseif quest_type==QUEST_TYPE_CUSTOMCHECK then
        self.target_ids={}
        local unit_name_list=Split(quest_data["quest_data_1"], "&")
        for k,v in pairs(unit_name_list) do 
            self.target_ids[#self.target_ids+1]=QiData:GetCfgIDByUnitName(v)
        end
    end
    --任务事件 用于做一些新手引导
    local quest_func=_G["quest_func"]["event_"..tostring(quest_id)]
    if quest_func~=nil then 
        quest_func(quest_func,self)
    end
    self:GuildArrowInit()
    self:UIRefresh()
end

--- 解析杀怪数据
function QiQuest:ParseUnitKillData(quset_data)
    --重置数据
    self.killunitdata={}
    local q_datas=Split(quset_data["quest_data_1"], "&")
    self.target_ids={}
    for k,v in pairs(q_datas) do 
        local row_data=Split(v, "|")
        local u_name=row_data[1]
        local killnumber=tonumber(row_data[2])
        local cfg_id=tonumber(QiData:GetCfgIDByUnitName(u_name))
        self.killunitdata[#self.killunitdata+1]={
            u_name=u_name,
            killnumber=killnumber,
            cfg_id=cfg_id,
        }
        self.target_ids[#self.target_ids+1]=QiData:GetCfgIDByUnitName(u_name)
    end
end

--- 击杀单位事件
function QiQuest:KillUnitFunc(cfg_id)
    --当前处于击杀任务任务中
    if self.quest_type==QUEST_TYPE_KILLUNIT then 
        for k,v in pairs(self.killunitdata) do 
            if v["cfg_id"]==cfg_id then 
                v["killnumber"]=v["killnumber"]-1
                QiMsg("击败任务数据["..QiData.unit_property[v["u_name"]]["unit_name_schinese"].."]".."剩余"..tostring(v["killnumber"]).."只",
                     1, self.aid)
                if v["killnumber"]<=0 then 
                    self.killunitdata[k]=nil 
                    local new_targets={}
                    for k,v in pairs(self.target_ids) do 
                        if tonumber(v)~=cfg_id then
                            new_targets[#new_targets+1]=cfg_id
                        end
                    end
                    self.target_ids=new_targets
                end
            end
        end
        if #self.killunitdata==0 then 
            self:Complete()
            return
        end
    end
end

function QiQuest:UIRefresh()
    local eventName = StringId.new("SetQuest")
    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],self.quest_id} , eventName)
end

function QiQuest:NpcIn(n_actor)
    if self.quest_type==QUEST_TYPE_MEETNPC then 
        local cfg_id=sc.GetActorSystemProperty(n_actor,1000)
        if QiData:GetCfgIDByUnitName(self.quest_data["quest_data_1"])==tonumber(cfg_id) then 
            QiMsg("与NPC会见任务完成"..tostring(cfg_id),1,self.aid)
            self:Complete()
        end
    end
end

--- 任务完成
function QiQuest:Complete()
    local now_id=self.quest_id
    local next_id=self.quest_data["quest_next_id"]
    QiMsg("任务完成"..tostring(now_id),1,self.aid)
    MainAlert(self.aid,self.quest_data["quest_title"],"<color=#ffff00>任 务 完 成</color>",4)
    if quest_func["re_"..now_id] then 
        quest_func["re_"..now_id](self,self.pid)
    end
    sc.PlayCustomSound(1,StringId.new("Sound/sound_event_mission_complect.ogg"),1)
    self:InitQuestData(next_id)
end

function QiQuest:NpcOut(n_actor)
    if self.quest_type==QUEST_TYPE_MEETNPC then 

    end
end
