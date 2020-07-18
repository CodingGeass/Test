
function test_function()
	QiPrint("qi test_function");
end

function test_switch_function()
	QiPrint("qi test_switch_function");
end

function test_plaer_respawn(keys)
    QiPrint("test_plaer_respawn")
    if keys~=nil then 
        QiPrint("keys not nil ")
    end
end

function kill_plaer(keys)
    QiPrint("kill_plaer")
    if keys~=nil then 
        QiPrint("kill_plaer not nil ")
    end
end

function QiDebug(p1,p2,p3)
    QiPrint("QiDebug:"..tostring(p1),3)
    if p2 then 
        QiPrint(tostring(p2),3)
    end 
    if p3 then 
        QiPrint(tostring(p3),3)
    end
end