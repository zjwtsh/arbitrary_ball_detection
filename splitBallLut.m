function splitted = splitBallLut(lutBall,lutWhite,lutBlack)

[lutMat1,vpMat1]=substractLut2(lutBall,lutWhite,1,16);
[lutMat2,vpMat2]=substractLut2(lutBall,lutBlack,1,4);

[lutBiw, vpBiw]=substractLut2(lutBall,lutMat1,1,1);
[lutBib, vpBib]=substractLut2(lutBall,lutMat2,1,1);
[lutColor,vpColor]=substractLut2(lutMat2,lutBiw,1,1);
splitted = lutBiw*4+lutBib*2 + lutColor;

validPoints=[];
for i =1:64
    for j = 1:64
        for k = 1:64
            if(splitted(i,j,k)~=0)
                validPoints=[validPoints;i,j,k,splitted(i,j,k)];
            end
        end 
    end
end

% scatter3(validPoints(:,1),validPoints(:,2),validPoints(:,3),validPoints(:,4));
% axis equal;
% axis([1,64,1,64,1,64]);
% xlabel('v');
% ylabel('u');
% zlabel('y');
