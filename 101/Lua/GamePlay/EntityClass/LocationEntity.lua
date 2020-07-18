--定位实体，绑定该实体将自动把Object索引至Entity的table中，方便代码中快速调用访问

LocationEntity = LocationEntity or rtti.class("LocationEntity")
--申明绑定器
LocationEntity.m_binderObj = nil

--export string
LocationEntity.entityname = nil

--Enable函数(自动调用)
function LocationEntity:ctor()
    -- QiPrint("LocationEntity:Ctor()",3)
end

-- Enable函数(自动调用)
function LocationEntity:OnEnable()
     -- 初始化存储实体的table
     if Entity==nil then 
        QiPrint("init Entity table")
        Entity={}
    end
    
    local e_name=self.entityname:ToString():AsCStr()

    -- 将实体信息存储以供使用
    QiPrint("Player string init"..e_name,3)
    if Entity[e_name]== nil then 
        local position, rotation, forward = sc.GetUnityObjectTransform(self.m_binderObj)
        -- 存储实体信息至table
        Entity[e_name]={
            m_binderObj=self.m_binderObj,
            name=e_name,
            pos=position,
            position=position,
            rotation=rotation,
            forward=forward,
        }
        
        print("GetUnityObjectTransform")
        print(position.x, position.y, position.z)
        print(rotation.x, rotation.y, rotation.z)
        print(forward.x , forward.y, forward.z)	
    else
        QiPrint("Location Entity lua bind stringname Error,aready use",5)
    end
    
end

--- 
function LocationEntity:FightStart()
    QiPrint("LocationEntity:FightStart()")
 
end