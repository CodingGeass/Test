if QiShop==nil then 
    QiShop={}
    QiShop.aidlist={

    }
end

-- 初始化商店
function QiShop:Init()
    QiShop.shoplist=copy_table(QiData.shoplist)
    for __,shopdata in pairs(QiShop.shoplist) do 
        for index,item_data in pairs(shopdata) do 
            item_data["max_stock"]=tonumber(item_data["max_stock"])
            item_data["stock_time"]=tonumber(item_data["stock_time"])
            item_data["now_stocknumber"]=tonumber(item_data["init_num"])
            item_data["stock_reamaintime"]=tonumber(item_data["stock_time"])
        end
    end
    sc.SetTimer(1000,0,0,function ()
        for __,shopdata in pairs(QiShop.shoplist) do 
            for index,item_data in pairs(shopdata) do 
                -- 可冷却物品
                if item_data["max_stock"]~=-1 then 
                    -- 库存未满
                    if item_data["now_stocknumber"]<item_data["max_stock"] then 
                        item_data["stock_reamaintime"]=item_data["stock_reamaintime"]-1 
                        if item_data["stock_reamaintime"]<0 then 
                            -- 刷新库存
                            item_data["now_stocknumber"]=item_data["now_stocknumber"]+1
                            item_data["stock_reamaintime"]=item_data["stock_time"]
                        end
                    end
                end
            end
        end
    end,{})
end
-- 玩家进出商店 
function QiShop:PlayerSwitchShop(shopname,state,aid)
    -- 记录玩家商店
    if state==1 then 
        QiShop.aidlist[aid]=shopname
    else 
        QiShop.aidlist[aid]=nil
    end
    local eventName = StringId.new("shop_init")
    sc.CallUILuaFunction({shopname,state,aid} , eventName)
    QiShop:SendShopData(aid,shopname)
end

function QiShop:RefreshIndexData(aid,shopname,index)
    if  QiShop.aidlist[aid]==shopname then 
        local r_data=QiShop.shoplist[shopname][index]
        local now_stocknumber=r_data["now_stocknumber"]
        local stock_reamaintime=r_data["stock_reamaintime"]
        local stock_time=r_data["stock_time"]
        local eventName = StringId.new("SendShopIndexData")
        sc.CallUILuaFunction({aid,shopname,index,now_stocknumber,stock_reamaintime,stock_time} , eventName)
    end
end

function QiShop:SendShopData(aid,shopname)
    local shop_data=QiShop.shoplist[shopname]
    for index,v in pairs(shop_data) do 
        QiShop:RefreshIndexData(aid,shopname,index)
    end
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type qihero description
-- @tparam  type price_data description
-- @treturn any description.
-- @author 
function QiShop:TryBuyItemByPrice(qihero,price_data)
    local price_data =Split(price_data, "|")
    local price_value=tonumber(price_data[2])
    if price_data[1]=="k" then 
        return qihero:CostKillPoint(price_value,true)
    elseif  price_data[1]=="g" then
        return qihero:CostGold(price_value,true)
    end
    return false
end

function QiShop:ButItemByName(aid,pid,itemname)
    local shopname=QiShop.aidlist[aid]
    local shop_data=QiShop.shoplist[shopname]
    if shop_data~=nil then 
        for k,v in pairs(shop_data) do 
            if v["sell_item_name"]==itemname then 
                if v["now_stocknumber"]>=1 or v["now_stocknumber"]==-1 then 
                    if QiShop:TryBuyItemByPrice(PlayerController[pid]["QiHero"],v["sell_price"])==true then
                        PlayerController:GetBag(pid):AddItemByName(itemname,1)
                        if v["now_stocknumber"]~=-1 then 
                            v["now_stocknumber"]=v["now_stocknumber"]-1
                        end
                        QiShop:RefreshIndexData(aid,shopname,tonumber(v["sell_index"]))
                        QiBottomAlert("购买成功",nil,aid)
                    else

                    end
                end
            end
        end
    else 
        QiBottomAlert("购买错误，没有商店",nil,aid)
    end
end