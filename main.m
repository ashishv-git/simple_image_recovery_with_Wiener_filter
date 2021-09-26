close all; clc;

% Read data (blurred image and psf)
fid = fopen('images/blurred_image_and_Psf.dat', 'r', 'ieee-le');
data = fread(fid, [256, Inf], 'float32');
fclose(fid);
figure('Name', 'data'), imagesc(data); colormap(gray); title('Blurred image (left) and PSF (right)')
blurred_img = data(:, 1:256);
psf = data(:, 257:512);

h = psf;
H = fftshift(fft2(ifftshift(h)));

% Calculate SNR
S_in = 100  ;
S_noise = 1 ;
SNR = S_in / S_noise ;

% Wiener filter
W = conj(H) ./ ( abs(H).^2 + 1/SNR );

% Apply Wiener filter to the blurred image 
blurred_img_FT = fftshift(fft2(ifftshift(blurred_img)));
blurred_img_FT_Wiener_filtered = blurred_img_FT .* W ;
blurred_img_Wiener_filtered = fftshift(ifft2(ifftshift( blurred_img_FT_Wiener_filtered )));

% Display output
figure, subplot(1,2,1),  imagesc(blurred_img); axis equal; axis image ; title('Blurred image');
subplot(1,2,2),  imagesc(log(real(blurred_img_Wiener_filtered))); axis equal; axis image; colormap(gray);
title(['Recovered image for SNR = ', num2str(SNR)]);
