num_images = 600; 
window_size = 25;
alpha = 0.2;
images_to_display = [150, 300, 450, 600];
T = 2;

first_img = imread('image_001.jpg');
gray_first_img = rgb2gray(first_img);
[height, width] = size(gray_first_img);

images = zeros(height, width, num_images);

for k = 1:num_images
    img = imread(sprintf('image_%03d.jpg', k));
    images(:, :, k) = rgb2gray(img);
end

figure;

subplot_idx = 1;
motion_mask = false(height, width);

    
for k = 1:num_images
    start_idx = max(1, k - window_size);  
    end_idx = min(num_images, k + window_size);
    
    subset_images = images(:, :, start_idx:end_idx);
    
    mean_img = mean(subset_images, 3);
    std_img = std(subset_images, 0, 3);
   
    mask = abs(images(:, :, k) - mean_img) > alpha * std_img;
    
    if ismember(k, images_to_display)
        subplot(2, 2, subplot_idx);
        imshow(mask, []); 
        title(sprintf('Image %d', k));
        subplot_idx = subplot_idx + 1;
    end
end

sgtitle('alpha = 0.2');
