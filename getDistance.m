function [d,indZ] = getDistance(z)

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

