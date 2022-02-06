function [angle_out, vx_ref, vy_ref] = SpecRef(angle_in, vx, vy)
% Takes incoming angle and produces the reflected angle at the same
% magnitude
if angle_in > 0 && angle_in <= 90
    angle_out = 360 - angle_in;
    vx_ref = vx;
    vy_ref = -vy;
elseif angle_in > 90 && angle_in <= 180
    angle_out = 180 + (180 - angle_in);
    vx_ref = vx;
    vy_ref = -vy;
elseif angle_in > 180 && angle_in <= 270
    angle_out = 180 - (angle_in - 180);
    vx_ref = vx;
    vy_ref = -vy;
elseif angle_in > 270 && angle_in <= 360
    angle_out = 0 + (360 - angle_in);
    vx_ref = vx;
    vy_ref = -vy;
else
    angle_out = angle_in;
    vx_ref = vx;
    vy_ref = vy;
end

end

