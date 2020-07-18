-- 游戏管理 初始化
if GameController==nil then 
    GameController={}
    Entity={}
    GameController.isGameInit=false --游戏是否初始化
    GameController.Difficult=GAME_DIFFICULTY_EASY
    GameController.GameState=1--游戏阶段
    GameController.GameTime=0 --游戏时间
    GameController.UniqueIndex={}
end

function GameController:Init()
    --初始化自定义数据
    QiData:Init()
    --初始化游戏事件
    Event:EventInit()
    DropItemController:Init()
    QiWish:Init()
    QiYaota:Init()
    QiXiulian:Init()
    QiSuanming:Init()
    QiShop:Init()
    QiPrint("GameController:Init()")
    -- print(JSON_DATA_UNIT_PROPERTY)
    sc.SetTimer(1000, 1, 10 , OnTimer, {})
    sc.SetTimer(1000, 0, 0 , ConsoleTimer, {})
    QiPrint("GameController:Init() Done")
    --初始化刷怪事件
end

--- console每秒调用检测
function ConsoleTimer()
    GameController.GameTime=GameController.GameTime+1
    -- 每秒发送时间提醒控制台处理消息
    local eventName = StringId.new("ConsoleSecondFunc")
    sc.CallUILuaFunction({} , eventName)
end

function QiMsg(msg,type,aid)
    QiPrint("PrintMsg:"..tostring(msg),3)
    local eventName = StringId.new("UXQiMsg")
    sc.CallUILuaFunction({msg,type,aid} ,eventName)
end
function QiBottomAlert(msg,time,aid)
    local eventName = StringId.new("QiBottomAlert")
    sc.CallUILuaFunction({aid,msg,time} ,eventName)
end

function GetUniqueIndex(uniquestr)
    if GameController.UniqueIndex[uniquestr]==nil then 
        GameController.UniqueIndex[uniquestr]=0
    end
    GameController.UniqueIndex[uniquestr]=GameController.UniqueIndex[uniquestr]+1
    if GameController.UniqueIndex[uniquestr]>65534 then 
        GameController.UniqueIndex[uniquestr]=0
    end
    return GameController.UniqueIndex[uniquestr]
end
--- 游戏初始化 在Init之后调用
function GameController:GameInit()
    QiPrint("GameController:GameInit()")
    --仅仅调用一次
    if GameController.isGameInit==true then 
      return
    end
    QiPrint("GameController:GameInit() func")
    GameController.isGameInit=true
    QiPrint("Game Init",3)
    --游戏初始化
    SpawnController:Init()
end

function OnRecvUGCMsgLua(eventName, data) 
    if eventName == "eventName" then
    end
end

function OnTimer(data)
    QiPrint("OnTimer")
    --不断给UI发送消息，等待UI加载完成返回
    if PlayerController[0]["actor"]~=nil then 
        local eventName = StringId.new("InitCheck")
        -- QiPrint("setrpoperty ",3)
        -- sc.GetActorSystemProperty(PlayerController[0]["actor"],ActorAttribute_MagicalDef,1000)
        sc.CallUILuaFunction({} , eventName)
    else
    end
end

function RefreshUI(aid,type)
    local eventName = StringId.new("RefreshUI")
    sc.CallUILuaFunction({aid,type} , eventName)
end

