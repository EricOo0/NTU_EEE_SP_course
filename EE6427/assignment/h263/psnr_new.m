diff_MSE_2=[];
diff_PSNR_2=[];
MSE=0;

prefix='./decode_qp%d.yuv';
fix=["./decode_fix_1500k.yuv" ,"./decode_fix_2000k.yuv","./decode_fix_2500k.yuv","./decode_fix_3000k.yuv","./decode_fix_3500k.yuv"]

MSE_fix=[];
for i=1:5
    fix(i)
    fid1=fopen(fix(i),'rb');
    fid2=fopen('../football_cif.yuv','rb');
    mse_fix=[]
    for j=1:150
        Y=fread(fid1,[352,288],'uint8');
        U=fread(fid1,[352/2,288/2],'uint8');
        V=fread(fid1,[352/2,288/2],'uint8');

        Y_orgin=fread(fid2,[352,288],'uint8');
        U_origin=fread(fid2,[352/2,288/2],'uint8');
        V_orin=fread(fid2,[352/2,288/2],'uint8');

        mse_fix =[mse_fix,sum((Y_orgin-Y).^2,'all')/(352*288)];
    end
     MSE_fix=[ MSE_fix;mse_fix];
     fclose  all;
    
end
x=linspace(1,150,150);

y1 = MSE_fix(1,:)
plot(x,y1);
hold on;
y2 = MSE_fix(2,:)
plot(x,y2);
y3 = MSE_fix(3,:)
plot(x,y3);
y4 = MSE_fix(4,:)
plot(x,y4);
y5 = MSE_fix(5,:)
plot(x,y5);
legend('1500b','2000b','2500b','3000b','3500b')
hold off;
%for index=1:21
%    addr=sprintf(prefix,index)
%    a=yuvpsnr(addr,'../football_cif.yuv',352,288,'420','y')
%    diff_PSNR_2=[diff_PSNR_2,a];
%end