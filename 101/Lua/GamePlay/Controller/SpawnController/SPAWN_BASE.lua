function SpawnController:BASE_UNIT()
    -- AddAutoSpawnPoint("base_friend_unit_melee_attack1","unit_tiandi_soldier_melee",Entity["base_friend_unit_melee_attack1"]["pos"],
    -- 3000,4,60,{min_num=2,camp=DOTA_TEAM_GOODGUYS})
    -- AddAutoSpawnPoint("base_friend_unit_melee_attack2","unit_tiandi_soldier_melee",Entity["base_friend_unit_melee_attack2"]["pos"],
    -- 3000,4,60,{min_num=2,camp=DOTA_TEAM_GOODGUYS})
    -- AddAutoSpawnPoint("base_position","unit_tiandi_soldier_range",Entity["base_position"]["pos"],
    -- 3000,4,60,{min_num=2,camp=DOTA_TEAM_GOODGUYS})
    -- AddAutoSpawnPoint("base_friend_unit_paoche","unit_tiandi_soldier_catapult",Entity["base_friend_unit_paoche"]["pos"],
    -- 3000,1,60,{min_num=1,camp=DOTA_TEAM_GOODGUYS})
    SpawnController.base_unit=SpawnUnit("unit_weitian_citymaster",Entity["base_position"]["pos"],{
        can_move=true,
        camp=DOTA_TEAM_GOODGUYS,
        actorType=0,
        direction=VInt3.new(0,0,1)
    },"normal")
    SpawnController:CreateUIObject(SpawnController.base_unit,"base_jianzun")
    -- 刷新商店
    SpawnController.xiuliannpc=SpawnUnit("unit_base_npc_cangshusheng",Entity["npc_spawn_cangshusheng"]["pos"],{
        can_move=false,
        camp=DOTA_TEAM_GOODGUYS,
        actorType=0,
        direction=VInt3.new(0,0,1),
        isnpc=true,
    })
    SpawnController:CreateUIObject(SpawnController.xiuliannpc,"base_xiudao")

    if IS_VERIFY_VERSION==false then 
        SpawnController.suanmingnpc=SpawnUnit("unit_base_npc_suanming",Entity["base_spawn_suanming"]["pos"],{
            can_move=false,
            camp=DOTA_TEAM_GOODGUYS,
            actorType=0,
            direction=VInt3.new(0,0,1),
            isnpc=true,
        })
        SpawnController:CreateUIObject(SpawnController.suanmingnpc,"base_zhanbu")
        sc.SetInvincible(true,SpawnController.suanmingnpc)
    end
    SpawnController.youjienpc=SpawnUnit("unit_base_npc_youjie",Entity["npc_spawn_bosstiaozhan"]["pos"],{
        can_move=false,
        camp=DOTA_TEAM_GOODGUYS,
        actorType=0,
        direction=VInt3.new(0,0,1),
        isnpc=true,
    })
    SpawnController:CreateUIObject(SpawnController.youjienpc,"base_boss")
    SpawnController.weitianshop=SpawnUnit("unit_base_npc_weitianshop",Entity["npc_spawn_weitianzhu"]["pos"],{
        can_move=false,
        camp=DOTA_TEAM_GOODGUYS,
        actorType=0,
        direction=VInt3.new(0,0,1),
        isnpc=true,
    })
    SpawnController:CreateUIObject(SpawnController.weitianshop,"base_normalshop")
    sc.SetInvincible(true,SpawnController.xiuliannpc)
    sc.SetInvincible(true,SpawnController.youjienpc)
    sc.SetInvincible(true,SpawnController.weitianshop)
end