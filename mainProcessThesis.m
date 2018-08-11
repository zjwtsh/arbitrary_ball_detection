clear;
pkg load image;
VISION_ANGLE_WIDTH = 50/180*pi;
PICTURE_DIMENSION_WIDTH = 640;
PICTURE_DIMENSION_HEIGHT = 480;
CAMERA_FOCUS_LENGTH= PICTURE_DIMENSION_HEIGHT/2/tan(VISION_ANGLE_WIDTH/2);
ORIGINAL_BALL_RADIUS = 140;

camera_tilt = 15/180*pi;

%load qiuchangdi.mat
%load qiu.mat
load yuyv_20170713T124138.mat
singleImg=yuyvMontage(:,:,1,98);
[y1,u,y2,v] = yuyv2yuv(singleImg);
img(:,:,1)=combineImage(y1,y2);
img(:,:,2)=combineImage(u,u);
img(:,:,3)=combineImage(v,v);

% [lutBall, vpBall] = plotLut2( 'lut_172171.raw' );
% [lutWhite, vpWhite] = plotLut2( 'lut_172172.raw' );
[lutBall, vpBall] = plotLut2( 'lut_170712qiudi.raw' );
[lutWhite, vpWhite] = plotLut2( 'lut_170712xianmen.raw');
lutWhite = combineWhiteColor(lutWhite);
[lutBk,vpBk]= createBlackLut(64,4,7,15);

splitted = splitBallLut(lutBall,lutWhite,lutBk);
result=uint8(yuv2label(img,splitted));
%imshow(result*64);
DrawColoredLabel(result);

Dxy=[-1,0,1,0;0,1,0,-1];
maxNoisy = 50;
[width,height]=size(result);
pointProcFlag = result;
pointProcFlag(:) = 0;
filteredFlag = result;
filteredFlag(:) = 0;
infoOfCluster=[];

for i=1:width
    for j=1:height
        if(result(i,j)~=0 && pointProcFlag(i,j)==0)
            tag = result(i,j);
            pointProcFlag(i,j)=1;
            growQueue=[i;j];
            nStart=1;
            nEnd=2;
            corners=[i,i;j,j];
            
            while(nStart<nEnd)
                currPt=growQueue(:,nStart);
                for k=1:4
                    newPt=currPt+Dxy(:,k);

                    if(newPt(1)<=width&&newPt(1)>=1 ...
                        &newPt(2)<=height&&newPt(2)>=1 ...
                      )
                            if( pointProcFlag(newPt(1),newPt(2))==0 ...
                                    && result(newPt(1),newPt(2))==tag ...
                                )
                                    growQueue=[growQueue,newPt];
                                    nEnd=nEnd+1;
                                    pointProcFlag(newPt(1),newPt(2))=1;
                            else
                                switch k
                                    case 1
                                        if(currPt(1)<corners(1,1))
                                            corners(1,1)=currPt(1);
                                        end
                                    case 2
                                        if(currPt(2)>corners(2,2))
                                            corners(2,2)=currPt(2);
                                        end
                                    case 3
                                        if(currPt(1)>corners(1,2))
                                            corners(1,2)=currPt(1);
                                        end
                                    case 4
                                        if(currPt(2)<corners(2,1))
                                            corners(2,1)=currPt(2);
                                        end                                        
                                end
                            end
                    else
                        switch k
                            case 1
                                if(currPt(1)<corners(1,1))
                                    corners(1,1)=currPt(1);
                                end
                            case 2
                                if(currPt(2)>corners(2,2))
                                    corners(2,2)=currPt(2);
                                end
                            case 3
                                if(currPt(1)>corners(1,2))
                                    corners(1,2)=currPt(1);
                                end
                            case 4
                                if(currPt(2)<corners(2,1))
                                    corners(2,1)=currPt(2);
                                end                                        
                        end                        
                    end
                end
                nStart=nStart+1;
            end
            
            clusterCenterY = (corners(2,1)+corners(2,2))/2;
            lineAngle = atan(-(clusterCenterY-PICTURE_DIMENSION_HEIGHT/2)/ ...
                CAMERA_FOCUS_LENGTH)+camera_tilt;
%             if lineAngle <-10/180*pi
%                 continue;
%             end
%             if lineAngle <= 5/180*pi
%                 lineAngle = 5/180*pi;
%             end
            if lineAngle <5/180*pi
                continue;
            end

            maxRadius = ORIGINAL_BALL_RADIUS * sin(lineAngle);
            maxNoisy = 0.15*maxRadius*maxRadius/4;
            currRadius = max(abs(corners(1,1)-corners(1,2)),abs(corners(2,1)-corners(2,2)));
            
            if nEnd>6 && nEnd > maxNoisy && currRadius < 1.2*maxRadius
                infoOfCluster = [ ...
                    infoOfCluster; double(tag), nEnd-1, ... 
                    corners(1,1),corners(2,1),corners(1,2),corners(2,2), ...
                    ];
                for kpt = 1: (nEnd-1)
                    filteredFlag(growQueue(1,kpt),growQueue(2,kpt)) = tag;
                end                
            end
            
