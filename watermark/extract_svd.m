
%Function that extracts watermark

% Parameters
% red = red_mod from embed output
% green = greem_mod from embed output
% blue = blue_mod from embed output
% watermarked = watermarked image path
% original = original host image path
% alpha = damping factor
% savepath = path to which the extracted watermark will be saved
% plots_on = turn on plot plotting
% haar_on = set to the same setting that embed() was set to.

function extractedWatermark = extract_svd(red, green, blue, watermarked, original, alpha, savepath, plots_on, haar_on)

    %host/watermarked image
    rgbimage=imread(watermarked);
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
    [~,S_imgr1,~]= svd(red1);
    [~,S_imgg1,~]= svd(green1);
    [~,S_imgb1,~]= svd(blue1);

    %original
    rgbimage=imread(original);
    if plots_on
        figure;
        imshow(rgbimage);
        title('Watermark image');
    end

    if haar_on
        [w_LL,w_LH,w_HL,w_HH]=dwt2(rgbimage,'haar');
        img_wat=w_LL;
    else
        img_wat=double(rgbimage);
    end

    red_org=img_wat(:,:,1);
    green_orig=img_wat(:,:,2);
    blue_orig=img_wat(:,:,3);

    [~,S_r2_orig,~]= svd(red_org);
    [~,S_g2_orig,~]= svd(green_orig);
    [~,S_b2_orig,~]= svd(blue_orig);

    [U_rw, ~, V_rw] = svd(red);
    [U_gw, ~, V_gw] = svd(green);
    [U_bw, ~, V_bw] = svd(blue);

    D_red = U_rw * S_imgr1 * V_rw';
    D_green = U_gw * S_imgg1 * V_gw';
    D_blue = U_bw * S_imgb1 * V_bw';

    w_red = 1/alpha*(D_red - S_r2_orig);
    w_green= 1/alpha*(D_green - S_g2_orig);
    w_blue= 1/alpha*(D_blue - S_b2_orig);

    ex_wat=cat(3,w_red,w_green,w_blue);

    if haar_on
        ex_wm_LL = ex_wat;
        extractedWatermark=idwt2(ex_wm_LL,w_LH,w_HL,w_HH,'haar');
    else
        extractedWatermark=ex_wat;
    end

    extractedWatermark = uint8(extractedWatermark);
    imwrite(extractedWatermark,savepath);

    if plots_on
        figure;imshow(uint8(extractedWatermark));
        title('Extracted Watermark');
    end
end