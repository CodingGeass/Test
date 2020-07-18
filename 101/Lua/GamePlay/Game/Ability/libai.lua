-- 李白1技能普攻
function libai_normal_attack(keys)
    local caster=keys.caster
    local target=keys.target
    local c_pos,c_rotation,c_for=sc.GetActorLogicPos(caster)
    sc.PlayActorAnimation(caster, StringId.new("Atk"..tostring(math.random(1,4))), 150, 0, false,false, false)
    local buff_radio=5000
    local phantom_count=1
    for i=1,phantom_count do 
        -- sc.SetTimer(150*i,0,1,function ()
        --     QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/131_LiBai/LiBai_attack05_spell03.prefab",
        --     caster,VInt3.new(math.random(-2000,2000), 500,math.random(-2000,2000)),VInt3.new(0,0,0),1000,false,2000,{speed=-1000})
        -- end,{})caster
    end
    if sc.ActorHasBuffCount(caster, 801021)>0 then
        sc.SetTimer(300,0,1,function ()
            if caster~=nil and sc.IsAlive(caster)==true then 
                local partilce={
                    "Prefab_Skill_Effects/Hero_Skill_Effects/522_DongFangYao/DongFangYao_attack02_spell03C.prefab",
                    "Prefab_Skill_Effects/Hero_Skill_Effects/522_DongFangYao/DongFangYao_attack02_spell01.prefab",
                    "Prefab_Skill_Effects/Hero_Skill_Effects/522_DongFangYao/DongFangYao_attack02_spell02.prefab",
                }
                QiParticle(partilce[math.random(1,#partilce)],
                    caster,VInt3.new(0, 0,1500),VInt3.new(0,0,0),1000,false,2000,{})
                local t_pos=sc.GetActorLogicPos(caster)
                t_pos.z=t_pos.z+1500
                local units=FindUnitsInRadio(t_pos,buff_radio)
                for __,i in pairs(units) do
                    sc.BuffAction(i,caster,true,true,131010,0,0)
                    QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/522_DongFangYao/DongFangYao_hurt0"..tostring(math.random(1,3))..".prefab",
                    i,VInt3.new(0, 300,0),VInt3.new(0,0,0),1000,false,2000,{})
                end
            end
            QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/522_DongFangYao/DongFangYao_attack_0"..tostring(math.random(1,4))..".prefab",
                caster,VInt3.new(0, 0,0),VInt3.new(0,0,0),1000,false,2000,{})
        end,{})
    else 
                sc.SetTimer(300,0,1,function ()
            QiParticle("prefab_skill_effects/hero_skill_effects/131_libai/libai_attack_0"..tostring(math.random(1,4))..".prefab",
                caster,VInt3.new(0, 0,0),VInt3.new(0,0,0),1500,false,2000,{})
        end,{})
    end
end
function libai_attack_land(keys)
    local caster=keys.caster
    local target=keys.target
    if sc.ActorHasBuffCount(caster, 801021)>0 then 
        
    else 
        QiParticle("prefab_skill_effects/hero_skill_effects/131_libai/libai_hurt_spell02.prefab",
                                    target,VInt3.new(0, 0,0),VInt3.new(0,0,0),600,false,2000,{})
        QiParticle("prefab_skill_effects/hero_skill_effects/131_libai/libai_hurt_01.prefab",
                                    target,VInt3.new(0, 0,0),VInt3.new(0,0,0),1000,false,2000,{})
    end
            
    
