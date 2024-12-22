function [u, v] = hornSchunck(I1, I2, nIterations, alpha)
    I1 = double(I1);
    I2 = double(I2);

    I1 = imgaussfilt(I1, 1);
    I2 = imgaussfilt(I2, 1);

    u = zeros(size(I1));
    v = zeros(size(I1));
    
    Ex = (1/4) * (I1(1:end-1, 2:end) - I1(1:end-1, 1:end-1) + I1(2:end, 2:end) - I1(2:end, 1:end-1) + ...
                  I2(1:end-1, 2:end) - I2(1:end-1, 1:end-1) + I2(2:end, 2:end) - I2(2:end, 1:end-1));
    Ey = (1/4) * (I1(2:end, 1:end-1) - I1(1:end-1, 1:end-1) + I1(2:end, 2:end) - I1(1:end-1, 2:end) + ...
                  I2(2:end, 1:end-1) - I2(1:end-1, 1:end-1) + I2(2:end, 2:end) - I2(1:end-1, 2:end));
    Et = (1/4) * (I2(1:end-1, 1:end-1) - I1(1:end-1, 1:end-1) + I2(2:end, 1:end-1) - I1(2:end, 1:end-1) + ...
                  I2(1:end-1, 2:end) - I1(1:end-1, 2:end) + I2(2:end, 2:end) - I1(2:end, 2:end));

    kernel = [1/12 1/6 1/12; 1/6 0 1/6; 1/12 1/6 1/12];

    for iter = 1:nIterations
        uAvg = conv2(u, kernel, 'same');
        vAvg = conv2(v, kernel, 'same');

        u(1:end-1, 1:end-1) = uAvg(1:end-1, 1:end-1) - ...
            (Ex .* ((Ex .* uAvg(1:end-1, 1:end-1)) + (Ey .* vAvg(1:end-1, 1:end-1)) + Et)) ./ ...
            (alpha^2 + Ex.^2 + Ey.^2);
        v(1:end-1, 1:end-1) = vAvg(1:end-1, 1:end-1) - ...
            (Ey .* ((Ex .* uAvg(1:end-1, 1:end-1)) + (Ey .* vAvg(1:end-1, 1:end-1)) + Et)) ./ ...
            (alpha^2 + Ex.^2 + Ey.^2);
    end

    u(isnan(u)) = 0;
    v(isnan(v)) = 0;
end
