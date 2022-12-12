
%Parameters:
% path 1 - the path to the host image
% path 2 - path to the watermark image
% alpha - damping factor
% savepath - path to where the watermarked image should be saved
% plots_on - turn on plots
% haar_on - add Haar DWT 

% Returns:
% watermarkedImage - returns RGB 0-255 magnitude image
% red_mod - the sum of the singular value matrix and alpha*watermark_image
% in the red color channel
% green_mod - same as above but in the green channel
% blue_mod - same as above but in the blue channel
function [watermarkedImage, red_mod, green_mod, blue_mod] = embed_svd(path1, path2, alpha, savepath, plots_on, haar_on)

    %open host
    rgbimage=imread(path1);

    if plots_on
        figure;
        imshow(rgbimage);
        title('Original Image');
    end

    if haar_on
        [h_LL,h_LH,h_HL,h_HH]=dwt2(rgbimage,'haar');
        img=h_LL;
    else
        img=double(rgbimage);
    end

    red1=img(:,:,1);
    green1=img(:,:,2);
    blue1=img(:,:,3);
    [U_r1, S_r1, V_r1] = svd(red1);
    [U_g1, S_g1, V_g1] = svd(green1);
    [U_b1, S_b1, V_b1] = svd(blue1);

    % watermark image
    rgbimage=imread(path2);
    
    if plots_on
        figure;
        imshow(rgbimage);
        title('Watermark Image');
    end
    
    if haar_on
        [w_LL,w_LH,w_HL,w_HH]=dwt2(rgbimage,'haar');
        img_wat=w_LL;
    else
        img_wat = double(rgbimage);
    end

    red2=img_wat(:,:,1);
    green2=img_wat(:,:,2);
    blue2=img_wat(:,:,3);

    red_mod = S_r1 + alpha*red2;
    green_mod = S_g1 + alpha*green2;
    blue_mod = S_b1 + alpha*blue2;

    [U_rw, S_rw, V_rw] = svd(red_mod);
    [U_gw, S_gw, V_gw] = svd(green_mod);
    [U_bw, S_bw, V_bw] = svd(blue_mod);

    wr1 = U_r1 * S_rw * V_r1';
    wg1 = U_g1 * S_gw * V_g1';
    wb1 = U_b1 * S_bw * V_b1';

    watermark = cat(3, wr1, wg1, wb1);
    
    %Inverse DFT
    if haar_on
        wk_LL = watermark;
        watermark = idwt2(wk_LL, h_LH,h_HL,h_HH, 'haar');
    end

    imwrite(uint8(watermark), savepath)
    watermarkedImage=uint8(watermark);

    if plots_on
        figure, imshow(uint8(watermark))
    end
end


