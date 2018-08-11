imgPaper(:,:,1)=y1';
imgPaper(:,:,2)=u';
imgPaper(:,:,3)=v';

imshow(ycbcr2rgb(imgPaper));