function [denoised_image] = nl_mean_out(image_in, window_size, patch_size, gamma)

[imageWidth, imageHeight]=size(image_in);
denoised_image = zeros(imageWidth,imageHeight);
image_in = padarray(image_in,[patch_size,patch_size],'circular');

nl_kernel = nl_means(patch_size);
nl_kernel = nl_kernel/sum(sum(nl_kernel));

squared_gamma = gamma*gamma;

for x = 1:imageWidth
    for y = 1:imageHeight
        
        x_new = x+patch_size;
        y_new = y+patch_size;
        
        wind_1 = image_in(x_new-patch_size:x_new+patch_size,y_new-patch_size:y_new+patch_size);
        
        wind_max = 0;
        ave = 0;
        s_cum = 0;
        
        min_r = max(x_new-window_size,patch_size+1);
        max_r = min(x_new+window_size, imageWidth+patch_size);
        min_s = max(y_new-window_size, patch_size+1);
        max_s = min(y_new+window_size, imageHeight+patch_size);
        
        for i = min_r:max_r
            for j = min_s:max_s
                
                if(i==x_new && j==y_new)
                    continue;
                end
                
                wind_2 = image_in(i-patch_size:i+patch_size, j-patch_size:j+patch_size);
                
                diff = sum(sum(nl_kernel.*(wind_1-wind_2).*(wind_1-wind_2)));
                
                weigh_param = exp(-diff/squared_gamma);
                
                if weigh_param > wind_max
                    wind_max = weigh_param;
                end
                
                s_cum = s_cum+weigh_param;
                ave = ave +weigh_param*image_in(i,j);
            end
        end
        
        ave = ave + wind_max*image_in(x_new,y_new);
        s_cum = s_cum + wind_max;
        
        if s_cum > 0
            denoised_image(x,y) =ave/s_cum;
        else
            denoised_image(x,y) = image_in(x,y);
        end
    end
end
figure;
imshow(denoised_image);
end