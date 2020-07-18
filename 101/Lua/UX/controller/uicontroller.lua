UI_SOUND_EVENT=1

if uicontroller==nil then 
    uicontroller={}
    uicontroller.m_3DUI={}--记录自己创建的3DUI
end

function uicontroller:btn_click()
    LuaCallCs_Sound.PlayCustomSound(UI_SOUND_EVENT,"Sound/sound_button_click.ogg",1)
end

function uicontroller:btn_alert()
    LuaCallCs_Sound.PlayCustomSound(UI_SOUND_EVENT,"Sound/sound_button_alert.ogg",1)
end

function uicontroller:btn_exit()
    LuaCallCs_Sound.PlayCustomSound(UI_SOUND_EVENT,"Sound/sound_button_exit.ogg",1)
end
