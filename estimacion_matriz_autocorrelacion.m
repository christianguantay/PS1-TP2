function R = estimacion_matriz_autocorrelacion(M,u)
  
  N = length(u);
  R = zeros(M);
  for k = M:N-1
    a = flip (u(k-M+1:k));
    R = R + a * a';
  endfor
  
  R = R/(N-M);
  
endfunction
