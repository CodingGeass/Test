local public
local bag_main_panel

if AttackInfoView==nil then 
    AttackInfoView={}
    AttackInfoView.ExpBarSliceNumber=10
    AttackInfoView.ExpTweenHandls={}
    AttackInfoView.ShowSelectBtn=false
end

--- UI初始化，获得控件绑定至变量中，方便后面使用
function AttackInfoView:UIInit(keys)
    QiPrint("AttackInfoView:UIInit()",3)

    public = keys.SrcForm;
    --主panel
    AttackInfoView["row"]=public:GetWidgetProxyByName("row");
    AttackInfoView["fast_bag_gold_text"]=public:GetWidgetProxyByName("fast_bag_gold_text");
    AttackInfoView["killnumber_number_label"]=public:GetWidgetProxyByName("killnumber_number_label");

    AttackInfoView["top_game_next_attack_label"]=public:GetWidgetProxyByName("top_game_next_attack_label");
    AttackInfoView["console_inputfield"]=public:GetWidgetProxyByName("console_inputfield");
    AttackInfoView["LevelBar"]=public:GetWidgetProxyByName("LevelBar");
    AttackInfoView["LevelLabel"]=public:GetWidgetProxyByName("LevelLabel");
    AttackInfoView["LevelPerExpNumber"]=public:GetWidgetProxyByName("LevelPerExpNumber");
    AttackInfoView["LevelBarList"]=public:GetWidgetProxyByName("LevelBarList");
    AttackInfoView["mainpane_bg_image"]=public:GetWidgetProxyByName("mainpane_bg_image");
    AttackInfoView["fight_power_number_label"]=public:GetWidgetProxyByName("fight_power_number_label");
    AttackInfoView["teleport_gold_border_image"]=public:GetWidgetProxyByName("teleport_gold_border_image");
    AttackInfoView["bag_gold_border_image"]=public:GetWidgetProxyByName("bag_gold_border_image");
    AttackInfoView["test_image"]=public:GetWidgetProxyByName("test_image");
    AttackInfoView["exit_btn_panel"]=public:GetWidgetProxyByName("exit_btn_panel");

    if IS_VERIFY_VERSION==true then 
        AttackInfoView["exit_btn_panel"]:SetActive(true)
        AttackInfoView["console_inputfield"]:SetActive(false)
    else
        AttackInfoView["exit_btn_panel"]:SetActive(false)
        AttackInfoView["console_inputfield"]:SetActive(true)
    end
    -- 亮度遮罩
    AttackInfoView.gold_boder_list={
        [1]=AttackInfoView["teleport_gold_border_image"],
        [2]=AttackInfoView["bag_gold_border_image"],
    }
    --闪烁动画
    for k,v in pairs(AttackInfoView.gold_boder_list) do 
        LuaCallCs_Tween.WidgetAlpha(v, 0,0.7):SetLoopPingPong()
        v:SetActive(false)
    end
end

--- 退出游戏
function onlinegame_exit_btn(keys)
    QiPrint("onlinegame_exit_btn")
    local aid = LuaCallCs_Battle.GetHostActorID();
    local message = {[1]="onlinegame_exit_btn",[2]=aid}
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

-- 设置按钮金色状态
function SendMainBtnGoldBorder(aid,btnindex,isopen)
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if actorID==aid then 
        AttackInfoView.gold_boder_list[btnindex]:SetActive(isopen)
    end
end

function OnAttackInfoOpen(keys)
    AttackInfoView:UIInit(keys)
end
-- 设置金币
function UXSetGold(aid,gold)
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if actorID==aid then 
        AttackInfoView["fast_bag_gold_text"]:GetText():SetContent(tostring(gold))
    end
end

-- 设置击杀数
function UXSetKillPoint(aid,killpoint)
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if actorID==aid then 
        AttackInfoView["killnumber_number_label"]:GetText():SetContent(tostring(killpoint))
    end
end


-- 设置击杀数
function UXSetFightPower(aid,fightpower)
    local actorID = LuaCallCs_Battle.GetHostActorID();
    if actorID==aid then 
        AttackInfoView["fight_power_number_label"]:GetText():SetContent(tostring(fightpower))
    end
