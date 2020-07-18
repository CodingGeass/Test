-- 管理不同职业的专署武器成长
function QiHero:RoleInit()
    self.roledata=QiHero.herolist[self.cfgid]
    if self.roledata==nil then 
        QiPrint("错误没有角色数据信息", 5) 
        self.weapontype="sword"
    else 
        self.weapontype=self.roledata["weapon_type"]
    end
    self:GrowWeaponInit()
    local hero_equip=PlayerController:GetPlayerEquip(self.pid)
    -- 初始装备
    if weapontype==self.weapontype then
    end
    hero_equip:EquipItem(self.grow_weaponlist[1])
    hero_equip:EquipItem("item_ass_base_normal_1")
    self.weapon_level=1
    self.fabao_level=1
end

--- 成长武器初始化
function QiHero:GrowWeaponInit()
    self.grow_weaponlist={}
    self.grow_fabaolist={}
    self.remain_killnum={}
    local fabao_name_list={
        [1]="tian",
        [2]="mo",
    }
    -- 当局天魔2选1
    local this_round_fabaoname=fabao_name_list[RandomInt(1,#fabao_name_list)]
    local weapon_name="item_main_"..self.weapontype.."_"
    for i=1,13 do 
        self.grow_weaponlist[i]=weapon_name..tostring(i)
        if i<=8 then 
            self.grow_fabaolist[i]="item_ass_base_normal_"..tostring(i)
        else 
            self.grow_fabaolist[i]="item_ass_base_"..this_round_fabaoname.."_"..tostring(i)
        end
        self.remain_killnum[i]=i*100
    end
end

--- 成长武器获得击杀
function QiHero:GrowWeaponKill(add_value)
    local now_level=self.level
    -- 武器等级小于实际等级
    if self.weapon_level<=now_level then 
        if self.remain_killnum[self.weapon_level] then 
            -- 获得击杀数
            if self.remain_killnum[self.weapon_level] then 
                self.remain_killnum[self.weapon_level]=self.remain_killnum[self.weapon_level]-1 
                if self.remain_killnum[self.weapon_level]<=0 then 
                    self:GrowWeaponLevelOn()
                else 
                    local eventName = StringId.new("WeaponGrow")
                    sc.CallUILuaFunction({PlayerController[self.pid]["actorid"],self.remain_killnum[self.weapon_level]} , eventName)
                    if self.remain_killnum[self.weapon_level]%10==0 or self.remain_killnum[self.weapon_level]<10 then
                        QiBottomAlert("<color=#33ccff>专属武器</color>成长，还需要<color=#ffff66>["..tostring(self.remain_killnum[self.weapon_level]).."]</color>点<color=#33ccff>成长值</color>",nil,self.aid)
                        QiMsg("您的<color=#33ccff>专属武器</color>得到了成长，还需要["..tostring(self.remain_killnum[self.weapon_level]).."]点成长值", type)
                    end
                end
            end
        end
    end
end

-- 成长武器升级
function QiHero:GrowWeaponLevelOn()
    if self.remain_killnum[self.weapon_level]<=0 then 
        self.weapon_level=self.weapon_level+1
        local next_level=self.weapon_level
        if self.grow_weaponlist[next_level] then 
            local p_equip=PlayerController:GetPlayerEquip(self.pid)
            p_equip:SetEquipSolt(1,self.grow_weaponlist[next_level],1)
            QiPrint("恭喜你，你的武器升级了", 5)
            QiBottomAlert("<color=#33ccff>专属修道</color>成长已达到<color=#ffff66>["..tostring(next_level).."]</color>级",nil,self.aid)
            MainAlert(self.aid,"专属修道武器成长！！","专属武器已达到["..tostring(next_level).."]",4)
        end
    end
end

-- 成长武器升级
function QiHero:GrowfabaoLevelOn(level)
    if level>self.fabao_level then 
        self.fabao_level=level
        local next_level=self.fabao_level
        if self.grow_fabaolist[next_level] then 
            local p_equip=PlayerController:GetPlayerEquip(self.pid)
            p_equip:SetEquipSolt(2,self.grow_fabaolist[next_level],1)
            QiPrint("恭喜你，你的法宝升级了", 5)
            QiBottomAlert("<color=#33ccff>修道法宝</color>成长已达到<color=#ffff66>["..tostring(next_level).."]</color>级",nil,self.aid)
            MainAlert(self.aid,"专属修道法宝成长！！","专属法宝已达到["..tostring(next_level).."]",4)
        end
    end
end

function QiHero:GetFabaoLevel()
    return self.fabao_level
end