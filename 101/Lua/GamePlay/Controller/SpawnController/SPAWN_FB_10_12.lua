function SpawnController:FB10_12()
    AddAutoSpawnPoint("spawn_pos_shihuo_1","unit_fb_10_shihuo",
    Entity["spawn_pos_shihuo_1"]["pos"],5000,8,30,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_shihuo_2","unit_fb_10_shihuo",
    Entity["spawn_pos_shihuo_2"]["pos"],5000,8,30,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_shihuo_3","unit_fb_10_shihuo",
    Entity["spawn_pos_shihuo_3"]["pos"],5000,6,30,{min_num=2})
    AddAutoSpawnPoint("spawn_pos_rongshan_1","unit_fb_10_rongshan",
    Entity["spawn_pos_shihuo_3"]["pos"],0,1,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_junwang_1","unit_fb_10_junwang",
    Entity["spawn_pos_junwang_1"]["pos"],0,1,10,{min_num=1})

    AddAutoSpawnPoint("spawn_pos_canglang_1","unit_fb_11_canglang",
    Entity["spawn_pos_canglang_1"]["pos"],0,1,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_shikong_1","unit_fb_11_shikong",
    Entity["spawn_pos_shikong_1"]["pos"],0,1,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_yinze_1","unit_fb_11_yinze",
    Entity["spawn_pos_yinze_1"]["pos"],0,1,10,{min_num=1})
    AddAutoSpawnPoint("spawn_pos_huanying_1","unit_fb_11_huanying",
    Entity["spawn_pos_huanying_1"]["pos"],0,1,10,{min_num=1})
end