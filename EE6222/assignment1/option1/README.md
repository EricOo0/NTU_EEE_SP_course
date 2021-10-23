# 特征提取 Thining/skeletonization

指图像细化和骨架提取的方法：为了获得图像的轮廓特征

2-step thinning 算法：

​	安装opencv：brew install opencv

​	灰度和二值的区别：灰度只含亮度信息，不含色彩信息，但是亮度信息是连续的；二值图像只含0和255的黑白像素，通过设置阈值将灰度转化为二值图像；

细化算法：
	图像细化(Image Thinning)，一般指二值图像的骨架化(Image Skeletonization)的一种操作运算。切记：前提条件一定是二值图！所谓的细化就是经过一层层的剥离，从原来的图中去掉一些点，但仍要保持原来的形状，直到得到图像的骨架。骨架，可以理解为图象的中轴。

* 2-step thinning algorithm：

  https://blog.csdn.net/weixin_40977054/article/details/96888371

* mat：

  medial_axis()

  http://www.10qianwan.com/articledetail/627102.html



