AI_THINK_INTERVAL = 0.5 --//AI思考间隔时间

--AI 状态 constants
AI_STATE_IDLE = 0--待机阶段
AI_STATE_AGGRESSIVE = 1--攻击阶段
AI_STATE_RETURNING = 2--返回阶段

--定义 AIAttack 类
AIAttack = {}
AIAttack.__index = AIAttack

--[[通过一些参数和单位创建一个AIAttack类的实例  ]]
function AIAttack:MakeInstance( actor, params )
  --构造一个实例  of the AIAttack class
  local ai = {}
  setmetatable( ai, AIAttack )
  ai.unit = actor --这个AI控制的单位
  ai.can_attack=true
  ai.state = AI_STATE_IDLE --初始状态
  ai.stateThinks = { --加入每个思考阶段的函数
    [AI_STATE_IDLE] = 'IdleThink',
    [AI_STATE_AGGRESSIVE] = 'AggressiveThink',
    [AI_STATE_RETURNING] = 'ReturningThink'
  }
  --设置后面阶段可能要用到的参数
  ai.spawnPos =params.spawnPos or sc.GetActorLogicPos(actor)
  ai.aggroRange = params.aggroRange or 5000
  ai.leashRange =params.leashRange or 24000
  for i=-1,4 do
    sc.SetSkillBeanCount(ai.unit,i,1)
    if sc.IsSkillSlotValid(ai.unit,i)==true then 
        sc.SetSkillLevel (ai.unit,1, i)
    end
  end
  sc.SetSkillLevel (ai.unit,1, 2)
  sc.SetSkillLevel (ai.unit,1, 3)
  sc.SetSkillLevel (ai.unit,1, 1)
  --开始思考
  -- Timers:CreateTimer( ai.GlobalThink, ai )
  ai.tid=sc.SetTimer(AI_THINK_INTERVAL*1000, 0, 0 , function ()
    ai:GlobalThink()
  end, {})
  --Return the constructed instance
  return ai
end

--[[ 高优先级的计时器判断这个AI单位每跳要做的时, 选择正确的方法状态并执行. ]]
function AIAttack:GlobalThink()
  --单位死了就停止AI 
  if sc.IsAlive(self.unit)==false then

    sc.KillTimer(self.tid)
    return nil
  end
  self[self.stateThinks[ self.state ]](self)
  return
  -- --执行正确阶段的思考方法
  -- Dynamic_Wrap(AIAttack, self.stateThinks[ self.state ])( self )
  --等待时间后继续调用这个方法
  -- return AI_THINK_INTERVAL
end

--[[ Idle状态的方法]]
function AIAttack:IdleThink()
  local now_pos=sc.GetActorLogicPos(self.unit)
  if twoPointToDistance(now_pos.x,now_pos.z,self.spawnPos.x,self.spawnPos.z)  > self.leashRange then
    sc.RealMovePosition(self.unit,self.spawnPos)
    -- self.unit:MoveToPosition( self.spawnPos )
    self:SetState( AI_STATE_RETURNING) --转换到返回阶段
    --跳转到待机状态
    return
  end
  --找到范围内可攻击的对象
  local unit = sc.GetNearestEnemy( self.unit,  self.aggroRange ) 
  if unit~=nil and sc.IsTargetCanBeAttackedIgnoreVisible(self.unit,unit)==true then 
    self.aggroTarget=unit
    sc.SelectTarget(self.unit,unit)
    self:SetState(AI_STATE_AGGRESSIVE)  --进入积极阶段
    sc.RealMovePosition(self.unit,sc.GetActorLogicPos(self.aggroTarget))
  end
  return
end

--[[ 积极状态的方法 ]]
function AIAttack:AggressiveThink()
  local now_pos=sc.GetActorLogicPos(self.unit)
  local target_dis= twoPointToDistance(now_pos.x,now_pos.z,self.spawnPos.x,self.spawnPos.z)
  if  target_dis> self.leashRange then
    if self.aggroTarget~=nil or sc.IsAlive(self.aggroTarget)==true then
        local t_pos=sc.GetActorLogicPos(self.aggroTarget)
        local aid=self.aggroTarget
        if aid==nil or SpawnController.UnitListByActorId[aid]==nil then 
          QiPrint("t_pos nil")
        else
          if twoPointToDistance(now_pos.x,now_pos.t_pos.x,t_pos.z)> self.leashRange then 
              sc.RealMovePosition(self.unit,self.spawnPos)
              -- self.unit:MoveToPosition( self.spawnPos )
              self:SetState( AI_STATE_RETURNING) --转换到返回阶段
              --跳转到待机状态
              return
          else 

          end
        end
    end
  end
  --检查攻击的单位是否还活着 (self.攻击单位 会被设定在转到攻击阶段的时候)
  if self.aggroTarget==nil or sc.IsAlive(self.aggroTarget)==false then
    sc.RealMovePosition(self.unit,self.spawnPos)
    -- self.unit:MoveToPosition( self.spawnPos )
    self:SetState(AI_STATE_RETURNING) --转换到返回阶段
    --跳转到待机状态
    return
  end

  for i=-1,4 do 
    if sc.IsSkillSlotValid(self.unit,i)==true then 
      sc.RealMovePosition(self.unit,sc.GetActorLogicPos(self.aggroTarget))
      sc.SelectTarget(self.unit,self.aggroTarget)
      local s_id=sc.GetSkillSlotSkillID (self.unit,i)
      if s_id~=nil then 
        sc.SetSkillBeanCount(self.unit,i,1)
        sc.SetSkill(self.unit,i,false)
        sc.UGCRealUseSkill(self.unit,i)
        -- sc.PlayActorAnimation(self.unit, StringId.new("Idle"), 150, 0, false,false, false)
      end
    end
  end
  return
end

function AIAttack:SetState(state)
  if state==AI_STATE_IDLE then 
    sc.PlayActorAnimation(self.unit, StringId.new("Idle"), 150, 0, false,false, false)
  end
  self.state=state
end

--[[ 返回阶段的]]
function AIAttack:ReturningThink()
  local now_pos=sc.GetActorLogicPos(self.unit)
  local unit = sc.GetNearestEnemy( self.unit,  self.aggroRange ) 
  if unit~=nil and sc.IsTargetCanBeAttackedIgnoreVisible(self.unit,unit)==true then 
    self.aggroTarget=unit
    sc.SelectTarget(self.unit,unit)
    self:SetState(AI_STATE_AGGRESSIVE)  --进入积极阶段
    sc.RealMovePosition(self.unit,sc.GetActorLogicPos(self.aggroTarget))
    return
  end
  if twoPointToDistance(now_pos.x,now_pos.z,self.spawnPos.x,self.spawnPos.z)  <3000 then
    sc.RealMovePosition(self.unit,self.spawnPos)
    -- self.unit:MoveToPosition( self.spawnPos )
    self:SetState(AI_STATE_IDLE) --转换到返回阶段
    --跳转到待机状态
    return
  end
  sc.RealMovePosition(self.unit,self.spawnPos)
  -- --检查UI单位时候已经回到了出身点
  -- if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() < 50 then
  --   self.unit:MoveToPosition( self.spawnPos )
  --   --跳转到待机状态
  --   self.state = AI_STATE_IDLE
  --   return true
  -- end
end