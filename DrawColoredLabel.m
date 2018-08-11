function DrawColoredLabel(target)
    grayScale = target;
    [h,w] = size(grayScale);
    grayScale(:) = 128;
    
    rgbImg(:,:,1) = grayScale;
    rgbImg(:,:,2) = grayScale;
    rgbImg(:,:,3) = grayScale;
    
    for i=1:h
        for j=1:w
            if(target(i,j)==1)
                rgbImg(i,j,1) = 255;
                rgbImg(i,j,2) = 0;
                rgbImg(i,j,3) = 0;
            elseif(target(i,j)==2)
                rgbImg(i,j,1) = 0;
                rgbImg(i,j,2) = 0;
                rgbImg(i,j,3) = 0;
            elseif(target(i,j)==4)
                rgbImg(i,j,1) = 255;
                rgbImg(i,j,2) = 255;
                rgbImg(i,j,3) = 255;
            elseif(target(i,j)~=0)
                rgbImg(i,j,1) = 0;
                rgbImg(i,j,2) = 0;
                rgbImg(i,j,3) = 255;
                'error'
            end
        end
    end

    imshow(rgbImg);
end
