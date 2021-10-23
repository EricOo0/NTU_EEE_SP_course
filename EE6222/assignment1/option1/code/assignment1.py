import cv2
import numpy
import numpy as np
from skimage import morphology
import copy


#
# 2-step thining process
#
# define the neighbour of a pixel
#   P9 P2 P3
#   P8 P1 P4
#   P7 P6 P5
def find_neighbours(x, y, image):
    """
    Return 8-neighbours of point p1 of picture, in order
    """

    return [image[x - 1][y], image[x - 1][y + 1], image[x][y + 1], image[x + 1][y + 1],  # P2,P3,P4,P5
            image[x + 1][y], image[x + 1][y - 1], image[x][y - 1], image[x - 1][y - 1]]  # P6,P7,P8,P9


def freq(neighbours):
    """
    Return the frequency of 0-1 transitions
    """
    n = neighbours + neighbours[0:1]  # [P2, P3,... P9, P2]

    return sum((n1, n2) == (0, 1) for n1, n2 in zip(n, n[1:]))


def sum_neighbour(neighbours):
    """
    Return the sum of non-zero element in neighbour
    """
    count = 0
    for n in neighbours:
        if n == 1:
            count += 1
    return count


def thining(image):
    """
    repeat the 2-step thining until no element to remove
    """
    changing1 = changing2 = [(-1, -1)]  # initial statue
    while changing1 or changing2:
        # Step 1  flag the points to be remove
        changing1 = []
        for x in range(1, len(image) - 1):  # row
            for y in range(1, len(image[0]) - 1):  # col
                # Traverse the matric
                P2, P3, P4, P5, P6, P7, P8, P9 = n = find_neighbours(x, y, image)
                if (image[x][y] == 1 and  # (Condition 0 p1 == 1)
                        P4 & P6 & P8 == 0 and  # Condition 4
                        P2 & P4 & P6 == 0 and  # Condition 3
                        freq(n) == 1 and  # Condition 2
                        2 <= sum_neighbour(n) <= 6):  # Condition 1 non-zero>2&&non-zero<6
                    changing1.append((x, y))  # flag the remove_point
        # remove the flag point
        for x, y in changing1:
            image[x][y] = 0
        # Step 2  flag the points to be removed
        changing2 = []
        for x in range(1, len(image) - 1):
            for y in range(1, len(image[0]) - 1):
                P2, P3, P4, P5, P6, P7, P8, P9 = n = find_neighbours(x, y, image)
                if (image[x][y] == 1 and  # (Condition 0)
                        P2 & P6 & P8 == 0 and  # Condition 4
                        P2 & P4 & P8 == 0 and  # Condition 3
                        freq(n) == 1 and  # Condition 2
                        2 <= sum_neighbour(n) <= 6):  # Condition 1
                    changing2.append((x, y))
        # remove the point in step 2 until no point to be removed
        for x, y in changing2:
            image[x][y] = 0
        # repeat step1 and step2
        # print("c1: ", changing1)
        # print("c2", changing2)
    return image

def threshold(img,thres):
    for x in range(0, len(img)):
        for y in range(0, len(img[0])):
            if img[x][y] < thres:
                img[x][y]=0 #back
            else:
                img[x][y]=255  #white


def OTSU(gray):
    hist = cv2.calcHist([gray], [0], None, [256], [0, 256])  # 255*1的灰度直方图的数组
    gray_size = gray.size  # 图像像素数
    k = 0  # 初始化灰度阈值
    best_k = 0  # 最佳阈值
    best_M = 0  # 衡量阈值性

    p = []  # 灰度出现概率

    # for k in range(30,150):
    for i in range(len(hist)):
        p.insert(i, hist[i][0] / gray_size)  # 灰度集概率分布

    for k in range(30, 200):# k的可能范围
        u = 0  # 从1到k的累计出现概率的平均灰度级
        u_t = 0  # 从1到256的累计出现概率的平均灰度级
        σ2_0 = 0  # 类内方差
        σ2_1 = 0  # 类内方差
        σ2_t = 0  # 灰度级的总方差
        sum_0 = np.sum(hist[0:k + 1:], axis=0)

        sum_1 = np.sum(hist[k + 1:256:], axis=0)

        w_0 = np.sum(p[0:k + 1:])
        w_1 = np.sum(p[k + 1:256:])  # 各类的概率

        for i in range(k + 1):
            u = i * p[i] + u

        for i in range(len(hist)):
            u_t = i * p[i] + u_t

        u0 = u / w_0
        u1 = (u_t - u) / w_1  # 各类的平均灰度级

        for i in range(k + 1):
            σ2_0 = (p[i] / w_0) * np.square(i - u0) + σ2_0
        for i in range(k + 1, 256):
            σ2_1 = (p[i] / w_1) * np.square(i - u1) + σ2_1  # 两类的类内方差
        for i in range(256):
            σ2_t = p[i] * np.square(i - u_t) + σ2_t  # 总方差

        σ2_w = w_0 * σ2_0 + w_1 * σ2_1  # 类内方差
        σ2_b = w_0 * w_1 * np.square(u1 - u0)  # 类间方差

        M = σ2_b / σ2_t  # 衡量阈值k的好坏
        if M > best_M:
            best_M = M;
            best_k = k;
    return best_M, best_k


def mat_sum(x,y,img):

    num= img[x][y]
    #find_mat=[img[x-1][y-1],img[x-1][y],img[x-1][y+1],img[x][y-1],img[x][y+1],img[x+1][y-1],img[x+1][y],img[x+1][y+1]]
    find_mat = [ img[x - 1][y], img[x][y - 1], img[x][y + 1],
                img[x + 1][y]]
    if max(find_mat) <=img[x][y]:
        count =1
    else:
        count =0
    #count=np.count_nonzero(find_mat == num)

    return count
