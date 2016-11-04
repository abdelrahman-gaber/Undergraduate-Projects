% ------------------------------ loading images in X matrix
clear all; clc; %clear workspace and command window
load('ex7faces.mat');
fprintf('\nSize of X : %d * %d\n',size(X,1), size(X,2))
[nImages, nFeatures] = size(X);
% ------------------------------ normalizing images (z score = (x - u)/SD)
mu = mean(X); 
sigma = std(X);
X = X - (ones(5000,1) * mu  );
%X = X ./(ones(5000,1) *sigma);
% ------------------------------ plotting sample of faces
figure(1);
subplot(1,2,1) % second subplot
displayData(X(1:36,:)); % sample size = 36
% ------------------------------ 
covariance = (1/(nImages-1))*(X')*(X);  %calculate the covariance matrix of X (mean of each column=0)

[U, S] = eig(covariance); %U = eigen vectors of covariance , S = eigen values of covariance (in diagonal matrix)
S = diag(S);         %get the eigen values from diagonal of S
%---- sort the variances in decreasing order
[dummy,new_indices] = sort(S,'descend');   
S = S(new_indices);     
U = U(:,new_indices);

%Visualize the top 36 eigenvectors found [the new basis]
%{
figure(2);
displayData(U(:, 1:36)');    %print sample of the principle components
%}
%------------------------------- 
% pick smallest value of K satisfying the requested (variance reatined)
prompt = '\nEnter the percentage of the variance to retain : ';
variance_retained = input(prompt);  %reading variance_retained value from User

for K=1:1024
    VR = sum(S(1:K)) / sum(S);    %calculate the variance retained
    if(VR >= variance_retained)   break; end
end

fprintf('\nNumber of principal components retained = %d\n',K);
fprintf('\nCompression Ratio = %f\n',K/1024);
% ------------------------------ Project images R^1024 on R^k space 
Z = X * U(:, 1:K);
% ------------------------------ recover images [to be able to visualize Z]
X_recovered = Z * U(:, 1:K)';

figure(1);
subplot(1,2,2) % second subplot
displayData(X_recovered(1:36,:));
%--------------------------------