function x = optfcn(param,base)
a=param;

x=zeros(length(base),1);
index = find(base); % pierwszy niezerowy element
x(1:index)=base(1:index);
for i=index:length(base)-1
    xk=zeros(length(a),1); %inicjujemy zerami
    k=1;
    for j=length(a)-1:-1:0
        if i-j>=1 %jeœli element istnieje to podmieñ
            xk(k)=x(i-j);
            k=k+1;
        end
    end
    x(i+1)=a*xk; % wyznacz nastêpny element
end