if bagcontroller==nil then 
    bagcontroller={}
    bagcontroller["localized"]=QiData.PropertySchinese
end

BAG_SOLT_NUMBER=16

function bagcontroller:GetPropertyDesc(item_name)
    local desc_str=""
    local item_data=QiData.item_data[item_name]
    if item_data then 
        for k,v in pairs(item_data) do 
            if bagcontroller["localized"][k] then 
                desc_str="    "..desc_str..bagcontroller["localized"][k]..":"..tostring(v).."\n"
            end
        end
    end
    return desc_str
end

function bagcontroller:instance()
    -- for i=0,MAX_PLAYER_NUMBER-1 do 
        --初始化背包
        -- bagcontroller[i]= qibag:new({},i)
        -- TGCPrintTable(bagcontroller[i])
    -- end
    

end

-- 初始化背包
function bagcontroller:initbag(aid)
    if bagcontroller[aid]==nil then 
        bagcontroller[aid]={}
        bagcontroller[aid]["select"]={
            select_item=nil,
            select_type=nil,
        }
        bagcontroller[aid]["bag"]={}
        for i=1,BAG_SOLT_NUMBER do 
            bagcontroller[aid]["bag"][i]={
                name=nil,
                number=nil
            }
        end
    else
        return
    end
end


--- 设置背包
function SetBag(aid,solt_index,itemname,number)
    bagcontroller:initbag(aid)
    if itemname==0 then 
        itemname=nil 
    end
    bagcontroller[aid]["bag"][solt_index]["itemname"]=itemname
    bagcontroller[aid]["bag"][solt_index]["number"]=number
    QiBagView:RefreshBagInfo()
end

-- 打印一个物品的信息
function bagcontroller:MsgItemInfo(item_name)
    if item_name~=nil then 
        local item_data=QiData.item_data[item_name]
        if item_data~=nil then 
            QiMsg("=================================================")
            for k,v in pairs(item_data) do 
                if bagcontroller["localized"][k]~=nil then 
                    QiMsg(tostring(bagcontroller["localized"][k])..":"..tostring(v))
                end
            end
            QiMsg("=================================================")
        end
    end
end

