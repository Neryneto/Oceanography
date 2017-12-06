function [newAngle] = angleXtoCompass(oldAngle);
%
%   [newAngle] = angleXtoCompass(oldAngle);
%
%Program to convert angles measured counter-clockwise from the x-axis to
%angles on the compass (measured clockwise from North)
%
%Soupy Alexander (2/4/2)

for index = 1:length(oldAngle);
    newAngle(index) = (360 - oldAngle(index)) + 90;
    if newAngle(index) > 360;
        newAngle(index) = newAngle(index) - 360;
    end
    newAngle=newAngle';
end


        