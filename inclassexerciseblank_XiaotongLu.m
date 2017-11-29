% GB comments
Step1 0 No code or files of separately saved images
Step2 100
Step3 100 
Step4 100
Step5 100
Step6 100 
Step7 100 
Step8 100
Overall 88

%% step 1: write a few lines of code or use FIJI to separately save the
% nuclear channel of the image Colony1.tif for segmentation in Ilastik

%% step 2: train a classifier on the nuclei
% try to get the get nuclei completely but separe them where you can
% save as both simple segmentation and probabilities

segfilename='D:\48hColony1_DAPI.tif';
img=h5read(segfilename,'/exported_data');


%% step 3: use h5read to read your Ilastik simple segmentation
% and display the binary masks produced by Ilastik 
segfilename='C:\users\win\Documents\inclass15_3.h5';
img=h5read(segfilename,'/exported_data');
img=squeeze(img==1);
imshow(img);


% (datasetname = '/exported_data')
% Ilastik has the image transposed relative to matlab
% values are integers corresponding to segmentation classes you defined,
% figure out which value corresponds to nuclei

%% step 3.1: show segmentation as overlay on raw data
segfilename='C:\users\win\Documents\inclass15_3.h5';
img=h5read(segfilename,'/exported_data');
img=squeeze(img==1);
I=imread('D:\48hColony1_DAPI.tif');
overlayimg=cat(3,imadjust(I),img,zeros(size(I)));
imshow(overlayimg,[])

%% step 4: visualize the connected components using label2rgb
% probably a lot of nuclei will be connected into large objects
label_img= label2rgb(img,'jet','k');
imshow(label_img,[]);


%% step 5: use h5read to read your Ilastik probabilities and visualize

% it will have a channel for each segmentation class you defined
segfilename2='C:\users\win\Desktop\predict.h5';
segfile2=h5read(segfilename2,'/exported_data/');
segfile2=squeeze(segfile2(1,:,:));
imshow(segfile2);


%% step 6: threshold probabilities to separate nuclei better
seg_thre=segfile2>0.5;
imshow(seg_thre,[])

%% step 7: watershed to fill in the original segmentation (~hysteresis threshold)
img_bw=img>0.9;
imshow(img_bw,[])
D=bwdist(~img_bw);
D=-D;
D(~img_bw)=-Inf;
L=watershed(D);
L(~img_bw)=0;
label_img2=label2rgb(L,'jet',[.5 .5 .5]);
figure;
imshow(label_img2,'InitialMagnification','fit');
%% step 8: perform hysteresis thresholding in Ilastik and compare the results
% explain the differences
In this case, hysteresis thresholding in Ilastik is better at separating nuclei than watershed in matlab
as Ilastik is better at recognizing the cell edge.

%% step 9: clean up the results more if you have time 
% using bwmorph, imopen, imclose etc
label_img2_open=imopen(label_img2,strel('disk', 5));
imshow(label_img2_open,[]);


label_img2_morph=bwmorph(L,'remove');
imshow(label_img2_morph);

label_img2_close = imclose(label_img2,strel('disk', 5));
imshow(label_img2_close,[]);
