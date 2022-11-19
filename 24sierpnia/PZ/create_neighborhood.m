function [neighborhood] = create_neighborhood(i,j,dim,pop)
%     funkcja tworzaca sasiedztwo, jesli punkt jest na brzegu, to dokleja z
%     wartosci wziete z drugiej strony
%     i = 1; j = 2;
%     dim = 3;
%     pop = [1 2 3; 4 5 6; 7 8 9];
    neighborhood = ones(3,3);
    if (i == 1 && j == 1)
        neighborhood(1,1) = pop(dim,dim);
        neighborhood(1,2:3) = pop(dim,1:2);
        neighborhood(2:3,1) = pop(1:2,dim);
        neighborhood(2:3,2:3) = pop(1:2,1:2);
    elseif (i == 1 && j > 1 && j < dim)
        neighborhood(1,j-1:j+1) = pop(dim,j-1:j+1);
        neighborhood(2:3,1:3) = pop(1:2,j-1:j+1);
    elseif (i == 1 && j == dim)
        neighborhood(1,1:2) = pop(dim,j-1:j);
        neighborhood(1,3) = pop(dim,1);
        neighborhood(2:3,1:2) = pop(1:2,j-1:j);
        neighborhood(2:3,3) = pop(1:2,1);
    elseif (i > 1 && i < dim && j == dim)
        neighborhood(:,1:2) = pop(i-1:i+1,j-1:j);
        neighborhood(:,3) = pop(i-1:i+1,1);
    elseif (i == dim && j == dim)
        neighborhood(1:2,1:2) = pop(i-1:i,j-1:j);
        neighborhood(1:2,3) = pop(i-1:i,1);
        neighborhood(3,1:2) = pop(1,j-1:j);  
        neighborhood(3,3) = pop(1,1);
    elseif (i == dim && j > 1 && j < dim)
        neighborhood(1:2,:) = pop(i-1:i,j-1:j+1);
        neighborhood(3,:) = pop(1,j-1:j+1);
    elseif (i == dim && j == 1)
        neighborhood(1:2,1) = pop(i-1:i,dim);
        neighborhood(1:2,2:3) = pop(i-1:i,1:2);
        neighborhood(3,1) = pop(1,dim);  
        neighborhood(3,2:3) = pop(1,1:2);        
    elseif (i > 1 && i < dim && j == 1)
        neighborhood(:,1) = pop(i-1:i+1,dim);
        neighborhood(:,2:3) = pop(i-1:i+1,1:2);
    else
        neighborhood(:,:) = pop(i-1:i+1,j-1:j+1);
    end
end