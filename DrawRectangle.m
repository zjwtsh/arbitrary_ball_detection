function result=DrawRectangle(image,corners,value)
num=size(corners);

if size(value(:))== 1
    value = ones(1,num(2))*value;
end

if(num(1)==4)
    for(j=1:num(2))     
        for(i=corners(1,j):corners(3,j))
            image(i,corners(2,j))=value(j);
            image(i,corners(4,j))=value(j);
        end

        for(i=corners(2,j):corners(4,j))
            image(corners(1,j),i)=value(j);
            image(corners(3,j),i)=value(j);
        end
    end
    result=image;
end
end