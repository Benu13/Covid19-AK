function blad = optcomp(param) % Dla 3 systemów
global base;
global compy;
global compz;
global Etype;

x=optcompfcn(param,base,compy,compz);

et=Etype;
switch et
    case '1'%liczenie ró¿nica kwadratów
        blad=sum((base-x).^2);
    case '2'%œrednia ró¿nica
        blad=sum(abs(base-x))/length(base);
    case '3'%maksymalna ró¿nica
        blad=max(abs(base-x));
    case '4'%ca³ka ró¿nicy
        blad=trapz(abs(base-x));
end