function target = combineWhiteColor(origin)
sz = size(origin);

for i = 1:sz(1)
    for j = 1:sz(2)
        for k = 1:sz(3)
            if origin(i,j,k) == 2
                origin(i,j,k) = 16;
            end
        end
    end
end

target = origin;
