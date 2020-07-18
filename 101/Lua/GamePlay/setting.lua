LUA_SYSTEM_TYPE=2


SPAWN_UNIT_THINK=true-- 是否刷怪
USE_GAME_GLOBAL_MUSIC=true -- 是否开启背景音乐
LOCK_HERO_CHOICE=false -- 是否锁定英雄
TEST_ABILIT_MODE=false --测试技能模式
IS_IN_TOOLMODE=false -- 是否为测试版本
--游戏最大人数
GAME_MAX_PLAYER=4

--阵营
DOTA_TEAM_GOODGUYS=1
DOTA_TEAM_BADGUYS=2

-- 游戏难度
GAME_DIFFICULTY_TEST=0
GAME_DIFFICULTY_EASY=1
GAME_DIFFICULTY_NORMAL=2
GAME_DIFFICULTY_HARD=3
GAME_DIFFICULTY_VERYHARD=4
GAME_DIFFICULTY_SUPERHARD=5


ActorAttribute_None =     0
-- [EnumDisplayName("物理攻击")]
ActorAttribute_PhysicalDmg =   1                     --物理攻击
-- [EnumDisplayName("法术攻击")]
ActorAttribute_MagicalDmg = 2                        --法术攻击
-- [EnumDisplayName("物理防御")]
ActorAttribute_PhysicalDef =   3                     --物理防御
-- [EnumDisplayName("法术防御")]
ActorAttribute_MagicalDef = 4                        --法术防御
-- [EnumDisplayName("最大生命值")]
ActorAttribute_MaxHp = 5                             --最大生命值
-- [EnumDisplayName("暴击率")]
ActorAttribute_CriticalRate = 6                      --暴击率
-- [EnumDisplayName("物理护甲穿透伤害")]
ActorAttribute_PhysicalPenetration = 7               --物理护甲穿透伤害
-- [EnumDisplayName("法术护甲穿透伤害")]
ActorAttribute_MagicalPenetration = 8               --法术护甲穿透伤害
-- [EnumDisplayName("物理吸血")]
ActorAttribute_PhysicalLifeSteal = 9                 --物理吸血
-- [EnumDisplayName("法术吸血")]
ActorAttribute_MagicalLifeSteal = 10                --法术吸血
-- [EnumDisplayName("抗暴击率")]
ActorAttribute_AntiCriticalRate = 11                 --抗暴击率
-- [EnumDisplayName("暴击伤害加成(万分比)")]
ActorAttribute_CriticalDmgBonus = 12                 --暴击伤害加成 (万分比)
-- [EnumDisplayName("真实伤害")]
ActorAttribute_TrueDmg = 13                          --真实伤害
-- [EnumDisplayName("真实减伤")]
ActorAttribute_TrueReduceDmg = 14                    --真实减伤
-- [EnumDisplayName("移动速度")]
ActorAttribute_MoveSpeed = 15                        --移动速度
-- [EnumDisplayName("生命恢复")]
ActorAttribute_HpRegenRate = 16                      --生命恢复
-- [EnumDisplayName("韧性(控制时间减少)")]
ActorAttribute_Tenacity = 17                         --韧性(控制时间减少)
-- [EnumDisplayName("攻速加成")]
ActorAttribute_AttackSpeedBonus = 18                 --攻速加成
-- [EnumDisplayName("冷却缩减")]
ActorAttribute_CoolDownTimeReduce = 19              --冷却缩减
-- [EnumDisplayName("内部保留")]
ActorAttribute_SightRange = 20                      --视野范围
-- [EnumDisplayName("命中率")]
ActorAttribute_HitRate = 21                          --命中率
-- [EnumDisplayName("闪避率")]
ActorAttribute_DodgeRate = 22                        --闪避率
-- [EnumDisplayName("伤害免疫率")]
ActorAttribute_DmgImmuneRate = 29                   --伤害免疫率
-- [EnumDisplayName("最终伤害加成")]
ActorAttribute_finalDmgBonus = 30                   --最终伤害加成
-- [EnumDisplayName("最大能量")]
ActorAttribute_MaxMp = 31                            --最大能量
-- [EnumDisplayName("能量回复")]
ActorAttribute_MpRegenRate = 32                      --能量回复
-- [EnumDisplayName("护甲穿透率")]
ActorAttribute_PhysicalPenetrationRate = 33          --护甲穿透率
-- [EnumDisplayName("法术穿透率")]
ActorAttribute_MagicalPenetrationRate = 34           --法术穿透率
-- [EnumDisplayName("基础伤害")]
ActorAttribute_BaseDamage = 36                       --基础伤害
-- [EnumDisplayName("ConfigID")]
ActorAttribute_ConfigID = 1000                      --ConfigID
-- [EnumDisplayName("角色类型(内置)")]
ActorAttribute_ActorType = 1002                      --角色类型
-- [EnumDisplayName("角色阵营")]
ActorAttribute_ActorCamp = 1003                      --角色阵营
-- [EnumDisplayName("ActorID")]
ActorAttribute_ActorID = 1004                        --ActorID
-- [EnumDisplayName("当前生命值")]
ActorAttribute_HP = 1005                            --当前生命值 
-- [EnumDisplayName("当前法术能量")]
ActorAttribute_MP = 1006                            --当前法术能量
-- [EnumDisplayName("玩家ID")]
ActorAttribute_PlayerID = 1007                      -- 玩家ID
-- [EnumDisplayName("视野半径")]
ActorAttribute_SightRadius = 1008                      --视野半径
-- [EnumDisplayName("英雄等级")]
ActorAttribute_Level = 1009           