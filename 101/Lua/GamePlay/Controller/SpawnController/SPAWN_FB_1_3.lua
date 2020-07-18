
--副本1-3
function SpawnController:FB1_3()
    if IS_VERIFY_VERSION==false then 
        SpawnController.wishnpc=SpawnUnit("unit_base_npc_xuyuan",Entity["spawn_pos_npc_wish"]["pos"],{
            can_move=false,
            camp=DOTA_TEAM_GOODGUYS,
            actorType=0,
            direction=VInt3.new(0,0,-1),
            isnpc=true,
        })
        SpawnController:CreateUIObject(SpawnController.wishnpc,"npc_wish")
        sc.SetInvincible(true,SpawnController.wishnpc)
    end
    -- 练功房
    AddAutoSpawnPoint("spawn_pos_juxiong_1","unit_fb_0_juxiong",
    Entity["spawn_pos_juxiong_1"]["pos"],5000,8,10,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_juxiong_2","unit_fb_0_juxiong",
    Entity["spawn_pos_juxiong_2"]["pos"],5000,8,10,{min_num=2})

    AddAutoSpawnPoint("spawn_pos_huayao_1","unit_fb_1_huayao",
    Entity["spawn_pos_huayao_1"]["pos"],6000,8,10,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_huayao_2","unit_fb_1_huayao",
    Entity["spawn_pos_huayao_2"]["pos"],6000,8,10,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_huayaowang_1","unit_fb_1_huayaowang",
    Entity["spawn_pos_huayaowang_1"]["pos"],0,1,10,{min_num=1})

    AddAutoSpawnPoint("spawn_pos_jiulonglouzuo_1","unit_fb_2_jiulonglouluo",
    Entity["spawn_pos_jiulonglouzuo_1"]["pos"],6000,14,20,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_jiulonglouzuo_2","unit_fb_2_jiulonglouluo",
    Entity["spawn_pos_jiulonglouzuo_2"]["pos"],4000,10,10,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_jiulonglouzuo_3","unit_fb_2_jiulonglouluo",
    Entity["spawn_pos_jiulonglouzuo_3"]["pos"],4000,10,10,{min_num=2})

    AddAutoSpawnPoint("spawn_pos_jiulong_boss_3","unit_fb_2_boss_jiulong_boss1",
    Entity["spawn_pos_jiulong_boss_3"]["pos"],0,1,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_jiulong_boss_2","unit_fb_2_boss_jiulong_boss2",
    Entity["spawn_pos_jiulong_boss_2"]["pos"],0,1,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_jiulong_boss_1","unit_fb_2_boss_jiulong_boss3",
    Entity["spawn_pos_jiulong_boss_1"]["pos"],0,1,10,{min_num=1})

    AddAutoSpawnPoint("spawn_pos_fengxiaoguai_1","unit_fb_3_shanfengguai",
    Entity["spawn_pos_fengxiaoguai_1"]["pos"],8000,10,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_fengxiaoguai_2","unit_fb_3_shanfengguai",
    Entity["spawn_pos_fengxiaoguai_2"]["pos"],8000,10,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_fengxiaojushou","unit_fb_3_boss_fengxiaojushou",
    Entity["spawn_pos_fengxiaojushou"]["pos"],0,1,20,{min_num=1})
end
