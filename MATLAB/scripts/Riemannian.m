clearvars

load ./EpochData.mat

%
% X <- C x N
% C : Ch
% N : Time
%

X = Average.Data;

P1 = mean(X{2},3);

Nc = size(X,2);
for l = 1:Nc
    [C,N,I] = size(X{l});
    for m = 1:I
        Xb{l}(:,:,m) = [P1; X{l}(:,:,m)];
    end
end

for l=1:Nc
    [C,N,I] = size(X{l});
    for m = 1:I
        Sb{l}(:,:,m) = (1/(N-1))*(Xb{l}(:,:,m)*Xb{l}(:,:,m)');
    end
end

% Geometric Mean M of K SPD matricies
% Sb = Ck

MaxIteration = 50;

for Class = 1:Nc
    K = size(Sb{Class},3);
    
    %Initialize M
    M{Class} = mean(Sb{Class},3);
    
    %tmp = M{Class}
    for It = 1:MaxIteration
        rM = sqrtm(M{Class}); % root M
        nrM = 1./rM;    % negative root M
        
        % Calculate sigma[ln(M^-1/2 * Ck * M^-1/2)]
        tmp = 0;
        for k = 1:K
            tmp = tmp + lnm(nrM*Sb{Class}(:,:,k)*nrM);
            %return
        end
        % Calculate Frobenius norm of sigma[ln(M^-1/2 * Ck * M^-1/2)]
        J = norm(tmp);
        
        M{Class} = rM*expm((1./K)*tmp)*nrM;
        
        fprintf("Iteration : %d, Cost : %d\n",It,J);
        
    end
    
end

function res = lnm(C)
    [vec,lam] = eig(C);
    lam = logm(lam);
    res = vec*lam*vec';
end

function res = expm(C)
    [vec,lam] = eig(C);
    lam = expm(lam);
    res = vec*lam*vec';
end