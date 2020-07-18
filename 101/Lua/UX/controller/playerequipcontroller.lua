if playerequipcontroller==nil then 
    playerequipcontroller={}
    -- playerequipcontroller[LuaCallCs_Battle.GetHostActorID()]={}
    -- for i =1 ,6 do 
    --     playerequipcontroller[LuaCallCs_Battle.GetHostActorID()][i]=nil
    -- end
end

--- 添加装备
function AddEquip(AID,index,e_name)
    if AID==LuaCallCs_Battle.GetHostActorID() then 
        playerequipcontroller:InitPlayerEquipByAID(AID)
        playerequipcontroller[AID][index]=e_name
        local playerequ=playerequipcontroller
        QiPrint(LuaCallCs_Battle.GetHostActorID())
        QiMainView:RefreshSmartBag()
    end
end

--- 根据AID初始化玩家
function playerequipcontroller:InitPlayerEquipByAID(AID)
    if playerequipcontroller[AID]==nil then 
        playerequipcontroller[AID]={}
    else
        return
    end
    for i =1,6 do 
        playerequipcontroller[AID][i]=nil
    end
end