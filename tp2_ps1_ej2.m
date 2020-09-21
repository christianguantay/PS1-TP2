clear all;
close all;

blue = [0, 0.4470, 0.7410];
orange = [0.8500, 0.3250, 0.0980];


[s,fs]=audioread('pista_01.wav');


v = wgn(1,length(s), -10);

u = filter([0.8 , 0.2 , -0.1],1,v);


for i = 1 : length(s)
 x(i) = s(i) + v(i);
end 

M = [1,2,3,4,5,6];
%% Calculo de las matrices de autocorrelacion dependiendo de M

for i = 1 : length(M)    
    aux_sum = zeros(M(i));
    for k = M(i) : length(u)-1    
        aux_sum = aux_sum + (flip (u(k-M(i)+1:k)')*flip (u(k-M(i)+1:k))) ;
        %
    end
    aux_sum = aux_sum/(length(u)-M(i));
    auto_correlation{M(i)} = aux_sum;
end

%% Calculo del vector de correlacion cruzada

for i = 1 : length(M)    
    aux_sum = zeros(M(i),1);
    for k = M(i) : length(u)-1    
        aux_sum = aux_sum + (flip (u(k-M(i)+1:k)'))*x(k) ; %% NO SE SI DE d(n) EN LA FORMULA ES x(n)
        
    end
    aux_sum = aux_sum/(length(u)-M(i));
    vector_correlation{M(i)} = aux_sum;
end

%% Calculo los coeficientes del filtro de Wiener (CREO QUE ES ASI)
for i = 1 : length(M)    
    wiener_coefficients{M(i)} = inv(auto_correlation{M(i)})*vector_correlation{M(i)};
end

%% Calculo de y sombrero
 for l = 1 : length(M)
    y_hat{M(l)} = filter(wiener_coefficients{M(l)},1,u); 
 end
 
%% Calculo e(n)
for k = 1:length(M)
    for n = 1 : length(x)
        e{M(k)}(n) = x(n) - y_hat{M(k)}(n);
    end 
end

%% Calculo Jmin
for k = 1:length(M) 
    Jmin(k) = e{M(k)}* (e{M(k)}');
    Jmin(k) = Jmin(k)/length(s);
end
Js = s' * s;
Js = Js/length(s);

%% Graficos
figure(4);
scatter(M,Jmin,'filled');
grid on
xlim([0 6])
title('Potencia de error')
xlabel('Cantidad de muestras')
ylabel('Magnitud')

%% Audios
audiowrite('pista_01_noiseTP2.wav',x,fs);

audiowrite('pista_01_cleanedTP2M1.wav',e{1},fs);
audiowrite('pista_01_cleanedTP2M2.wav',e{2},fs);
audiowrite('pista_01_cleanedTP2M3.wav',e{3},fs);
audiowrite('pista_01_cleanedTP2M4.wav',e{4},fs);
audiowrite('pista_01_cleanedTP2M5.wav',e{5},fs);
audiowrite('pista_01_cleanedTP2M6.wav',e{6},fs);
