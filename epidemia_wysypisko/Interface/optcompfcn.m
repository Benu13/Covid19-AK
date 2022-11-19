function [x]=optcompfcn(param,base,compy,compz)
global options;
switch options
case 1  %1 z 2
    a=param(1,:);
    b=param(2,:);
    c=zeros(1,length(a));
case 2 % 1 z 3
    a=param(1,:);
    b=zeros(1,length(a));
    c=param(2,:);
case 3 % 1 z 2 i 3
    a=param(1,:);
    b=param(2,:);
    c=param(3,:);
end

x=zeros(length(base),1);
index = find(base); % pierwszy niezerowy element
x(1:index)=base(1:index);
for i=index:length(base)-1 
    xk=zeros(length(a),1);  %inicjujemy zerami
    yk=zeros(length(b),1);
    zk=zeros(length(c),1);
    k=1;
    for j=length(a)-1:-1:0
        if i-j>=1   %jeœli element istnieje to podmieñ
            xk(k)=x(i-j);
            yk(k)=compy(i-j);
            zk(k)=compz(i-j);
            k=k+1;
        end
    end
    x(i+1)=a*xk+b*yk+c*zk; % wyznacz nastêpny element
end