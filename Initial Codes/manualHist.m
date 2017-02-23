opticalFlow = vision.OpticalFlow('ReferenceFrameSource','Input port');
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
converter = vision.ImageDataTypeConverter;
imPrev = im2double(rgb2gray(imread('C:\Users\Akanksha\Documents\MATLAB\test23BBox\output_test23_.jpg12.png')));
imCurr = im2double(rgb2gray(imread('C:\Users\Akanksha\Documents\MATLAB\test23BBox\output_test23_.jpg13.png')));

of = step(opticalFlow, imPrev, imCurr);
disp(size(of));
disp(size(imPrev));
%imagesc(imPrev);
%disp(of(130:230,150:350));
ofBBox = of(130:230,150:350);
%disp(ofBBox(1,1));
rV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);
iV = zeros((size(ofBBox,1)*size(ofBBox,2)), 1);

k=1;
for i=1:101
    for j=1:201
        rV(k,1) = real(ofBBox(i,j));
        iV(k,1) = imag(ofBBox(i,j));
        k = k+1;
    end
end

[theta, r] =  cart2pol(rV, iV);
[minR, in1] = min(r);
%disp(minR);
[maxR, in2] = max(r);
%disp(maxR);
[minTheta, in3] = min(theta);
%disp(minTheta);
[maxTheta, in4] = max(theta);
%disp(maxTheta);

bins = 3600;

Vec = [r,theta];
%disp(Vec);

fh = hist3(Vec, [10 360]);

% Normalizing Histogram
nh = fh / sum(fh);
bar(nh, 'rho', 'theta');
view(3);


%nfh = histogram(Vec, 360,  'Normalization', 'probability');
%%plot(nfh);
%view(3);


