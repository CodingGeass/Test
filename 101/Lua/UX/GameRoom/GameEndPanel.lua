if GameEndPanel==nil then 
    GameEndPanel={}
end
local public
function GameEndPanel:Init(keys)
    public = keys.SrcForm;
    GameEndPanel["game_end_result_image"]=public:GetWidgetProxyByName("game_end_result_image");
    GameEndPanel["game_end_result_image2"]=public:GetWidgetProxyByName("game_end_result_image2");
    
    GameEndPanel["game_end_result_text1"]=public:GetWidgetProxyByName("game_end_result_text1");
    GameEndPanel["game_end_result_text2"]=public:GetWidgetProxyByName("game_end_result_text2");
    
    GameEndPanel["game_end_players_data_list"]=public:GetWidgetProxyByName("game_end_players_data_list");
    
    GameEndPanel["game_end_top_title_label"]=public:GetWidgetProxyByName("game_end_top_title_label");

    GameEndPanel["main_property_list"]=public:GetWidgetProxyByName("main_property_list");
    GameEndPanel["ass_property_list"]=public:GetWidgetProxyByName("ass_property_list");

    GameEndPanel:InitTitlePanel()
    GameEndPanel:InitPlayerData()
    GameEndPanel:InitPropertyPanel()
    --主panel
end

function GameEndPanel:InitTitlePanel()
    local starttext="游戏时间 "
    local title_text="荒神罪-长安挽歌 "..maincontroller.gamediftext
    local min=math.floor(consolecontroller.nowtime/60)
    local sec=consolecontroller.nowtime%60
    local wave=maincontroller.playerproperty["wave"]
    GameEndPanel["game_end_top_title_label"]:GetText():SetContent("你成功抵御了"..tostring(wave).."/15波进攻")
    if maincontroller.iswin==true then 
        GameEndPanel["game_end_result_image"]:GetImage():SetRes("Texture/Sprite/icon_game_su.sprite")
        GameEndPanel["game_end_result_image2"]:GetImage():SetRes("Texture/Sprite/game_end_text_victor.sprite")
    else 
        GameEndPanel["game_end_result_image"]:GetImage():SetRes("Texture/Sprite/icon_game_fale.sprite")
        GameEndPanel["game_end_result_image2"]:GetImage():SetRes("Texture/Sprite/game_end_text_fail.sprite")

    end
    starttext=starttext..tostring(min).."分"..tostring(sec).."秒"
    GameEndPanel["game_end_result_text1"]:GetText():SetContent(title_text)
    GameEndPanel["game_end_result_text2"]:GetText():SetContent(starttext)
end
function GameEndPanel:InitPropertyPanel()
    for i=1,10 do 
        local list_element=GameEndPanel["main_property_list"]:GetListElement(i-1)
        if list_element~=nil then 
            if PROPERTY_LIST_MAIN[i]~=nil and maincontroller.playerproperty[PROPERTY_LIST_MAIN[i]]~=nil then 
                local s_chinese="<color=#75cce7>"..bagcontroller["localized"][PROPERTY_LIST_MAIN[i]].."</color>" or PROPERTY_LIST_MAIN[i]
                local key_label=list_element:GetWidgetProxyByName("main_element_text_label")
                key_label:GetText():SetContent(s_chinese.." "..tostring(maincontroller.playerproperty[PROPERTY_LIST_MAIN[i]]))
            else
                list_element:SetActive(false)
            end
        end
    end
    for i=1,14 do 
        local list_element=GameEndPanel["ass_property_list"]:GetListElement(i-1)
        if list_element~=nil then 
            if PROPERTY_LIST_ASS[i]~=nil and maincontroller.playerproperty[PROPERTY_LIST_ASS[i]]~=nil then 
                local s_chinese="<color=#75cce7>"..bagcontroller["localized"][PROPERTY_LIST_ASS[i]].."</color>" or PROPERTY_LIST_ASS[i]
                local key_label=list_element:GetWidgetProxyByName("ass_element_text_label")
                key_label:GetText():SetContent(s_chinese.." "..tostring(maincontroller.playerproperty[PROPERTY_LIST_ASS[i]]))
            else
                list_element:SetActive(false)
            end
        end
    end
end
function GameEndPanel:InitPlayerData()
    for i=1,4 do 
        list_element=GameEndPanel["game_end_players_data_list"]:GetListElement(i-1)
        if maincontroller.playerdatalist[i-1]~=nil then 
            local data=maincontroller.playerdatalist[i-1]

            list_element:SetActive(true) 
            local palyer_name_label=list_element:GetWidgetProxyByName("player_name")
            --玩家
            palyer_name_label:GetText():SetContent("玩家"..tostring(i))
            local palyer_gold_label=list_element:GetWidgetProxyByName("player_gold")
            --金币
            local gold=data["gold"]
            if gold>100000 then 
                gold=tostring(math.floor(gold/10000)).."W"
            else
                gold=tostring(gold) 
            end
            palyer_gold_label:GetText():SetContent(tostring(gold))

            --杀敌数
            local player_killnum=list_element:GetWidgetProxyByName("player_killnum")
            local killnum=data["killnum"]
            if killnum>10000 then 
                killnum=tostring(math.floor(killnum/1000)).."K"
            else
                killnum=tostring(killnum) 
            end
            
            player_killnum:GetText():SetContent(tostring(killnum))
             --妖塔
            local player_yaota_level=list_element:GetWidgetProxyByName("player_yaota_level")
            local yaota_level=tostring(data["yaota_level"])
            player_yaota_level:GetText():SetContent(tostring(yaota_level))

            --战斗力
            local player_fight_number=list_element:GetWidgetProxyByName("player_fight_number")
            local fight_power=data["fight_power"]
            player_fight_number:GetText():SetContent(tostring(fight_power))
            for i=1,6 do 
                local equip_dataname="equip"..tostring(i)
                local item_name=data[equip_dataname]
                local item_data=QiData.item_data[item_name]
                if item_data~=nil then 
                    local m_quality=item_data["m_quality"]
                    local m_equipIconPath="Texture/Sprite/"..item_name..".sprite"
                    local boder_image=list_element:GetWidgetProxyByName("item_quality_"..tostring(i))
                    local item_image=list_element:GetWidgetProxyByName("item_image_"..tostring(i))
                    bagcontroller:SetImageWithQuality(boder_image:GetImage(),m_quality,false)
                    item_image:GetImage():SetRes(m_equipIconPath)
                end
            end
        else
            list_element:SetActive(false) 
        end
    end
