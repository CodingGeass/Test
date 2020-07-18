GameManagerEntity = GameManagerEntity or rtti.class("GameManagerEntity")
--申明绑定器
GameManagerEntity.m_binderObj = nil

--Enable函数(自动调用)
function GameManagerEntity:OnEnable()
    print("ManagerEntit y OnEnable")
    -- sc.AddEventListener(self, sc.BattleEventID.StartLevel)
   --在Enable被执行的时候, 内置的m_binderObj变量会被赋值(lua绑定的物体), 可以直用(self.m_binderObj)获取使用
    -- self.m_binderObj
    --注册监听事件
    -- sc.AddEventListener(self, sc.BattleEventID.StartLevel)
    sc.AddEventListener(self, sc.BattleEventID.FightStart)
    sc.AddEventListener(self, sc.BattleEventID.UpdateLogic)
    sc.AddEventListener(self, sc.BattleEventID.ActorDamage)

end

--- 开始游戏事件
function GameManagerEntity:FightStart()
    QiPrint("GameManagerEntity FightStart")
end

-- --- 响应监听的FightStart事件
-- function GameManagerEntity:StartLevel()
--     print("ManagerEntity StartLevel")
-- end

--- 每帧事件(全局)
function GameManagerEntity:Tick()
    -- print("ManagerEntity UpdateLogic")
end

-- 初始化
function GameManagerEntity:ctor()
    -- print("ManagerEntity ctor")
end

--Disable函数(自动调用)
function GameManagerEntity:OnDisable()
end

--Destroy函数(自定调用)
function GameManagerEntity:OnDestroy()

end

function GameManagerEntity:ActorDamage(src,atker,m_hurtTotal,m_hpChanged,m_critValue,skillId)
    m_hurtTotal=999
end
