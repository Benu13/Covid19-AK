function blad = optcomp(param) % Dla 3 system�w
global base;
global compy;
global compz;
global Etype;

x=optcompfcn(param,base,compy,compz);

et=Etype;
switch et
    case '1'%liczenie r�nica kwadrat�w
        blad=sum((base-x).^2);
    case '2'%�rednia r�nica
        blad=sum(abs(base-x))/length(base);
    case '3'%maksymalna r�nica
        blad=max(abs(base-x));
    case '4'%ca�ka r�nicy
        blad=trapz(abs(base-x));
end