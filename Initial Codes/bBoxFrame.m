opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
i=11;
while i<51
    im = imread(strcat('test23_', num2str(i), '.jpg'));
    fm = figure;
    bb = regionprops(im,'BoundingBox');
    bbMatrix = vertcat(bb(:).BoundingBox);
    %disp(bbMatrix);
    %disp('Break here!');
    [r, c] = size(bbMatrix);
    aRatio = 0;
    dim = [0, 0, 0, 0];
    for j=1:r
        pos = bbMatrix(j, :);
        temp = pos(4)/pos(3);
        if(temp > aRatio)
            aRatio = temp;
            dim = pos;
        end
    end
    disp(strcat('Frame', num2str(i)));
    disp(dim);
    %imshow(im);
    %hold on;
    rectangle('Position',dim,'EdgeColor', 'r','LineWidth', 3,'LineStyle','-');
    out = getframe(fm);
    filename = strcat('C:\Users\Akanksha\Documents\MATLAB\test23BBox\output_test23_.jpg',num2str(i),'.png');
    %imwrite(out.cdata, filename);

    i = i+1;
end