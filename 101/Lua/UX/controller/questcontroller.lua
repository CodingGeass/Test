if questcontroller==nil then 
    questcontroller={}
    questcontroller.quest={}
    
end


--- 初始化一个玩家的任务系统
-- function detail description.
-- @tparam  type self description
-- @tparam  type aid description
-- @author 
function questcontroller:newquest(aid)
    if questcontroller.quest[aid]==nil then 
        questcontroller.quest[aid]={
            quest_id=nil,
            aid=aid,
        }
        questcontroller:SetQuest(aid,"Q00001")
    else

    end
    return questcontroller.quest[aid]
end

--- 设置任务数据
-- function detail description.
-- @tparam  type self description
-- @tparam  type aid description
-- @tparam  type quest_id description
-- @author 
function questcontroller:SetQuest(aid,quest_id)
    local quest=questcontroller:newquest(aid)
    quest["quest_id"]=quest_id
    local quest_title=QiData.quest_data[quest_id]["quest_title"]
    local quest_des=QiData.quest_data[quest_id]["quest_description"]
    QiQuestView:SetQuest(aid,quest_title,quest_des)
end

function SetQuest(aid,quest_id)
    questcontroller:SetQuest(aid,quest_id)
end