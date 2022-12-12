
%I and K must be the same size!
function psnr = findPSNR(I, K)
    
    Ired = I(:,:,1);
    Igreen = I(:,:,2);
    Iblue = I(:,:,3);

    Kred = K(:,:,1);
    Kgreen = K(:,:,2);
    Kblue = K(:,:,3);

    imageSize = height(Ired) * width(Ired);

    mseR = (sum(sum((Ired - Kred).^2)))/(imageSize);
    mseG = (sum(sum((Igreen - Kgreen).^2)))/(imageSize);
    mseB = (sum(sum((Iblue - Kblue).^2)))/(imageSize);

    mse = mean([mseR, mseG, mseB]);

    psnr = 10*log10(255^2 / mse);






    