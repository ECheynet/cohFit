function [cohU] = targetCoh(U,d,f,z,c,type,varargin)

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


Nm = numel(d);
Nf = numel(f);

if strcmpi(type,'Davenport')
    c(2:3) = 0;
elseif  strcmpi(type,'Bowen')
    c(3) = 0;    
end

cohU = zeros(Nm,Nf);
for pp = 1:Nm
    A = c(1).*f;
    B = c(3);
    F1 = exp(-sqrt(A.^2+B.^2).*d(pp)./U(pp));
    F2 = exp(-c(2).*f.*d(pp).^2./(U(pp).*z(pp)));
    cohU(pp,:) = F1.*F2.*cos(2.*pi.*dx(pp).*f./U(pp));
end

end