end
--接受进攻信息
function SetAttackInfo(row,remain_time,table)
    -- QiPrint("SetAttackInfo",3)
    -- local row=table.row
    -- local remain_time=table.remain_time
    if remain_time<0 then remain_time=0  end
    local time_min=math.floor(remain_time/60)
    local time_sec=math.floor(remain_time%60)
    if time_min<10 then 
        time_min="0"..tostring(time_min)
    else 
        time_min=tostring(time_min)
    end
    if time_sec<10 then 
        time_sec="0"..tostring(time_sec)
    else 
        time_sec=tostring(time_sec)
    end
    local time_label=time_min..":"..time_sec
    AttackInfoView["row"]:GetText():SetContent("第 "..tostring(row).."波")
    AttackInfoView["top_game_next_attack_label"]:GetText():SetContent(tostring(time_label))
end

--显示掉落物品图片-drop item_hat_shenxian_n6
function ShowItemWorldImage(actorID,dropname)
    QiPrint("ShowItemWorldImage",3)
    -- "Texture/Sprite3d/shop_label.sprite3d"
    -- "Texture/Sprite/chaofanrusheng.sprite3d"
    -- LuaCallCs_Common.Log("Show3DUI"..sprite3d_path) 
    local sprite_path="Texture/Sprite3d/"..dropname..".sprite3d"
    local UIObject = nil
    --清空之前的3DUI
    if uicontroller.m_3DUI[actorID] ~= nil then
        LuaCallCs_FightUI.Destroy3DUI(uicontroller.m_3DUI[actorID])
        uicontroller.m_3DUI[actorID]=nil
    end
    UIObject = LuaCallCs_FightUI.Create3DUI(sprite_path,32,32)
    -- LuaCallCs_FightUI.Set3DUISize(UIObject, 128, 128)
    --关联actorID和3DUI
    uicontroller.m_3DUI[actorID] = UIObject
    --让3DUI跟随Actor
    local offset = BluePrint.UGC.UI.Core.Vector3(0,0,0)
    LuaCallCs_FightUI.SetFollowActor(UIObject,actorID,offset)
end

--显示英雄星级的3DUI
function ShowCustomFollow3DUI(actorID,s_name)
    -- "Texture/Sprite3d/shop_label.sprite3d"
    -- "Texture/Sprite/chaofanrusheng.sprite3d"
    -- LuaCallCs_Common.Log("Show3DUI"..sprite3d_path) 
    local sprite_path="Texture/Sprite3d/"..s_name..".sprite3d"
    -- QiPrint("Show3DUI"..tostring(sprite_path),3)
    local UIObject = nil
    --清空之前的3DUI
    if uicontroller.m_3DUI[actorID] ~= nil then
        LuaCallCs_FightUI.Destroy3DUI(uicontroller.m_3DUI[actorID])
        uicontroller.m_3DUI[actorID]=nil
    end
    UIObject = LuaCallCs_FightUI.Create3DUI(sprite_path,200,40)
    --关联actorID和3DUI
    uicontroller.m_3DUI[actorID] = UIObject
    --让3DUI跟随Actor
    local offset = BluePrint.UGC.UI.Core.Vector3(0,2.4,0)
    LuaCallCs_FightUI.SetFollowActor(UIObject,actorID,offset)
end

function Remove3DUIByActorID(aid)
    if uicontroller.m_3DUI[aid] ~= nil then
        LuaCallCs_FightUI.Destroy3DUI(uicontroller.m_3DUI[aid])
        uicontroller.m_3DUI[aid]=nil
    end
end

--背包打开按钮
function bag_btn_click(keys)
    -- ability_test()
    -- return
    bag_panel_open_switch()
    -- datacenter_test()
end

function image_test(icon)
    local res_path="Texture/Sprite/"..icon..".sprite"
    AttackInfoView["test_image"]:GetImage():SetRes(res_path)
end
--datacenter
function datacenter_test()
    QiPrint("datacenter_test")
    local dataC = LuaCallCs_Data.GetRunningDataCenter()
    local actorID = LuaCallCs_Battle.GetHostActorID();
    TGCPrintTable(dataC)
    -- [Lua] __typename: UGCRunningDataCenter
    -- [Lua] heroDic:userdata: 0000019358F4F348
    -- [Lua] monsterDic:userdata: 0000019358F4E7C8
    -- [Lua] organDic:userdata: 0000019358F4EC08
    -- [Lua] soldierDic:userdata: 0000019358F4F608
    -- TGCPrintTable(dataC.heroDic[actorID])
    -- [Lua] heroDic
    -- [Lua]  ObjID:1
    -- [Lua]  __typename: ActorData
    -- [Lua]  actorHp:8720
    -- [Lua]  actorHpTotal:8720
    -- [Lua]  camp:1
    -- [Lua]  cfgID:105
    -- [Lua]  coin:314
    -- [Lua]  resConfigID:105
    -- [Lua] __typename: HeroData
    -- [Lua] actorExp:0
    -- [Lua] actorGoldCoin:0
    -- [Lua] actorIncomingGoldCoin:0
    -- [Lua] actorMaxExp:0
    -- [Lua] skillData:SkillData
    local coin=dataC.heroDic[actorID].coin
    QiPrint("coin:"..tostring(coin))
