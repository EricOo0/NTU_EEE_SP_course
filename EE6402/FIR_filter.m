N=21 %滤波器的长度，一个周器内的采样点数，等于阶数+1 

order = N-1

fs = 2800 %采样频率2800hz

fo = fs/28%截至频率100hz

%b = fir1(order,1/14,'low',hann(N));
b = fir1(order,1/7,'low',chebwin(N));
%b = fir1(order,1/14,'low',);
[h1,w1]=freqz(b,1,N);%求频率响应  
subplot(4,1,1)
x=1:1:N;
Y=ifft(h1);
%test=filter(b,1,sin(200*x));
stem(x,abs(fft(Y)))

subplot(4,1,2)
plot(w1/pi,20*log10(abs(h1))); 

axis([0,1,-80,10]); 

grid;

xlabel('归一化频率/p') ;

ylabel('幅度/dB') ;
subplot(4,1,3)
stem(x,abs(fft(b)));


 q = quantizer('fixed', 'Ceiling', 'Saturate', [16 15])
  c= num2bin(q,b)
  d=bin2dec(c)
  dec2hex(d)