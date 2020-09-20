clear all;
close all;

digits(128);
[s,fs]=audioread('pista_01.wav');

v = wgn(1,length(s),0.1);

u = filter([0.8 , 0.2 , -0.1],1,v);


for i = 1 : length(s)
 x(i) = s(i) + v(i);
end 

M = [1,2,3,4,5,6];
%%Calculo de las matrices de autocorrelacion dependiendo de M

for i = 1 : length(M)    
    aux_sum = zeros(M(i));
    for k = M(i) : length(u)-1    
        aux_sum = aux_sum + (flip (u(k-M(i)+1:k)')*flip (u(k-M(i)+1:k))) ;
        %aux_sum = aux_sum/(length(u)-M(i));
        
    end
    auto_correlation{M(i)} = aux_sum;
end

%%Calculo del vector de correlacion cruzada

for i = 1 : length(M)    
    aux_sum = zeros(M(i),1);
    for k = M(i) : length(u)-1    
        aux_sum = aux_sum + (flip (u(k-M(i)+1:k)'))*x(k) ; %% NO SE SI DE d(n) EN LA FORMULA ES x(n)
        %aux_sum = aux_sum/(length(u)-M(i));
    end
    vector_correlation{M(i)} = aux_sum;
end

%%Calculo los coeficientes del filtro de Wiener (CREO QUE ES ASI)
for i = 1 : length(M)    
    
    wiener_coefficients{M(i)} = inv(auto_correlation{M(i)})*vector_correlation{M(i)};
end
