function lutMat = plotLut( filename )
%PLOTLUT Summary of this function goes here
%   Detailed explanation goes here
rst = [];

pfile = fopen(filename);
rst = fread(pfile);
fclose(pfile);
lutMat = reshape(rst,[64,64,64]);