end

function GameEndPanel:PlayerPropertyInit()
    for i=1,7 do 
        local list_element=GameEndPanel["main_property_list"]:GetListElement(i-1)
        if list_element~=nil then 
            if PROPERTY_LIST_MAIN[i]~=nil and maincontroller.playerproperty[PROPERTY_LIST_MAIN[i]]~=nil then 
                local s_chinese=bagcontroller["localized"][PROPERTY_LIST_MAIN[i]] or PROPERTY_LIST_MAIN[i]
                local key_label=list_element:GetWidgetProxyByName("porperty_main_key_label")
                key_label:GetText():SetContent(s_chinese.." "..tostring(maincontroller.playerproperty[PROPERTY_LIST_MAIN[i]]))
            else
                list_element:SetActive(false)
            end
        end
    end
    for i=1,14 do 
        local list_element=GameEndPanel["ass_property_list"]:GetListElement(i-1)
        if list_element~=nil then 
            if PROPERTY_LIST_ASS[i]~=nil  and maincontroller.playerproperty[PROPERTY_LIST_ASS[i]]~=nil then 
                local s_chinese=bagcontroller["localized"][PROPERTY_LIST_ASS[i]] or PROPERTY_LIST_ASS[i]
                local key_label=list_element:GetWidgetProxyByName("porperty_ass_key_label")
                key_label:GetText():SetContent(s_chinese.." "..tostring(maincontroller.playerproperty[PROPERTY_LIST_ASS[i]]))
            else
                list_element:SetActive(false)
            end
        end
    end
end

function OnGameEndPanelCreate(keys)
    GameEndPanel:Init(keys)
end

-- 返回大厅	consolecontroller.nowtime
function retrun_start_page(keys)
    LuaCallCs_GameFinish.CloseBattleScene()
    LuaCallCs_UGCStateDriver.CloseUGC()
    LuaCallCs_UI.CloseForm("UI/GameRoom/GameEndPanel.uixml")
    if G_GameData.IsOnline==true then 
        LuaCallCs_UI.OpenForm("UI/OnlineMode/MainForm.uixml");
    else 
        LuaCallCs_UI.OpenForm("UI/GameRoom/GameStartPanel.uixml");
    end
end
-- --匹配成功，收到需要点击确认的要求
-- function MainForm.ReceiveNeedConfirmMatching(param)
-- 	-- buttonProxy = l_self_form:GetWidgetProxyByName("Button(1008)")
-- 	-- buttonProxy:SetActive(true)
-- 	LuaCallCs_TeamMatch.ShowMatchingConfirmBox(enUGCMatchingConfirmBoxType.enConfirmBoxType_SingleSide)
-- end


--开启背包界面
function OpenInnerSystemBagUI()
	--开启背包黑盒界面
	LuaCallCs_InnerSystem.OpenInnerBagForm()
end


--添加道具
function AddCustomItem()
	--添加道具(仅在测试服务器有效)
	LuaCallCs_Item.AddItem(2, 1)
end

function OpenChatRoom()
	--显示局外聊天界面
	LuaCallCs_InnerSystem.ShowInnerLobbyChatForm()
end


function OpenFriendRoom()
	--显示好友界面
	LuaCallCs_Friend.OpenFriendForm()
end


function FacetoFaceRoom()
	--显示好友界面
	LuaCallCs_Room.CreateFaceToFaceRoom(20, 3, 10, "main_Level")
end


function CreateTeam()
	--开启组队匹配
	LuaCallCs_TeamMatch.CreateTeam(5, 1, 5, "main_Level")
end

function CreateTask()
	--开启任务面板
	LuaCallCs_InnerSystem.OpenInnerTaskForm()
end

function CreateRank()
	--显示排行榜
	local Ranking = {}
	table.insert(Ranking,{0,"击杀榜","击杀数"})
	table.insert(Ranking,{1,"金钱榜","金币数"})
	LuaCallCs_InnerSystem.OpenInnerRankingForm(Ranking)
end



function GetGameReport()
	--获取历史战绩
	LuaCallCs_History.RequestGameReportHistory() 
	LuaCallCs_Common.Log("GetGameReport")
end

function OnReceivedReportHistoryData()
	LuaCallCs_Common.Log("ReceivedReport")
	local HistArr = LuaCallCs_History.GetGameReportHistory()
	local HistArrLength = #HistArr
	LuaCallCs_Common.Log(HistArrLength)
	for i = 1, HistArrLength do	
		LuaCallCs_Common.Log(HistArr[i])
	end
    if  LuaCallCs_History.HasMoreReport() == true then
        LuaCallCs_History.RequestMoreGameReportHistory()
    end
end


return MainForm