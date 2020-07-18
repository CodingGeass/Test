function SpawnController:BASE_UNIT()

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
        -- 基地商店
        SpawnController.weitianshop=SpawnUnit("unit_base_npc_weitianshop",Entity["npc_spawn_weitianzhu"]["pos"],{
            can_move=false,
            camp=DOTA_TEAM_GOODGUYS,
            actorType=0,
            direction=VInt3.new(0,0,1),
            isnpc=true,
        })
        SpawnController:CreateUIObject(SpawnController.weitianshop,"base_normalshop")
        sc.SetInvincible(true,SpawnController.weitianshop)
         -- 遗迹商人
        SpawnController.yijishangren=SpawnUnit("unit_base_npc_yijishangren",Entity["spawn_pos_yijishop"]["pos"],{
            can_move=false,
            camp=DOTA_TEAM_GOODGUYS,
            actorType=0,
            direction=VInt3.new(0,0,-1),
            isnpc=true,
        })
        sc.SetInvincible(true,SpawnController.yijishangren)
        SpawnController:CreateUIObject(SpawnController.yijishangren,"shop_yijishangren")
    end
    SpawnController.youjienpc=SpawnUnit("unit_base_npc_youjie",Entity["npc_spawn_bosstiaozhan"]["pos"],{
        can_move=false,
        camp=DOTA_TEAM_GOODGUYS,
        actorType=0,
        direction=VInt3.new(0,0,1),
        isnpc=true,
    })
    SpawnController:CreateUIObject(SpawnController.youjienpc,"base_boss")
  
    sc.SetInvincible(true,SpawnController.xiuliannpc)
    sc.SetInvincible(true,SpawnController.youjienpc)
end