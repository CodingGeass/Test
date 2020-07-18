if GameStartPanel==nil then 
    GameStartPanel={}
end

local public
function GameStartPanel:Init(keys)
    GameStartPanel.dif_textlist={
        [1]="简单难度",
        [2]="中等难度",
        [3]="困难难度"
    }
    public = keys.SrcForm;
    --主panel
    
    GameStartPanel["game_room_main_panel"]=public:GetWidgetProxyByName("game_room_main_panel");
    
    GameStartPanel["game_dif_choose_list"]=public:GetWidgetProxyByName("game_dif_choose_list");
    GameStartPanel["game_start_panel_bg_glow"]=public:GetWidgetProxyByName("game_start_panel_bg_glow");
    LuaCallCs_Tween.WidgetAlpha(GameStartPanel["game_start_panel_bg_glow"], 0,1):SetEase(TweenType.easeInQuad):SetLoopPingPong()
    GameStartPanel.select_dif=1
    maincontroller.gamediftext= GameStartPanel.dif_textlist[1]
    GameStartPanel.select_gold_panel=nil
    GameStartPanel:DifListInit(keys)
    if IS_VERIFY_VERSION==true then
        GameStartPanel["game_room_main_panel"]:SetActive(false)
    end
end

function GameStartPanel:DifListInit(keys)
    local dif_textlist=GameStartPanel.dif_textlist
    for i=1,3 do 
        list_element=GameStartPanel["game_dif_choose_list"]:GetListElement(i-1)
        local text_label=list_element:GetWidgetProxyByName("dif_des_text")
        text_label:GetText():SetContent(dif_textlist[i])
        local gold_image=list_element:GetWidgetProxyByName("gold_dif_select_image")
        local dif_icon_image=list_element:GetWidgetProxyByName("dif_icon_image")

        dif_icon_image:GetImage():SetRes("Texture/Sprite/game_dif_icon_"..tostring(i)..".sprite")

        LuaCallCs_Tween.WidgetAlpha(gold_image, 0,3):SetEase(TweenType.easeInQuad):SetLoopPingPong()

        gold_image:SetActive(false)
        if i==1 then 
            GameStartPanel.select_gold_panel=gold_image
            GameStartPanel.select_gold_panel:SetActive(true)
        end
    end
end

function dif_select_click(keys)
    local SrcWidget = keys.SrcWidget;
    local index = SrcWidget:GetIndexInBelongedList()
    maincontroller.gamedif=index+1
    maincontroller.gamediftext= GameStartPanel.dif_textlist[maincontroller.gamedif]

    local list_element=GameStartPanel["game_dif_choose_list"]:GetListElement(index)
    GameStartPanel.select_gold_panel:SetActive(false)
    GameStartPanel.select_gold_panel=list_element:GetWidgetProxyByName("gold_dif_select_image")
    GameStartPanel.select_dif=index+1
    GameStartPanel.select_gold_panel:SetActive(true)
end

function OnStartRoomOpen(keys)
    QiPrint("asdadasd")
    	--创建默认房间
	-- 
    if G_GameData.IsOnline==true then 
        -- LuaCallCs_InnerSystem.CreateInnerLobbyChatForm()
    else 
        --局域网下表示进入自定义操作阶段
        LuaCallCs_UGCStateDriver.CreateRoom()
        LuaCallCs_UGCStateDriver.SendMatchConfirm()
         --设置默认开局数据，该数据将在startup.gl中被使用，用于初始化关卡数据
        OfflineSetDefaultCustomOperation()
    end
    GameStartPanel:Init(keys)
end

function OnStartRoomClose(keys)
    if G_GameData.IsOnline==true then 
        -- LuaCallCs_InnerSystem.DestoryInnerLobbyChatForm()
    else 
     
    end
end

function timer_startgame()
    QiPrint("timer_startgame")
    if IS_VERIFY_VERSION==true then 
        LuaCallCs_UGCStateDriver.SendCustomOperationCompleted("ugc_hsz_224")
    end
end

--开始游戏
function OnPlay()
    if G_GameData.IsOnline==true then 
        LuaCallCs_UGCStateDriver.SendCustomOperationCompleted("ugc_hsz_224")
    else
        LuaCallCs_UGCStateDriver.StartGame("ugc_hsz_224");
    end
end

--发送默认的自定义操作数据(也是开局数据,局域网下房主发)
function OfflineSetDefaultCustomOperation()
    --- 初始化数据
	playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    playerArrLenght = #playerArr
    --需要准备的数据
    for i = 1, playerArrLenght do
        local playerBattleInfo = {}
        playerBattleInfo.playerID = playerArr[i].playerID
		playerBattleInfo.heroID = 1164;
		playerBattleInfo.skinID = QiData:GetSkinIdByConfigID(playerBattleInfo.heroID)
        G_GameData.playerInfos[i] = playerBattleInfo
    end
	--对数据序列化为json格式
	local operatData = json.encode(G_GameData)
	--发送数据到服务器
	LuaCallCs_UGCStateDriver.SendFullDataBuf(operatData)
end
