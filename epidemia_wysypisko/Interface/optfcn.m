function x = optfcn(param,base)
a=param;

x=zeros(length(base),1);
index = find(base); % pierwszy niezerowy element
x(1:index)=base(1:index);
for i=index:length(base)-1
    xk=zeros(length(a),1); %inicjujemy zerami
    k=1;
    for j=length(a)-1:-1:0
        if i-j>=1 %je�li element istnieje to podmie�
            xk(k)=x(i-j);
            k=k+1;
        end
    end
    x(i+1)=a*xk; % wyznacz nast�pny element
end