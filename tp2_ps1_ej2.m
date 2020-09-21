clear all;
close all;
clc;

blue = [0, 0.4470, 0.7410];
orange = [0.8500, 0.3250, 0.0980];

%% Se carga el archivo de audio
[s,fs]=audioread('pista_01.wav');
sigma = sqrt(0.1);

%% Se crea el vector de ruido blanco gaussiano de media nula y varianza 0.1
v = wgn(1,length(s), -10)';

%% Se filtra v para obtener u, señal del micrófono 2
u = filter([0.8 , 0.2 , -0.1],1,v);

%% Señal del micrófono 1
x = s + v;

M = [1,2,3,4,5,6];
%% Cálculo de las matrices de autocorrelacion dependiendo de M

for i = 1 : length(M)
    R = estimacion_matriz_autocorrelacion(M(i),u);
    auto_correlation{M(i)} = R;
end

%% Cálculo del vector de correlacion cruzada

for i = 1 : length(M)
    p = estimacion_matriz_correlacion_cruzada(M(i),u,x);
    vector_correlation{M(i)} = p;
end

%% Cálculo los coeficientes del filtro de Wiener
for i = 1 : length(M)    
    wiener_coefficients{M(i)} = inv(auto_correlation{M(i)})*vector_correlation{M(i)};
end

%% Cálculo de y sombrero
 for l = 1 : length(M)
    y_hat{M(l)} = filter(wiener_coefficients{M(l)},1,u); 
 end
 
%% Cálculo e(n), señal de salida
for k = 1:length(M)
    for n = 1 : length(x)
        e{M(k)}(n) = x(n) - y_hat{M(k)}(n);
    end 
end

%% Cálculo Jmin
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

audiowrite('pista_01_noiseTP2.wav',x,fs);

audiowrite('pista_01_cleanedTP2M1.wav',e{1},fs);
audiowrite('pista_01_cleanedTP2M2.wav',e{2},fs);
audiowrite('pista_01_cleanedTP2M3.wav',e{3},fs);
audiowrite('pista_01_cleanedTP2M4.wav',e{4},fs);
audiowrite('pista_01_cleanedTP2M5.wav',e{5},fs);
audiowrite('pista_01_cleanedTP2M6.wav',e{6},fs);