--游戏结束wd
function GameController:GameEnd(isSu,force)
    local dealy_time=5000
    if force==true then 
        dealy_time=500
    end
    --全部传送回城
    -- for k,v in pairs(PlayerController["aidlist"]) do 
    --     TeleportController:TeleportTo(v,"b_base")
    -- end
    -- for 
    -- if isSu==true then 
    --     sc.SetTimer(1000, 1, 10 , function ()
    --         MainAlert(-1,"<color=#ff1a1a>游 戏 胜 利</color>","<color=#3333ff>您 已 通 关</color>",4)
    --         QiMsg("恭喜你获得了<color=#ff0000>胜利</color>！！！", 1)
    --         local eventName = StringId.new("ShowGameUIFunc")
    --         sc.CallUILuaFunction({1,true} , eventName)
    --     end, {})
    -- else 
    --     MainAlert(-1,"<color=#ff1a1a>基 地 失 守</color>","<color=#3333ff>胜败乃兵家常识，还请重头再来。</color>",4)
    --     local eventName = StringId.new("ShowGameUIFunc")
    --     sc.CallUILuaFunction({2,true} , eventName)
    --     sc.SetTimer(1000, 1, 10 , function ()
    --         QiMsg("你 <color=#ff0000>输</color> 了！！！", 1)
    --     end, {})
    -- end
    for i=0,GAME_MAX_PLAYER-1 do 
        if PlayerController[i]["ugcpid"]~=-1 then 
            local pid=i
            local aid=PlayerController[i]["actorid"]
            local gold=math.floor(PlayerController[i]["QiHero"].gold)
            local killnum=math.floor(PlayerController[i]["QiHero"].killpoint)
            local yaota_level=math.floor(PlayerController[i]["QiYaota"].reward_point)
            local fight_power=PlayerController[i]["QiHero"]:PlayerFightNumberText()
            local p_equip=PlayerController[i]["QiPlayerEquip"]
            sc.CallUILuaFunction({pid,"gold",gold} , StringId.new("recive_playerdata"))
            sc.CallUILuaFunction({pid,"killnum",killnum} , StringId.new("recive_playerdata"))
            sc.CallUILuaFunction({pid,"yaota_level",yaota_level} , StringId.new("recive_playerdata"))
            sc.CallUILuaFunction({pid,"fight_power",fight_power} , StringId.new("recive_playerdata"))
            for k,v in pairs(PlayerController[i]["QiHero"].nowproperty) do 
                sc.CallUILuaFunction({PlayerController[i]["actorid"],k,v} , StringId.new("player_property"))
            end
            sc.CallUILuaFunction({PlayerController[i]["actorid"],"wave", (SpawnController.nowwave-1)} , StringId.new("player_property"))
             for j=1,6 do 
                local e_name=p_equip.equiplist[j]["equipname"]
                sc.CallUILuaFunction({pid,"equip"..tostring(j),e_name} , StringId.new("recive_playerdata"))

            end
        end
    end
    for i=0,GAME_MAX_PLAYER-1 do 
        if PlayerController[i]["ugcpid"]~=-1 then 
            -- for k,v in pairs(PlayerController[i]["QiHero"].nowproperty) do 
            --     sc.CallUILuaFunction({PlayerController[i]["actorid"],k,v} , StringId.new("player_property"))
            -- end
            local eventName = StringId.new("SendPlayerQuitGameInfo")
            sc.CallUILuaFunction({ PlayerController[i]["ugcpid"]} , eventName)
        end
    end
    sc.SetTimer(dealy_time,0,1,function ()
        for i=0,GAME_MAX_PLAYER-1 do 
            if PlayerController[i]["ugcpid"]~=-1 then 
                -- for k,v in pairs(PlayerController[i]["QiHero"].nowproperty) do 
                --     sc.CallUILuaFunction({PlayerController[i]["actorid"],k,v} , StringId.new("player_property"))
                -- end
            end
            sc.CallUILuaFunction({i}, StringId.new("SendPlayerQuitGameInfo"))
        end
        sc.CallUILuaFunction({ isSu} , StringId.new("QiGameFinish"))
        sc.CallUILuaFunction({} , StringId.new("OnGameEnd"))
    end,{})
end

function GameController:PlayerExitGame(pid)
    QiPrint("GameController:PlayerExitGame(pid)",3)
    GameController:GameEnd(false,true)
end

function MainAlert(aid,m_text,a_text,time)
    local eventName = StringId.new("MainAlert")
    sc.CallUILuaFunction({aid,m_text,a_text,time} , eventName)
end
