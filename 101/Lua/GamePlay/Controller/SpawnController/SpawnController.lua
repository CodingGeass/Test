SPAWN_CHECK_INTERVAL_TIME=1
SPAWN_NEXT_WAVETIME=90
if SpawnController==nil then 
    SpawnController={}
    SpawnController.ulist={}
    SpawnController.nowwave=0
    SpawnController.farmroomnpc={}
    SpawnController.nextwavetime=0
    SpawnController.attackUnitList={}
    SpawnController.base_unit=nil--基地
    SpawnController.attack_unit_total_num=0
    --主要进攻怪物
    SpawnController.main_spawn_posname={
        [1]="main_enemy_attack_spawn_pos_2",
        [2]="main_enemy_attack_spawn_pos_1",
    }
    --特殊进攻怪怪物
    SpawnController.special_spawn_posname={
        [1]="special_enemy_attack_spawn_pos_2",
        [2]="special_enemy_attack_spawn_pos_1",
    }
    --玩家练功房
    SpawnController.playr_farmroom_posname={
        [1]="player_farmrroom_pos_1",
        [2]="player_farmrroom_pos_2",
        [3]="player_farmrroom_pos_3",
        [4]="player_farmrroom_pos_4",
    }
    -- 记录ActorID链接到我们的数据中
    SpawnController.UnitListByActorId={
    }
end

function SpawnController:RecordUnitInfo(actor_id,actor_data)
    SpawnController.UnitListByActorId[actor_id]=actor_data
end

-- 通过ActorID获得数据信息
function SpawnController:GetUnitDataByAID(actor_id)
    return SpawnController.UnitListByActorId[actor_id]
end

-- 刷怪器初始化
function SpawnController:Init()
    SpawnController:GameStart()
    SpawnController:GameAutoSpawn()
    SpawnController:FarmRoomSpawn()
    SpawnController:AttackUnitTimer()
    sc.SetTimer(1000, 0, 0, function ()
        for k,v in pairs(SpawnController.UnitListByActorId) do 
            if v["actor"]==nil or  sc.IsAlive(v["actor"])==false then
                -- 取消actor记录
                SpawnController.UnitListByActorId[k]=nil
            end
        end
    end, {})
   
  
end


--- 游戏开始
function SpawnController:GameStart()
    SpawnController:BaseStateInit()
    SpawnController:FB1_3()
    SpawnController:FB4_6()
    SpawnController:FB7_9()
    SpawnController:FB10_12()
    SpawnController:BASE_UNIT()
    QiPrint("SpawnController GameStart")
    --刷新基地

     -- 刷新商店
    --  SpawnController.shop1=SpawnUnit("unit_base_npc_weitianzhu",Entity["npc_spawn_weitianzhu"]["pos"],{
    --     can_move=false,
    --     camp=DOTA_TEAM_GOODGUYS,
    --     actorType=0,
    --     direction=VInt3.new(0,0,1)
    --     -- unityObject=Entity["base_position"]["m_binderObj"],
    -- })
    sc.UGCSendMsg("send_base_unit", { base_actorRoot=SpawnController.base_unit})
    -- SpawnController:CreateUIObject(SpawnController.xiuliannpc,2)
    -- SpawnController:CreateUIObject(SpawnController.xiuliannpc,2)
    -- SpawnController:CreateUIObject(SpawnController.xiuliannpc,2)
    -- SpawnController:CreateUIObject(SpawnController.xiuliannpc,2)
    -- SpawnController:CreateUIObject(SpawnController.xiuliannpc,2)
    -- SpawnController:CreateUIObject(SpawnController.xiuliannpc,2)
    -- SpawnController:CreateUIObject(SpawnController.base_unit,2)
    -- 设置NPC属性
    -- UnitController:SetNPC(SpawnController.xiuliannpc)
    MusicController:Start()
end

