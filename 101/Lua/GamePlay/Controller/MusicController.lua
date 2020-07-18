MUSIC_BACKGROUND_EVENT=2
MUSIC_UI_EVENT=1
if MusicController == nil then
    MusicController = {}
    MusicController.music_table={--场景-1 气势-2 激烈战斗-3 提琴4 场景5 激烈战斗6 特殊7
        {"hsz_music_temp_normal_1",1},
        {"hsz_music_temp_fight_1",3},
	}
    MusicController.state = 1
    MusicController.stopsafetime = 10
    MusicController.bgmindex=nil
end

-- 开始播放音乐
function MusicController:Start()
    MusicController:SwitchState(1)
end

function MusicController:SwitchState(state)
    -- if MusicController.stopsafetime
    sc.StopCustomSound(MUSIC_BACKGROUND_EVENT)
    MusicController.bgmindex=GetUniqueIndex("bgm")
    local u_index=MusicController.bgmindex
    if USE_GAME_GLOBAL_MUSIC==true then 
        sc.SetTimer(5000, 1, 1 , function ()
            if u_index==MusicController.bgmindex then 
                if state==1 then 
                    sc.PlayCustomSound(MUSIC_BACKGROUND_EVENT,StringId.new("Sound/hsz_music_temp_normal_1.ogg"),1)
                elseif state==3 then 
                    sc.PlayCustomSound(MUSIC_BACKGROUND_EVENT,StringId.new("Sound/hsz_music_temp_fight_1.ogg"),1)
                end
            end
        end, {})
    end
end