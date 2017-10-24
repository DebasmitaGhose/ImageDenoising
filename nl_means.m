function [means_kernel] = nl_means(patch_size)
means_kernel = zeros(2*patch_size+1, 2*patch_size+1);
for distance = 1:patch_size
    weight = (1/(2*distance+1))^2;
    for x=-distance:distance
        for y=-distance:distance
            means_kernel(patch_size+1-x,patch_size+1-y)=means_kernel(patch_size+1-x,patch_size+1-y)+weight;
        end
    end
end
means_kernel = means_kernel./patch_size;
end





