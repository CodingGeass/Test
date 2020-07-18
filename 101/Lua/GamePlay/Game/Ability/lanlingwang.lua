--- 兰陵王一技能幻影
function lanlingwang_ability_huanying_attack(keys)
    local caster=keys.caster
    local c_pos=sc.GetActorLogicPos(caster)
    local radio=6500
    local hit_time=12
    local func_timenext=200
    local u_caster=sc.GetUnityObjectFromActorRoot(caster)
    QiPrint("lanlingwang_ability_huanying_attack",3)
    local units=FindUnitsInRadio(c_pos,radio)
    if #units>0 then
        for i=1,hit_time do 
            local target=units[RandomInt(1,#units)]
            sc.SetTimer(func_timenext*i,0,1,function ()
                for i=1,2 do 
                    if target~=nil and sc.IsAlive(target)==true then
                        local u_target=sc.GetUnityObjectFromActorRoot(target)
                        sc.PlayUGCAgeMultiObject(StringId.new("ability/hero_3_lanlingwang/ability_1/s1b1.xml"),
                        {u_caster ,u_target},{})
                    else
                        units=FindUnitsInRadio(c_pos,radio)
                    end
                end
            end,{})
        end
    end
end

-- 发射匕首
function lanlingwang_ability_bishou_attack(keys)
    QiPrint("lanlingwang_ability_bishou_attack",3)
    local caster=keys.caster
    local target=keys.target
    local action=keys.action
    local bullet
    for i=1,5 do 
        sc.SetTimer(1000*i,0,1,function ()
            sc.PlayUGCAgeSingleObject(StringId.new("ability/hero_3_lanlingwang/ability_1/s1b1.xml"),
            u_caster,{})
            sc.PlayUGCAgeSing(StringId.new("ability/hero_3_lanlingwang/ability_1/s1b1.xml"),
                        {u_caster ,sc.GameObject_Nil},{})
        end)

    end
    -- caster

end


