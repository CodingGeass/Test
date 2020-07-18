if qishop==nil then
    qishop={}
    qishop.nowshopname=nil
    qishop.shoplist={
        farmroom_killpoint_shop="战功商店",
    }
end

--- 初始化
function qishop:instance()
  
end

--- 根据名字返回商店的信息
function qishop:GetShopInfo(shop_name)
    QiPrint("GetShopInfo"..tostring(shop_name),3)
    local shop_data=QiData.shoplist[shop_name]
    local shop_title=qishop.shoplist[shop_name]
    return shop_title,shop_data
end

--- 格式化价格文字
function qishop:FormatPriceString(p_str)
    local price_data =Split(p_str, "|")
    local str=""
    if price_data[1]=="k" then 
        str=str.."击败数"
    elseif  price_data[1]=="g" then
        str=str.."金币"
    end
    str=str..":"..tostring(price_data[2])
    return str
end

--根据物品名字购买装备
-- function qishop:BuyItemByName(pid,item_name)
    -- local bag_handle=bagcontroller:GetBagByPlayerId(pid)
    -- bag_handle:AddItemByName(item_name)
-- end
