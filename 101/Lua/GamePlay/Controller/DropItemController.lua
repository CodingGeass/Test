DUMMY_CFG_ID=35535
PICK_DISTANCE=2000
if DropItemController==nil then 
    DropItemController={}
    DropItemController.dropList={}
    DropItemController.unitdroplist={}
    DropItemController.unitdroplist_fenlei={}

end

-- 初始化
function DropItemController:Init()
    DropItemController:FormatDropList()
    DropItemController:DropTimer()
end

function DropItemController:DropTimer()
    sc.SetTimer(1000, 0, 0 , function ()
        for k,v in pairs(DropItemController.dropList) do 
            v.clean_time=v.clean_time-1
            if v.clean_time<=0 then 
                DropItemController:ClearOneDropByAID(k)
            end
        end
    end, {})
end

-- 移除一个drop
function DropItemController:ClearOneDropByAID(aid)
    if DropItemController.dropList[aid] then 
        local actor=DropItemController.dropList[aid]["actor"]
        sc.KillActor(actor,true,true,actor)
        if DropItemController.dropList[aid]["particle"] then 
            sc.TriggerParticleEnd(DropItemController.dropList[aid]["particle"])
        end
        DropItemController.dropList[aid]=nil
        eventname = StringId.new("Remove3DUIByActorID")
        sc.CallUILuaFunction({aid},eventname)
    end
    -- QiMsg("清理一个凋落物"..tostring(aid),5)
end

-- 处理凋落物清单
function DropItemController:FormatDropList()
    for item_name,item_data in pairs(QiData.item_data) do 
        if item_data["m_droptype"]~=nil then 
            for __,droptype in pairs(Split(item_data["m_droptype"], "|")) do 
                local d_num=tonumber(droptype)
                if DropItemController.unitdroplist[d_num]==nil then
                    DropItemController.unitdroplist[d_num]={} 
                end
                local m_itemtype=tonumber(item_data["m_itemtype"])
                if m_itemtype~=nil then 
                -- DropItemController.unitdroplist_fenlei[]
                    -- 进行掉落分类储存
                    if DropItemController.unitdroplist_fenlei[m_itemtype]==nil then
                        DropItemController.unitdroplist_fenlei[m_itemtype]={}
                    end
                    if DropItemController.unitdroplist_fenlei[m_itemtype][d_num]==nil then 
                        DropItemController.unitdroplist_fenlei[m_itemtype][d_num]={}
                    end
                    DropItemController.unitdroplist_fenlei[m_itemtype][d_num][#DropItemController.unitdroplist_fenlei[m_itemtype][d_num]+1]=item_name
                end
                DropItemController.unitdroplist[d_num][#DropItemController.unitdroplist[d_num]+1]=item_name
            end
        end
    end
end

-- 根据掉落物ID产生一个掉落
function DropItemController:CreateDropByDropID(dropid,pos)
    if DropItemController.unitdroplist[dropid] then
        local drop_name=DropItemController.unitdroplist[dropid][math.random(1, #DropItemController.unitdroplist[dropid])]
        DropItemController:CreateDrop(drop_name,pos)
    end
end

function DropItemController:PickItem(pid)
    local player_actor=PlayerController[pid]["actor"]
    local player_pos=sc.GetActorLogicPos(player_actor)
    local pick_distance=99999
    local pick_id=-1

    -- 判读出最优先的拾取物
    for k,v in pairs(DropItemController.dropList) do 
        local drop_pos=v.pos
        local distance=twoPointToDistance(player_pos.x,player_pos.z,drop_pos.x,drop_pos.z)
        if distance<=2000 then 
            if pick_distance>distance then 
                pick_distance=distance
                pick_id=k
            end
        end
    end
    --添加失去五
    if pick_id~=-1 then 
        local item_name=DropItemController.dropList[pick_id]["dropname"]
        PlayerController:GetBag(pid):AddItemByName(item_name)
        DropItemController:ClearOneDropByAID(pick_id)
    end
end

--- 判断是否有合法拾取物
function DropItemController:HaveAvaliablePickItem(pid)
    local player_actor=PlayerController[pid]["actor"]
    local player_pos=sc.GetActorLogicPos(player_actor)
    local pick_distance=99999
    local pick_id=-1
    for k,v in pairs(DropItemController.dropList) do 
        local drop_pos=v["pos"]
        local distance=twoPointToDistance(player_pos.x,player_pos.z,drop_pos.x,drop_pos.z)
        if distance<=2000 then 
            if pick_distance>distance then 
                pick_distance=distance
                pick_id=k
            end
        end
    end
    
    if pick_id~=-1 then
        local item_name=DropItemController.dropList[pick_id]["dropname"]
        return true,item_name
    else
        return false,nil
    end
end


--创建一个掉落
function DropItemController:CreateDrop(dropname,pos)
    if QiData.item_data[dropname] then
        local actor = sc.SpawnActor(sc.GameObject_Nil, pos,  VInt3.new(-180+RandomInt(360), 0, -180+RandomInt(360)) , DUMMY_CFG_ID, 1, DOTA_TEAM_GOODGUYS, true, false,1)
        local actorID = sc.GetActorSystemProperty(actor,1004)
        local u_object=sc.GetUnityObjectFromActorRoot(actor)
        local particle_name=StringId.new("Prefab_Skill_Effects/tongyong_effects/Huanling_Effect/Ganshe_buff_01.prefab")
        local particle=sc.TriggerParticleStart (particle_name, particle_name, particle_name, 
        actor, false, u_object, VInt3.new(0, 500,0), VInt3.new(0, 0,0),VInt3.new(1, 1,1), false,true)
        DropItemController:CreateItemWordImg(actorID,dropname)
        DropItemController.dropList[actorID]={
            pos=pos,
            actor=actor,
            actorID=actorID,--马甲
            dropname=dropname,-- 掉落物
            clean_time=90,-- 自动清除时间
            particle=particle,
        }
    end
end

function DropItemController:CreateItemWordImg(actorID,dropname)
    eventname = StringId.new("ShowItemWorldImage")
    sc.CallUILuaFunction({actorID,dropname},eventname)
end