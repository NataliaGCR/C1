num_images = 600;     
window_size = 5;        
alpha_s = 1.3;         
alpha_v = 0.1;          
images_to_display = [150, 270, 450, 600]; 

first_img = imread('image_001.jpg');
[height, width, ~] = size(first_img);

images_s = zeros(height, width, num_images, 'double');
images_v = zeros(height, width, num_images, 'double');

for k = 1:num_images
    img = imread(sprintf('image_%03d.jpg', k));
    hsv_img = rgb2hsv(img);
    images_s(:, :, k) = hsv_img(:, :, 2);
    images_v(:, :, k) = hsv_img(:, :, 3);
end

figure;

mean_s = mean(images_s, 3);
std_s = std(images_s, 0, 3);
mean_v = mean(images_v, 3);
std_v = std(images_v, 0, 3);


subplot_idx = 1;
for k = 1:num_images
    current_s = images_s(:, :, k);
    current_v = images_v(:, :, k);

    motion_mask_s = abs(current_s - mean_s) > alpha_s * std_s;
    motion_mask_v = abs(current_v - mean_v) > alpha_v * std_v;

    combined_motion_mask = motion_mask_s & motion_mask_v;
    binary_motion = uint8(combined_motion_mask) * 255;

    if ismember(k, images_to_display)
        subplot(2, 2, subplot_idx);
        imshow(binary_motion, []); 
        title(sprintf('Image %03d', k));
        subplot_idx = subplot_idx + 1;
    end
end

sgtitle('Alpha-s = 1.3 & Alpha-v = 0.1');
