
-- function FindRandomPoint(point,radio)
--     local re_point=point + RandomVector(RandomFloat(0, radio))
--     return re_point;
--   end

-- --- 向量旋转
-- -- Some description, can be over several lines.
-- -- @param c_dir description
-- -- @param rad description
-- -- @return value description.
-- -- @author 
-- function dir_rotation(c_dir,rad)
--     -- [x*cosA-y*sinA  x*sinA+y*cosA]
--     local x1=c_dir[1]
--     local y1=c_dir[2]
--     x2=x1*math.cos(math.rad(rad))-y1*math.sin(math.rad(rad))
--     y2=x1*math.sin(math.rad(rad))+y1*math.cos(math.rad(rad))
--     return Vector(x2,y2,c_dir[3]):Normalized()
-- end