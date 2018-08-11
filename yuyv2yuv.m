function [y1,u,y2,v] = yuyv2yuv(img)

mask = [hex2dec('ff000000'),hex2dec('00ff0000'),hex2dec('0000ff00'),hex2dec('000000ff')];
v = uint8(bitshift(bitand(img,mask(1)),-24));
y1 = uint8(bitshift(bitand(img,mask(2)),-16));
u = uint8(bitshift(bitand(img,mask(3)),-8));
y2 = uint8(bitshift(bitand(img,mask(4)),0));


