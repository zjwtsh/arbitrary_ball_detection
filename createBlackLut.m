function [lut,validPoints]=createBlackLut(stage,tag, blackWidth, blackDepth)

lut = uint8(zeros(stage,stage,stage));

uvRange=fix([(stage-blackWidth)/2,(stage+blackWidth)/2]);
validPoints=[];

for i = uvRange(1):uvRange(2)
    for j = uvRange(1):uvRange(2)
        for k = 1:blackDepth
            lut(i,j,k)=uint8(tag);
            validPoints=[validPoints;i,j,k,lut(i,j,k)];
        end
    end
end

%scatter3(validPoints(:,1),validPoints(:,2),validPoints(:,3));
% axis equal;
% axis([1,stage,1,stage,1,stage]);
% xlabel('v');
% ylabel('u');
% zlabel('y');