%             if nEnd > maxNoisy
%                 infoOfCluster = [ ...
%                     infoOfCluster; double(tag), nEnd-1, ... 
%                     corners(1,1),corners(2,1),corners(1,2),corners(2,2), ...
%                     ];
%                 for kpt = 1: (nEnd-1)
%                     filteredFlag(growQueue(1,kpt),growQueue(2,kpt)) = tag;
%                 end
%             end

        end
    end
end

filteredFlag = DrawRectangle(filteredFlag,infoOfCluster(:,3:6)',infoOfCluster(:,1));
DrawColoredLabel(filteredFlag);

%rgbImg = ycbcr2rgb(img);
%rgbImg(:,:,1) = DrawRectangle(rgbImg(:,:,1),infoOfCluster(:,3:6)',infoOfCluster(:,1));
%rgbImg(:,:,2) = DrawRectangle(rgbImg(:,:,2),infoOfCluster(:,3:6)',infoOfCluster(:,1));
%rgbImg(:,:,3) = DrawRectangle(rgbImg(:,:,3),infoOfCluster(:,3:6)',infoOfCluster(:,1));
%next step cluster the bounding boxes according to the size of the ball
%firstly create the connecting map of the clusters
clusterNum = size(infoOfCluster,1);
relationMap = eye(clusterNum);
for i = 1: clusterNum
    currCluster = infoOfCluster(i,3:6);
    for j = (i+1):clusterNum
        tryingCluster = infoOfCluster(j,3:6);
        enlargedAABB = [ min(currCluster(1),tryingCluster(1)),...
            min(currCluster(2),tryingCluster(2)),...
            max(currCluster(3),tryingCluster(3)),...
            max(currCluster(4),tryingCluster(4))
            ];

        clusterCenterY = (enlargedAABB(2)+enlargedAABB(4))/2;
        lineAngle = atan(-(clusterCenterY-PICTURE_DIMENSION_HEIGHT/2)/ ...
            CAMERA_FOCUS_LENGTH)+camera_tilt;
        if lineAngle <5/180*pi
            relationMap(i,j) = 2;
            relationMap(j,i) = 2;
            continue;
        end
%         if lineAngle <= 5/180*pi
%             lineAngle = 5/180*pi;
%         end

        maxRadius = ORIGINAL_BALL_RADIUS * sin(lineAngle);
        currRadius = max(abs(enlargedAABB(1)-enlargedAABB(3)),abs(enlargedAABB(2)-enlargedAABB(4)));
        if currRadius > 1.2*maxRadius
            relationMap(i,j) = 2;
            relationMap(j,i) = 2;
            continue;
        end

        totalLengthx = currCluster(3)-currCluster(1)+tryingCluster(3)-tryingCluster(1);
        totalLengthy = currCluster(4)-currCluster(2)+tryingCluster(4)-tryingCluster(2);
        if totalLengthx+2 >= enlargedAABB(3)-enlargedAABB(1) && ...
                totalLengthy+2 >= enlargedAABB(4)-enlargedAABB(2)
            relationMap(i,j) = 1;
            relationMap(j,i) = 1;
        end
    end
end

candidateRegionCenter = zeros(1,clusterNum);
ballCandidates = [];
ballReverse = [];
allConnectedBox=[];

for i =1:clusterNum
    if candidateRegionCenter(i) == 3
        continue;
    end
    
    %initialize two vectors
    connectRegion = relationMap(i,:);
    connectRegion(i) = 3;
    nextConnectRegion = connectRegion;
    isRunning=true;
    
    while(isRunning)
        isRunning = false;
        for j = 1:clusterNum
            if connectRegion(j) ==1
                targetRegion = relationMap(j,:);
                for k = 1:clusterNum
                    if targetRegion(k) ~= 0
                        if targetRegion(k) == 2
                            connectRegion(k) = targetRegion(k);
                            nextConnectRegion(k) = targetRegion(k);
                        elseif connectRegion(k) == 0 
                            nextConnectRegion(k) = targetRegion(k);
                            isRunning =true;
                        end
                    end
                end
                connectRegion(j) = 3;
                nextConnectRegion(j) = 3;
            end
        end
        connectRegion = nextConnectRegion;
    end
    
    %extract specialties of the connected region and update candidateRegionCenter
    connectedResult = [];
    
    for j = 1:clusterNum
        if connectRegion(j) ~= 0
            if connectRegion(j) == 3
                connectedResult = [connectedResult;infoOfCluster(j,:)];
                candidateRegionCenter(j) = connectRegion(j);
            elseif candidateRegionCenter(j) ~= 3 
                candidateRegionCenter(j) = connectRegion(j);
            end
        end
    end
    
    %possible ball observation is stalled in connectedResult
    bkCntr = 0; 
    wtCntr = 0; 
    blCntr = 0;
    aabbOfBall = connectedResult(1,3:6);
    rstBlkNum = size(connectedResult,1);
    
    for i = 1:rstBlkNum
        aabbOfBall(1)= min(connectedResult(i,3),aabbOfBall(1));
        aabbOfBall(2)= min(connectedResult(i,4),aabbOfBall(2));
        aabbOfBall(3)= max(connectedResult(i,5),aabbOfBall(3));
        aabbOfBall(4)= max(connectedResult(i,6),aabbOfBall(4));
        switch connectedResult(i,1)
            case 1
               blCntr = blCntr+ connectedResult(i,2);
            case 2
               bkCntr = bkCntr+connectedResult(i,2);
            case 4
               wtCntr = wtCntr + connectedResult(i,2);
        end
    end
    totalCntr = bkCntr + wtCntr+blCntr;
    if(totalCntr == 0)
        continue;
    end
    
    rateCntr = 0;
    rate = blCntr/totalCntr;
    if(rate < 0.9 && rate > 0.1)
        rateCntr = rateCntr+1;
    end
    rate = wtCntr/totalCntr;
    if(rate < 0.9 && rate > 0.1)
        rateCntr = rateCntr+1;
    end
    rate = bkCntr/totalCntr;
    if(rate < 0.9 && rate > 0.1)
        rateCntr = rateCntr+1;
    end
    if(rateCntr<2)
        continue;
    end
    
    ballReverse = [ballReverse; ...
        aabbOfBall,blCntr/totalCntr, wtCntr/totalCntr,bkCntr/totalCntr];
    allConnectedBox=[allConnectedBox;connectedResult];
    
    ballCenterY = (aabbOfBall(2)+aabbOfBall(4))/2;
    lineAngle = atan(-(ballCenterY-PICTURE_DIMENSION_HEIGHT/2)/ ...
        CAMERA_FOCUS_LENGTH)+camera_tilt;
    maxRadius = ORIGINAL_BALL_RADIUS * sin(lineAngle);
    currRadius = max(abs(aabbOfBall(1)-aabbOfBall(3)+1),abs(aabbOfBall(2)-aabbOfBall(4)+1));
    if(currRadius<maxRadius*0.4)
        continue;
    end

    squareRate = (aabbOfBall(4)-aabbOfBall(2)+1)/(aabbOfBall(3)-aabbOfBall(1)+1);
    if(squareRate > 1) 
        squareRate = 1/squareRate;
    end
    if(squareRate <0.4)
        continue
    end
    
    fillRate = totalCntr/((aabbOfBall(4)-aabbOfBall(2)+1)*(aabbOfBall(3)-aabbOfBall(1)+1));
    if(fillRate < 0.20)
        continue;
    end
    
    config.aabbOfBall = aabbOfBall;
    config.offset = 2;
    config.lutBall = lutBall;
    config.tag = 8;
    config.imgSz = size(filteredFlag);
    config.img = img;

    backGroundRatio = CountBackgroundRatio(config);
    if(backGroundRatio<0.35)
        continue;
    end
%     ballCandidates = [ballCandidates; ...
%         aabbOfBall,blCntr/totalCntr, wtCntr/totalCntr,bkCntr/totalCntr, ...
%         (aabbOfBall(3)-aabbOfBall(1))*(aabbOfBall(4)-aabbOfBall(2)) ];

    Kcolor = 1/15;
    Kground = 1/5;
    Kradius = 1/5;
    KfillRate = 1/5;
    KsquareRate = 1/5;
    evaluation = Kcolor*((blCntr/totalCntr-0.3)^2 + (wtCntr/totalCntr-0.4)^2 + ...
        (bkCntr/totalCntr-0.3)^2) + Kradius * (currRadius/maxRadius-1)^2 + ...
        Kground*(backGroundRatio-1)^2 + ...
        KfillRate*(fillRate-0.75)^2 +...
        KsquareRate*(squareRate-1)^2;
    
    ballCandidates = [ballCandidates; ...
        aabbOfBall,blCntr/totalCntr, wtCntr/totalCntr,bkCntr/totalCntr, ...
        currRadius/maxRadius,backGroundRatio,squareRate, totalCntr, evaluation];

end

finalImage=img;
drawTarget = allConnectedBox(:,3:6)';
finalImage(:,:,1) = DrawRectangle(finalImage(:,:,1),drawTarget,128);
finalImage(:,:,2) = DrawRectangle(finalImage(:,:,2),drawTarget,128);
finalImage(:,:,3) = DrawRectangle(finalImage(:,:,3),drawTarget,255);

% drawTarget = ballCandidates(:,1:4)';
% finalImage(:,:,1) = DrawRectangle(finalImage(:,:,1),drawTarget,255);
% finalImage(:,:,2) = DrawRectangle(finalImage(:,:,2),drawTarget,0);
% finalImage(:,:,3) = DrawRectangle(finalImage(:,:,3),drawTarget,255);

imshow(ycbcr2rgb(finalImage));