function SpawnController:CreateUIObject(actor,sprite_name)
    local actorID = sc.GetActorSystemProperty(actor,1004)
    local sprite_path=s_path
    local eventname = nil
    eventname = StringId.new("ShowCustomFollow3DUI")
    local eventName = StringId.new("SetAttackInfo")
    QiPrint("CreateUIObject")
    QiPrint("actorID"..tostring(actorID))
    QiPrint("s_type"..tostring(sprite_name))
    -- sc.CallUILuaFunction({actorID,s_type},eventname)
    sc.SetTimer(1000, 1, 0 , function ()
        sc.CallUILuaFunction({actorID,sprite_name},eventname)
    end, {})
    -- --调用(UIlua)SelectHero.lua里的函数,创建3DUI
end
--- 那些自动刷新的怪物 


--- 练功房
function SpawnController:FarmRoomSpawn()
    QiPrint("FarmRoomSpawn")
    for i=1,4 do 
        AddAutoSpawnRoom("player_farmrroom_pos_"..tostring(i),
        Entity["player_farmrroom_pos_"..tostring(i)]["pos"],4000,16,2,{min_num=2},i)
    end
    -- 练功房NPC刷新
    SpawnController:FarmRoomNPC()
end

--- 练功房NPC刷新
function SpawnController:FarmRoomNPC()
    local l_entity_name="player_farmrroom_pos_"
    local distance=6000
    local fix_distance=distance-800
    for i=1,4 do 
        local s_name=l_entity_name..tostring(i)
        local s_pos=Entity[s_name]["pos"]
        SpawnController.farmroomnpc[i]={}
        local pos_list={
            {VInt3.new(s_pos.x+distance,s_pos.y,s_pos.z+fix_distance),VInt3.new(-1000,0,-1000)},
            {VInt3.new(s_pos.x+distance*-1,s_pos.y,s_pos.z+fix_distance*-1),VInt3.new(1000,0,1000)},
            {VInt3.new(s_pos.x+distance,s_pos.y,s_pos.z+fix_distance*-1),VInt3.new(-1000,0,1000)},
            {VInt3.new(s_pos.x+distance*-1,s_pos.y,s_pos.z+fix_distance),VInt3.new(1000,0,-1000)},
        }
    
        SpawnController.farmroomnpc[i]["kutong"]=SpawnUnit("unit_base_npc_kutong",pos_list[3][1],{
            can_move=false,
            camp=DOTA_TEAM_GOODGUYS,
            direction=pos_list[2][2],
            isinvincible=true,
            isnpc=true,
        })

        SpawnController.farmroomnpc[i]["xiulian"]=SpawnUnit("unit_base_npc_xiulian",pos_list[2][1],{
            can_move=false,
            camp=DOTA_TEAM_GOODGUYS,
            direction=pos_list[3][2],
            isinvincible=true,
            isnpc=true,
        })
        -- SpawnController.farmroomnpc[i]["mijing"]=SpawnUnit("unit_base_npc_mijingxuanshang",pos_list[4][1],{
        --     can_move=false,
        --     camp=DOTA_TEAM_GOODGUYS,
        --     direction=pos_list[1][2],
        --     isinvincible=true,
        --     isnpc=true,
        -- })
        if IS_VERIFY_VERSION==false then 
            SpawnController.farmroomnpc[i]["shadi"]=SpawnUnit("unit_base_npc_shadi",pos_list[1][1],{
                can_move=false,
                camp=DOTA_TEAM_GOODGUYS,
                direction=pos_list[4][2],
                isinvincible=true,
                isnpc=true,
            })        
            SpawnController:CreateUIObject(SpawnController.farmroomnpc[i]["shadi"],"farm_killpoint")
            sc.SetInvincible(true,SpawnController.farmroomnpc[i]["shadi"])
        end

        SpawnController:CreateUIObject(SpawnController.farmroomnpc[i]["kutong"],"farm_jieti")
        SpawnController:CreateUIObject(SpawnController.farmroomnpc[i]["xiulian"],"farm_xiulianzhidi")
        -- SpawnController:CreateUIObject(SpawnController.farmroomnpc[i]["mijing"],"farm_mijingxuanshang")

        sc.SetInvincible(true,SpawnController.farmroomnpc[i]["kutong"])
        sc.SetInvincible(true,SpawnController.farmroomnpc[i]["xiulian"])
        -- sc.SetInvincible(true,SpawnController.farmroomnpc[i]["mijing"])
    end
end

