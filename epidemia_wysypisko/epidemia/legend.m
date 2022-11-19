function [image_rgb] = legend()
      image_rgb = zeros(400,200,1);
      for j = 1:400
          for i = 1:400
                    image_rgb(i,j,1) = 0;
                    image_rgb(i,j,2) = 255;
                    image_rgb(i,j,3) = 0; 
          end
          for i = 401:800
                    image_rgb(i,j,1) = 160;
                    image_rgb(i,j,2) = 160;
                    image_rgb(i,j,3) = 160; 
          end 
          for i = 801:1200
                    image_rgb(i,j,1) = 255;
                    image_rgb(i,j,2) = 51;
                    image_rgb(i,j,3) = 255;
          end
         for i = 1201:1600
                    image_rgb(i,j,1) = 0;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 255;    
         end 
     end
     for j = 401:800
         for i = 1:400
                    image_rgb(i,j,1) = 255;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 0; 
         end
         for i = 401:800
                    image_rgb(i,j,1) = 200;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 200;     
         end
        for i = 801:1200
                    image_rgb(i,j,1) = 255;
                    image_rgb(i,j,2) = 255;
                    image_rgb(i,j,3) = 255;
        end
        for i = 1201:1600
                    image_rgb(i,j,1) = 0;
                    image_rgb(i,j,2) = 0;
                    image_rgb(i,j,3) = 0;    
        end
     end
    
    image_rgb(:,:,:) = image_rgb(:,:,:)/255;     
    %state = ["healthy", "in_quarantine"; "infected", "sick"; "infected_and_sick", "in_hospital"; "recovered", "dead"];
    state = ["healthy", "infected_and_sick"; "in_quarantine","in_hospital"; "infected" , "recovered"; "sick", "dead"];
    for i=1:4
        for j=1:2
            if (j == 2 && i == 1)
                image_rgb = insertText(image_rgb,[400*j-350 400*i-225],state(i,j), 'FontSize', 30);
            else
            image_rgb = insertText(image_rgb,[400*j-300 400*i-250],state(i,j), 'FontSize', 40); 
            end
        end
    end  
    imshow(image_rgb);  
    imwrite(image_rgb, 'legend2.png');     
end