end
function libai_ability_1(keys)
    local caster=keys.caster
    local radio=6500
    local hit_time=12
    local func_timenext=150
    local c_pos=sc.GetActorLogicPos(caster)

    local u_caster=sc.GetUnityObjectFromActorRoot(caster)
    QiPrint("libai_ability_2",3)
    local units=FindUnitsInRadio(c_pos,radio)
    if #units>0 then
        for i=1,hit_time do 
            local target=units[math.random(1,#units)]
            sc.SetTimer(func_timenext*i,0,1,function ()
                c_pos=sc.GetActorLogicPos(caster)
                units=FindUnitsInRadio(c_pos,radio)
                for i=1,2 do 
                    if target~=nil and sc.IsAlive(target)==true then
                        QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/131_LiBai/LiBai_attack05_spell03.prefab",
                        target,VInt3.new(math.random(-2000,2000), 500,math.random(-2000,2000)),VInt3.new(0,0,0),800,false,2000,{speed=500})
                        sc.SetTimer(140,0,1,function ()
                            if target~=nil and sc.IsAlive(target)==true then
                                sc.BuffAction(target,caster,true,true,1311001,0,0)
                                QiParticle("Prefab_Skill_Effects/Common_Effects/PVE_talent/rizhita_zhaohuan_xunjie02.prefab",
                                target,VInt3.new(0, 500,0),VInt3.new(0,0,0),600,false,2000,{})
                            end
                        end,{})
                    else
                    end
                end
            end,{})
        end
    end
end


function libai_ability_2(keys)
    -- Prefab_Skill_Effects/Hero_Skill_Effects/107_Zhaoyun/ZhaoyunN_attack01_spell03A.prefab
    local caster=keys.caster
    local target=keys.target
    local base_distance=4000
    local c_pos=sc.GetActorLogicPos(caster)
    local radio=7500
    local particle_pos_1={
        VInt3.new(base_distance, 500,0),
        VInt3.new(-base_distance, 500,0),
        VInt3.new(0, 500,base_distance),
        VInt3.new(0, 500,-base_distance),
        
    }
    local particle_pos_2={
        VInt3.new(base_distance, 500,base_distance),
        VInt3.new(-base_distance, 500,base_distance),
        VInt3.new(base_distance, 500,-base_distance),
        VInt3.new(-base_distance, 500,-base_distance),
    }
    -- 一层特效
    for k,v in pairs(particle_pos_1) do 
        QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/107_Zhaoyun/ZhaoyunN_attack01_spell03A.prefab",
                        target,v,VInt3.new(0,0,0),1000,false,2000,{})
    end
    -- 二层特效
    sc.SetTimer(400,1,1,function ()
        for k,v in pairs(particle_pos_2) do 
            QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/107_Zhaoyun/ZhaoyunN_attack01_spell03A.prefab",
                                    target,v,VInt3.new(0,0,0),1000,false,2000,{})
        end
    end,{})
    local units=FindUnitsInRadio(c_pos,radio)
    for __,i in pairs(units) do
        sc.BuffAction(i,caster,true,true,131015,0,0)
        QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/522_DongFangYao/DongFangYao_hurt0"..tostring(math.random(1,3))..".prefab",
        i,VInt3.new(0, 300,0),VInt3.new(0,0,0),1000,false,2000,{})
    end
    -- local random_attack_name="Prefab_Skill_Effects/Hero_Skill_Effects/107_Zhaoyun/10701/ZhaoYunN_attack_01.prefab"
    -- Prefab_Skill_Effects/Common_Effects/PVE_zhanchang/rizita_fenjiegongji.prefab
    -- Prefab_Skill_Effects/Level_Effects/PVE_Rizita/RiZhiTa_ShuangZi_skill3_hurt_low.prefab
end

-- 李白
function libai_ability_3(keys)
    local caster=keys.caster
    local target=keys.target
    local buffid=600126
    local duraion=12
    sc.BuffAction(caster,caster,true,true,tonumber(buffid),0,0)

    QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/149_LiuBang/Liubang_buff_spell02b.prefab",
    caster,VInt3.new(0,0,0),VInt3.new(0,0,0),1000,true,duraion*1000,{})
    QiParticle("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/Rizhita_Boss_skill02_4mingzhongBOSS_low.prefab",
    caster,VInt3.new(0,0,0),VInt3.new(0,0,0),1500,true,1000,{})
    
    QiParticle("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/Rizhita_BossMoZhong_attack02_spell01_low.prefab",
    caster,VInt3.new(0,0,0),VInt3.new(0,0,0),1000,true,1000,{})
    QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/135_XiangYu/XiangYu_debuff_spell02.prefab",
    caster,VInt3.new(0,0,0),VInt3.new(0,0,0),1500,true,duraion*1000,{})
    sc.BuffAction(caster,caster,true,true,801021,0,0)
end