function [lut,validPoints] = substractLut2(lut1,lut2,state1,state2)

state1 = uint8(state1);
state2 = uint8(state2);
lut = lut1;
lut(:)=0;
validPoints=[];

for i =1:64
    for j = 1:64
        for k = 1:64
            if(lut1(i,j,k)==state1)
                if(lut2(i,j,k)~=state2)
                    lut(i,j,k)=state1;
                    validPoints=[validPoints;i,j,k,lut(i,j,k)];
                end
            end
        end 
    end
end

% scatter3(validPoints(:,1),validPoints(:,2),validPoints(:,3));
% axis equal;
% axis([1,64,1,64,1,64]);
% xlabel('v');
% ylabel('u');
% zlabel('y');