end
function shop_btn_click(keys)
    if QiBagView["ShopMainPanel"]==nil then 
        QiPrint("base_shop_player_in not init",3)
        return
    end
    QiBagView["ShopMainPanel"]:SetActive(not QiBagView["ShopMainPanel"]:IsActived())
end


--传送背包
function teleport_btn_click(keys)
    QiPrint("teleport_btn_click")
    ui_switch_open()
    uicontroller:btn_alert()
end
    
function ConsoleInputDone(keys, paramsTable)
    -- QiPrint("ConsoleInputDoneQi")
    -- QiPrint(AttackInfoView["console_inputfield"]:GetInputContent())
    QiMsg(AttackInfoView["console_inputfield"]:GetInputContent(), MSG_TYPE_CONSOLE)
    -- QiPrint("TextParse:"..s_text,2)
    local s_text=AttackInfoView["console_inputfield"]:GetInputContent()
    if string.sub(s_text,1,1)=="-" or string.sub(s_text,1,1)=="`"  then
        consolecontroller:CMDParse(string.sub(s_text,2,-1))
    end
end

--- 同步经验值
-- function detail description.
-- @author 
function SyncExp(aid,level,now_exp,max_exp,add_exp)
    local ux_aid = LuaCallCs_Battle.GetHostActorID();
    if ux_aid==aid then 
        AttackInfoView:RefreshExpBar(level,now_exp,max_exp,add_exp)
    end
end

--- 刷新经验条
function AttackInfoView:RefreshExpBar(level,now_exp,max_exp,add_exp)
    local exp_percent=math.floor((now_exp/max_exp)*100)
    local exp_slice=math.floor(exp_percent/10)
    local slice_value=(exp_percent%10)/10
    -- 设置等级
    AttackInfoView["LevelPerExpNumber"]:GetText():SetContent(tostring("+"..tostring(add_exp)))
    AttackInfoView["LevelLabel"]:GetText():SetContent(tostring("等级"..tostring(level)))
    for k,v in pairs(AttackInfoView.ExpTweenHandls) do 
        if v then 
            v:Cancel()
        end
    end
    AttackInfoView.ExpTweenHandls={}
    -- LuaCallCs_Tween.CancelAll(true)
    AttackInfoView.ExpTweenHandls[#AttackInfoView.ExpTweenHandls+1]=LuaCallCs_Tween.ScaleLocal(AttackInfoView["LevelPerExpNumber"], 3, 2,0.1)
    AttackInfoView.ExpTweenHandls[#AttackInfoView.ExpTweenHandls+1]=LuaCallCs_Tween.WidgetAlpha(AttackInfoView["LevelPerExpNumber"], 1,0.1)
    AttackInfoView.ExpTweenHandls[#AttackInfoView.ExpTweenHandls+1]=LuaCallCs_Tween.ScaleLocal(AttackInfoView["LevelPerExpNumber"], 1, 1,2):SetDelay(0.11):SetEase(TweenType.easeInOutQuart)
    AttackInfoView.ExpTweenHandls[#AttackInfoView.ExpTweenHandls+1]=LuaCallCs_Tween.WidgetAlpha(AttackInfoView["LevelPerExpNumber"], 0, 2):SetDelay(0.11)
    -- 设置经验条
    for i=1,AttackInfoView.ExpBarSliceNumber do
        local element=AttackInfoView["LevelBarList"]:GetListElement(i-1)
        if i<=exp_slice then 
            element:GetWidgetProxyByName("levelProgressBar"):SetProgressValue(1)
        elseif i== (exp_slice+1) then 
            element:GetWidgetProxyByName("levelProgressBar"):SetProgressValue(slice_value)
        elseif i>(exp_slice+1) then 
            element:GetWidgetProxyByName("levelProgressBar"):SetProgressValue(0)
        end
    end
end