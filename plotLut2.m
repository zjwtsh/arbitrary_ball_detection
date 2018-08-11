function [lutMat, validPoints] = plotLut2( filename )
%PLOTLUT Summary of this function goes here
%   Detailed explanation goes here
rst = [];

pfile = fopen(filename);
rst = fread(pfile);
fclose(pfile);
validPoints = [];

for i = 1:64
    for j = 1:64
        for k = 1:64
            if rst((i-1)*64*64+(j-1)*64+k)~= 0
                validPoints=[validPoints;i,j,k,rst((i-1)*64*64+(j-1)*64+k)];
            end
        end
    end
end
lutMat = reshape(rst,[64,64,64]);
scatter3(validPoints(:,1),validPoints(:,2),validPoints(:,3),validPoints(:,4));
axis equal;
axis([1,64,1,64,1,64]);
xlabel('y');
ylabel('u');
zlabel('v');

