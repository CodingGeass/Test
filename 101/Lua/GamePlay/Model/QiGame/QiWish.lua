WISH_TYPE_ITEM=1
WISH_TYPE_GOLD=2
WISH_TYPE_PROPERTY=3
WISH_TYPE_EXP=4

WISH_NEXT_DURATION=90

WISH_ITEM_CLOTHES=3
WISH_ITEM_SHOE=4
WISH_ITEM_PANT=5
WISH_ITEM_OHTER=6

if QiWish==nil then 
    QiWish={}
end

-- 初始化心愿
function QiWish:Init()
    QiWish:WishDataInit()
end

function QiWish:GetItemLevel()
    local roll=RandomInt(1,100)
    local level_data={
        [1]=40,
        [2]=70,
        [3]=90,
        [4]=100,
    }
    local wish_title_level={
        [-1]="这个愿望无法被满足",
        [1]="你的愿望将被满足",
        [2]="我将实现您的愿望",
        [3]="百花圣人将会满足您的愿望",
        [4]="您的心愿必将达成",
    }
    local wish_quality={
        [1]="green",
        [2]="blue",
        [3]="purple",
        [4]="pink",
    }
    local random_level=1
    local level=-1
    for i=1,#level_data do 
        if roll<=level_data[i] then 
            self.wish_title= QiData:SetStrinColorByQuality(wish_title_level[i],wish_quality[i])
            random_level=i
            level=i-3
            break
        end
    end
    local reward_level=PlayerController[self.pid]["QiHero"]:GetFabaoLevel()+level
    if reward_level<=0 then 
        reward_level=1
    end
    if reward_level>=12 then 
        reward_level=reward_level
    end
    return reward_level,random_level
end

