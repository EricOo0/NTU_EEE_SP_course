N=21 %�˲����ĳ��ȣ�һ�������ڵĲ������������ڽ���+1 

order = N-1

fs = 2800 %����Ƶ��2800hz

fo = fs/28%����Ƶ��100hz

%b = fir1(order,1/14,'low',hann(N));
b = fir1(order,1/7,'low',chebwin(N));
%b = fir1(order,1/14,'low',);
[h1,w1]=freqz(b,1,N);%��Ƶ����Ӧ  
subplot(4,1,1)
x=1:1:N;
Y=ifft(h1);
%test=filter(b,1,sin(200*x));
stem(x,abs(fft(Y)))

subplot(4,1,2)
plot(w1/pi,20*log10(abs(h1))); 

axis([0,1,-80,10]); 

grid;

xlabel('��һ��Ƶ��/p') ;

ylabel('����/dB') ;
subplot(4,1,3)
stem(x,abs(fft(b)));


 q = quantizer('fixed', 'Ceiling', 'Saturate', [16 15])
  c= num2bin(q,b)
  d=bin2dec(c)
  dec2hex(d)