local l_self
local l_mapdrop
local l_heroid
local l_heroiddrop
local l_heroidlist

--初始化
function OnStartupOpen(luaUIEvent)
	LuaCallCs_Common.Log("OnStartupOpen");
	l_self = luaUIEvent.SrcForm;
	l_mapdrop = l_self:GetWidgetProxyByName("MapNameDropList");
	l_heroiddrop = l_self:GetWidgetProxyByName("HeroID_Drop");
	
	mapname = LuaCallCs_Level.GetAllLevelFiles();--获取project下可用的level名字
	
	l_mapdrop:SetDropTextContents(mapname);
	l_mapdrop:SelectElement(0,true);
	
	heroidlist = LuaCallCs_Data.GetAllHeroInfo();--获取可以选用的英雄ID
	
	heroiddrop = {}
	l_heroidlist = {}
	lastElem = 0
	-- for index =1,#heroidlist do
	-- 	heroiddrop[index] = heroidlist[index].cfgID.."("..heroidlist[index].heroName..")";
	-- 	l_heroidlist[index] = heroidlist[index].cfgID;
	-- 	lastElem = index
	-- end
	for index =1163,1164 do
		local Hero = LuaCallCs_Data.GetHeroInfo(index)
		heroiddrop[index-1162] = index.."("..Hero.heroName..")"
		--heroiddrop[index-1000] = index.."编号"
		l_heroidlist[index-1162] = index
		lastElem = index
	end
	
	l_heroid = l_self:GetWidgetProxyByName("HeroID");
	l_heroid:SetInputContent(1163);--廉颇
	
	l_heroiddrop:SetDropTextContents(heroiddrop);
	l_heroiddrop:SelectElement(0,true);
end

--选择英雄后的回调
function OnHeroDropChange(luaUIEvent)	
	LuaCallCs_Common.Log("OnHeroDropChange");
	l_heroid:SetInputContent(l_heroidlist[l_heroiddrop:GetSelectedIndex()+1]);

	--选择英雄
	playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
	selfPlayer = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
	playerArrLenght = #playerArr
	LuaCallCs_Common.Log("playerArr Lenght: "..playerArrLenght)
	LuaCallCs_Common.Log("G_GameData.playerInfos Lenght: "..#G_GameData.playerInfos)

	--构造命令
	local operateCmd = {}
	operateCmd.cmdType = 1;
	operateCmd.playerID = selfPlayer.playerID;
	operateCmd.selectHeroID = l_heroid:GetInputContent()
	operateCmd.skinID = QiData:GetSkinIdByConfigID(operateCmd.selectHeroID)
	operateCmd.confirmed = 1

	operatData = json.encode(operateCmd)
	LuaCallCs_UGCStateDriver.SendOperateCmd(operatData)
end

--选择关卡
function OnLevelDropChange(luaUIEvent)
	local nameidx = l_mapdrop:GetSelectedIndex()
	dropp = l_mapdrop:GetDropListElement(nameidx)

	--构造命令
	local operateCmd = {}
	operateCmd.cmdType = 2;
	operateCmd.levelName = dropp:GetItemText():GetContent()

	LuaCallCs_Common.Log("OnLevelDropChange: "..operateCmd.levelName )

	local operatData = json.encode(operateCmd)
	LuaCallCs_UGCStateDriver.SendOperateCmd(operatData)
end

--操作完成，通知服务器操作完成，所有的玩家都确认后服务器下发开局协议
function OnCompleted()
	LuaCallCs_UGCStateDriver.SendCustomOperationCompleted(G_GameData.levelName)
end

--用data刷新界面
function OperationRefreshUI(fulldata)
	
end