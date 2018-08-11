function outputOPImg(matfile,sel)
pfile = fopen('sample.yuyv','wb+');

%load yuyv_20170721T220059.mat
load yuyv_20170316T112035.mat
singleImg=yuyvMontage(:,:,1,89);
%singleImg = rot90(singleImg);
fwrite(pfile, singleImg, 'uint32')
fclose(pfile);

[y1,u,y2,v] = yuyv2yuv(singleImg);
img(:,:,1)=y1;
img(:,:,2)=u;
img(:,:,3)=v;
imtool(ycbcr2rgb(img));
