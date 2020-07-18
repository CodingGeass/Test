function SpawnController:BaseStateInit()
    SpawnController.lasthppercent=100
    sc.SetTimer(200,0,0,function ()
        local hp_percent=QiUnit:GetActorHPPercent(SpawnController.base_unit)
        if hp_percent>SpawnController.lasthppercent then 
        end
        if hp_percent<SpawnController.lasthppercent then
            for i=0,GAME_MAX_PLAYER-1 do 
                if PlayerController[i]["actorid"]~=nil then 
                    QiBottomAlert("长安城正在被攻击["..tostring(hp_percent).."%]",nil,PlayerController[i]["actorid"])
                end
            end
            local blood_alert_event = StringId.new("ShowBloodAlert")
            sc.CallUILuaFunction({} , blood_alert_event)
        end
        SpawnController.lasthppercent=hp_percent
    end,{})
end