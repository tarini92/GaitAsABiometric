function [AFH] = createGaitSignature(mat_w, mat_h, total_rows, I, folderName, videoNum)

opticalFlow = vision.OpticalFlow('ReferenceFrameSource','Input port');
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
converter = vision.ImageDataTypeConverter;

% Declaring the cell for storing flow histograms
FH = cell(total_rows, 1);

j = 1;
while j < size(I, 1);
    imPrev = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\',folderName,'\output_test',num2str(videoNum),'_',num2str(I(j)),'.png'))));
    imCurr = im2double(rgb2gray(imread(strcat('C:\Users\Akanksha\Documents\MATLAB\',folderName,'\output_test',num2str(videoNum),'_', num2str(I(j+1)),'.png'))));
    of = step(opticalFlow, imPrev, imCurr);

    ofBBox = of(mat_h(j,1):mat_h(j, 2), mat_w(j, 1):mat_w(j,2));
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

    bins = 3600;

    Vec = [r,theta];

    fh = hist3(Vec, [10 360]);
    
    % Normalizing Histogram
    nh = fh / sum(fh);

    FH{j} = nh;
    j = j+1; 
end

% Histogram Matching
j =1;
fro_norm = zeros(total_rows,1);
while j< total_rows
    fro_norm(j, 1) = norm(FH{j}, 'fro');
    j = j+1;
end

mid = round(size(I,1)/2);
ref_fro_norm = fro_norm(mid);

diff_fro_norm = abs(fro_norm - ref_fro_norm);


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
