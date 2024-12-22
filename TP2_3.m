N = 10;       
Vmin = 0;    
Vmax = 255;  
TV = 32; 
m = 4;      
p = 1;  
sigma = 2^m / 2^p; 

num_images = 600; 

first_img = imread('image_001.jpg');
gray_first_img = rgb2gray(first_img);
[height, width] = size(gray_first_img);

M = zeros(height, width);
V = zeros(height, width);
motion_mask = zeros(height, width);

images = zeros(height, width, num_images, 'uint8');
for k = 1:num_images
    img = imread(sprintf('image_%03d.jpg', k));
    images(:, :, k) = rgb2gray(img);
end

frames_to_plot_1 = [150, 300];
frames_to_plot_2 = [450, 600];

figure1 = figure('Name', 'Resultados de las imágenes 50 y 100');
figure2 = figure('Name', 'Resultados de las imágenes 200 y 300');

for t = 2:num_images
    gray_frame = images(:, :, t);
    for x = 1:height
        for y = 1:width
            if V(x, y) > sigma
                if M(x, y) < gray_frame(x, y)
                    M(x, y) = M(x, y) + 1;
                elseif M(x, y) > gray_frame(x, y)
                    M(x, y) = M(x, y) - 1;
                end
            end
        end
    end
    
    O = abs(double(M) - double(gray_frame));

    if mod(t, TV) == 0
        for x = 1:height
            for y = 1:width
                if V(x, y) < N * O(x, y)
                    V(x, y) = V(x, y) + 1;
                elseif V(x, y) > N * O(x, y)
                    V(x, y) = V(x, y) - 1;
                end
                V(x, y) = max(min(V(x, y), Vmax), Vmin);
            end
        end
    end
    
    E = O >= V; 
  
    if ismember(t, frames_to_plot_1)
        figure(figure1);
        subplot(2, 2, find(frames_to_plot_1 == t));
        imshow(gray_frame);
        title(['Image ', num2str(t)]);
        
        subplot(2, 2, find(frames_to_plot_1 == t) + 2);
        imshow(E);
        title(['Movement ', num2str(t)]);
    elseif ismember(t, frames_to_plot_2)
        figure(figure2);
        subplot(2, 2, find(frames_to_plot_2 == t));
        imshow(gray_frame);
        title(['Image ', num2str(t)]);
        
        subplot(2, 2, find(frames_to_plot_2 == t) + 2);
        imshow(E);
        title(['Movement ', num2str(t)]);
    end
end

figure(figure1);
sgtitle('TV = 32');

figure(figure2);
sgtitle('TV = 32');
