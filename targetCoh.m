function [cohU] = targetCoh(U,d,f,z,c,type,varargin)
% [cohU] = targetCoh(U,d,f,z,c,type,varargin) computes the coherence from
% three empirical models (Davenport, Bowen or modified Bowen model
% 'Bowen2'). This function is only used to illustrate the function cohFit.m
%
%% Author info
%  E. Cheynet - UiB - last modified: 25-05-2022
%
% See also coh4Para cpsd pwelch coherence cohere targetCoh getDistance

%% Inputparseer
p = inputParser();
p.CaseSensitive = false;
p.addOptional('dx',[]);
p.parse(varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%
dx = p.Results.dx; % maximal height taken by default as equal to 200 m
if isempty(dx)
    dx = zeros(size(d));
end
%%
% the Davenport model  uses only the first element of the  vector c
% the Bowen model  use  only the first two elements of the  vector c
% the modified Bowen model  uses  the three elements of the  vector c

if strcmpi(type,'Davenport')
    c(2:3) = 0; 
elseif  strcmpi(type,'Bowen')
    c(3) = 0;    
end


%% Loop over each separation distance
Nm = numel(d);
Nf = numel(f);
cohU = zeros(Nm,Nf);
for pp = 1:Nm
    A = c(1).*f;
    B = c(3);
    F1 = exp(-sqrt(A.^2+B.^2).*d(pp)./U(pp));
    F2 = exp(-c(2).*f.*d(pp).^2./(U(pp).*z(pp)));
    cohU(pp,:) = F1.*F2.*cos(2.*pi.*dx(pp).*f./U(pp));
end

end