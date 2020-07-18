json = require "json.lua"
mainForm = require "OnlineMode/MainForm.lua"
require "Lua/UX/require.lua"
GameDataMgr = require"OnlineMode/G_GameDataMgr.lua"
G_GameData = GameDataMgr.GameData
G_GameData.IsOnline=true

--(不能改名)
function main()
    require("SGame/Lua/LuaPanda").start("127.0.0.1", 8820)
	LuaCallCs_Common.Log("ainentry() online start");
    gameinit()
    -- QiPrint("mainentry() online start",3)
    --LuaCallCs_UGCStateDriver.CreateRoom()
    playerBattleInfoTable = {}
    G_GameData.playerInfos = playerBattleInfoTable
    -- 默认一个玩家
    LuaCallCs_UI.OpenForm("UI/OnlineMode/MainForm.uixml")
end

--(不能改名)当开始匹配的时候
function OnStartMatching()
    --LuaCallCs_Common.Log("OnStartMatching")
    mainForm.OnStartMatching()
end

--(不能改名)匹配成功，需要玩家确认,需要都确认后才能让所有玩家进入匹配后的流程，如果长时间不确认则会被踢掉
function OnReceiveNeedConfirmMatching(param)
    -- mainForm.ReceiveNeedConfirmMatching(param)
    mainForm.ReceiveNeedConfirmMatching(param)
end

--(不能改名)进入自定义操作阶段
--如果是所有的玩家第一次进入自定义操作阶段则customOperation为nil或者长度为0
--如果是重连进入，则customOperation是当前的自定义操作的数据
function OnStartOperation(customOperation)
    LuaCallCs_UI.CloseAllFormExceptUGC()
    GameDataMgr.OnStartOperation(customOperation)

    -- if (customOperation == nil or string.len(customOperation) == 0)

    -- then
    --     --发送默认的自定义操作
    --     GameDataMgr.OnStartOperation(customOperation)
    --     SendDefaultCustomOperation()
    --     LuaCallCs_Common.Log("customOperation1 lenth :"..string.len(customOperation))
	-- 	LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
	-- 	LuaCallCs_UI.OpenForm("UI/OnlineMode/OperationForm.uixml")
    -- else
    --     LuaCallCs_Common.Log("customOperation2 lenth :"..string.len(customOperation))
	-- 	LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
	-- 	LuaCallCs_UI.OpenForm("UI/OnlineMode/OperationForm.uixml")
    -- end
end

--(不能改名)收到自定义操作命令 cmd是string类型
function OnReceiveOperateCmd(cmd)
    LuaCallCs_Common.Log("OnReceiveOperateCmd")
    --根据自定义操作命令修改操作数据
	cmdInfo = json.decode(cmd)
    G_GameDataMgr.OnReceiveOperateCmd(cmdInfo)
    -- --根据自定义操作命令修改操作数据
	-- cmdInfo = json.decode(cmd)
	-- --LuaCallCs_Common.Log("cmd is "..cmd)

    -- if (cmdInfo.cmdType == 1) then
    --     for i = 1, playerArrLenght do
    --         if G_GameData.playerInfos[i].playerID == cmdInfo.playerID
                
    --         then
    --             G_GameData.playerInfos[i].confirmed = 1
    --             G_GameData.playerInfos[i].heroID = cmdInfo.selectHeroID
    --             G_GameData.playerInfos[i].skinID=QiData:GetSkinIdByConfigID(cmdInfo.selectHeroID)
    --         end
    --     end
    -- elseif (cmdInfo.cmdType == 2) then
    --     G_GameData.levelName = cmdInfo.levelName
    --     LuaCallCs_Common.Log("G_GameData.levelName: "..G_GameData.levelName )
    -- end

end

--(不能改名)单次自定义操作命令接收完，需要上传全量结果数据
function OnOperateCmdReceiveDone()
    GameDataMgr.OnOperateCmdReceiveDone()

	-- local OpData = json.encode(G_GameData)
	-- --LuaCallCs_Common.Log("SendFullDataBuf:"..OpData)
	-- LuaCallCs_UGCStateDriver.SendFullDataBuf(OpData)
end
--(不能改名)开始loading之后会被调用
function OnPersistentDataInBattleIsReady()
    GameDataMgr.OnPersistentDataInBattleIsReady()
end

--(不能改名)收到玩家自己定义的结果数据 fulldata 全量的玩家自定义的操作数据，用该数据刷新界面
function OnReceiveOperateFullData(fulldata)
    fulldataTable = json.decode(fulldata)
    --todo 刷新界面
end

--(不能改名)开始loading游戏
function OnStartLoadingGame()
    LuaCallCs_UI.CloseForm("UI/GameRoom/GameStartPanel.uixml")
    if G_GameData.IsOnline == true then
		-- LuaCallCs_UI.CloseForm("UI/LanMode/Online.uixml")
		-- LuaCallCs_UI.CloseForm("UI/LanMode/OnlineOperation.uixml")
	end
    -- LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
    LuaCallCs_Loading.ShowTemplateLoading(enTemplateLoadingType.en_Loading_Single)
end

--(不能改名)
function OnFightPrepare()
    -- LuaCallCs_UI.OpenForm("UI/OnlineMode/MainBattleForm.uixml")
    maincontroller:init()
	maincontroller:OnFightPrepare()
	--LuaCallCs_Common.Log("OnFightPrepare");
end

--(不能改名)
function OnFightStart()
	maincontroller:OnFightStart()
end

--(不能改名)
function OnFightOver()
	-- LuaCallCs_UI.OpenForm("UI/OnlineMode/MainForm.uixml")
end



--发送玩家退出游戏信息,在蓝图startUp.gl中调用
function SendPlayerQuitGameInfo(playerID)
    --发送指定玩家离开游戏信息
    --true:  彻底结束游戏,触发数据上报函数(Saas指标数据,FixedFormatData,CustomIntArr,CustomStringArr,发送和接收GameReport)
    --false: 重新载入下一个Level的流程
	LuaCallCs_UGCStateDriver.SendPlayerQuitInfo(playerID, true)
	-- OnGameEnd()
end

--游戏结束（不能改名字）
function OnGameEnd()
	LuaCallCs_GameFinish.CloseBattleScene()
	LuaCallCs_UI.OpenForm("UI/GameRoom/GameEndPanel.uixml");
end
--接收到可靠的单局战绩
function OnRecvGameReportInfo(data)

end
-- --收到返还的结算信息
-- function OnRecvGameOverInfo(param)
-- end

--收到匹配成功后需要确认是否进入 param玩家输入的匹配参数
function OnReceiveNeedConfirmMatching(param)
    mainForm.ReceiveNeedConfirmMatching(param)
end

-- --匹配队伍被销毁
-- function MatchTeamDestroyNtf()
-- end

-- --玩家匹配成功后，发送了确认信息的玩家
-- function OnPlayerConfirmMatching(playerUid)
-- end

-- --有玩家离开匹配队伍
-- function OnMatchPlayerLeave(playerUid)
-- end