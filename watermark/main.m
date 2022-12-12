
clc
close all

path1= '/Users/rohansanda/Desktop/stanford.jpeg';
path2= '/Users/rohansanda/Desktop/gene_qr.png';
savepath1= '/Users/rohansanda/Desktop/watermarked_snow.jpg';
path3=savepath1;
savepath2= '/Users/rohansanda/Desktop/extracted_snow.jpg';
alpha=0.1;

%Embed watermark into hose
[watermarked, red, green, blue] = embed_svd(path1, path2, alpha, savepath1, true, false);

%Extract watermark from host
[extracted] = extract_svd(red, green, blue, savepath1, path1, alpha, savepath2, true, false);

%Calculate PSNR between original host and watermarked image
original=double(imread(path1));
watermarked= double(imread(savepath1));

psnr = findPSNR(original, watermarked)

red_corr2 = corr2(original(:,:,1), watermarked(:,:,1));
green_corr2= corr2(original(:,:,2), watermarked(:,:,2));
blue_corr2 = corr2(original(:,:,3), watermarked(:,:,3));

%Calculate the 2D Correlation
corr= mean([red_corr2, green_corr2, blue_corr2])