function SpawnController:GameAutoSpawn()
    --友军防守势力
 
    -- AddAutoSpawnPoint("auto_spawn_beermonster_1","unit_nature_normal_beermonster",Entity["spawn_pos_juxiongguai_2"]["pos"],
    -- 10000,8,10,{min_num=2})
end

--- 获取进攻波数
function SpawnController:GetWaveNumber()
    if SpawnController.nowwave<=0 then return 0 end
    if SpawnController.nowwave>15 then return 15 end 
    return SpawnController.nowwave
end

--- 自动刷新进攻怪物
function SpawnController:AttackUnitTimer()
    local hp_data={
        [0]=1000,
        [1]=1000,
        [2]=1000,
        [3]=3500,
        [4]=3500,
        [5]=6000,
        [6]=6000,
        [7]=8000,
        [8]=8000,
        [9]=10000,
        [10]=60000,
        [11]=90000,
        [12]=100000,
        [13]=120000,
        [14]=350000,
        [15]=350000,
        [16]=120000,
        [17]=120000,
    }
    local check_interval_time=1
    local spawn_attack_unit_check_func=function (data)
        for k,v in pairs(SpawnController.attackUnitList) do 
            if sc.IsActorEqualNull(v)==true or sc.IsActorDead(v)==true then 
                SpawnController.attackUnitList[k]=nil
            end
        end
        local attack_unit_total_num=0
        for k,v in pairs(SpawnController.attackUnitList) do 
            attack_unit_total_num=attack_unit_total_num+1
        end
        if attack_unit_total_num~=SpawnController.attack_unit_total_num then 
            local eventName = StringId.new("SetAttackUnitNumInfoPanel")
            sc.CallUILuaFunction({attack_unit_total_num},eventName)
        end
        SpawnController.attack_unit_total_num=attack_unit_total_num
        SpawnController.nextwavetime=SpawnController.nextwavetime-1
        local eventName = StringId.new("SetAttackInfo")
        if SpawnController.nextwavetime==60 then 
            SpawnController.attackUnitList={}
        end
        if SpawnController.nextwavetime<=60 and SpawnController.nextwavetime%10==0  and SpawnController.nowwave>0 then 
            QiBottomAlert(tostring(SpawnController.nowwave) .." 波<color=#ff0000>魔军部队</color>将在 <color=#ff0000>" ..tostring(SpawnController.nextwavetime) .." 秒</color>后<color=#ff0000>进攻</color>",nil,-1)
            QiMsg("[警告] 第 ".. tostring(SpawnController.nowwave) .." 波<color=#ff0000>魔军部队</color>将在 <color=#ff0000>" ..tostring(SpawnController.nextwavetime) .." 秒</color>后<color=#ff0000>进攻</color>", 1)
        end
        sc.CallUILuaFunction({row=math.floor(SpawnController.nowwave-1),remain_time=math.floor(SpawnController.nextwavetime)} , eventName)
        if SpawnController.nextwavetime<=0 then 
            SpawnController.nextwavetime=SPAWN_NEXT_WAVETIME
            if SpawnController.nowwave>0 then 
                local blood_alert_event = StringId.new("ShowBloodAlert")
                sc.CallUILuaFunction({} , blood_alert_event)
                MusicController:SwitchState(1)
                SpawnNextWaveAttackUnit(SpawnController.nowwave)
                sc.PlayCustomSound(MUSIC_BACKGROUND_EVENT,StringId.new("Sound/all_attack.ogg"),1)
            end
            SpawnController.nowwave=SpawnController.nowwave+1
            local set_hp=hp_data[SpawnController.nowwave]
            -- 审核版本基地血量变多
            if IS_VERIFY_VERSION==true then 
                set_hp=set_hp*10
            end
            sc.SetActorSystemProperty(SpawnController.base_unit,5,set_hp)
            -- 
            sc.SetActorSystemProperty(SpawnController.base_unit,ActorAttribute_HP,sc.GetActorSystemProperty(SpawnController.base_unit,ActorAttribute_MaxHp))
        end
    end
    if SPAWN_UNIT_THINK==true then 
        sc.SetTimer(check_interval_time*1000, 1, 0 , spawn_attack_unit_check_func, {})
    end
end