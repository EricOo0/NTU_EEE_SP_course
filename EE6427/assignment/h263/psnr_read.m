%fid='./QP1.yuv'; %读入文件
%row=352;col=288; %图像的高、宽
%frames=150; % total=97 %序列的帧数
clc
clear;
Frames=150;
diff_MSE=[];
diff_PSNR=[];
MSE=0;
prefix='./decode_qp%d.yuv';
for index=1:21
    addr=sprintf(prefix,index)
    fid=fopen(addr,'rb');
    fid2=fopen('../football_cif.yuv','rb');
    for i=1:Frames  
        %Y=fread(fid,[1024,768],'uint8');
        Y=fread(fid,[352,288],'uint8');
        U=fread(fid,[352/2,288/2],'uint8');
        V=fread(fid,[352/2,288/2],'uint8');


       % figure;imshow(uint8(Y));
        Y_orgin=fread(fid2,[352,288],'uint8');
        U_origin=fread(fid2,[352/2,288/2],'uint8');
        V_orin=fread(fid2,[352/2,288/2],'uint8');

        MSE =MSE + sum((Y_orgin-Y).^2,'all')/(352*288);
    end
    MSE=MSE/Frames
    PSNR =10*log10(255^2 / MSE)
    diff_MSE=[diff_MSE,MSE];
    diff_PSNR=[diff_PSNR,PSNR];
    fclose  all;
end 

bit_rate=[10901.63,5355.12,3784.63,2718.93, 2211.47 ,  1763.82 ,1522.87,  1283.76 ,1147.70,1000.27,913.09, 817.12, 758.08 ,  689.69,648.08, 599.02,567.63,529.91 , 506.87,477.66, 459.59];
figure ;

plot(bit_rate,diff_MSE);
xlabel('x = bitrate')
ylabel('MSE')
title('MSE','FontSize',12)

figure ;

plot(bit_rate,diff_PSNR);
xlabel('x = bitrate')
ylabel('PSNR')
title('PSNR','FontSize',12)

%File1='dec_dp01_2900'
%filep = dir(File1);
%fileBytes = filep.bytes; %Filesize2