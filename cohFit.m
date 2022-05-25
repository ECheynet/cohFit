function [CoeffFit,modelFun,mse] = cohFit(d,f,coh,guess,meanU,varargin)
% [CoeffFit,modelFun,varargout] = cohFit(d,f,coh,guess,meanU,varargin) fits
% empirical models of the co-coherence to the one estimated from
% measurements or simulations. 
%% Synthax
% Input
%	* d: double  [M x 1]: vector separation distance 
%	* freq: double [1 x Nfreq]: vector frequency
%	* coh: double  [M x Nfreq]: matrix of co-coherence estimates
%	* guess: double  [1x Ncoeff]: Initial values of the coefficients
%	* meanU: double  [M x 1]: vector of averaged (mean) wind speed beteween sensors
%   * varargin
%       - freqThres: double [1x1]: maximal frequency for the fitting
%       - dispIter, lb,ub,tolX,tolFun: parameters specific to lsqcurvefit
%       - cohModel: string: type of co-coherence model
%       - z: double  [M x 1]: vector of average height between the sensors
%       if needed. Otherwise, it is set to NaN by default.
%       - dx: : double [M x 1]: vector of longitudinal separation distance 
%       if needed. Otherwise, it is set to zero by default.
%       - s: [1x1] eddy slopes if needed [1]
% 
%  Output
%	* CoeffFit: double  [1x Ncoeff]: Fitted coefficients
%   * modelFun: anonymous function of the fitted co-coherence model
%   * modelFun:  double  [1x 1]: mean square error to evaluate the quality
%   of the fit
%% References
%  [1]  Bowen, A. J., R. G. J. Flay, and H. A. Panofsky. 
% "Vertical coherence and phase delay between wind components in strong 
% winds below 20 m." Boundary-Layer Meteorology 26.4 (1983): 313-324.
%
%% Example
% clearvars;close all;clc;
% z = [10 20 30 50 100]; 
% U = log(z./0.03); 
% Nm = numel(z);
% [d,indZ] = getDistance(z);
% meanZ = zeros(size(indZ,1),1);
% meanU = zeros(size(indZ,1),1);
% for ii=1:size(indZ,1)
%     meanZ(ii) = 0.5.*(z(indZ(ii,1))+z(indZ(ii,2))');
%     meanU(ii) = 0.5.*(U(indZ(ii,1))+U(indZ(ii,2))');
% end
% f = logspace(log10(1/600),log10(1),100);
% C = [7 0 0]; % Davenport model
% cohType = 'Davenport';
% [cohU] = targetCoh(meanU,d,f,meanZ,C,cohType);
% guess = 5;
% [CoeffFit,modelFun] = cohFit(d,f,cohU,guess,meanU,'freqThres',0.2);
% 
%
%% Author info
%  E. Cheynet - UiB - last modified: 25-05-2022
%
% See also coh4Para cpsd pwelch coherence cohere targetCoh getDistance

%% Inputparser
p = inputParser();
p.CaseSensitive = false;
p.addOptional('freqThres',0.1);
p.addOptional('dispIter','off');
p.addOptional('ub',[]); % uper boundary
p.addOptional('lb',[]); % lower boundary
p.addOptional('tolX',1e-6);
p.addOptional('tolFun',1e-6);
p.addOptional('cohModel','Davenport');
p.addOptional('z',[]);
p.addOptional('dx',[]);
p.addOptional('s',0);
p.parse(varargin{:});
% shorthen the variables name
freqThres =  p.Results.freqThres ;
tolX = p.Results.tolX ;
tolFun = p.Results.tolFun ;
dispIter = p.Results.dispIter ;
cohModel = p.Results.cohModel;
z = p.Results.z;
ub = p.Results.ub;
lb = p.Results.lb;
s = p.Results.s; % eddy slope
dx = p.Results.dx; % eddy slope

options=optimset('TolX',tolX,'TolFun',tolFun,'Display',dispIter);


%% Preprocessing

% check d
% if and(size(d) == size(d'),numel(d(:))>1),
%     warning('d is given as a square matrix. I use only the unique values in d ');
%     d = unique(d(:))';
% end
Nyy = numel(d);


% Check numel U vs numel d
if numel(meanU)>numel(d)
    error(' numel(U)>numel(d). It is a non-sense. Check the input for possible error');
end
% check f
if min(size(f))>1
    fprintf(['freq is ',num2str(size(f,1)),' by ',num2str(size(f,2)),'\n'])
    error('Error: y should be [1 x Nfreq], not a matrix')
else
    f = f(:)';
    Nfreq =length(f);
end

% check guess
if min(size(guess))>1,    error('Error: ''guess'' should be a scala or a vector'); end
if numel(guess)>4 || numel(guess) < 1 , error(' I need to have 0 < numel(guess) < 5'); end
Ncoeff = numel(guess);
if Ncoeff>1 && (isempty(cohModel) || strcmpi(cohModel,'Davenport')==1),
    guess = guess(1);
    Ncoeff = numel(guess);
end
% check dimension of coh
if size(coh,2)==Nyy && size(coh,1)==Nfreq,
    coh = coh';
elseif size(coh,1)~=Nfreq && size(coh,2)~=Nfreq
    error(' The size of ''coh'' is not compatibale with the dimension of ''f'' ');
elseif size(coh,1)~=Nyy && size(coh,2)~=Nyy
    error(' The size of ''coh'' is not compatibale with the dimension of ''d'' ');
end


assert(license('test','Curve_Fitting_Toolbox')==1,'The cohFit function requires Matlab''s Curve Fitting Toolbox.')
%% Curve fitting
indMinF = find(f<=freqThres); % fit up to threshold

newCoh = coh(:,indMinF);
[F,D] = meshgrid(f(indMinF),d);
% D= newD(:);%distance is now [ Nyy x Nfreq, 1]
% F= newF(:);%frequency is now [Nyy x Nfreq, 1]
D = D(:);
F = F(:);

newCoh = newCoh(:);

[modelFun,lb,ub] = chooseModel(cohModel,Ncoeff,lb,ub);


if numel(meanU)==1,   meanU = repmat(meanU,[1,numel(d)]);end

[~,U] = meshgrid(f(indMinF),meanU);
U = abs(U(:));

% If no info on height z
if ~isempty(z),
    if numel(z)==sqrt(numel(d)),   z = (z(:)+z(:)')/2;end
    [~, Z] = meshgrid(f(indMinF),z);
    Z = Z(:);
    Z(isnan(newCoh),:)=[];
else 
    Z = nan(size(D));
end

% if no info on along-wind distance dx
if ~isempty(dx)
    [~, DX] = meshgrid(f(indMinF),dx);
    DX = DX(:);
    DX(isnan(newCoh),:)=[];
else 
    DX = zeros(size(D));
end


F(isnan(newCoh),:)=[];
D(isnan(newCoh),:)=[];
U(isnan(newCoh),:)=[];
newCoh(isnan(newCoh))=[];
    

if (strcmpi(cohModel,'2para_slope')) || strcmpi(cohModel,'Bowen2_slope')
    [CoeffFit,mse] = lsqcurvefit(@(C,F) modelFun(C,F,D,Z,U,DX,s),guess,F,newCoh,lb,ub,options);
else
    [CoeffFit,mse] = lsqcurvefit(@(C,F) modelFun(C,F,D,Z,U,DX),guess,F,newCoh,lb,ub,options);
end


% if nargout==3,            varargout{1}=mse;        end



    function [modelFun,lb,ub] = chooseModel(cohModel,Ncoeff,lb,ub)
        if strcmpi(cohModel,'Bowen')
            modelFun = @ (C,F,D,Z,U,DX) exp(-F.*C(1).*D./(U)).*exp(-F.*C(2).*D.^2./(U.*Z)).*cos(2.*pi.*F.*DX./U);
            if isempty(lb), lb = zeros(1,Ncoeff); end
            if isempty(ub), ub = [50 50]; end
        elseif strcmpi(cohModel,'Bowen2')
            modelFun = @ (C,F,D,Z,U,DX) exp(-(sqrt((C(1).*F).^2+C(3).^2).*D./U)).*exp(-F.*C(2).*D.^2./(U.*Z)).*cos(2.*pi.*F.*DX./U);
            if isempty(lb), lb = zeros(1,Ncoeff); end
            if isempty(ub),  ub = [50 50 10]; end
        elseif strcmpi(cohModel,'Bowen2_slope')
            modelFun = @ (C,F,D,Z,U,DX,s) exp(-(sqrt((C(1).*F).^2+C(3).^2).*D./U)).*exp(-F.*C(2).*D.^2./(U.*Z)).*cos((s*D./Z).*(2*pi*F.*D./U)).*cos(2.*pi.*F.*DX./U);
            if isempty(lb), lb = zeros(1,Ncoeff); end
            if isempty(ub),  ub = [50 50 10]; end            
        elseif strcmpi(cohModel,'Davenport')
            modelFun = @(C,F,D,Z,U,DX) exp(-C(1).*F.*D./U).*cos(2.*pi.*F.*DX./U);
            if isempty(lb), lb = zeros(1,Ncoeff); end
            if isempty(ub), ub = 60; end
        elseif strcmpi(cohModel,'2para')
            if Ncoeff~=2,                error(' You have choosen ''2para'' coherence model, but ''guess'' is not a 2x1 or 1x2 vector');            end
            if isempty(lb), lb = zeros(1,Ncoeff); end
            if isempty(ub), ub = [50 1]; end
            modelFun = @(C,F,D,Z,U,DX) exp(-D./U.*sqrt((C(1).*F).^2+C(2).^2)).*cos(2.*pi.*F.*DX./U);     
        end
    end
end

