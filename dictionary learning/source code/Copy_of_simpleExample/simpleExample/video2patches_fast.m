% the constant blocks are NOT removed (in contrary to image2patches).
% Avoid the double loop that scans all the patches for speeding. Use only one
% loop. (This accelerate 5 times the funciton.)
% 2009.10.23

function M_patches = video2patches_fast(im, n1, n2, delta1, delta2, nPatch)
% Transfer an image to patches of size n1 x n2. The patches are sampled
% from the images with a translating distance delta1 x delta2. The patch sampling
% starts from (i1, j1) and ends at (i2, j2).
% 
%
% Guoshen Yu, 2009.09.30

[N1, N2, N3] = size(im);

if ( N1 > 65535 ) || ( N2 > 65535 ) 
    error('The image size should be smaller than 65535 x 65535');
end

% the coordinates of the top-left point in all the patches are computed and
% stored in (XstartI, YstartI). XstartI or YstartI is a vector of length
% #patches. 
Xstart = uint16(1 : delta1 : N1 - n1 + 1);
Ystart = uint16(1 : delta2 : N2 - n2 + 1);
[YstartI, XstartI] = meshgrid(Ystart, Xstart);
YstartI = YstartI(:);
XstartI = XstartI(:);

n1_minus1 = n1 - 1;
n2_minus1 = n2 - 1;

% use (one-layer) loop to extract the patches. This loop is inevitable in
% the reconstruction phase (patches2image) because we need to add the
% patches and accumulate the weight. 
num_patches = length(XstartI);
if nargin < 6
    M_patches = zeros(n1*n2*N3, num_patches);
    % for m = 1:N3
    for k = 1 : num_patches
        patch1 = im(XstartI(k):XstartI(k)+n1_minus1, YstartI(k):YstartI(k)+n2_minus1,:);
        M_patches(:, k) = patch1(:);
    %     M_patches((m-1)*n1*n2+(1:n1*n2), k) = patch1(:);
    end
    % end
else
    pInd = randperm(num_patches, nPatch);
    M_patches = zeros(n1*n2*N3, nPatch);
    for ki = 1 : nPatch
        k = pInd(ki);
        patch1 = im(XstartI(k):XstartI(k)+n1_minus1, YstartI(k):YstartI(k)+n2_minus1,:);
        M_patches(:, ki) = patch1(:);
    end
end
