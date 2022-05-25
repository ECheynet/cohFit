function [d,indZ] = getDistance(z)
%  [d,indZ] = getDistance(z) get distance d between two locations and the
%  associated indices indZ. This functions can help to speed up the computation
%  of the co-coherence of turbulence by avoiding redundant pairs of
%  sensors.
%% Author info
%  E. Cheynet - UiB - last modified: 25-05-2022
%
% See also coh4Para cpsd pwelch coherence cohere targetCoh getDistance


Nm = numel(z);
indZ = zeros(Nm,Nm,2);
for ii=1:Nm
    for jj=1:Nm
        indZ(ii,jj,:) = [ii,jj];
    end
end
indZ = reshape(indZ,[],2);
d = triu(abs(z(:)-z(:)'));d = d(:);
k = find(d~=0);
d = d(k);
indZ = indZ(k,:);


end

