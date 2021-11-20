

H.263 :CIF分辨率（352×288）

YUYUV在存储时是以数组的形式存储的，可以看做连续的三个一维数组。三个数组分别单独存储Y、U、V分量。以一幅100×100的YUV444图像为例，下图表示的**YUV444的存储格式**和**YUV420的存储格式**。

用psnr_read.m绘制psnr和mse绘制不同Q的结果

用psnr_new.m绘制5个固定比特率下每帧的MSE

其余m文件也可以load视频文件和计算psnr，参考代码使用

![image-20211019171016587](/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211019171016587.png)

* Encode:

.\tmn.exe -i ..\football_cif.yuv -a 0 -b 149 -x 3 -O 0 -S 0 -I 1 -q 1 -B QP1.bits -o QP1.yuv

-a start at frame 0

-b stop at frame 149

-x coding format x3--cfi

-O 0 skip 0 frame

-S 0 skip 0 frame

-q 1 quantization parameter

-B output bitstream

-o reconstruct yuv

-l loop sequence

-I 1 qp for first frame

* Fix bitrate:

./tmn -i ../football_cif.yuv -a 0 -b 149  -x 3  -O 0 -S 0  -I 1 -q 1 -r 29000000 -o dec_bit_29000k.yuv -B dec_bit_29000k.bits

* Decode:

 ./tmndec -o5 -l .\QP19.bits .\decode_qp1.yuv

-o5 output format YUV concatenated







QP1.      10901.63 (10833.82) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142244842.png" alt="image-20211024142244842" style="zoom:50%;" />

QP2  5355.12 (5302.44) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142332122.png" alt="image-20211024142332122" style="zoom:50%;" />

QP3  3784.63 (3744.56) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142421078.png" alt="image-20211024142421078" style="zoom:50%;" />

QP4 2718.93 (2685.28) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142459397.png" alt="image-20211024142459397" style="zoom:50%;" />

QP5   2211.47 (2183.36) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142610646.png" alt="image-20211024142610646" style="zoom:50%;" />

QP6   1763.82 (1739.08) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142707929.png" alt="image-20211024142707929" style="zoom:50%;" />



QP7   1522.87 (1501.34) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142756091.png" alt="image-20211024142756091" style="zoom:50%;" />



QP8   1283.76 (1264.21) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142845305.png" alt="image-20211024142845305" style="zoom:50%;" />



QP9   1147.70 (1130.14) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024142921776.png" alt="image-20211024142921776" style="zoom:50%;" />

QP10   1000.27 (984.11) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143041424.png" alt="image-20211024143041424" style="zoom:50%;" />

QP11.    913.09 (898.31) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143147347.png" alt="image-20211024143147347" style="zoom:50%;" />

QP12  817.12 (803.30) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143233087.png" alt="image-20211024143233087" style="zoom:50%;" />

QP13  758.08 (745.31) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143342529.png" alt="image-20211024143342529" style="zoom:50%;" />



QP14   689.69 (677.68) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143422152.png" alt="image-20211024143422152" style="zoom:50%;" />

QP15  648.08 (636.84) kbit/sec

 

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143509999.png" alt="image-20211024143509999" style="zoom:50%;" />

QP16   599.02 (588.36) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143546372.png" alt="image-20211024143546372" style="zoom:50%;" />

QP17   567.63 (557.60) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143640121.png" alt="image-20211024143640121" style="zoom:50%;" />

QP18   529.91 (520.33) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143748868.png" alt="image-20211024143748868" style="zoom:50%;" />

QP19.     506.87 (497.72) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143832105.png" alt="image-20211024143832105" style="zoom:50%;" />



QP20      477.66 (468.90) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024143935690.png" alt="image-20211024143935690" style="zoom:50%;" />



QP21  459.59 (451.20) kbit/sec

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024144016393.png" alt="image-20211024144016393" style="zoom:50%;" />

Decode:



<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024145317228.png" alt="image-20211024145317228" style="zoom:50%;" />

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024145422641.png" alt="image-20211024145422641" style="zoom:50%;" />

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024145507417.png" alt="image-20211024145507417" style="zoom:50%;" />

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024145809024.png" alt="image-20211024145809024" style="zoom:50%;" />

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024145909261.png" alt="image-20211024145909261" style="zoom:50%;" />







.\tmn.exe -i ..\football_cif.yuv -x 3 -S 0 -O 0 -b 149 -I 30 -r 1500000 -R 30 -o dec_bit_1500k.yuv -B dec_bit_1500k.bits



I:30 1500k

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024164459259.png" alt="image-20211024164459259" style="zoom:50%;" />

I:30 2000k

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024164653174.png" alt="image-20211024164653174" style="zoom:50%;" />

I:30 2500k

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024164758177.png" alt="image-20211024164758177" style="zoom:50%;" />

I:30 3000k

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024164903522.png" alt="image-20211024164903522" style="zoom:50%;" />

I:30 3500k

<img src="/Users/weizhifeng/Library/Application Support/typora-user-images/image-20211024164959352.png" alt="image-20211024164959352" style="zoom:50%;" />