-- =============== 妖塔100层 苦痛阶梯===========================
function quest_func:in_9115(n_actor,u_actor)
    -- QiMsg("苦痛阶梯接引人")
    local eventName = StringId.new("yaotaview_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,1} , eventName)
end

function quest_func:out_9115(n_actor,u_actor)
    -- QiMsg("苦痛阶梯接引人")
    local eventName = StringId.new("yaotaview_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,0} , eventName)
end

-- =============== BOSS挑战 幽界之井===========================
function quest_func:in_9176(n_actor,u_actor)
    -- QiMsg("幽界之井接引人")
    local eventName = StringId.new("bossfight_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,1} , eventName)
end

function quest_func:out_9176(n_actor,u_actor)
    -- QiMsg("幽界之井接引人")
    local eventName = StringId.new("bossfight_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,0} , eventName)
end


-- =============== 修炼之地===========================
function quest_func:in_9501(n_actor,u_actor)
    -- QiMsg("修炼之地接引人")
    local eventName = StringId.new("xiulian_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,1} , eventName)
end

function quest_func:out_9501(n_actor,u_actor)
    -- QiMsg("修炼之地接引人")
    local eventName = StringId.new("xiulian_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,0} , eventName)
end

-- =============== 杀敌点数兑换===========================
function quest_func:in_9605(n_actor,u_actor)
    -- QiMsg("杀敌点数兑换接引人")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    QiShop:PlayerSwitchShop("farmroom_killpoint_shop",1,aid)
end

function quest_func:out_9605(n_actor,u_actor)
    QiMsg("杀敌点数兑换接引人")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    QiShop:PlayerSwitchShop("farmroom_killpoint_shop",0,aid)
end

-- =============== 许愿人===========================
function quest_func:in_9505(n_actor,u_actor)
    QiMsg("许愿人")
    local eventName = StringId.new("wish_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,1} , eventName)
end

function quest_func:out_9505(n_actor,u_actor)
    QiMsg("许愿人")
    local eventName = StringId.new("wish_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,0} , eventName)
end

-- =============== 算命先生===========================
function quest_func:in_9124(n_actor,u_actor)
    QiMsg("算命先生")
    local eventName = StringId.new("suanming_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,1} , eventName)
end
function quest_func:out_9124(n_actor,u_actor)
    QiMsg("算命先生")
    local eventName = StringId.new("suanming_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,0} , eventName)
end

-- =============== 秘境悬赏 ===========================
function quest_func:in_9523(n_actor,u_actor)
    QiMsg("秘境悬赏")
    local eventName = StringId.new("xuanshang_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,1} , eventName)
end

function quest_func:out_9523(n_actor,u_actor)
    QiMsg("秘境悬赏")
    local eventName = StringId.new("xuanshang_view_show")
    local aid=sc.GetActorSystemProperty(u_actor,ActorAttribute_ActorID )
    sc.CallUILuaFunction({aid,0} , eventName)
end