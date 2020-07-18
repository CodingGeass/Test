function wangzhaojun_ability_base_attack_func(keys)
    QiPrint("wangzhaojun_ability_base_attack_func",3)
    local caster=keys.caster
    local target=keys.target
    local next_time=100
    local delay_time=100
    local hit_time=3
    local u_caster=sc.GetUnityObjectFromActorRoot(caster)
    local u_target=sc.GetUnityObjectFromActorRoot(target)
    local t_pos=sc.GetActorLogicPos(target)
    -- sc.PlayUGCAgeMultiObject(StringId.new("ability/hero_2_wangzhaojun/ability0/bullet/a3b21.xml"),{u_caster ,u_target,sc.GameObject_Nil,sc.GameObject_Nil},{})
    -- sc.PlayUGCAgeMultiObject(StringId.new("ability/hero_2_wangzhaojun/ability0/bullet/a3b31.xml"),{u_caster ,u_target,sc.GameObject_Nil,sc.GameObject_Nil},{})
    -- 创建发射投射物的age
    -- sc.PlayUGCAgeMultiObject(StringId.new("ability/hero_2_wangzhaojun/ability0/main_bullet.xml"),{u_caster ,u_target,sc.GameObject_Nil,sc.GameObject_Nil},{})
    for i=1,hit_time do
        sc.PlayUGCAgeMultiObject(StringId.new("ability/hero_2_wangzhaojun/ability0/bullet/a3b"..tostring(i).."1.xml"),{u_caster ,u_target,sc.GameObject_Nil,sc.GameObject_Nil},{})
        sc.SetTimer(next_time*i+delay_time,1,1,function ()
            if target~=nil and sc.IsAlive(target)==true then
                -- sc.BuffAction(target,caster,true,true,1520001,0,0)
                sc.PlayUGCAgeMultiObject(StringId.new("ability/hero_2_wangzhaojun/ability0/bullet/bullet_func.xml"),
                {u_caster ,u_target},{})
                local units=FindUnitsInRadio(t_pos,3500)
                for __,i in pairs(units) do 
                    sc.BuffAction(i,caster,true,true,15220000,0,0)
                end
            else
                sc.PlayUGCAgeMultiObject(StringId.new("ability/hero_2_wangzhaojun/ability0/bullet/bullet_func.xml"),
                {u_caster ,u_target},{})
                local units=FindUnitsInRadio(t_pos,3500)
                for __,i in pairs(units) do 
                    sc.BuffAction(i,caster,true,true,15220000,0,0)
                end
                -- units=FindUnitsInRadio(c_pos,radio)  
            end
        end,{})
    end
end

