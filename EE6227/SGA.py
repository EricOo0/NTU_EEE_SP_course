import numpy as np
import math
import matplotlib.pyplot as plt
from matplotlib import animation
#绘制动画
def initialization(popsize,len_bits):
    #python 无 ;
#    numpy.random.rand(d0,d1,…dn)
#    以给定的形状创建一个数组，数组元素来符合标准正态分布N(0,1
#     初始化产生popsize个长度为len_bits的popn
    popn=1-(np.random.rand(popsize,len_bits)<0.5);#编码
    return popn;
def evaluate(popn,len_bits):
    #解码
    xpopn=decode(popn,len_bits)
    #计算fitness
    fitness=objfun(xpopn,len_bits)
    #计算均值
    meanf=np.sum(fitness)/popn.shape[0]
    maxf= np.max(fitness);
    imax=np.argmax(fitness)
    xopt = xpopn[0,imax]
    return [xpopn,fitness,xopt,maxf,meanf]
def decode(popn,len_bits):
    twopowers = np.power(2,[range(len_bits,0,-1)])# 2的0至len_bits-1次方
    xpopn =np.transpose(np.dot(popn,np.transpose(twopowers))) #矩阵乘法  np.transpose是转置   
    return xpopn

def objfun(xpopn,len_bits):
    # c=np.power(2,len_bits)-1
    # fitness = np.power((xpopn/c),10)
    fitness = -(xpopn**2)+10000
    return fitness

def reproduction(popn,fitness):
    #使用轮盘法
    normfit = fitness/np.sum(fitness);#计算比例
    normfit=normfit.T
    partsum = 0  
    randnum = np.random.rand(fitness.shape[1]);
    matepool=[]
    count=[0]
    select=[]
    matingpair=[]
    for i in range(1,fitness.shape[1]+1,1):
        partsum=partsum+normfit[i-1]#累计概率
        c=0
        for num in randnum :
            if(num < partsum):
                c=c+1  
        count.append(c)
        select.append(count[i]-count[i-1])#选择哪一个范围 
        # print(np.ones((1,select[i-1])))
        tem = np.multiply(np.ones((select[i-1],1)),popn[i-1])
        for i in range(0,tem.shape[0]):
            matepool.append(list(tem[i]))#交配池
            
    #配对池
    length=np.arange(0,np.array(matepool).shape[0])
    np.random.shuffle(length)
    for i in length:
        matingpair.append(matepool[i])
    return matingpair
def crossover(popn,pc):
    #one point crossover
    #probability is pc
    #只有一半重组  
    lbits=np.array(popn).shape[1]
    #ceil向上取整
    sites=np.ceil(np.random.rand(np.array(popn).shape[1]//2,1)*4)#交换点
    sites=np.multiply(sites,(np.random.rand(sites.shape[0],1)<pc))
    sites=sites.astype(int)
    offspring =np.array(popn)
    for i in range(0,sites.shape[0]):
        site= sites[i][0]   
        if(site !=0) :
            offspring[2*i][site:lbits]=popn[2*i+1][site:lbits]
            offspring[2*i+1][site:lbits]=popn[2*i][site:lbits]
    return offspring
def mutation(offspring,pm):
    mutate = np.random.rand(offspring.shape[0],offspring.shape[1])<pm
    newpopn=offspring
    for i in range(0,mutate.shape[0]):
        for j in range(0,mutate.shape[1]):
            if(mutate[i][j]):
                newpopn[i][j]=1-offspring[i][j];
    return newpopn
#def report():

if __name__ == "__main__":

    popnsize=5
    lbits=5
    pc=0.06
    pm=0.0333
    numgens=1000

    meanfhistory=[]
    maxfhistory=[]
    xopthistory=[]

    gen = 0
    popn = initialization(popnsize,lbits)
    [xpopn,fitness,xopt,maxf,meanf] = evaluate(popn,lbits)
    xopthistory.append(xopt)
    maxfhistory.append(maxf)
    meanfhistory.append(meanf)
    #report()
    for gen in range(1,numgens,1):
        matingpairs =reproduction(popn,fitness)
        offspring = crossover(matingpairs,pc)
        popn = mutation(offspring,pm)
        [xpopn,fitness,xopt,maxf,meanf] = evaluate(popn,lbits)
        xopthistory.append(xopt)
        print("gen   meanf   maxf   potimalx ")
        print(gen,meanf,maxf,xopt)
        # for i in range(0,len(xpopn)):
        #     x=np.linspace(0,2**lbits,5000)
        #     y = -x**2 +10000
        #     plt.plot(x,y)
        #     plt.plot(xpopn[i],fitness[i],"*")
        #     a.show()
        #     plt.pause(0.005)
        #     plt.close(a)
        maxfhistory.append(maxf)
        meanfhistory.append(meanf)
    
    
