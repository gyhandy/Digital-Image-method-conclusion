function [initial_x, initial_y] = fun_getStartPoint(binaryImage)
    [rows,cols] = size(binaryImage);
    for i=1:rows
        for j=1:cols
            if(binaryImage(i, j) == 1)
                initial_x = i;
                initial_y = j;
                return;
            end
        end
    end
end

