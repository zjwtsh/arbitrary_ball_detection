function result = yuv2label(yuvImage,lut)
yvec = fix((yuvImage(:,:,1)+4)/4);
uvec = fix((yuvImage(:,:,2)+4)/4);
vvec = fix((yuvImage(:,:,3)+4)/4);

result=yuvImage(:,:,1);
result(:) = 0;

imagesize = size(result);

for i = 1:imagesize(1)
    for j =1:imagesize(2)
        result(i,j)= lut(vvec(i,j),uvec(i,j),yvec(i,j));
    end 
end
