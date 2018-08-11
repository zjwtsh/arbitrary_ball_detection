function [ outImg ] = combineImage( in1,in2 )
%COMBINEIMAGE Summary of this function goes here
%   Detailed explanation goes here

if(size(in1)~=size(in2))
    outImg = [];
    return;
end

img = [reshape(in1,numel(in1),1),reshape(in2,numel(in2),1)];
outImg = reshape(img',size(in1,1)*2,size(in1,2));
