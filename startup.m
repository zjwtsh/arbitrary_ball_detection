addpath(genpath(pwd));

fid = fopen('lut_171161.raw', 'r');
[A, count] = fscanf(fid, '%s',[1 inf]);
rst = [];
for i = 1 : length(A)
     rst(i) = A(i);
    if rst(i) ==13
        
      fprintf('%d\n', i);
    end
end
fclose(fid);
lut = reshape(rst, [64,64,64]);

fid1 = fopen('lut_172172.raw', 'r');
[A1, count1] = fscanf(fid1, '%s',[1 inf]);
rst1 = [];
for i = 1 : length(A1)
     rst1(i) = A1(i);
     if rst1(i) ==1
        fprintf('%d\n', i);
     end
end
fclose(fid1);
lut1 = reshape(rst1, [64,64,64]);

singleImg=yuyvMontage(:,:,1,40);
tu= yuyv2yuv(singleImg);

Y=tu(:,:,1);
U=tu(:,:,2);
V=tu(:,:,3);

x=round((V+4)/4);
y=round((U+4)/4);
z=round((Y+4)/4);

new=Y;
new(:,:)=0;
for i=1:size(new,1)
    for j=1:size(new,2)       
    %new(i,j)=lut(x(i,j),y(i,j),z(i,j));
    
    r1=lut(x(i,j),y(i,j),z(i,j));
    r2=lut1(x(i,j),y(i,j),z(i,j));
    if r1==1 && r2~=16
      new(i,j)=255;
    elseif r1==1
     
    new(i,j)=lut(x(i,j),y(i,j),z(i,j))*255;
        end

    end
end
imtool(new);


 

%x = [1:64];
%y = [1:64];
%z = [1:64];
%a = lut(x,y,z);
%scatter3(x,y,z,40,lut(x,y,z),'filled');
%scatter3(x,y,z,40,lut,'filled');
%colormap hsv;
%lutff=reshape(rst, [64,64,64]);
%C = importdata('lut_0613.raw');
