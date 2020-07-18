SPAWN_ATTACK_TYPE_NOMAL=1
SPAWN_ATTACK_TYPE_SPECIAL=2
SPAWN_ATTACK_TYPE_BOSS=3

-- 刷新怪物
function SpawnUnit(unit_name,pos,data,ai)
    -- PrintTable(QiData.unit_property)
    -- QiPrint("spawnunit"..unit_name)
    if QiData.unit_property[unit_name]==nil then 
        QiPrint("Spawn error cant find :"..unit_name,5)
        return
    end
    local u_data=QiData.unit_property[unit_name]
    local cfgId=tonumber(QiData.unit_property[unit_name]["unit_config_id"])
    -- QiPrint("cfgId"..tostring(cfgId))
    local unityObject=data.unityObject or sc.GameObject_Nil 
    local spawnPos=pos or VInt3.Zero()
    local direction=data.direction or VInt3.new(-180+RandomInt(360), 0, -180+RandomInt(360)) 
    local camp=data.camp or DOTA_TEAM_BADGUYS
    local actorType=tonumber(u_data["actorType"])
    if actorType==nil then 
        actorType=data.actorType or 1
    end
    -- local actorType=data.actorType or 1
    local isinvincible=data.isinvincible or false
    local can_move=data.can_move or true
    local isnpc=data.isnpc or false
    local skin=1
    if actorType==0 then
        skin=tonumber(QiData.unit_property[unit_name]["skin"]) 
        if skin==-1 then 
            skin=1
        end
    end
    if skin==nil then 
        skin=1 
    end
    local actor = sc.SpawnActor(unityObject, spawnPos, direction, cfgId, actorType,
     camp, isinvincible, can_move,skin)
     if IS_VERIFY_VERSION==true then 
        for i=1,11 do 
            sc.DelSkill(actor,i)
        end
     end
    -- SpawnController.UnitListByActorId
    QiUnit:new({},actor,unit_name,camp)
    --设置刷新的英雄单位禁止复活
    if actorType==0 then 
        sc.DisableActorRevive(actor,true)
    end
    if actor~=nil then 
        if isnpc==true then 
            UnitController:SetNPC(actor)
        end
        local actor_id=sc.GetActorSystemProperty(actor,1004)
        local u_data=copy_table(QiData.unit_property[unit_name])
        u_data["isinvincible"]=isinvincible
        u_data["actor"]=actor
        SpawnController:RecordUnitInfo(actor_id,u_data)
        if ai=="normal" then 
            AINormal:MakeInstance( actor, {spawnPos=pos} )
        end
    end
    return actor
end

-- 增加自动刷怪点
function AddAutoSpawnPoint(uniquestr,unit_name,pos,radio,max_num,spawn_time,data)
    local min_num=data.min_num or 0
    local state_max=data.state_max or 9
    SpawnController.ulist[uniquestr]={}
    local actorlist=SpawnController.ulist[uniquestr]
    -- 刷新怪物
    local aotu_spawn_unit_fun=function (t_data)
        -- QiPrint("aotu_spawn_unit_fun")
        local spawnlist=t_data.spawnlist
        local max_num=t_data.max_num
        local min_num=t_data.min_num
        local unit_name=t_data.unit_name
        --当前刷新的数量
        local now_spawn_num=0
        for i=1,max_num do 
            if spawnlist[i]~=nil and sc.IsActorEqualNull(spawnlist[i])==false and sc.IsActorDead(spawnlist[i])==false then 
                now_spawn_num=now_spawn_num+1
            end
        end

        -- QiPrint("aotu_spawn_unit_fun now_spawn_num"..tostring(now_spawn_num))
        --达到最低刷怪要求
        if now_spawn_num<=min_num then 
            for i=1,max_num do 
                if spawnlist[i]==nil or sc.IsActorEqualNull(spawnlist[i])==true or sc.IsActorDead(spawnlist[i])==true then 
                    local spwan_pos = FindRandomPoint(pos,radio)
                    spawnlist[i]=SpawnUnit(unit_name,spwan_pos,data,"normal")
                end
            end
        end
    end
    sc.SetTimer(spawn_time*1000, 100, 0 , aotu_spawn_unit_fun, {unit_name=unit_name,spawnlist=actorlist,max_num=max_num,min_num=min_num})
end

