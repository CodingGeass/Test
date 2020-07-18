if TeleportController==nil then 
    TeleportController={}
    TeleportController.area={}
    TeleportController.area["b_base"]={
        pos="base_position",
        schinese="<color=#0066ff>长安城</color>",
        description="守卫长安城，在此抵御敌军的进攻",
        short_des="玩家主城",
        Tier=0,
        index=99,
    }
    TeleportController.area["b_liangong"]={
        pos="liangong",
        schinese="<color=#00ff00>练功房</color>",
        description="提供给修炼侠士修道的安静场所",
        short_des="可供玩家进行修炼",
        Tier=0,
        index=100,
    }
    TeleportController.area["n0_weitiansenling"]={
        pos="n0_weitiansenling",
        schinese="<color=#ffb3b3>长安森林</color>",
        description="长安城旁边的森林，适合初级修炼者",
        short_des="秘境等级1",
        Tier=1,
        index=0,
    }
    
    TeleportController.area["n1_baihua"]={
        pos="n1_baihua",
        schinese="<color=#ffb3b3>百花谷</color>",
        description="存在于长安城古籍中的室外桃园",
        short_des="秘境等级1",
        Tier=1,
        index=1,
    }

    TeleportController.area["n2_jiulong"]={
        pos="n2_jiulong",
        schinese="<color=#ff9999>九龙寨</color>",
        description="山贼的大本营",
        short_des="秘境等级2",
        Tier=2,
        index=2,
    }

    TeleportController.area["n3_jifeng"]={
        pos="n3_jifeng",
        schinese="<color=#ff9999>疾风崖</color>",
        description="险峻的山崖，最令人丧胆的是在此处出没的山风兽",
        short_des="秘境等级3",
        Tier=3,
        index=3,
    }
    
    TeleportController.area["n4_feihuang"]={
        pos="n4_feihuang",
        schinese="<color=#ff8080>飞蝗河谷</color>",
        description="受到蝗虫侵袭的所在，方圆百里早已无人烟",
        short_des="秘境等级4",
        Tier=4,
        index=4,
    }
    
    TeleportController.area["n5_lingtai"]={
        pos="n5_lingtai",
        schinese="<color=#ff6666>灵台</color>",
        description="内中有许多珍奇异兽",
        short_des="秘境等级5",
        Tier=5,
        index=5,
    }
    
    TeleportController.area["n6_kunlun"]={
        pos="n6_kunlun",
        schinese="<color=#ff6666>昆仑后山</color>",
        description="修仙求道传说起源的地方",
        short_des="秘境等级6",
        Tier=6,
        index=6,
    }
    
    TeleportController.area["n7_nvwa"]={
        pos="n7_nvwa",
        schinese="<color=#ff4d4d>女娲秘境</color>",
        description="",
        short_des="秘境等级7",
        Tier=7,
        index=7,
    }
    
    TeleportController.area["n8_xueshan"]={
        pos="n8_xueshan",
        schinese="<color=#ff4d4d>千年雪山</color>",
        description="",
        short_des="秘境等级8",
        Tier=8,
        index=8,
    }
    
    TeleportController.area["n9_jile"]={
        pos="n9_jile",
        schinese="<color=#ff3333>极乐净土</color>",
        description="",
        short_des="秘境等级9",
        Tier=9,
        index=9,
    }
    
    TeleportController.area["n10_zhulu"]={
        pos="n10_zhulu",
        schinese="<color=#ff3333>炎焰山</color>",
        description="",
        short_des="秘境等级10",
        Tier=10,
        index=10,
    }
    
    TeleportController.area["n11_shushan"]={
        pos="n11_shushan",
        schinese="<color=#ff1a1a>蜀山剑冢</color>",
        description="",
        short_des="秘境等级11",
        Tier=11,
        index=11,
    }
    
    TeleportController.area["n12_youjie"]={
        pos="n12_youjie",
        schinese="<color=#ff1a1a>幽界之井</color>",
        description="",
        short_des="秘境等级12",
        Tier=12,
        index=12,
    }
    TeleportController.area["s1_yaota1"]={
        pos="s1_yaota",
        schinese="<color=#ff1a1a>苦痛阶梯</color>",
        description="",
        short_des="秘境等级",
        Tier=12,
        index=101,
    }
    TeleportController.area["s2_boss"]={
        pos="s2_boss",
        schinese="<color=#ff1a1a>幽界之井</color>",
        description="",
        short_des="秘境等级",
        Tier=12,
        index=102,
    }
    TeleportController.t_list={
        [1]="b_base",
        [2]="b_liangong",
        [3]="n0_weitiansenling",
        [4]="n1_baihua",
        [5]="n2_jiulong",
        [6]="n3_jifeng",
        [7]="n4_feihuang",
        [8]="n5_lingtai",
        [9]="n6_kunlun",
        [10]="n7_nvwa",
        [11]="n8_xueshan",
        [12]="n9_jile",
        [13]="n10_zhulu",
        [14]="n11_shushan",
        [15]="n12_youjie",
    }
end

--- 初始化
function TeleportController:init()

end

--- 传送到
function TeleportController:TeleportTo(aid,e_name)
    QiPrint("GamePlayer teleport to")
    local t_list=TeleportController.area[e_name]
    local pid=PlayerController["aidlist"][aid]
    if t_list then 
        local s_name=t_list["schinese"]
        local pos_name=t_list["pos"]
        if pos_name=="liangong" then 
            pos_name=PlayerController["liangong"][pid]
        end
        QiMsg("AID"..tostring(aid).."玩家["..tostring(pid).."]".."TP "..pos_name, 5)
        QiPrint(" sc teleport "..tostring(s_name).." "..tostring(pos_name))
        QiMsg("传送到["..s_name.."]",5)
        QiBottomAlert("传送到["..s_name.."]",nil,aid)
        if Entity[pos_name]==nil then 
            -- QiMsg("找不到"..tostring(pos_name),5)
        else
            MainAlert(aid,t_list["schinese"],t_list["description"],3)
            sc.TeleportActor(PlayerController[pid]["actor"],sc.GameObject_Nil,Entity[pos_name]["pos"],Entity[pos_name]["forward"])
            TeleportController:SetPlayerArea(pid,t_list["index"])
        end
    else
        
        -- QiMsg("没有找到,无法传送"..tostring(e_name),5)
    end
end

--- 设置玩家区域
function TeleportController:SetPlayerArea(pid,index)
    PlayerController[pid]["area_index"]=index
end