--- function summary description.
-- function detail description.
-- @tparam  type self description
-- @tparam  type r_type description
-- @tparam  type r_level description
-- @author 
function QiWish:GetRewardItemName(r_type,r_level)
    -- return nil
    if  DropItemController.unitdroplist_fenlei[r_type]~=nil and DropItemController.unitdroplist_fenlei[r_type][r_level]~=nil then 
        local r_list=DropItemController.unitdroplist_fenlei[r_type][r_level]
        if #r_list>=1 then 
            return r_list[RandomInt(1,#r_list)]
        else 
            return nil 
        end
    end
    return nil
end

function QiWish:WishDataInit()
    -- local wish_item_list={
    --     [1]=WISH_ITEM_CLOTHES,
    --     [2]=WISH_ITEM_SHOE,
    --     [3]=WISH_ITEM_PANT,
    --     [4]=WISH_ITEM_OHTER,
    -- }
    -- for __,w_type in pairs(wish_item_list) do 
    --     QiWish.rewarditem[w_type]={}
    -- end
    QiWish.reward_type_list={
        [WISH_TYPE_ITEM]="许愿装备",
        [WISH_TYPE_GOLD]="许愿财富",
        [WISH_TYPE_PROPERTY]="许愿属性值",
        [WISH_TYPE_EXP]="许愿经验值",
    }
    local reward_item =function (m_wish,itype)
        local item_name=m_wish:GetRewardItemName(itype,m_wish:GetItemLevel())
        if item_name~=nil then 
            PlayerController:GetBag(m_wish.pid):AddItemByName(item_name,1)
            self.wish_des=QiData:SetStringByItemColor(QiData.item_data[item_name]["m_itemTitle"],item_name)
            self.wish_des="您得到了 "..tostring(m_wish.wish_des)
        end
    end

    local reward_property=function (m_wish,data_list)
        local __,reward_level=m_wish:GetItemLevel()
        local p_level=PlayerController[m_wish.pid]["QiHero"]:GetFabaoLevel()
        local random_list={}
        for k,v in pairs(data_list) do 
            random_list[#random_list+1]=k
        end
        local choose_property=random_list[RandomInt(1,#random_list)]
        local add_value=data_list[choose_property][p_level]*reward_level
        local p_hero=PlayerController[m_wish.pid]["QiHero"]
        p_hero.base_property[choose_property]=p_hero.base_property[choose_property]+add_value
        self.wish_des="您的 "..QiData.PropertySchinese[choose_property].."增加了"..tostring(add_value)
    end
    QiWish.wish_reward_data={
        [WISH_TYPE_ITEM]={
            [1]={
                title="想要衣服",
                func=function (m_wish)
                    reward_item(m_wish,WISH_ITEM_CLOTHES)
                end,
            },
            [2]={
                title="想要下装",
                func=function (m_wish)
                    reward_item(m_wish,WISH_ITEM_PANT)
                end,
            },
            [3]={
                title="想要鞋子",
                func=function (m_wish)
                    reward_item(m_wish,WISH_ITEM_SHOE)
                end,
            },
            [4]={
                title="想要首饰",
                func=function (m_wish)
                    reward_item(m_wish,WISH_ITEM_OHTER)
                end,
            },
        },
        [WISH_TYPE_GOLD]={
            [1]={
                title="供奉5000金币",
                func=function (m_wish)
                    if PlayerController[m_wish.pid]["QiHero"]:CostGold(5000,false)==true then 
                        m_wish.wish_title="供奉成功"
                        m_wish.wish_des="感谢您的供奉"
                        m_wish.stockgold=m_wish.stockgold+5000
                        if m_wish.stockgold>20000 then 
                            m_wish.wish_title="累积供奉达到20000"
                            m_wish.wish_des="奖励您特定道具"
                        end
                    else 
                        m_wish.wish_title="供奉失败"
                        m_wish.wish_des="咦，您身上的金币不够哦"
                    end
                end,
            },
            [2]={
                title="想要金币",
                func=function (m_wish)
                    local __,r_level=m_wish:GetItemLevel()
                    local add_gold=PlayerController[m_wish.pid]["QiHero"].level*500*r_level
                    PlayerController[m_wish.pid]["QiHero"]:AddGold(add_gold,false)
                    m_wish.wish_des="您获得了 ["..tostring(add_gold).."]".."金币"
                end,
            },
            [3]={
                title="获取金币速度增加50%",
                func=function (m_wish)
                    local p_hero=PlayerController[m_wish.pid]["QiHero"]
                    local add_value=p_hero.base_property["GoldAddPercent"]*0.5+50
                    p_hero.extra_property["GoldAddPercent"]=p_hero.extra_property["GoldAddPercent"]+add_value
                    local __,r_level=m_wish:GetItemLevel()
                    local add_time=30*r_level
                    m_wish.wish_des="您的总金币收益将会在["..tostring(add_time).."]秒内提高50%"
                    sc.SetTimer(add_time*1000,0,0,function ()
                        p_hero.extra_property["GoldAddPercent"]=p_hero.extra_property["GoldAddPercent"]-add_value
                    end,{})
                end,
            },
            [4]={
                title="财产升值",
                func=function (m_wish)
                    local p_hero=PlayerController[m_wish.pid]["QiHero"]
                    local base_add_percent=4
                    local __,r_level=m_wish:GetItemLevel()
                    local add_percent=base_add_percent*r_level
                    p_hero:AddGold(math.floor(p_hero.gold*base_add_percent/100),false)
                    m_wish.wish_des="您的金币升值了["..tostring(add_percent).."%]"
                end,
            },
        },
        [WISH_TYPE_PROPERTY]={
            [1]={
                title="法术相关",
                func=function (m_wish)
                    local chuantou_list={}
                    local chuantou_rate={}
                    local player_mage_attack=copy_table(QiData.smart_lua["player_magic_attack"])
                    for k,v in pairs(player_mage_attack) do 
                        player_mage_attack[k]=v*0.1
                    end
                    local player_magic_defence=copy_table(QiData.smart_lua["player_magic_defence"])
                    for k,v in pairs(player_magic_defence) do 
                        player_magic_defence[k]=v*0.1
                    end
                    for i=1,15 do 
                        chuantou_list[i]=i
                        chuantou_rate[i]=1000
                    end
                    local fashu_list={
                        MagicalDmg=player_mage_attack,
                        MagicalDef=player_magic_defence,
                        MagicalPenetration=chuantou_list,
                        MagicalPenetrationRate=chuantou_rate,
                    }
                    reward_property(m_wish,fashu_list)
                end,
            },
            [2]={
                title="物理相关",
                func=function (m_wish)
                    local chuantou_list={}
                    local chuantou_rate={}
                    local player_phy_attack=copy_table(QiData.smart_lua["player_phy_attack"])
                    for k,v in pairs(player_phy_attack) do 
                        player_phy_attack[k]=v*0.1
                    end
                    local player_def_defence=copy_table(QiData.smart_lua["unit_magic_defence"])
                    for k,v in pairs(player_def_defence) do 
                        player_phy_attack[k]=v*0.1
                    end
                    for i=1,15 do 
                        chuantou_list[i]=i
                        chuantou_rate[i]=1000
                    end
                    local fashu_list={
                        PhysicalDmg=player_phy_attack,
                        PhysicalDef=player_def_defence,
                        PhysicalPenetration=chuantou_list,
                        PhysicalPenetrationRate=chuantou_rate,
                    }
                    reward_property(m_wish,fashu_list)
                end,
            },
            [3]={
                title="体术相关",
                func=function (m_wish)
                    local base_attack=copy_table(QiData.smart_lua["player_phy_attack"])
                    for k,v in pairs(base_attack) do 
                        base_attack[k]=v*0.25
                    end
                    local baojilv={}
                    local baojishanghai={}
                    local yidongsudu={}
                    for i=1,15 do 
                        baojilv[i]=300
                        baojishanghai[i]=300
                        yidongsudu[i]=250
                    end
                    local tishu_list={
                        BaseDamage=base_attack,
                        CriticalRate=baojilv,
                        CriticalDmgBonus=baojishanghai,
                        MoveSpeed=yidongsudu,
                    }
                    reward_property(m_wish,tishu_list)
                end,
            },
            [4]={
                title="其他属性",
                func=function (m_wish)
                    local maxhp=copy_table(QiData.smart_lua["player_hp"])
                    for k,v in pairs(maxhp) do 
                        maxhp[k]=v*0.1
                    end
                    local hp_regen=copy_table(QiData.smart_lua["player_hp"])
                    for k,v in pairs(maxhp) do 
                        hp_regen[k]=v*0.1*0.01
                    end
                    local otherlist={
                        MaxMp=maxhp,
                        HpRegenRate=hp_regen,
                    }
                    reward_property(m_wish,otherlist)
                end,
            },
        },
        [WISH_TYPE_EXP]={
            [1]={
                title="获得经验值",
                func=function (m_wish)
                    local __,r_level=m_wish:GetItemLevel()
                    local add_exp=PlayerController[m_wish.pid]["QiHero"].level*3000*r_level
                    PlayerController[m_wish.pid]["QiHero"]:AddExp(add_exp,PlayerController[m_wish.pid]["QiHero"].level)
                    m_wish.wish_des="您获得了 ["..tostring(add_exp).."]".."经验值"
                end,
            },
            [2]={
                title="获得经验值速度增加50%",
                func=function (m_wish)
                    local p_hero=PlayerController[m_wish.pid]["QiHero"]
                    local add_value=p_hero.base_property["ExpAddPercent"]*0.5+50
                    p_hero.extra_property["ExpAddPercent"]=p_hero.extra_property["ExpAddPercent"]+add_value
                    local __,r_level=m_wish:GetItemLevel()
                    local add_time=30*r_level
                    m_wish.wish_des="您的总经验值收益将会在["..tostring(add_time).."]秒内提高50%"
                    sc.SetTimer(add_time*1000,0,0,function ()
                        p_hero.extra_property["ExpAddPercent"]=p_hero.extra_property["ExpAddPercent"]-add_value
                    end,{})
                end,
            },
            [3]={
                title="经验值增加20%",
                func=function (m_wish)
                    local p_hero=PlayerController[m_wish.pid]["QiHero"]
                    local add_value=QiData.exp_data[p_hero.level]["level_up_exp"]*0.2
                    p_hero:AddExp(add_value,p_hero.level)
                    m_wish.wish_title="经验值"
                    m_wish.wish_des="经验值增加20%"
                end,
            },
            [4]={
                title="当前经验值翻倍",
                func=function (m_wish)
                    local p_hero=PlayerController[m_wish.pid]["QiHero"]
                    local add_value=p_hero.exp
                    -- if add_value>QiData.exp_data[p_hero.level]["level_up_exp"]*0.5 then 
                    --     p_hero:ForceAddLevel()
                    --     -- p_hero:AddExp(1,p_hero.level)
                    -- else
                        p_hero:AddExp(add_value,p_hero.level)
                    -- end
                    m_wish.wish_title="当前等级经验值翻倍"
                    m_wish.wish_des="经验值增加了["..tostring(add_value).."]"
                end,
            }
        }
    }
end

-- 
function QiWish:new(o,actor,pid)
    setmetatable(o,self)
    self.__index =self
    o.pid=pid
    o.unit=actor
    o.aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID)
    o.selecttype=nil
    o.wish_title=nil
    o.wish_des=nil
    o.wish_duration=0
    o.stockgold=0
    sc.SetTimer(1000, 0, 0 , function (m_wish)
        if o.wish_duration>0 then 
            o.wish_duration=o.wish_duration-1 
        end
    end, {})
    return o
end

-- 请求愿望按下
function QiWish:AskWishBtnClick(index)
    index=index+1
    QiPrint("AskWishBtnClick"..tostring(index).."   nowtype:"..tostring(self.selecttype),3)
    if self.selecttype==nil then
        self.selecttype=tonumber(index)
    else
        --作用
        self:WishRewardChoose(index)
        self.wish_duration=WISH_NEXT_DURATION
    end
    self:SendWishData()
end

-- 已经确定了选择的奖励
function QiWish:WishRewardChoose(index)
    QiWish.wish_reward_data[self.selecttype][index]["func"](self)
    self.selecttype=nil
end
-- 发送愿望数据
function QiWish:SendWishData()
    local wish_state=-1
    local d1,d2,d3,d4
    -- reward_type_list
    -- 当前许愿机会冷却中
    if self.wish_duration>0 then 
        wish_state=0
        d1=self.wish_duration
        d2=self.wish_title
        d3=self.wish_des
    else
        local select_data
        if self.selecttype==nil then 
            -- 没有选择奖励分类
            select_data=QiWish.reward_type_list
            d1=select_data[1]
            d2=select_data[2]
            d3=select_data[3]
            d4=select_data[4]
        else
           select_data= QiWish.wish_reward_data[self.selecttype]
           d1=select_data[1]["title"]
           d2=select_data[2]["title"]
           d3=select_data[3]["title"]
           d4=select_data[4]["title"]
        end
    end
    local eventName = StringId.new("SendWishData")
    sc.CallUILuaFunction({self.aid,wish_state,d1,d2,d3,d4} , eventName)
end