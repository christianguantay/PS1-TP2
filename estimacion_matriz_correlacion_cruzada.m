function p = estimacion_matriz_correlacion_cruzada(M,u,v)
  
  N = length(u);
  p = zeros(M,1);
  
  for k = M : N-1    
    a = (flip (u(k-M+1:k)));
    p = p + a*v(k);
  endfor
  
  p = p/(N-M);
endfunction