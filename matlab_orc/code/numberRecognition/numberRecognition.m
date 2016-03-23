% 数字识别

% 生成输入向量和目标向量
clear all;
'LOADING......'
filename =dir('nums\*.bmp');
for kk = 0:99
    p1=zeros(16,16);  %建立全为1的样本矩阵   
    m=strcat('nums\',filename(kk+1).name);
    x=imread(m,'bmp');  %循环读入0-99个样本数字文件 
    if(length(size(x))==3)
        x = rgb2gray(x); %将图像转灰度
    end
%     figure,imshow(x);title('原始黑白图像');
     bw=im2bw(x,0.5);
%      grd=edge(x,'canny');%用canny算子识别强度图像中的边界
%      figure,imshow(grd);
[l,r]=size(bw);
bw1=bw;
    for i=1:l
        for j=1:r
            if bw1(i,j)==0
                bw1(i,j)=1;
            else
                bw1(i,j)=0;
            end
        end
    end
    %figure,imshow(bw1);
    [i,j]=find(bw1==1);
    imin=min(i);
    imax=max(i);
    jmin=min(j);
    jmax=max(j);
    bw2=bw1(imin:imax,jmin:jmax);  %截取是入图像中的数字部分
    %figure,imshow(bw2);
    rate=16/max(size(bw2));
    bw2=imresize(bw2,rate);  %对输入文件变尺寸处理
    [i,j]=size(bw2);
    i1=round((16-i)/2);
    j1=round((16-j)/2);
    p1(i1+1:i1+i,j1+1:j1+j)=bw2;  %建立起16*16的矩阵
    %figure,imshow(p1);
   
    
    p1 = bwmorph(p1,'thin',inf);%图像细化
%     figure,imshow(p1);
           
             for m=0:15
                if(0<=m&&m<=3)
                    mm=(m+1)*4;
                    p(m+1,kk+1)=length(find(p1(1:4,mm-3:mm)==1));%第一到第四块方格内像素值为1的总数
                end
                if(4<=m&&m<=7)
                    mm=(m-3)*4;
                    p(m+1,kk+1)=length(find(p1(5:8,mm-3:mm)==1));%第五到第八块方格内像素值为1的总数
                end
                 if(8<=m&&m<=11)
                    mm=(m-7)*4;
                    p(m+1,kk+1)=length(find(p1(9:12,mm-3:mm)==1));%第九到第十二块方格内像素值为1的总数
                 end
                 if(12<=m&&m<=15)
                    mm=(m-11)*4;
                    p(m+1,kk+1)=length(find(p1(13:16,mm-3:mm)==1));%第十三到十六块方格内像素值为1的总数
                 end
             end
        p(17,kk+1)=length(find(p1(4 ,1:16)==1));%第四行线上像素值为1的总数
        p(18,kk+1)=length(find(p1(8 ,1:16)==1));%第八行线上像素值为1的总数
        p(19,kk+1)=length(find(p1(12,1:16)==1));%第十二行线上像素值为1的总数
        p(20,kk+1)=length(find(p1(1:16, 4)==1));%第四列线上像素值为1的总数
        p(21,kk+1)=length(find(p1(1:16, 8)==1));%第八列线上像素值为1的总数
        p(22,kk+1)=length(find(p1(1:16,12)==1));%第十二列线上像素值为1的总数
        s1=0;
        for zz=1:16
            xx=17-zz;
            s1=p1(zz,xx)+s1;
            p(23,kk+1)=s1;%y=x线上像素值为1的总数
        end
        s2=0;
        for zz=1:16
            s2=p1(zz,zz)+s2;
            p(24,kk+1)=s2;%y=-x线上像素值为1的总数
        end
       
        
    
   %将处理的源样本输入供神经网络训练的样本   pcolum是样本数循环变量 
 

    switch kk
        case{0,1,2,3,4,5,6,7,8,9}
            t(1:4,kk+1)=[0.01,0.01,0.01,0.01];   %数字0 
        case{10,11,12,13,14,15,16,17,18,19}
            t(1:4,kk+1)=[0.01,0.01,0.01,0.99];   %数字1    
        case{20,21,22,23,24,25,26,27,28,29}
            t(1:4,kk+1)=[0.01,0.01,0.99,0.01];   %数字2 
        case{30,31,32,33,34,35,36,37,38,39}
            t(1:4,kk+1)=[0.01,0.01,0.99,0.99];   %数字3 
        case{40,41,42,43,44,45,46,47,48,49}
            t(1:4,kk+1)=[0.01,0.99,0.01,0.01];   %数字4 
        case{50,51,52,53,54,55,56,57,58,59}
            t(1:4,kk+1)=[0.01,0.99,0.01,0.99];   %数字5 
        case{60,61,62,63,64,65,66,67,68,69}
            t(1:4,kk+1)=[0.01,0.99,0.99,0.01];   %数字6 
        case{70,71,72,73,74,75,76,77,78,79}
            t(1:4,kk+1)=[0.01,0.99,0.99,0.99];   %数字7 
        case{80,81,82,83,84,85,86,87,88,89}
            t(1:4,kk+1)=[0.99,0.01,0.01,0.01];   %数字8 
        case{90,91,92,93,94,95,96,97,98,99}
            t(1:4,kk+1)=[0.99,0.01,0.01,0.99];   %数字9 
    end
end     %建立与训练样本对应的输出值t 

'LOAD OK.'

save numberPT p t;
% 创建和训练BP网络

clear all;
load numberPT p t;   %加载样本 


%创建BP网络 
net=newff(minmax(p),[14 4],{'logsig' 'purelin'}, 'traingdx', 'learngdm'); 
%  当前输入层权值和阈值 
inputWeights=net.IW{1,1} 
inputbias=net.b{1} 
%  当前网络层权值和阈值 
layerWeights=net.LW{2,1}   
layerbias=net.b{2} 
net.trainParam.epochs=25000;  %设置训练步数 
net.trainParam.goal=0.001;   %设置训练目标 
net.trainParam.show=10;      %设置训练显示格数 
net.trainParam.lr=0.05;      %设置训练学习率 w
[net,tr]=train(net,p,t);          %训练BP网络   

'TRAIN OK.'

save numbernet net;

% 识别
for times=0:99
    clear all;
    p1=ones(16,16);
    load numbernet net;
    test=input('FileName:', 's');
    x=imread(test,'bmp');
    bw=im2bw(x,0.5);
    [i,j]=find(bw==0);
    imin=min(i);
    imax=max(i);
    jmin=min(j);
    jmax=max(j);
    bw1=bw(imin:imax,jmin:jmax);  %截取是入图像中的数字部分
    rate=16/max(size(bw1));
    bw1=imresize(bw1,rate);  %对输入文件变尺寸处理
    [i,j]=size(bw1);
    i1=round((16-i)/2);
    j1=round((16-j)/2);
    p1(i1+1:i1+i,j1+1:j1+j)=bw1;  %建立起16*16的矩阵
    p1=-1.*p1+ones(16,16);%反色处理
    p1 = bwmorph(p1,'thin',inf);
          
         for m=0:15
            if(0<=m&&m<=3)
                mm=(m+1)*4;
                p(m+1,1)=length(find(p1(1:4,mm-3:mm)==1));
            end
            if(4<=m&&m<=7)
                mm=(m-3)*4;
                p(m+1,1)=length(find(p1(5:8,mm-3:mm)==1));
            end
             if(8<=m&&m<=11)
                mm=(m-7)*4;
                p(m+1,1)=length(find(p1(9:12,mm-3:mm)==1));
             end
             if(12<=m&&m<=15)
                mm=(m-11)*4;
                p(m+1,1)=length(find(p1(13:16,mm-3:mm)==1));
             end
         end
        p(17,1)=length(find(p1(4 ,1:16)==1));
        p(18,1)=length(find(p1(8 ,1:16)==1));
        p(19,1)=length(find(p1(12,1:16)==1));
        p(20,1)=length(find(p1(1:16, 4)==1));
        p(21,1)=length(find(p1(1:16, 8)==1));
        p(22,1)=length(find(p1(1:16,12)==1));
        s1=0;
        for zz=1:16
            xx=17-zz;
            s1=p1(zz,xx)+s1;
            p(23,1)=s1;
        end
        s2=0;
        for zz=1:16
            s2=p1(zz,zz)+s2;
            p(24,1)=s2;
        end
       
        
  
    [a,Pf,Af]=sim(net,p);   %测试网络 
    imshow(p1);
    a=round(a);
    a=a(1,1)*8+a(2,1)*4+a(3,1)*2+a(4,1)%输出网络识别结果 
end
