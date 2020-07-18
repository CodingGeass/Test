function QiPrint(msg,level)
    -- LuaCallCs_Common.Log(msg);
    print(msg)
end

--- 通过遍历返回table长度
-- @param t table
-- @return value int.
-- @author 
function tablelength( t )
	local count = 0
	local t = checkTable( t )
	for k, v in pairs( t ) do
		count = count + 1
	end
	return count
  end
function FindUnitsInRadio(pos,radio,datas)
	local actors = sc.GetActorsInRange(sc.Actor_Nil, pos, radio, false)
	local a_list={}
	local f_team=DOTA_TEAM_BADGUYS
	if datas~=nil then 
		f_team=datas.team or f_team
	end
	sc.TraverseActorArray(actors,function (actor)
		if sc.GetActorSystemProperty(actor,ActorAttribute_ActorCamp)==f_team then 
			local aid=sc.GetActorSystemProperty(actor,ActorAttribute_ActorID)
			if aid~=nil and SpawnController.UnitListByActorId[aid] then
				a_list[#a_list+1]=actor
			end
		end
	end)
	return a_list
	-- for k,v in pairs(SpawnController.UnitListByActorId)
end

--- function sum description.
-- @param szFullString description
-- @param szSeparator description
-- @return value description.
-- @author 
function Split(szFullString, szSeparator)
	if szFullString==nil then 
		return {}
	  end
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
	   if not nFindLastIndex then
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
		break
	   end
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	   nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
  end
function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end
  
	done = done or {}
	done[t] = true
	indent = indent or 0
  
	local l = {}
	for k, v in pairs(t) do
	  table.insert(l, k)
	end
  
	table.sort(l)
	for k, v in ipairs(l) do
	  -- Ignore FDesc
	  if v ~= 'FDesc' then
		local value = t[v]
  
		if type(value) == "table" and not done[value] then
		  done [value] = true
		  print(string.rep ("\t", indent)..tostring(v)..":")
		  PrintTable (value, indent + 2, done)
		elseif type(value) == "userdata" and not done[value] then
		  done [value] = true
		  print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		  PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
		  if t.FDesc and t.FDesc[v] then
			print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
		  else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		  end
		end
	  end
	end
end

function TGCPrintTable(t, indent, done, m_t)
  if type(t) == "userdata"  then
      if indent==nil then 
        m_t=t 
      end
      TGCPrintTable(getmetatable(t), 0,nil,m_t)
      return
  end
  done = done or {}
  done[t] = true
  indent = indent or 0
  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end
  table.sort(l)
  for k, v in ipairs(l) do
    if v ~= 'FDesc' then
      local t = t[v]
      if type(t) == "table" and not done[t] then
        done [t] = true
        pcall(function ()
          QiPrint(string.rep (" ", indent)..tostring(v)..":"..tostring(m_t[v]))
        end)
        TGCPrintTable (t, indent + 1, done,m_t)
      elseif type(t) == "userdata" and not done[t] then
        done [t] = true
        QiPrint(string.rep (" ", indent)..tostring(v)..": "..tostring(t))
        TGCPrintTable(getmetatable(t), indent + 1, done,m_t)
      elseif type(t)=="function" then
      else
        if t.FDesc and t.FDesc[v] then
          QiPrint(string.rep (" ", indent)..tostring(t.FDesc[v]))
        else
          QiPrint(string.rep (" ", indent)..tostring(v)..": "..tostring(t))
        end
      end
    end
  end
end
--随机整数
function RandomInt(maxint)
	return math.floor(math.random()*maxint)
	-- body
end

--- function summary description.
-- function detail description.
-- @tparam  type particle_string description
-- @tparam  type target description
-- @tparam  type off_int3 description
-- @tparam  type rotation_int3 description
-- @tparam  type scall description
-- @tparam  type follow description
-- @tparam  type delay description
-- @tparam  type data description
-- @treturn any description.
-- @author 
function QiParticle(particle_string,target,off_int3,rotation_int3,scall,follow,delay,data)
	local str_id=StringId.new(particle_string)
	delay=delay or 100000
	data=data or {}
	local life=data.life or 1000
	local speed=data.speed or 1000
	local target_object=sc.GetUnityObjectFromActorRoot(target)
	local particle=sc.TriggerParticleStart (str_id, str_id, str_id,
	target, false, target_object, off_int3, rotation_int3,VInt3.new(scall, life,speed), true,follow)
	if delay~=-1 then 
		sc.SetTimer(delay, 1, 1, function ()
			sc.TriggerParticleEnd (particle)
		end, {})
	end
	return particle
end

function FindRandomPoint(point,radio)
	local point_add=VInt3.new(RandomInt(radio),0,0)
	point_add=dir_rotation(point_add, RandomInt(360))
	local result_int3= VInt3.new(point_add.x+point.x,point_add.y+point.y,point_add.z+point.z)
	-- QiPrint("result_int3x.."..tostring(result_int3.x).."y.."..tostring(result_int3.y).."z.."..tostring(result_int3.z))
	return result_int3
  end

--- 向量旋转
-- Some description, can be over several lines.
-- @param c_dir description
-- @param rad description
-- @return value description.
-- @author 
function dir_rotation(c_dir,rad)
    -- [x*cosA-y*sinA  x*sinA+y*cosA]
    local x1=c_dir.x
    local y1=c_dir.z
    x2=x1*math.cos(math.rad(rad))-y1*math.sin(math.rad(rad))
	y2=x1*math.sin(math.rad(rad))+y1*math.cos(math.rad(rad))
	QiPrint("x.."..tostring(x2).."y.."..tostring(y2).."z.."..tostring(c_dir.z))
	local result_int3=VInt3.new(math.floor(x2),math.floor(c_dir.y),math.floor(y2))
    return result_int3
end
--[[
计时器，对SetContextThink的简化
1.游戏暂停将不会继续执行
2.实体死亡将不会继续执行，英雄单位会跳过这个条件
3.实体无效将不会继续执行

调用方式
Timer([unique_str,] func)
Timer([unique_str,] delay, func)
Timer([unique_str,] entity, func)
Timer([unique_str,] entity, delay, func)

@params entity handle
@params delay  int
@params func   function
@params unique_str string 可选
]]
function Timer(...)
	local arg1,arg2,arg3,arg4 = ...
	local entity,delay,func,unique_str
	if type(arg1) == "string" then
		arg1,arg2,arg3 = arg2,arg3,arg4
	else
	end
	if type(arg1) == "function" then
		delay = 0
		func = arg1
	elseif type(arg1) == "number" and type(arg2) == "function" then
		delay = arg1
		func = arg2
	end
	local timer_delay=sc.SetTimer(delay, 0, 1 , function ()
		func()
	end, {})
end
-- function QiPrintTable(t,indent,done)
--   if type(t)=="userdata" then 
--     QiPrintTable(getmetatable(t))
--   end
--   if type(t) ~= "table" then return end
--   indent=indent or 0


--   -- QiPrint("QiPrintTable")
--   if t~=nil then 
--     QiPrint(type(t))
--     if type(t)=="number" then
--       -- QiPrint("Print find number")
--       QiPrint(tostring(t),3)
--     elseif type(t)=="string" then
--       -- QiPrint("Print find string")
--       QiPrint(tostring(t),3)
--     elseif type(t)=="userdata" and not done[t] then 
--       QiPrintTable ( getmetatable(t),string.rep (" ", indent))
--     elseif type(t)=="table" then 
--       local l = {}
--       for k, v in pairs(t) do
--         table.insert(l, k)
--       end
--       for k,v in pairs(l) do
--         QiPrint(k)
--         -- QiPrintTable(v)
--       end
--     elseif type(t)=="function" then 
--       -- QiPrint(tostring(t).."|"..tostring(t))
--     end
--   end
-- end

-- function PrintTable(t, indent, done)
--     if type(t) ~= "table" then return end
--     done = done or {}
--     done[t] = true
--     indent = indent or 0
--     QiPrint(tostring(indent))
--     local l = {}
--     for k, v in pairs(t) do
--       table.insert(l, k)
--     end
--     table.sort(l)
--     for k, v in ipairs(l) do
--       if v ~= 'FDesc' then
--         local t = t[v]
--         if type(t) == "table" and not done[t] then
--           done [t] = true
--           QiPrint("table"..string.rep (" ", indent)..tostring(v)..tostring(t[v]))
--           PrintTable (t, indent + 1, done)
--         elseif type(t) == "userdata" and not done[t] then
--           done [t] = true
--           QiPrint(string.rep (" ", indent)..tostring(v)..": "..tostring(t))
--           PrintTable(getmetatable(t), indent + 1, done)
--         elseif type(t)=="function" then
--           QiPrint(string.rep (" ", indent)..tostring(v)..":"..tostring(t))
--         else
--           if t.FDesc and t.FDesc[v] then
--             QiPrint(string.rep (" ", indent)..tostring(t.FDesc[v]))
--           else
--             QiPrint(string.rep (" ", indent)..tostring(v)..": "..tostring(t))
--           end
--         end
--       end
--     end
-- end
  
---两点之间距离
-- Some description, can be over several lines.
-- @param x1 description
-- @param y1 description
-- @param x2 description
-- @param y2 description
-- @return value description.
-- @author 
function twoPointToDistance(x1,y1,x2,y2)
	return math.abs(math.sqrt(math.pow(math.abs(y2-y1),2)+math.pow(math.abs(x2-x1),2)))
  end