%Question 2.(d)
%read source image -- lena
source_img=imread('source_img.bmp');

%X is to store partitoined block erroe is to store the reconstruction error
%in each block
X=[];
error=[];

%an array to keep retain_component;
retain=(64:-1:1);
%retain=(4:-1:1)
len=size(source_img,1);

%partition the image to different block size (8*8 or 2*2)
for i=1:8:len
%for i=1:2:len
    for j=1:8:len
   % for j=1:2:len
       c=reshape(source_img(i:i+7,j:j+7)',64,1);
   %     c=reshape(source_img(i:i+1,j:j+1)',4,1);
        X=[X;c'];
    end
end

%perform zero-mean centering and caculate covariance matrix
X=double(X);
X_mean=mean(X);
x=(X'-X_mean')';
C=cov(x);

%caculate eigenvalue and eigen vector
[V,D]=eig(C);

%keep different retained component ; 
for i=1:length(retain)
    retained_comp=retain(i);
    new_V=[zeros(size(V,2)-retained_comp,size(V,1));V(:,size(V,2)-retained_comp+1:size(V,2))']';
    factor=X*new_V; %calculate ci factor
    X_estimate=factor*new_V';%compression
    tem_img=[];
    row=[];
    
    %reconstruct the image from X to tem_img
   for k=1:1:4096
   %  for k=1:1:65536
        block=reshape(X_estimate(k,:),8,8)';
   %     block=reshape(X_estimate(k,:),2,2)';
        if mod(k,64)==0
     %   if mod(k,256)==0
            %»»ÐÐ
            row=[row block];
            tem_img=[tem_img;row];
            row=[];
        else
            row=[row block];
        end
   end
   %show the reconstruct image
    img=uint8(tem_img);
    imshow(img);
    retained_comp
    %calculate the reconstruction error 
    error=[error,sse(source_img-img)];
    %t=sum(sum((source_img-img).^2))
    %error=[error,t];
end
figure(2);
%draw the reconstruction error 
plot(retain,error);
xlabel('number of retained component');
ylabel('reconstruction error');
