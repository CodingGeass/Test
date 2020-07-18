if quest_func==nil then 
    quest_func={}
end

function quest_func:in_131(n_actor,u_actor)
    QiMsg("苍书生回调")
end

function quest_func:event_Q00001(quest)
    quest:SetGuildInfo(true,650,920,"请优先完成主线任务")
    quest:SetQuestHightLgiht(true)
    -- SetMouseAlertPos(show,x,y,text,aid)
    -- sc.SetTimer(4000, 1, 1, OnTimer, {})
end

function quest_func:event_Q00002(quest)
    quest:SetGuildInfo(true,130,580,"传送到其他区域")
    quest:SetQuestHightLgiht(false)
    local timer
    local pid=quest.pid
    local check_func= function ()
        if PlayerController[pid]["area_index"]==100 then 
            PlayerController[pid]["QiQuest"]:SetGuildInfo(false,650,920,"")
            sc.KillTimer(timer)
        end
    end
    timer=sc.SetTimer(200, 100, 0,check_func, {})

end

function quest_func:event_Q00003(quest)
    quest:SetGuildInfo(true,130,580,"传送至卫天城交任务")
    local timer
    local pid=quest.pid
    local check_func=function ()
        if PlayerController[pid]["area_index"]==99 then 
            PlayerController[pid]["QiQuest"]:SetGuildInfo(true,650,920,"找到目标人物交付任务")
            sc.KillTimer(timer)
        end
    end
    timer=sc.SetTimer(200, 100, 0,check_func, {})

    quest:SetQuestHightLgiht(true)
end

function quest_func:event_Q00004(quest)
    quest:SetGuildInfo(true,130,580,"传送到卫天森林开启冒险")
    quest:SetQuestHightLgiht(false)
    local timer
    local pid=quest.pid
    local check_func=function ()
        if PlayerController[pid]["area_index"]==0 then 
            PlayerController[pid]["QiQuest"]:SetGuildInfo(false,650,920,"")
            sc.KillTimer(timer)
        end
    end
    timer=sc.SetTimer(200, 0, 0,check_func, {})
end

function quest_func:event_Q00005(quest)
    quest:SetGuildInfo(false,130,580,"传送到卫天森林开启冒险")
    quest:SetQuestHightLgiht(false)
end

-- 苦痛阶梯
function quest_func:Q00007(pid)
    return PlayerController[pid]["QiYaota"].level>1
end

-- 天书修炼
function quest_func:Q00008(pid)
    return (PlayerController[pid]["QiXiulian"].level>1 or PlayerController[pid]["QiXiulian"].thislevel_buyindex>1)
end

-- 天书修炼
function quest_func:Q00018(pid)
    return PlayerController[pid]["QiBossChallenge"].su_fight_time>0
end

--- 升到2级
function quest_func:Q00002(pid)
    local qihero=PlayerController:GetQiHero(pid)
    if qihero.level>=2 then 
        return true 
    else 
        return false 
    end
end

-- 专属武器到2级
function quest_func:Q00005(pid)
    local qihero=PlayerController:GetQiHero(pid)
    if qihero.weapon_level>=2 then 
        return true 
    end
    return false
end

-- 专属武器到2级
function quest_func:Q00012(pid)
    local qihero=PlayerController:GetQiHero(pid)
    if qihero.level>=4 then 
        return true 
    else 
        return false 
    end
end
