function backGroundRatio = CountBackgroundRatio(config)%(aabbOfBall, offset, lutBall, tag)
aabbOfBall = config.aabbOfBall;
offset = config.offset;
lutBall = config.lutBall;
tag = config.tag;
imgSz = config.imgSz;
img = config.img;

yvec = fix((img(:,:,1)+4)/4);
uvec = fix((img(:,:,2)+4)/4);
vvec = fix((img(:,:,3)+4)/4);

minx = max(1,aabbOfBall(1)-offset);
miny = max(1,aabbOfBall(2)-offset);
maxx = min(imgSz(1), aabbOfBall(3)+offset);
maxy = min(imgSz(2), aabbOfBall(4)+offset);

cntr = 0;

j = miny;
for i = minx:maxx
    if(lutBall(vvec(i,j),uvec(i,j),yvec(i,j))== tag)
        cntr = cntr +1;
    end
end

j = maxy;
for i = minx:maxx
    if(lutBall(vvec(i,j),uvec(i,j),yvec(i,j))== tag)
        cntr = cntr +1;
    end
end

i = minx;
for j = miny:maxy
    if(lutBall(vvec(i,j),uvec(i,j),yvec(i,j))== tag)
        cntr = cntr +1;
    end
end

i = maxx;
for j = miny:maxy
    if(lutBall(vvec(i,j),uvec(i,j),yvec(i,j))== tag)
        cntr = cntr +1;
    end
end

backGroundRatio = cntr/(2*(maxx-minx)+2*(maxy-miny));
