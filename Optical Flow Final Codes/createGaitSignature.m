function [AFH] = createGaitSignature(mat_w, mat_h, total_rows, I, folderName, videoNum)
opticalFlow = vision.OpticalFlow('ReferenceFrameSource','Input port');
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
converter = vision.ImageDataTypeConverter;
% FIFTH VIDEO- Video No 11

% Bounding Box Matrix
%mat_w = [150 220; 170 240; 190 240; 190 250; 190 260; 200 270; 260 310; 270 310; 270 310; 270 320; 280 320; 290 330; 300 340; 280 350; 280 360; 290 370; 300 370; 310 380; 320 390; 340 400; 350 400; 360 410; 360 410; 350 400; 350 400; 340 400; 330 400; 340 400; 360 420; 360 420; 360 430; 370 440; 390 450; 400 460; 400 460; 400 460; 400 460; 390 470; 400 470; 400 470; 410 480; 410 490; 410 490; 420 510; 410 505; 420 510; 430 510; 440 510; 460 520; 470 530; 470 530; 480 530; 490 560; 490 570; 500 580; 500 590; 500 600; 520 605; 520 610; 530 610; 560 610; 570 620; 560 620; 560 620; 560 630; 570 640; 580 650; 580 660; 600 660; 600 670; 590 670; 600 680; 600 680; 610 700; 610 700; 610 710; 630 720];
%mat_h = [160 355; 155 360; 155 355; 155 360; 160 360; 170 355; 160 360; 160 360; 160 360; 160 355; 160 350; 160 350; 160 350; 170 350; 175 355; 175 360; 175 360; 175 350; 160 350; 155 350; 155 350; 150 350; 145 350; 150 350; 145 350; 145 345; 150 350; 150 350; 155 350; 155 360; 160 350; 155 350; 155 355; 150 350; 150 355; 150 355; 145 350; 150 350; 150 355; 150 350; 150 345; 145 345; 150 350; 150 350; 155 350; 155 350; 150 350; 150 350; 150 345; 150 350; 150 355; 145 350; 150 360; 150 375; 160 375; 160 360; 155 360; 150 350; 150 345; 145 345; 145 355; 150 360; 145 360; 145 360; 140 360; 145 370; 145 370; 150 355; 150 355; 150 360; 155 365; 155 360; 155 350; 150 355; 145 355; 145 360; 145 360];

% Declaring the cell for storing flow histograms
FH = cell(total_rows, 1);

j = 1;
%I = [30; 34; 35; 41; 44; 47; 57; 58; 59; 61; 62; 65; 66; 67; 68; 69; 70; 71; 72; 73; 75; 76; 77; 78; 79; 80; 81; 82; 84; 85; 86; 87; 89; 90; 91; 92; 93; 94; 95; 96; 97; 98; 100; 101; 102; 103; 104; 105; 106; 107; 108; 109; 114; 116; 118; 119; 20; 121; 122; 123; 124; 125; 126; 127; 129; 130; 131; 132; 133; 134; 135; 136; 137; 138; 139; 140; 141];
%disp(size(I,1));
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\',folderName,'\output_test',num2str(videoNum),'_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\',folderName,'\output_test',num2str(videoNum),'_', num2str(I(j+1)),'.png'))));
    %disp(j);
    of = step(opticalFlow, imPrev, imCurr);
    %disp(matrix(j,1));
    %disp(matrix(j,2));
    %disp(size(of));
    ofBBox = of(mat_h(j,1):mat_h(j, 2), mat_w(j, 1):mat_w(j,2));
    %disp(ofBBox(1,1));
    rV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);
    iV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);

    k=1;
    for p=1:(mat_h(j,2) - mat_h(j,1))
        for q=1:(mat_w(j,2)-mat_w(j,1))
            rV(k,1) = real(ofBBox(p,q));
            iV(k,1) = imag(ofBBox(p,q));
            k = k+1;
        end
    end

    [theta, r] =  cart2pol(rV, iV);
    %[minR, in1] = min(r);
    %disp(minR);
    %[maxR, in2] = max(r);
    %disp(maxR);
    %[minTheta, in3] = min(theta);
    %disp(minTheta);
    %[maxTheta, in4] = max(theta);
    %disp(maxTheta);

    bins = 3600;

    Vec = [r,theta];
    %disp(Vec);

    fh = hist3(Vec, [10 360]);
    
    % Normalizing Histogram
    nh = fh / sum(fh);
    %bar(nh, 'r', 'theta
    %plot(nh);
    %view(3);

    %disp(fh);
    
    FH{j} = nh;

    %nfh = histogram(Vec, 360,  'Normalization', 'probability');
    %%plot(nfh);
    %view(3);
    
    j = j+1; 
end

%disp(FH1{1});
%disp(FH1{2});

% Histogram Matching
j =1;
fro_norm = zeros(total_rows,1);
while j< total_rows
    fro_norm(j, 1) = norm(FH{j}, 'fro');
    j = j+1;
end

%disp(fro_norm1);
mid = round(size(I,1)/2);
ref_fro_norm = fro_norm(mid);

diff_fro_norm = abs(fro_norm - ref_fro_norm);

%disp(diff_fro_norm1);

j=1;
diff1 = diff_fro_norm(1);
firstMin =0;
while j < total_rows
    if (diff_fro_norm(j) < diff1) && (j ~= mid) 
        diff1 = diff_fro_norm(j);
        firstMin = j; 
    end
    
    j = j+1;
end

j=1;
diff2 = diff_fro_norm(1);
secondMin =0;
while j < total_rows
    if (diff_fro_norm(j) < diff2) && (j ~= mid) && (diff_fro_norm(j) ~= diff1)
        diff2 = diff_fro_norm(j);
        secondMin = j; 
    end
    j = j+1;
end


%disp(diff1);
%disp(diff2);
%disp(firstMin);
%disp(secondMin);


% Computing Average Flow Histogram
var = firstMin > secondMin;
in1 =0;
in2=0;
if var
    in1 = secondMin;
    in2 = firstMin;
else
    in1 = firstMin;
    in2 = secondMin;
end

AFH = FH{in1};
for i=in1+1:in2
    AFH = AFH + sum(FH{i}(:));
end

AFH = AFH/(in2-in1);

%disp(AFH);
