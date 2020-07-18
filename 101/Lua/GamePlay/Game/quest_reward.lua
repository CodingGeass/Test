function quest_func:re_Q00001(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("MaxHp",100)
end

function quest_func:re_Q00002(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("PhysicalDmg",20)
    qihero:ModifyExtraProperty("MagicalDmg",20)
end

function quest_func:re_Q00003(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(2)
end

function quest_func:re_Q00004(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("PhysicalDef",250)
    qihero:ModifyExtraProperty("MagicalDef",250)

end

function quest_func:re_Q00005(pid)
    local qihero=PlayerController:GetQiHero(pid)
end

function quest_func:re_Q00006(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(3)
end

function quest_func:re_Q00007(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("MoveSpeed",1000)
end

function quest_func:re_Q00008(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("AttackSpeedBonus",2000)
end

function quest_func:re_Q00009(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(4)
end

function quest_func:re_Q00010(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("HpRegenRate",10)
end


function quest_func:re_Q00011(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("MaxHp",450)
end


function quest_func:re_Q00011(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("MaxMp",300)
end


function quest_func:re_Q00012(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(5)
end


function quest_func:re_Q00013(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("PhysicalDmg",100)
end

function quest_func:re_Q00014(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:ModifyExtraProperty("PhysicalDef",500)
    qihero:ModifyExtraProperty("MagicalDef",500)
end


function quest_func:re_Q00016(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(6)
end

function quest_func:re_Q00017(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(7)
end


function quest_func:re_Q00020(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(8)
end


function quest_func:re_Q00021(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(9)
end

function quest_func:re_Q00023(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(10)
end


function quest_func:re_Q00024(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(11)
end


function quest_func:re_Q00027(pid)
    local qihero=PlayerController:GetQiHero(pid)
end

function quest_func:re_Q00028(pid)
    local qihero=PlayerController:GetQiHero(pid)
    qihero:GrowfabaoLevelOn(12)
end
