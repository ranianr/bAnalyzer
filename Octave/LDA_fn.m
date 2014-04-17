function  [Z, V]  = LDA_fn(c,X, ClassLabels)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Applying LDA (Linear Discriminant Analysis)  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Classes = [];
    Classes_Mu = [];
    %create the data in X with corresponding classes in c
        

    %Get Classes
    for L = 1: length(ClassLabels)
  	Class_temp = X(find(c == ClassLabels(L)),:);
	Classes_Mu = [Classes_Mu; mean(Class_temp)];
	Classes = [Classes; Class_temp];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Finding the projection matrix  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Finding the between and within-classes scatter matrices is easy for our two classes example:
        Maxclass = max(c);
        mu_total = mean(X);
        %mu = [ mean(c1); mean(c2) ];
        Sw = (X - Classes_Mu(c,:))'*(X - Classes_Mu(c,:));
        Sb = (ones(Maxclass,1) * mu_total - Classes_Mu)' * (ones(Maxclass,1) * mu_total - Classes_Mu);

    %The General Eigenvalue problem is now solved by simply doing
        [V, D] = eig(Sw\Sb);
    
    % sort eigenvectors desc
        [D, ss] = sort(diag(D), 'descend');
        V = real(V(:,ss)); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Projection and Reconstruction  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %First shift the data to the new center
        %Xm = bsxfun(@minus, X, mu_total);
    
    %then calculate the projection and reconstruction
	Z = X*real(V);    
end
