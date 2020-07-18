if maincontroller==nil then 
    maincontroller={}
    --玩家数据
    maincontroller.playerinfo=nil
    maincontroller.pid=nil
    maincontroller.hid=nil
    maincontroller.AlertShowList={}
    maincontroller.gamedif=1
    maincontroller.gamediftext="asd"
    QiPrint("maincontroller init")
end

-- function 

function maincontroller:init()
    maincontroller.playerdatalist={}
    maincontroller.playerproperty={}

    maincontroller.iswin=false
    QiData:Init()
    consolecontroller:init()
    alertcontroller:init()
    bagcontroller:instance()
    qishop:instance()
    consolecontroller:QiMsg("游戏UX初始化完成",MSG_TYPE_CONSOLE)
end

function player_property(aid,k,v)
    if aid==LuaCallCs_Battle.GetHostActorID() then 
        maincontroller.playerproperty[k]=v
    end
end

function recive_playerdata(pid,key,value)
    if maincontroller.playerdatalist[pid]==nil then 
        maincontroller.playerdatalist[pid]={}
    end
    maincontroller.playerdatalist[pid][key]=value
end

function QiGameFinish(isSu)
    if isSu==true then 
        maincontroller.iswin=isSu
    end
    LuaCallCs_UI.CloseForm("ui/MainUI.uixml")
    LuaCallCs_UI.CloseForm("UI/QiBag.uixml")
    LuaCallCs_UI.CloseForm("UI/QiShop.uixml")
    LuaCallCs_UI.CloseForm("UI/Console.uixml")
    LuaCallCs_UI.CloseForm("UI/AttackInfo.uixml")
    LuaCallCs_UI.CloseForm("UI/TeleportUI.uixml")
    LuaCallCs_UI.CloseForm("UI/Quest.uixml")
    LuaCallCs_UI.CloseForm("UI/QiGuildAlert.uixml")

    LuaCallCs_UI.CloseForm("UI/GameMode/QiYaota.uixml")
    LuaCallCs_UI.CloseForm("UI/GameMode/QiFateRoom.uixml")
    LuaCallCs_UI.CloseForm("UI/GameMode/QiBossFight.uixml")
    LuaCallCs_UI.CloseForm("UI/GameMode/QiShadi.uixml")
    LuaCallCs_UI.CloseForm("UI/GameMode/QiWish.uixml")
    LuaCallCs_UI.CloseForm("UI/GameMode/QiXiulian.uixml")
    LuaCallCs_UI.CloseForm("UI/GameMode/QiXuanshang.uixml")
    LuaCallCs_UI.CloseForm("UI/GameMode/QiSuanming.uixml")
    -- OnGameEnd()
end

-- 增加一条显示
function MainAlert(aid,main_text,ass_text,time)
    if aid==-1 or aid==LuaCallCs_Battle.GetHostActorID() then 
        maincontroller.AlertShowList[#maincontroller.AlertShowList+1]={
            main_text=main_text,
            ass_text=ass_text,
            time=time,
        }
        maincontroller:alert_func()
    end
end
-- 
function maincontroller:alert_think()
    local now_data=maincontroller.AlertShowList[1]
    if now_data then
        now_data["time"]=now_data["time"]-1
        if now_data["time"]<=0 then 
            maincontroller.AlertShowList[1]=nil
            for i=1,#maincontroller.AlertShowList do 
                if maincontroller.AlertShowList[i+1] then 
                    maincontroller.AlertShowList[i]=copy_table(maincontroller.AlertShowList[i+1])
                end
            end
            maincontroller.AlertShowList[#maincontroller.AlertShowList-1]=nil
        end
    end
    maincontroller:alert_func()
end

function maincontroller:alert_func()
    now_data=maincontroller.AlertShowList[1]
    if now_data then 
        QiConsoleView:SetAlertShowInfo(true,now_data["main_text"],now_data["ass_text"])
    else 
        QiConsoleView:SetAlertShowInfo(false)
    end
end

function UXQiMsg(msg,type)
    consolecontroller:QiMsg(msg,type)
end

function RecValue(a,b,c,d)
    QiPrint("RecValue")
    -- QiPrint(a)
    -- QiPrint(b)
    -- QiPrint(c)
    -- QiPrint(d)
end

--收到lua中Init的请求
function InitCheck()
    QiPrint("InitCheck")
    local message = {}
    message.fnam = "initcheck"
    passp = json.encode(message); 
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

--初始化，发送数据到lua 先只发送一个玩家
function gameinit()
    -- local send_list=LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    -- local send_list={
    --     playerID =maincontroller.pid,
    --     heroID = maincontroller.hid,
    -- }
    -- local json_send_list=json.encode(send_list)
    QiPrint("gameinit send game player info ")
    QiPrint(tostring(maincontroller.pid))
    QiPrint(tostring(maincontroller.hid))
    -- LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(json_send_list)
    maincontroller:init()
end

--- 处于战斗准备状态
-- function detail description.
-- @tparam  type self description
-- @author 
function maincontroller:OnFightPrepare()
    LuaCallCs_FightUI.EnableUI_Prerequisite()
    LuaCallCs_UI.OpenForm("ui/MainUI.uixml")
    LuaCallCs_UI.OpenForm("UI/QiBag.uixml")
    LuaCallCs_UI.OpenForm("UI/QiShop.uixml")
    LuaCallCs_UI.OpenForm("UI/Console.uixml")
    LuaCallCs_UI.OpenForm("UI/AttackInfo.uixml")
    LuaCallCs_UI.OpenForm("UI/TeleportUI.uixml")
    LuaCallCs_UI.OpenForm("UI/Quest.uixml")
    LuaCallCs_UI.OpenForm("UI/QiGuildAlert.uixml")

    LuaCallCs_UI.OpenForm("UI/GameMode/QiYaota.uixml")
    LuaCallCs_UI.OpenForm("UI/GameMode/QiFateRoom.uixml")
    LuaCallCs_UI.OpenForm("UI/GameMode/QiBossFight.uixml")
    LuaCallCs_UI.OpenForm("UI/GameMode/QiShadi.uixml")
    LuaCallCs_UI.OpenForm("UI/GameMode/QiWish.uixml")
    LuaCallCs_UI.OpenForm("UI/GameMode/QiXiulian.uixml")
    LuaCallCs_UI.OpenForm("UI/GameMode/QiXuanshang.uixml")
    LuaCallCs_UI.OpenForm("UI/GameMode/QiSuanming.uixml")

    -- LuaCallCs_UI.OpenForm("UI/ConsoleUICreate.uixml")
    -- LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(enBattleUIForLua.BattleMain, "Center/PVPTopRightPanel", false);
    LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(enBattleUIForLua.BattleMain, "Center/PanelHeroInfo", false);
    LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(enBattleUIForLua.BattleMain, "Center/MapPanel", false);
    LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(enBattleUIForLua.BattleMain, "Center/Panel_Equip", false);
    LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(enBattleUIForLua.BattleMain, "Center/CustomRoomPanel", false);

end

function maincontroller:OnFightStart()
    --先关闭所有
    --先关闭所有
    LuaCallCs_FightUI.EnableUI(0, false)
    -- LuaCallCs_FightUI.EnableUI(1, true)
    LuaCallCs_FightUI.EnableUI(1, true)
    LuaCallCs_FightUI.EnableUI(4, true)
end
function RefreshUI(aid,type)
    if aid==LuaCallCs_Battle.GetHostActorID() then 
        if type==1 then 
            --装备栏
            QiMainView:RefreshSmartBag()
        elseif type==2 then
            --背包
            QiBagView:RefreshBag()
        end
    end
end