%img = imread('C:\Users\Akanksha\Documents\MATLAB\test45BBox\output_test45_106.png');
%imagesc(img);

load('trainingData.mat', 'trainData', 'labels');

% Fitting the KNN Model
model = fitcknn(trainData, labels, 'NumNeighbors',10, 'Standardize', 1);
cvknn = crossval(model);
classError = kfoldLoss(cvknn);
disp(classError);

% Fitting the Multi Class SVM Model
t = templateSVM('Standardize',1);
svmModel = fitcecoc(trainData, labels, 'Learners', t);
cvSvm = crossval(svmModel);
oosLoss = kfoldLoss(cvSvm);
disp(oosLoss);

% Fitting the Multinomial Logistic Regression Model
lrModel = fitctree(trainData, labels);
cvLr = crossval(lrModel);
loss = kfoldLoss(cvLr);
disp(loss);

% Fitting Discriminatory Model
DiscrMdl = fitcdiscr(trainData, labels);
cvDiscr = crossval(DiscrMdl);
loss = kfoldLoss(cvDiscr);
disp(loss);

% Fitting Generalized Logistic Regression Model
glr = fitcdiscr(trainData, labels);
cvGlr = crossval(glr);
loss = kfoldLoss(cvGlr);
disp(loss);
   

    
