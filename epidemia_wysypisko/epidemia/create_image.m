function [image_rgb] = create_image(pop)
        % 1 - healty - zielony
        % 2 - in_quarantine - szary
        % 3 - infected - pomaranczowy
        % 4 - sick - niebieski
        % 5 - infected_and_sick - czerwony
        % 6 - in_hospital - fioletowy
        % 7 - recovered - bialy 
        % 8 - dead - czarny
        image_rgb = zeros(length(pop),length(pop),3);
    for i = 1:length(pop)
        for j = 1:length(pop)
            switch pop(i,j)
                case 1
                    image_rgb(i,j,1) = 0;
                    image_rgb(i,j,2) = 255;
                    image_rgb(i,j,3) = 0;   
                case 2
                    image_rgb(i,j,1) = 160;
                    image_rgb(i,j,2) = 160;
                    image_rgb(i,j,3) = 160;  
                case 3
                    image_rgb(i,j,1) = 255;
                    image_rgb(i,j,2) = 51;
                    image_rgb(i,j,3) = 255;                    
                case 4
                    image_rgb(i,j,1) = 0;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 255;       
                case 5
                    image_rgb(i,j,1) = 255;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 0;                    
                case 6
                    image_rgb(i,j,1) = 200;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 200;                 
                case 7
                    image_rgb(i,j,1) = 255;
                    image_rgb(i,j,2) = 255;
                    image_rgb(i,j,3) = 255;
                case 8
                    image_rgb(i,j,1) = 0;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 0;      
            end
        end
    end
    image_rgb(:,:,:) = image_rgb(:,:,:)/255;
end
