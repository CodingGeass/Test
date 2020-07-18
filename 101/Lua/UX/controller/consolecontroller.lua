MSG_TYPE_WOLRD=1--世界
MSG_TYPE_TEAM=2--组队
MSG_TYPE_REWARD=3--奖励
MSG_TYPE_SYSTEAM=4--系统
MSG_TYPE_CONSOLE=5--控制台

if consolecontroller==nil then
    consolecontroller={}
    consolecontroller.stay_time=8
    consolecontroller.msglist={}
    consolecontroller.msgnum=18
    consolecontroller.nowtime=0
end


function consolecontroller:init()
    consolecontroller.nowtime=0
    for i=1,consolecontroller.msgnum do 
        consolecontroller.msglist[i]={
            msg=nil,
            remain_time=0,
            type=nil,
        }
    end
end

-- 发信息
function consolecontroller:QiMsg(msg,type)
 
    for i=1,consolecontroller.msgnum do 
        if consolecontroller.msglist[i] and consolecontroller.msglist[i]["msg"]==nil then 
            if type==MSG_TYPE_WOLRD then 
                msg="[<color=#ff4d4d>世界</color>]"..msg
            elseif type==MSG_TYPE_TEAM then 
                msg="[<color=#0099ff>队伍</color>]"..msg
            elseif type==MSG_TYPE_REWARD then
                msg="[<color=#40ff00>奖励</color>]"..msg
            elseif type==MSG_TYPE_SYSTEAM then 
                msg="[<color=#ffff00>系统</color>]"..msg
            elseif type==MSG_TYPE_CONSOLE then
                msg="[<color=#000000>Admin</color>]"..msg
            end
            consolecontroller.msglist[i]["msg"]=msg
            consolecontroller.msglist[i]["remain_time"]=consolecontroller.stay_time
            consolecontroller.msglist[i]["type"]=type
            QiConsoleView:RefreshUI()
            return consolecontroller.msglist[i],i
        end
    end
    --删除最前端的消息
    consolecontroller:MsgFrom(1)
    consolecontroller:QiMsg(msg,type)
end

function QiMsg(msg,type,aid)
    QiPrint("UXmsg"..tostring(msg),3)
    if aid~=nil then 
        if LuaCallCs_Battle.GetHostActorID()==aid then 
            consolecontroller:QiMsg(msg,type)

        else 
        end
    else 
        consolecontroller:QiMsg(msg,type)
    end
end

function consolecontroller:MsgFrom(i)
    if consolecontroller.msglist[i+1] and consolecontroller.msglist[i+1]["msg"]~=nil then 
        consolecontroller.msglist[i]=copy_table(consolecontroller.msglist[i+1])
        consolecontroller.msglist[i+1]["msg"]=nil
        consolecontroller:MsgFrom(i+1)
    end
end

--- GamePlay消息发送 每秒接受
-- function detail description.
-- @author 
function ConsoleSecondFunc()
    --UI界面主动刷新
    if QiBagView.funcindex==2 then 
        QiBagView:RefreshProperty()
    end
    -- UX没计时器 临时借用一下
    maincontroller:alert_think()
    AlertSecondFunc()
    -- 许愿池倒计时通讯
    if  QiWishView["wish_main_panel"]:IsActived()==true and QiWishView["wish_select_alert_label"]:IsActived()==true then 
        QiWishView:AskWishData()
    end
    for i=1,consolecontroller.msgnum do
        -- QiPrint("i:"..tostring(i).."   msg:"..tostring(consolecontroller.msglist[i]["msg"]))
        consolecontroller:CheckMsg(i)
    end
    consolecontroller.nowtime=consolecontroller.nowtime+1
    if consolecontroller.nowtime%10==0 then 
        consolecontroller:QiMsg("游戏进行中 当前游戏时间["..tostring(consolecontroller.nowtime)..tostring("]"),type)
    end
    -- QiPrint("ConsoleSecondFunc")
    -- PrintTable(consolecontroller.msglist)
    --UI刷新
    QiConsoleView:RefreshUI()
end

--检查一条消息
function consolecontroller:CheckMsg(i)
    -- QiPrint("check msg"..tostring(i))
    if consolecontroller.msglist[i] and consolecontroller.msglist[i]["msg"]~=nil then
        --删除显示时间到了的 信息
        if consolecontroller.msglist[i]["remain_time"]<=0 then 
            -- QiPrint("remain_time 0"..tostring(i))
            consolecontroller.msglist[i]["msg"]=nil 
            consolecontroller:MsgFrom(i)
            consolecontroller:CheckMsg(i)
        else 
            -- QiPrint(consolecontroller.msglist[i]["msg"]..":remain_time"..tostring(consolecontroller.msglist[i]["remain_time"]))
            consolecontroller.msglist[i]["remain_time"]=consolecontroller.msglist[i]["remain_time"]-1
        end
    end
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type cmd description
-- @author 
function consolecontroller:CMDParse(s_text)
    QiPrint("CMDParse:"..tostring(s_text),3)
    local x,y=string.find(s_text, " ")
    local cmdname=""
    local arg=nil
    if y==nil then
        cmdname=s_text
        arg={}
    else 
        local clist = Split(s_text, " ")
        cmdname=clist[1]
        clist[1]=0
        -- table.remove(clist,1)
        arg=clist
        -- PrintTable(arg)
        QiPrint("CallCMD:"..tostring(cmdname).." Arg:".. tostring(arg),3)
    end
    cmdname=string.lower(cmdname)--转化为小写
    -- if cmdname=="init" then
    --     PlayerCommand:init()
    -- end
    if consolecontroller[cmdname]~=nil then 
        consolecontroller[cmdname](consolecontroller[cmdname],arg)
    end
    local message = {[1]="console",[2]=LuaCallCs_Battle.GetHostActorID()}
    for k,v in pairs(arg) do 
        message[#message+1]=v 
    end
    message[3]=cmdname
    passp =  massage_zip(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

function consolecontroller:test(arg)
    -- QiMsg("欢迎体验测试控制台/n //n \\n <br>", MSG_TYPE_CONSOLE)
    QiMainView:RefreshSmartBag()
    if type(arg)=="table" then
        for k,v in pairs(arg) do
            QiMsg(tostring(k))
            QiMsg(tostring(v))
        end
    end
end

-- function consolecontroller:drop(arg)
--     local pid=arg[1]
--     local drop_id=tonumber(arg[1])

-- end