function wangzhaojun_ability_1_start(keys)
    QiPrint("wangzhaojun_ability_1_start", 5)
    local caster=keys.caster
    local hit_next_time=200
    local cast_duration=5.5
    local hit_time=math.floor(cast_duration/(hit_next_time/1000))
    local radio=6500
    local damage_buff_id=1521001

    local cast_flash_paticle=StringId.new("Prefab_Skill_Effects/Hero_Skill_Effects/146_HongFu/Hongfu_buff_01.prefab")
    local caster_particle=StringId.new("Prefab_Skill_Effects/Hero_Skill_Effects/152_WangZhaoJun/wangzhaojun_attack_spell03_mid.prefab")
    local caster_particle2=StringId.new("Prefab_Skill_Effects/Hero_Skill_Effects/118_SunBin/SunBing_fly_spell04.prefab")
 
    local bg_particle_radio_1=StringId.new("Prefab_Skill_Effects/Hero_Skill_Effects/118_SunBin/SunBing_attack_spell01.prefab")
    -- local bg_particle_radio_2=StringId.new("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/RiZhiTa_Chongzhuang_swirl01B.prefab")

    local hit_particle_1=StringId.new("Prefab_Skill_Effects/Hero_Skill_Effects/118_SunBin/SunBing_attack02_spell02_mid.prefab")
    local hit_particle_2=StringId.new("Prefab_Skill_Effects/Common_Effects/allhero_jiaxue_02_low.prefab")

    local caster_object=sc.GetUnityObjectFromActorRoot(caster)
    local bg_particle1=sc.TriggerParticleStart (bg_particle_radio_1, bg_particle_radio_1, bg_particle_radio_1,
    caster, false, caster_object, VInt3.new(0, 500,0), VInt3.new(0, 0,0),VInt3.new(2500, 1000,1000), true,true)
    local bg_particle2=sc.TriggerParticleStart (caster_particle, caster_particle, caster_particle,
    caster, false, caster_object, VInt3.new(0, 500,0), VInt3.new(0, 0,0),VInt3.new(1000, 1000,1000), true,true)
    local bg_particle3=sc.TriggerParticleStart (caster_particle2, caster_particle2, caster_particle2,
    caster, false, caster_object, VInt3.new(0, 500,0), VInt3.new(0, 0,0),VInt3.new(1200, 1000,1000), true,true)
    for i=1, 5 do 
        sc.SetTimer(1000*i,0,1,function ()
            local flash_particle=sc.TriggerParticleStart (cast_flash_paticle, cast_flash_paticle, cast_flash_paticle,
                    caster, false, caster_object, VInt3.new(0, 0,0), VInt3.new(0, 0,0),VInt3.new(1200, 1000,1000), true,true)
                    sc.SetTimer(2000,1,1,function ()
                        sc.TriggerParticleEnd (flash_particle)
                    end,{})
        end,{})
    end
    sc.SetTimer((cast_duration-1)*1000, 1, 1, function ()
        sc.TriggerParticleEnd (bg_particle1)
        sc.TriggerParticleEnd (bg_particle2)
        sc.TriggerParticleEnd (bg_particle3)
    end, {})
    for i=1,hit_time do
        -- 
            sc.SetTimer(hit_next_time*i,0,1,function ()
            local c_pos=sc.GetActorLogicPos(caster)
            -- 环境特效
            -- local env_pos=FindRandomPoint(c_pos,radio)
            local env_particle="Prefab_Skill_Effects/Level_Effects/PVE_Rizita/RiZhiTa_Chongzhuang_swirl01C.prefab"
            QiParticle(env_particle,caster,VInt3.new(math.random(-radio,radio), 500,math.random(-radio,radio)),VInt3.new(0,0,0),1500,false,2000,{speed=100})
            local units=FindUnitsInRadio(c_pos,radio)
            if #units>0 then 
                local target=units[math.random(1,#units)]
                if target~=nil and sc.IsAlive(target)==true then
                    local target_object=sc.GetUnityObjectFromActorRoot(target)
                    sc.BuffAction(target,caster,true,true,damage_buff_id,0,0)
                    local particle1=sc.TriggerParticleStart (hit_particle_1, hit_particle_1, hit_particle_1,
                    target, false, target_object, VInt3.new(0, 0,0), VInt3.new(0, 0,0),VInt3.new(1000, 1000,1000), true,false)
                    local particle2=sc.TriggerParticleStart (hit_particle_2, hit_particle_2, hit_particle_2,
                    target, false, target_object, VInt3.new(0, 0,0), VInt3.new(0, 0,0),VInt3.new(1800, 1000,1000), true,false)
                    -- 创建特效
                    sc.SetTimer(3000, 1, 1, function ()
                        sc.TriggerParticleEnd (particle1)
                        sc.TriggerParticleEnd (particle2)
                    end, {})
                end
            else 
                local particle1=sc.TriggerParticleStart (hit_particle_1, hit_particle_1, hit_particle_1,
                caster, false, caster_object, VInt3.new(math.random(radio), 0,math.random(radio)), VInt3.new(0, 0,0),VInt3.new(1000, 1000,1000), true,false)
                local particle2=sc.TriggerParticleStart (hit_particle_2, hit_particle_2, hit_particle_2,
                caster, false, caster_object, VInt3.new(math.random(radio), 0,math.random(radio)), VInt3.new(0, 0,0),VInt3.new(1800, 1000,1000), true,false)
                -- 创建特效
                sc.SetTimer(3000, 1, 1, function ()
                    sc.TriggerParticleEnd (particle1)
                    sc.TriggerParticleEnd (particle2)
                end, {})
            end
        end,{})

    end
end

--- function summary description.
-- function detail description.
-- @tparam  type keys description
-- @author 
function wangzhaojun_ability_2_ice_blink(keys)
    local caster=keys.caster
    local target=keys.target
    local c_pos=sc.GetActorLogicPos(caster)
    local t_pos=sc.GetActorLogicPos(target)
    local c_forward=VInt3.new(c_pos.x-t_pos.x,c_pos.y-t_pos.y,c_pos.z-t_pos.z)
    c_forward=c_forward:Normalize(1000)
    local hit_next_time=15
    -- 落地传送特效
    QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/332_MaKeBoLuo/33202/Makeboluo_attack01_spell04_a.prefab",
    caster,VInt3.new(0, 500,0),VInt3.new(0, 0,0),2400,true,2000,{})
    sc.SetTimer(800, 1, 1, function ()
        QiParticle("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/Rizhita_BossMoZhong_attack05_spell02.prefab",
        caster,VInt3.new(0, 500,0),VInt3.new(0, 0,0),800,true,600,{})
    end,{})
    sc.SetTimer(1200, 1, 1, function ()
        QiParticle("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/Rizhita_BossMoZhong_attack07_spell01.prefab",
        caster,VInt3.new(0, 500,0),VInt3.new(0, 0,0),300,true,2000,{})
    end,{})
-- Prefab_Skill_Effects/Hero_Skill_Effects/332_MaKeBoLuo/33201/Makeboluo_attack01_spell04_b_mid.prefab
    -- sc.TeleportActor(caster,sc.GameObject_Nil,t_pos,c_forward)
    local base_dis=2000
    local base_forward=VInt3.new(1000,0,0)
    local radio=8000
    local delaytime=600
    local attack_pos_func=function (caster,pos)
        pos= VInt3.new(pos.x,pos.y+500,pos.z)
        local s1=StringId.new("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/RiZhiTa_ShuangZi_hurt02.prefab")
        local s2=StringId.new("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/RiZhiTa_ShuangZi_hurt03.prefab")
        local u_object=sc.GetUnityObjectFromActorRoot(caster)
        local particle=sc.TriggerParticleStart (s1, s1, s1,
        caster, false, u_object, pos, VInt3.new(0, 0,0),VInt3.new(math.random(600,1000), 800,800), true,false)
        local particle2=sc.TriggerParticleStart (s2, s2, s2,
        caster, false, u_object, pos, VInt3.new(0, 0,0),VInt3.new(math.random(600,1000), 800,800), true,false)
        sc.SetTimer(5000, 1, 1, function ()
            sc.TriggerParticleEnd (particle)
            sc.TriggerParticleEnd (particle2)
        end, {})
    end
    local pre_attack_pos_func=function (caster,pos)
        pos= VInt3.new(pos.x,pos.y+500,pos.z)
        local s1=StringId.new("Prefab_Skill_Effects/Hero_Skill_Effects/127_ZhenJi/zhenji_hurt_spell01_mid.prefab")
        local u_object=sc.GetUnityObjectFromActorRoot(caster)
        local particle=sc.TriggerParticleStart (s1, s1, s1,
        caster, false, u_object, pos, VInt3.new(0, 0,0),VInt3.new(math.random(500,2500), 500,500), true,false)
        sc.SetTimer(600, 1, 1, function ()
            sc.TriggerParticleEnd (particle)
        end, {})
    end
    local func_num={
        [1]=0,
        [2]=0,
        [3]=6,
        [4]=9,
        [5]=15,
    }
    local finaly_list={}
    for i=1,5 do 
        local func_num_final=func_num[i] 
        for j=1,func_num_final do 
            local dir_per=360/func_num_final
            -- c_pos+
            local sim_dir=dir_rotation(base_forward,dir_per*j+2000)
            local posvalue=VInt3.new(math.floor(sim_dir.x*(i-1)*1.4),
            math.floor(sim_dir.y*(i-1)*1.4),math.floor(sim_dir.z*(i-1)*1.4))
            finaly_list[#finaly_list+1]=posvalue
        end
    end
    for k,v in pairs(finaly_list) do 
        sc.SetTimer(k*hit_next_time+delaytime, 1, 1, function ()
            attack_pos_func(caster,v)
        end, {})
    end
    for i=1,#finaly_list do 
        sc.SetTimer(i*hit_next_time, 1, 1, function ()
            if finaly_list[#finaly_list-i+1]~=nil then 
                pre_attack_pos_func(caster,finaly_list[#finaly_list-i+1])
                QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/332_MaKeBoLuo/33201/Makeboluo_attack01_spell04_b_mid.prefab",
                caster,VInt3.new(math.random(-radio,radio), 500,math.random(-radio,radio)),VInt3.new(0,0,0),500,false,2000,{speed=100})
            end
        end, {})
    end
    sc.SetTimer(delaytime, 1, 1, function ()
        local c_pos=sc.GetActorLogicPos(caster)
        local actors = sc.GetActorsInRange(caster, c_pos, radio, false)
        QiParticle("Prefab_Skill_Effects/Hero_Skill_Effects/332_MaKeBoLuo/33202/Makeboluo_attack01_spell04_b.prefab",
        caster,VInt3.new(0, 500,0),VInt3.new(0, 0,0),2400,true,2000,{})
        sc.TraverseActorArray(actors,function (actor)
            if sc.GetActorSystemProperty(actor,ActorAttribute_ActorCamp)==DOTA_TEAM_BADGUYS then 
                local aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID)
                if aid~=nil and SpawnController.UnitListByActorId[aid] then 
                    sc.BuffAction(actor,caster,true,true,152200,0,0)
                    -- 1153100
                end
            end
        end)
    end,{})
end

--- 寒冰毁灭
function wangzhaojun_ability_3_ice_destrory(keys)
    QiPrint("wangzhaojun_ability_3_ice_destrory")
    local caster=keys.caster
    local target=keys.target
    local hit_duration=8
    local hit_next_time=0.3
    local hit_total_time=math.floor(hit_duration/hit_next_time)
    local total_radio=9000
    local strike_radio=4000
    for i=1,hit_duration do 
        sc.SetTimer(1000*i,1,1,function ()
            QiParticle("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/Rizhita_BossMoZhong_attack07_spell01.prefab",
            caster,VInt3.new(0,500,0),VInt3.new(0,0,0),1000,false,2000,{})
        end,{})
    end
    -- 施法区域特效
    QiParticle("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/RiZhiTa_JiTan_skill1_damage01.prefab",
        caster,VInt3.new(0, 0,0),VInt3.new(0,0,0),700,true,hit_duration*1000,{life=400,speed=500})
    local strike_pos=function (pos,offpos)
        offpos.y=offpos.y+400
        QiParticle("Prefab_Skill_Effects/Level_Effects/PVE_Rizita/RiZhiTa_Chongzhuang_swirl01B_low.prefab",
        caster,offpos,VInt3.new(0,0,0),1000,false,2000,{})
        QiParticle("Prefab_Skill_Effects/Common_Effects/ActorGhost_Mecan.prefab",
        caster,offpos,VInt3.new(0,0,0),1000,false,2000,{})
        sc.SetTimer(750,1,1,function ()
            local units=FindUnitsInRadio(pos,3500)
            QiParticle("Prefab_Skill_Effects/Monsters_Skill_Effects/Mst_61_Angryboss/nu_born_01.prefab",
            caster,offpos,VInt3.new(0,0,0),1000,false,2000,{})
            QiParticle("Prefab_Skill_Effects/Monsters_Skill_Effects/Mst_61_Angryboss/nu_born_02.prefab",
            caster,offpos,VInt3.new(0,0,0),800,false,2000,{})
            for __,i in pairs(units) do
                sc.BuffAction(i,caster,true,true,15220003,0,0)
            end
        end,{})
    end

    for i=1,hit_total_time do 
        sc.SetTimer(hit_next_time*1000*i,1,1,function ()
            local strike_pos_off=VInt3.new(math.random(-total_radio,total_radio), 500,math.random(-total_radio,total_radio))
            local c_pos=sc.GetActorLogicPos(caster)
            c_pos.x=c_pos.x+strike_pos_off.x
            c_pos.z=c_pos.z+strike_pos_off.z
            strike_pos(c_pos,strike_pos_off)
        end,{})
    end
end