-- require "OnlineMode/EventLoop.lua"
json = require "json.lua"


local G_GameDataMgr = {}
local GameData = {}
local AllPlayerPersistentData = {}
local G_EventLoop = {}
--EventLoop
-- G_EventLoop = EventLoop.new("1")
G_GameDataMgr.GameData = GameData
G_GameDataMgr.PersistentData = AllPlayerPersistentData
-- G_GameDataMgr.EventLoop = G_EventLoop




function G_GameDataMgr.OnStartOperation(customOperation)
    if (customOperation == nil or string.len(customOperation) == 0)
    then
        --发送默认数据到服务器中
            SendDefaultCustomOperation()
            LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
            LuaCallCs_UI.OpenForm("UI/GameRoom/GameStartPanel.uixml");
            LuaCallCs_UI.CloseForm("UI/GameRoom/GameEndPanel.uixml")
		-- LuaCallCs_UI.OpenForm("UI/OnlineMode/OperationForm.uixml")
        --如果是重连进入
    else
        LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
        LuaCallCs_UI.OpenForm("UI/GameRoom/GameStartPanel.uixml");
        LuaCallCs_UI.CloseForm("UI/GameRoom/GameEndPanel.uixml")
		-- LuaCallCs_UI.OpenForm("UI/OnlineMode/OperationForm.uixml")
    end
end

--开始loading之后,开始准备游戏内使用的玩家自定义数据
function G_GameDataMgr.OnPersistentDataInBattleIsReady()
    --获取所有玩家的PlayerInfo
    local playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    local playerArrLenght = #playerArr
    --循环
    for i = 1,playerArrLenght do
        local PID = playerArr[i].playerID
        local PlayerPersistentData = {}
        PlayerPersistentData.FixedFormatData  = LuaCallCs_PersistentDataInBattle.GetFixedFormatDataInBattle(PID)
        PlayerPersistentData.CustomizeDataIntArr = LuaCallCs_PersistentDataInBattle.GetCustomizeDataIntArrInBattle(PID)
        PlayerPersistentData.CustomizeDataStringArr = LuaCallCs_PersistentDataInBattle.GetCustomizeDataStringArrInBattle(PID)
        PlayerPersistentData.ReportData = "WinGame"
        PlayerPersistentData.SaasData = {}
        PlayerPersistentData.SaasData.IsWin = 1
        PlayerPersistentData.SaasData.killcnt = 2
        AllPlayerPersistentData[PID] = PlayerPersistentData
    end
end

--发送默认的自定义操作数据(也是开局数据)
function SendDefaultCustomOperation()
    LuaCallCs_Common.Log("SendDefaultCustomOperation")
    --一定要先发送默认数据, 这样玩家不进行任何操作也能开始游戏
    ----初始化数据
	playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    playerArrLenght = #playerArr
    --需要准备的数据
    for i = 1, playerArrLenght do
        local playerBattleInfo = {}
        playerBattleInfo.playerID = playerArr[i].playerID
        playerBattleInfo.heroID = 1164;
        playerBattleInfo.SelectedHero = nil
        playerBattleInfo.confirmed = 0
        playerBattleInfo.playerName = playerArr[i].playerName
        playerBattleInfo.skinID = QiData:GetSkinIdByConfigID(playerBattleInfo.heroID);
        GameData.playerInfos[i] = playerBattleInfo
    end
    --初始化地图数据
    GameData.levelName = "ugc_hzs_224"
	--对数据序列化为json格式
	operatData = json.encode(GameData)
	--发送数据到服务器
	LuaCallCs_UGCStateDriver.SendFullDataBuf(operatData)
end

function G_GameDataMgr.OnReceiveOperateCmd(cmdInfo)
    --LuaCallCs_Common.Log("G_GameDataMgr.OnReceiveOperateCmd")
    --切换英雄
    if cmdInfo.cmdType == 1 then
        for i = 1, playerArrLenght do
            if GameData.playerInfos[i].playerID == cmdInfo.playerID then
                GameData.playerInfos[i].heroID = cmdInfo.heroID
                GameData.playerInfos[i].SelectedHero = cmdInfo.heroID
                GameData.playerInfos[i].confirmed = cmdInfo.confirmed
                GameData.playerInfos[i].skinID=QiData:GetSkinIdByConfigID(cmdInfo.selectHeroID)
            end
        end
    --发送刷新UI事件
    -- G_EventLoop:DispatchEvent("RefreshUI")
    --切换地图
    elseif (cmdInfo.cmdType == 2) then 
        GameData.levelName = cmdInfo.levelName
    elseif cmdInfo.cmdType == 3 then
        for i = 1, playerArrLenght do
            if GameData.playerInfos[i].playerID == cmdInfo.playerID then
                GameData.playerInfos[i].heroID = cmdInfo.heroID
                GameData.playerInfos[i].SelectedHero = cmdInfo.heroID
                GameData.playerInfos[i].confirmed = cmdInfo.confirmed
                GameData.playerInfos[i].skinID=QiData:GetSkinIdByConfigID(cmdInfo.selectHeroID)
            end
        end
    -- G_EventLoop:DispatchEvent("Confirmed")
    end
end


function G_GameDataMgr.OnOperateCmdReceiveDone()
    local OpData = json.encode(GameData)
    --上传全量数据
	LuaCallCs_UGCStateDriver.SendFullDataBuf(OpData)
end


--当数据发生变化时(自动调用)
function OnFixedFormatDataChanged()
    --获取用户自身的数据
    local fixedData = LuaCallCs_PersistentData.GetFixedFormatData()
    --local DTable = json.decode(fixedData) 
    --获取匹配分数(内置固定数据,用来决定玩家之间的匹配优先级)
    local score = fixedData.MatchScore
end


--当数据发生变化时(自动调用)
function OnCustomizeIntAllDataChanged()
    --获取用户自身的数据 
   local customIntArr = LuaCallCs_PersistentData.GetCustomizeDataIntArr()
   local v = customIntArr[200]
end

--当数据发生变化时(自动调用)
function OnCustomizeStringAllDataChanged()
    --获取用户自身自定义数据
    local StringArr = LuaCallCs_PersistentData.GetCustomizeDataStringArr()
    local s = StringArr[5]
end


--上传单局战绩, 自动保存到战绩历史记录里面(服务器会自动比对,下发可靠数据)
function UploadGameReport(PlayerID)
    return AllPlayerPersistentData[PlayerID].ReportData
end

--上传Saas的指标数据(自动调用)
function UploadSaasString(PlayerID)
    --只需要上传单局的数据, 指标数据会根据在后台配置的规则自动累加
	local SaasString = json.encode(AllPlayerPersistentData[PlayerID].SaasData)
    return SaasString
end


function UploadFixedFormatData(playerID)
    return AllPlayerPersistentData[playerID].FixedFormatData
end

function UploadCustomizeIntArr(playerID)
    return AllPlayerPersistentData[playerID].CustomizeDataIntArr
end

function UploadCustomizeStringArr(playerID)
    return AllPlayerPersistentData[playerID].CustomizeDataStringArr
end


return G_GameDataMgr