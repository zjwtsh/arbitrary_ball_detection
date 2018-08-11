
load yuyv_20170316T112035.mat
%load qiu.mat
singleImg=yuyvMontage(:,:,1,42);
[y1,u,y2,v] = yuyv2yuv(singleImg);
img = [];
img(:,:,1)=y1;
img(:,:,2)=u;
img(:,:,3)=v;
img = uint8(img);
imtool(ycbcr2rgb(img));

[lutBall, vpBall] = plotLut2( 'FieldandBall0318.raw' );
result=uint8(yuv2label(img,lutBall));