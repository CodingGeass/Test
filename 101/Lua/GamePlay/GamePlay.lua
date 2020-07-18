require "Lua/GamePlay/require.lua"
IS_VERIFY_VERSION=true --审核版本

function main()
    print("game player main")
    -- if IS_IN_TOOLMODE==true then 
    if IS_VERIFY_VERSION==false then 
        -- require("LuaPanda").start("127.0.0.1", 8818)
    end
    -- end
    GameController:Init()
end

--- 每帧触发事件
function GameUpdateLogicEventNode()
    -- print("GameUpdate")
    -- Event:GameUpdateLogicEventNode()
end

--- 准备关卡数据
function FightPrepare()
    Event:FightPrepare()
end
 
--- 开始关卡
function FightStart()
    Event:FightStart()
end

--- 角色生存事件
function ActorStartFight()
    Event:ActorStartFight()
end

--- Actor死亡事件
-- function detail description.
-- @tparam  type src 死亡源
-- @tparam  type atker 攻击者
-- @tparam  type orignalAtker 原始攻击者 (塔杀死目标的话， 原始攻击者就是塔. 逻辑攻击者就是玩家)
-- @tparam  type logicAtker 逻辑攻击者
-- @tparam  type bImmediateRevive 是否为立即复活 (复活甲会传True)
-- @author
function ActorDead(src,atker,orignalAtker,logicAtker,bImmediateRevive)
    Event:ActorDead(src,atker,orignalAtker,logicAtker,bImmediateRevive)
    local attacker_aid=sc.GetActorSystemProperty(atker,ActorAttribute_ActorID)
    -- 是玩家击杀的
    -- if PlayerController["aidlist"][attacker_aid] then 
    --     if RandomInt(100)>98 then
    --         local item_data=QiData.item_data_list[RandomInt(1, #QiData.item_data_list)]
    --         local item_name=item_data["item_name"]
    --         local item_type=item_data["m_itemtype"]
    --         local m_tier=item_data["m_tier"] or 1
    --         if RandomInt(m_tier)<=1 then
    --             if item_type>2 then
    --                 PlayerController:GetBag(PlayerController["aidlist"][attacker_aid]):AddItemByName(item_name,1)
    --             end
    --         end
    --     end
    -- end
end

--- 技能使用事件
-- function detail description.
-- @tparam  type src 使用者
-- @tparam  type target 目标
-- @tparam  type slot 技能槽位
-- @tparam  type skill_Id 技能ID
-- @author
function UseSkill(src,target,slot,skill_Id)
    Event:UseSkill(src,target,slot,skill_Id)
end


--- 触发器触发事件
-- function detail description.
-- @tparam  type trigger description
-- @tparam  type gameObject description
-- @tparam  type bEnterOrLeave description
-- @tparam  type src description
-- @author 
function OnShapeTriggerEvent(trigger,gameObject,bEnterOrLeave,src)
    Event:OnShapeTriggerEvent(trigger,gameObject,bEnterOrLeave,src)

end


function OnReceiveAgeCustomEvent(action, intArr, stringArr)
    Event:OnReceiveAgeCustomEvent(action, intArr, stringArr)
end