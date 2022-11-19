close all; clear all;
knee = double(imread("knee.png"));
[size_x, size_y] = size(knee);
visited = zeros(size(knee));
segmented = zeros(size(knee));
stack = create_stack();

figure(1)
hold on
imshow(knee,[]);
hold off
title('Obraz oryginalny');
[a,b] = ginput(1);
y_start = round(a);
x_start = round(b);

close all
stack=stack.push(stack,[x_start y_start]);
segmented(x_start,y_start) = 1;
n = 1;
mn = 0;

figure(2);
hold on;
while ~isempty(stack.stack)
    [stack, coor] = stack.pop(stack);
    mn = (mn*(n-1)+knee(coor(1),coor(2)))/n;
    for x = coor(1)-1:coor(1)+1
        if x > 0 && x <= size_x
            for y = coor(2)-1:coor(2)+1
                if y > 0 && y <= size_y
                    if visited(x,y) == 0
                        if (abs(knee(x,y)-mn) <= 48)
                            segmented(x,y) = 1;
                            stack=stack.push(stack,[x y]);
                        end
                    end
                    visited(x,y) = 1;
                end
            end
        end 
    end
    n=n+1;
    if mod(n,5000) == 0
        imshow(segmented)
        drawnow 
    end       
end

mask = fspecial('gaussian', 10);
imshow(imfilter(segmented, mask));
hold off
%%
function stack = create_stack()
stack.stack = [];
stack.push = @push;
stack.pop = @pop;


function stack = push(stack, x)
    stack.stack = [stack.stack; x];
end

function [stack,x] = pop(stack, x)
    x = stack.stack(end,:);
    stack.stack(end,:) = [];
end
end