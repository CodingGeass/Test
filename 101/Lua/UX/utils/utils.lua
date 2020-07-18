function QiPrint(msg,level)
    LuaCallCs_Common.Log(msg);
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

function massage_zip(m_table)
  local zip_msg=""
  for k,v in pairs(m_table) do 
    if zip_msg~="" then 
      zip_msg=zip_msg.."|"
    end
    zip_msg=zip_msg..tostring(v)
  end
  return zip_msg
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
  