def medial_axis(image):
    distance_img=copy.deepcopy(image).astype(float)  #distance image
    transform_img = copy.deepcopy(image) #image after transform
    a=np.argwhere(image == 0) # boundary
    b=np.argwhere(image == 1)  # object
    '''
    DT
    '''
    for p in b:
        x=p[0]
        y=p[1]
        #dis_x =np.sqrt(np.sum(np.asarray(a- p) ** 2, axis=1))  #  nearest boudary
        dis_x = np.sqrt(np.sum(np.asarray(a[np.where(a[:,0] == x)] - p) ** 2, axis=1))  # nearest boudary
        dis_y = np.sqrt(np.sum(np.asarray(a[np.where(a[:,1] == y)] - p) ** 2, axis=1))
        if dis_x.size == 0 and dis_y.size == 0:
        #    transform_img[x][y] = 1
            continue
        elif dis_x.size ==0:
        #    transform_img[x][y] = 1
            nearset_nei =np.min(dis_y)
        elif dis_y.size == 0:
            nearset_nei = np.min(dis_x)
        else:
            nearset_nei=min(np.min(dis_x),np.min(dis_y))
        distance_img[x][y] = nearset_nei  #dis
    '''
        mat
    '''
    for p in b:
        x = p[0]
        y = p[1]
        dis = np.sqrt(np.sum(np.asarray(a - p) ** 2, axis=1))  # nearest boudary
        nearst_counts = np.sum(dis == distance_img[x][y])
        # nearst_counts +=np.sum(dis_y == nearset_nei)
        if nearst_counts > 1 or mat_sum(x,y,distance_img) == 1:
            transform_img[x][y] = 1
        else:
           # if mat_sum(x, y, distance_img) > 2:
           #     transform_img[x][y] = 1
           # else:
                transform_img[x][y] = 0

    return   transform_img.astype(int), distance_img



if __name__ == '__main__':

    #test_arry=np.array([[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]])
    test_arry = np.array(
        [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 1, 1, 1, 1, 1, 1, 1, 1, 0], [0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
         [0, 1, 1, 1, 1, 1, 1, 1, 1, 0], [0, 1, 1, 1, 1, 1, 1, 1,  1, 0],
         [0, 1, 1, 1, 1, 1, 1, 1, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])

    mat_img, distance = morphology.medial_axis(test_arry, return_distance=True)
    test_img, test_dis_img = medial_axis(test_arry)

    '''
    adaptive threshold to convert the image
    '''
    input_img = cv2.imread("./img6.bmp", 0)  # read the orgin image in grey
    _,thres=OTSU(input_img)
    #maximum_pixel = np.max(input_img)
    #minimum_pixel = np.min(input_img)
    #thres = minimum_pixel + (maximum_pixel - minimum_pixel) / 2  # adaptive threshold
    thres_img = copy.deepcopy(input_img)
    threshold(thres_img,thres)

    '''
        retain the image after threshold as background
        boundary is black 0
        poit is white 255
    '''
    background = copy.deepcopy(thres_img)
    background[background == 0] = 1
    background[background == 255] = 0
    background[background == 1] = 255
    '''
        ret, img2 = cv2.threshold(img1, thres, maximum_pixel,cv2.THRESH_BINARY)  # set threshold and change to 0-1 image; threshold(src, thresh, maxval, type, dst=None)
    
        process 2-step thinning
    '''
    thinning_img = copy.deepcopy(thres_img)
    mat_img = copy.deepcopy(thres_img)
    # 2-step thinning
    thinning_img[thinning_img == 0]= int(1) # point
    thinning_img[thinning_img == 255] = int(0) # boundary
    thining(thinning_img)
    thinning_img[thinning_img == 0] = 255  # boundary change to white
    thinning_img[thinning_img == 1] = 0  # point chage to black

    '''
        process mat thinning
    '''
    mat_img[mat_img == 0] = int(1)  # point
    mat_img[mat_img == 255] = int(0)  # boundary
    my_mat_img = copy.deepcopy(mat_img)
    '''
        official mat
    '''
    mat_img, distance = morphology.medial_axis(mat_img, return_distance=True)
    mat_img = distance * mat_img
    mat_img = mat_img.astype(np.uint8) * 255
    mat_img[mat_img > 0] = 1
    mat_img[mat_img == 0] = 255
    mat_img[mat_img == 1] = 0
    '''
        my mat function
    '''
    transform_img,distance_img = medial_axis(my_mat_img)
    transform_img=transform_img.astype(np.uint8)
    transform_img[transform_img == 0] = 255 # boundary
    transform_img[transform_img == 1] = 0   # point


    #
    # show the image
    #
    after_thining = thinning_img & background  # 255 white 0 black
    official_after_mat = mat_img & background
    my_after_mat= transform_img & background
    imags = np.hstack([input_img, thres_img])
    thin = np.hstack([thres_img,thinning_img,after_thining])
    o_mat = np.hstack([thres_img,mat_img,official_after_mat])
    my_mat = np.hstack([thres_img, transform_img, my_after_mat])
    cv2.namedWindow("threshod_image")
    cv2.namedWindow("thinning_image")
    cv2.namedWindow("o_mat_image")
    cv2.namedWindow("my_image")
    cv2.imshow("image", imags)
    cv2.imshow("thinning_image", thin)
    cv2.imshow("o_mat_image", o_mat)
    cv2.imshow("my_image", my_mat)

    cv2.waitKey(0)
