if alertcontroller==nil then 
    alertcontroller={}
    alertcontroller.stay_time=6
    alertcontroller.msgnum=8
    alertcontroller.nowtime=0
    alertcontroller.msglist={}
end
function alertcontroller:init()
    for i=1,alertcontroller.msgnum do 
        alertcontroller.msglist[i]={
            msg=nil,
            remain_time=0,
        }
    end
end

function alertcontroller:bottomalert(msg,time)
    local time=time or alertcontroller.stay_time
    for i=1,alertcontroller.msgnum do 
        if alertcontroller.msglist[i] and alertcontroller.msglist[i]["msg"]==nil then 
            alertcontroller.msglist[i]["msg"]=msg
            alertcontroller.msglist[i]["remain_time"]=alertcontroller.stay_time
            QiAlertGuildAlert:RefreshUI()
            return alertcontroller.msglist[i],i
        end
    end
    alertcontroller:MsgFrom(1)
    alertcontroller:bottomalert(msg,time)
end

function QiBottomAlert(aid,msg,time)
    if aid~=nil then 
        if LuaCallCs_Battle.GetHostActorID()==aid or aid==-1 then 
            alertcontroller:bottomalert(msg,time)
        end
    else 
        alertcontroller:bottomalert(msg,time)
    end
end
-- 每秒计算 UX没计时器 借用的
function AlertSecondFunc()
    for i=1,alertcontroller.msgnum do
        -- QiPrint("i:"..tostring(i).."   msg:"..tostring(alertcontroller.msglist[i]["msg"]))
        alertcontroller:CheckMsg(i)
    end
    alertcontroller.nowtime=alertcontroller.nowtime+1
    QiAlertGuildAlert:RefreshUI()
end

--检查一条消息
function alertcontroller:CheckMsg(i)
    -- QiPrint("check msg"..tostring(i))
    if alertcontroller.msglist[i] and alertcontroller.msglist[i]["msg"]~=nil then
        --删除显示时间到了的 信息
        if alertcontroller.msglist[i]["remain_time"]<=0 then 
            -- QiPrint("remain_time 0"..tostring(i))
            alertcontroller.msglist[i]["msg"]=nil 
            alertcontroller:MsgFrom(i)
            alertcontroller:CheckMsg(i)
        else 
            -- QiPrint(alertcontroller.msglist[i]["msg"]..":remain_time"..tostring(alertcontroller.msglist[i]["remain_time"]))
            alertcontroller.msglist[i]["remain_time"]=alertcontroller.msglist[i]["remain_time"]-1
        end
    end
end

function alertcontroller:MsgFrom(i)
    if alertcontroller.msglist[i+1] and alertcontroller.msglist[i+1]["msg"]~=nil then 
        alertcontroller.msglist[i]=copy_table(alertcontroller.msglist[i+1])
        alertcontroller.msglist[i+1]["msg"]=nil
        alertcontroller:MsgFrom(i+1)
    end
end