-- 增加练功房
function AddAutoSpawnRoom(uniquestr,pos,radio,max_num,spawn_time,data,p_index)
    local min_num=data.min_num or 0
    local state_max=data.state_max or 9
    local pid=p_index-1
    SpawnController.ulist[uniquestr]={}
    local actorlist=SpawnController.ulist[uniquestr]
    -- 刷新怪物
    local aotu_spawn_unit_fun=function (t_data)
        local spawnlist=t_data.spawnlist
        local max_num=t_data.max_num
        local min_num=t_data.min_num
        local spawn_level= 1
        if PlayerController[pid]["QiXiulian"]~=nil then 
            spawn_level=PlayerController[pid]["QiXiulian"].level or 1
        end
        -- 以天书等级
        local unit_name="unit_farmroom_normal_"..tostring(spawn_level)
        -- QiPrint("AddAutoSpawnRoom unit_name"..tostring(unit_name))
        --当前刷新的数量
        local now_spawn_num=0
        for i=1,max_num do 
            if spawnlist[i]~=nil and sc.IsActorEqualNull(spawnlist[i])==false and sc.IsActorDead(spawnlist[i])==false then 
                now_spawn_num=now_spawn_num+1
            end
        end
        -- QiPrint("aotu_spawn_unit_fun "..unit_name.."now_spawn_num"..tostring(now_spawn_num))
        --达到最低刷怪要求
        if now_spawn_num<=min_num then 
            for i=1,max_num do 
                if spawnlist[i]==nil or sc.IsActorEqualNull(spawnlist[i])==true or sc.IsActorDead(spawnlist[i])==true then 
                    local spwan_pos = FindRandomPoint(pos,radio)
                    spawnlist[i]=SpawnUnit(unit_name,spwan_pos,data,"normal")
                end
            end
        end
    end
    sc.SetTimer(spawn_time*1000, 100, 0 , aotu_spawn_unit_fun, {unit_name=unit_name,spawnlist=actorlist,max_num=max_num,min_num=min_num})
end

--刷新下一波进攻怪物
function SpawnNextWaveAttackUnit(wave_number)
    QiMsg("[警告]魔军部队正在进攻长安城，请道友立刻回援！！！")
    QiMsg("[警告]魔军部队正在进攻长安城，请道友立刻回援！！！")
    QiMsg("[警告]魔军部队正在进攻长安城，请道友立刻回援！！！")
    local spwan_wave_list=QiData.unit_attack_property[wave_number]
    local music_state=1
    --根据信息刷新怪物
    for k,v in pairs(spwan_wave_list) do 
        local unit_name=v["unit_name"]
        local spawn_num=tonumber(v["spawn_num"])
        local attack_type=tonumber(v["attack_type"])
        local spawn_interval_time=tonumber(v["spawn_interval_time"])
        local spawn_wait_time=tonumber(v["spawn_wait_time"])
        local spawn_pos
        --判断将要刷新的进攻怪物类型
        if attack_type==SPAWN_ATTACK_TYPE_NOMAL then 
            MainAlert(-1,"敌军第["..tostring(wave_number.."]波进攻开始"),"请道友注意基地的防守",3)
            spawn_pos=SpawnController.main_spawn_posname
        elseif attack_type==SPAWN_ATTACK_TYPE_SPECIAL then 
            spawn_pos=SpawnController.special_spawn_posname
            MainAlert(-1,"敌军头目来袭","请尽快回防",4)
            -- MusicController:SwitchState(3)
            music_state=3
        elseif  attack_type==SPAWN_ATTACK_TYPE_BOSS then
            spawn_pos=SpawnController.main_spawn_posname
            MainAlert(-1,"大量精锐开始进攻！","发现大量敌方精锐部队，请所有道友立刻支援",5)
        end
        for i=1,spawn_num do 
            local spawn_entity_pos=spawn_pos[i%#spawn_pos+1]
            sc.SetTimer(i*350,1000,1,function ()
                local actorType=0
                if attack_type==SPAWN_ATTACK_TYPE_BOSS then 
                    actorType=1
                end
                local spawn_actor=SpawnUnit(unit_name,Entity[spawn_entity_pos]["pos"],{actorType=actorType})
                local aid=sc.GetActorSystemProperty(spawn_actor,ActorAttribute_ActorID )
                SpawnController.attackUnitList[aid]=spawn_actor
                AIAttack:MakeInstance( spawn_actor, {spawnPos=Entity["base_position"]["pos"]} )
            end,{})
        end
    end
    MusicController:SwitchState(music_state)
end