--- 根据物品名字返回物品的主属性和副属性
function bagcontroller:GetMainAndAssProperty(item_name)
    local item_data=QiData.item_data[item_name]
    local main_property_list={
        "PhysicalDmg",
        "MagicalDmg",
        "PhysicalDef",
        "MagicalDef",
        "MaxHp",
        "MaxHpPercentAdd",
        "PhysicalDmgPercentAdd",
        "MagicalDmgPercentAdd",
        "PhysicalDefPercentAdd",
        "MagicalDefPercentAdd",
        "MaxHpKillAdd",
        "MagicalDmgKillAdd",
        "PhysicalDmgKillAdd",
        "PhysicalDefKillAdd",
        "MagicalDefKillAdd",
        "MaxHpSecAdd",
        "PhysicalDmgSecAdd",
        "MagicalDmgSecAdd",
        "PhysicalDefSecAdd",
        "MagicalDefSecAdd",
        -- PhysicalDmgPercentAdd="全局物理伤害<color=#ffff33>百分比增加</color>",
        -- MagicalDmgPercentAdd="全局法术伤害<color=#ffff33>百分比增加</color>",
        -- PhysicalDefPercentAdd="全局护甲值<color=#ffff33>百分比增加</color>",
        -- MagicalDefPercentAdd="全局法术抗性<color=#ffff33>百分比增加</color>",
        -- PhysicalDmgKillAdd="<color=#0099ff>击败增加</color>物理伤害",
        -- MagicalDmgKillAdd="<color=#0099ff>击败增加</color>法术伤害",
        -- PhysicalDefKillAdd="<color=#0099ff>击败增加</color>护甲值",
        -- MagicalDefKillAdd="<color=#0099ff>击败增加</color>法术抗性",
        -- PhysicalDmgSecAdd="<color=#00ff55>每秒</color>物理伤害增加",
        -- MagicalDmgSecAdd="<color=#00ff55>每秒</color>法术伤害增加",
        -- PhysicalDefSecAdd="<color=#00ff55>每秒</color>护甲值增加",
        -- MagicalDefSecAdd="<color=#00ff55>每秒</color>法术抗性增加",
    }
    local main_property_table={}
    local ass_property_table={}
    if item_data~=nil then
        for k,v in pairs(item_data) do 
            if bagcontroller["localized"][k]~=nil then 
                local is_main_property=false
                if #main_property_table<2 then 
                    for kk,vv in pairs(main_property_list) do 
                        if k==vv then 
                            is_main_property=true 
                            break
                        end
                    end
                end
                if is_main_property==true then 
                    main_property_table[#main_property_table+1]={k,v}
                else 
                    ass_property_table[#ass_property_table+1]={k,v}
                end
            end
        end
    end
    return main_property_table,ass_property_table
end

function bagcontroller:SetSelectItem(aid,m_type,itemname,index)
    bagcontroller:initbag(aid)
    bagcontroller[aid]["select"]["select_type"]=m_type
    bagcontroller[aid]["select"]["select_item"]=itemname
    bagcontroller[aid]["select"]["index"]=index
    if aid==LuaCallCs_Battle.GetHostActorID() then
        local equip_light_index=-1
        local bag_light_index=-1
        if m_type==1 then 
            equip_light_index=index
        elseif m_type==2 then 
            bag_light_index=index
        end
        QiBagView:SetEquipHighLight(equip_light_index)
        QiBagView:SetBagHighLight(bag_light_index)
    --    QiBagView:RefreshBagInfo()
        QiBagView:RefreshItemShow()
    end
end
-- 发送背包物品操作命令
function bagcontroller:SendBagCommand(aid,cs)
    -- QiMsg("背包操作 aid|"..tostring(aid).."cmd|"..tostring(cs),5,aid)
    bagcontroller:initbag(aid)
    local i_info = bagcontroller[aid]["select"]
    -- i_infostr=tostring(i_info["select_type"]).."|"..tostring(i_info["select_item"]).."|"..tostring(i_info["index"])
    local message={}
    message.cs=cs
    message.fnam="bcmd"
    message.aid=aid
    message.item=i_infostr
    passp = massage_zip({
        message.fnam,
        message.aid,
        message.cs,
        i_info["select_type"],
        i_info["select_item"],
        i_info["index"],
    })
    -- QiMsg(passp,5)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);
end

function bagcontroller:GetSelectItem(aid)
    bagcontroller:initbag(aid)
    return bagcontroller[aid]["select"]
end

--- 返回玩家的背包
function bagcontroller:GetBagByPlayerId(aid)
    bagcontroller:initbag(aid)
    if  bagcontroller[aid]  then 
        return bagcontroller[aid]["bag"]
    else
        QiPrint("GetPlayerBagIdError Retrun nil"..tostring(aid),3) 
    end
end

-- --刷新背包相关
-- function bagcontroller:RefreshBagInfo(aid)
--     return bagcontroller[aid]:GetSoltInfo()
-- end

--- 根据装备的eid获取自定义物品数据
-- function detail description.
-- @tparam  type self description
-- @tparam  type eid description
-- @treturn any description.
-- @author 
-- function bagcontroller:GetQiItemNameByEquiaid(eid)
--     QiPrint("GetQiItemNameByEquiaid"..tostring(eid),3)
--     for k,v in pairs(item_list) do 
--         -- QiPrint(v["m_equiaid"],3)
--         if v["m_equiaid"] and v["m_equiaid"]==eid then 
--             return k
--         end
--     end
--     return name
-- end

--根据物品品质设置图片效果
function bagcontroller:SetImageWithQuality(u_handle,m_quality,isimage)
    -- u_handle:SetColor(BluePrint.UGC.UI.Core.Color(1, 1, 1, 1));
    if m_quality=="white" then 
        u_handle:SetColor(ITEM_QUALITY_WHITE);
        if isimage==true then 
            u_handle:SetRes(ITEM_QUALITY_WHITE_BACK_IMAGE)
        end
        return
    elseif m_quality=="green" then 
        u_handle:SetColor(ITEM_QUALITY_GREEN);
        if isimage==true then 
            u_handle:SetRes(ITEM_QUALITY_GREEN_BACK_IMAGE)
        end
        return
    elseif m_quality=="blue" then 
        u_handle:SetColor(ITEM_QUALITY_BLUE);
        if isimage==true then 
            u_handle:SetRes(ITEM_QUALITY_BLUE_BACK_IMAGE)
        end
        return
    elseif m_quality=="purple" then 
        u_handle:SetColor(ITEM_QUALITY_PURPLE);
        if isimage==true then 
            u_handle:SetRes(ITEM_QUALITY_PURPLE_BACK_IMAGE)
        end
        return
    elseif m_quality=="pink" then 
        u_handle:SetColor(ITEM_QUALITY_PURPLE);
        if isimage==true then 
            u_handle:SetRes(ITEM_QUALITY_PINK_BACK_IMAGE)
        end
        return
    elseif m_quality=="orange" then 
        u_handle:SetColor(ITEM_QUALITY_ORANGE);
        if isimage==true then 
            u_handle:SetRes(ITEM_QUALITY_ORANGE_BACK_IMAGE)
        end
        return
    end
    if isimage==true then 
        u_handle:SetRes(ITEM_QUALITY_WHITE_BACK_IMAGE)
        u_handle:SetColor(BluePrint.UGC.UI.Core.Color(1, 1, 1, 1))
        return
    end
    u_handle:SetColor(BluePrint.UGC.UI.Core.Color(1, 1, 1, 1));

end
