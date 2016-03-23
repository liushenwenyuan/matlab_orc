function varargout = szsb(varargin)
% SZSB M-file for szsb.fig
%      SZSB, by itself, creates a new SZSB or raises the existing
%      singleton*.
%
%      H = SZSB returns the handle to a new SZSB or the handle to
%      the existing singleton*.
%
%      SZSB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SZSB.M with the given input arguments.
%
%      SZSB('Property','Value',...) creates a new SZSB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before szsb_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to szsb_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help szsb

% Last Modified by GUIDE v2.5 23-Feb-2010 11:23:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @szsb_OpeningFcn, ...
                   'gui_OutputFcn',  @szsb_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before szsb is made visible.
function szsb_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to szsb (see VARARGIN)

% Choose default command line output for szsb
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes szsb wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = szsb_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
clear all;
global im
global p1
global p5
global p3
global p4
global bw
global bw1
global bw2
global n
global t1
global i3
global i4
global i2
global b
global gray
filename=0;
[filename,pathname]=...
        uigetfile({'*.bmp'},'请选择图片');
 str=[pathname filename];
 l=length(filename);
 if l==1
     return;
 end
 test=filename(1,l-2:l);
 if test=='bmp'
 else 
     msgbox('请选择bmp文件','错误');
     return;
 end
im=imread(str);
imshow(im);
if(length(size(im))==3)
       gray = rgb2gray(im); %图像灰度化
end
p1=zeros(16,16); 
bw=im2bw(im,0.9); %图像二值化
[l,r]=size(bw);
i4=bw;
    for i=1:l
        for j=1:r
            if i4(i,j)==0
                i4(i,j)=1;
            else
                i4(i,j)=0;
            end
        end
    end
i2 = bwmorph(i4,'majority','inf');%图像细化
i3=i2;
[i,j]=find(i3==1);
imin=min(i);
imax=max(i);
jmin=min(j);
jmax=max(j);
lab=false;%lab 用作是否进入一个字符分割的标志
k=1;
for j = jmin:jmax+1
    if (max(size(find(i3(imin:imax,j)==1)))-1)==0 %在第j列中没有找到像素为1（白点）的点
        if lab==true;
            t1(1,k)=j-1;  %t1的第一行偶数记录分割数字的右边界
            k=k+1;
            lab=false;
        end     

    else%在第j列中存在像素为1（白点）的点
        if lab==false
            lab=true;
            t1(1,k)=j; %t1的第一行奇数记录分割数字的左边界
            k=k+1;
        end
    end
end
n=max(size(t1))/2;%m为待识别数字的个数
for i=1:n   
    j=2*i;
    for k=imin:imax%由上到下寻找上边界
         if (max(size(find(i3(k,t1(1,j-1):t1(1,j))==1)))-1)>0% 在对应的列中找到了分割数字的上边界
             t1(2,j-1)=k;  %t1的第二行奇数列分别记录分割数字的上边界
             break;
         end
             
    end
end
    
for i=1:n   
    j=2*i;
    for k=imax:-1:imin%由下到上寻找下边界
         if (max(size(find(i3(k,t1(1,j-1):t1(1,j))==1)))-1)>0% 在对应的列中找到了分割数字的下边界
             t1(2,j)=k;  %t1的第二行偶数列分别记录分割数字的下边界
             break;
         end
             
    end
end
    p4=zeros(l,r);
    p5=zeros(l,r);
    load numbernet net;
for i=1:n
        j=2*i;
        bw1=i3(t1(2,j-1):t1(2,j),t1(1,j-1):t1(1,j)); 
        p1=zeros(16,16);
        rate=16/max(size(bw1));
        bw1=imresize(bw1,rate);
        [z,x]=size(bw1);
        i1=round((16-z)/2);
        j1=round((16-x)/2);
        p1(i1+1:i1+z,j1+1:j1+x)=bw1;        
        p4(t1(2,j)-15:t1(2,j),t1(1,j-1):t1(1,j-1)+15)=p1;      
        p1 = bwmorph(p1,'thin',inf);
        p5(t1(2,j)-15:t1(2,j),t1(1,j-1):t1(1,j-1)+15)=p1;       
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


       
        [a,Pf,Af]=sim(net,p);
       
        a=round(a) ;
        b(1,i)=a(1,1)*8+a(2,1)*4+a(3,1)*2+a(4,1);
end
 b=num2str(b);

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf)
% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bw
axes(handles.axes1);
    imshow(bw);

% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i4
axes(handles.axes1);
imshow(i4)

% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i3
axes(handles.axes1);
imshow(i3)

% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global n
global t1
global i3
axes(handles.axes1);
imshow(i3)
hold on 
for i=1:n
    j=2*i;
    plot([t1(1,j-1),t1(1,j)],[t1(2,j-1),t1(2,j-1)],'red');
    plot([t1(1,j-1),t1(1,j)],[t1(2,j),t1(2,j)],'red');
    plot([t1(1,j-1),t1(1,j-1)],[t1(2,j-1),t1(2,j)],'red');
    plot([t1(1,j),t1(1,j)],[t1(2,j-1),t1(2,j)],'red');
end

hold off
% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p4
global n
global t1
axes(handles.axes1);
imshow(p4)
hold on 
for i=1:n
    j=2*i;  
    plot([t1(1,j-1),t1(1,j-1)+15],[t1(2,j)-15,t1(2,j)-15],'blue');
    plot([t1(1,j-1),t1(1,j-1)+15],[t1(2,j),t1(2,j)],'blue');
    plot([t1(1,j-1),t1(1,j-1)],[t1(2,j)-15,t1(2,j)],'blue');
    plot([t1(1,j-1)+15,t1(1,j-1)+15],[t1(2,j)-15,t1(2,j)],'blue');
end
hold off
% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global p5
global n
global t1

axes(handles.axes1);
imshow(p5);
    hold on 
for i=1:n
    j=2*i;  
    plot([t1(1,j-1),t1(1,j-1)+15],[t1(2,j)-15,t1(2,j)-15],'green');
    plot([t1(1,j-1),t1(1,j-1)+15],[t1(2,j),t1(2,j)],'green');
    plot([t1(1,j-1),t1(1,j-1)],[t1(2,j)-15,t1(2,j)],'green');
    plot([t1(1,j-1)+15,t1(1,j-1)+15],[t1(2,j)-15,t1(2,j)],'green');
end
hold off
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox('数字识别系统v1.0版 作者：温源','数字识别系统');


% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_14_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global n
global b
set(handles.edit3,'string',n);
set(handles.edit4,'string',b);
% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)








function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --------------------------------------------------------------------
function Untitled_16_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gray
axes(handles.axes1);
imshow(gray);
