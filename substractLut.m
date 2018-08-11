function [lut,validPoints] = substractLut(lut1,lut2)

lut = lut1;
validPoints=[];
for i =1:64
    for j = 1:64
        for k = 1:64
            if(lut1(i,j,k)~=0)
                if(lut2(i,j,k)~=0)
                    lut(i,j,k) = 0;
                else
                    validPoints=[validPoints;i,j,k,lut(i,j,k)];
                end
            end
        end 
    end
end

% scatter3(validPoints(:,1),validPoints(:,2),validPoints(:,3));
% axis([1,64,1,64,1,64]);
% xlabel('x');
% ylabel('y');
% zlabel('z');
