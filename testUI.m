%Test = @(hObj,event) disp ('I am in the callback function'); 

% create figure and panel on it
f = figure;
p = uipanel ("title", "Datos de la funcion de Transferencia","position",[.09,.15,1,.75]);

%Create labels
e1 = uicontrol (p, "style", "text", "string", "Ingrese valores de la funcion transferencia como polinomios o por ceros y raices","position",[20 250 480 40],"enable","inactive");
e1 = uicontrol (p, "style", "text", "string", "G(S) =","position",[80 165 80 40],"enable","inactive");
e1 = uicontrol (p, "style", "text", "string", "Ceros =","position",[80 80 80 40],"enable","inactive");
e1 = uicontrol (p, "style", "text", "string", "Polos =","position",[80 40 80 40],"enable","inactive");

%Creo los textbox para ingresar Numerador, Denominador y K
txtSalida = uicontrol (p, "style", "edit", "string", "S(S)","position",[220 185 200 40]);
txtEntrada = uicontrol (p, "style", "edit", "string", "E(S)", "position",[220 145 200 40]);
txtValorK = uicontrol (p, "style", "text", "string", "K", "position",[170 165 50 40]);

%Creo los textbox para ingresar Polos y Ceros
txtPolos = uicontrol (p, "style", "edit", "string", "Polos","position",[170 40 200 40]);
txtCeros = uicontrol (p, "style", "edit", "string", "Ceros", "position",[170 80 200 40]);

%Creo botones con opciones
btnTodasLasCaracteristicas = uicontrol (f, "style", "pushbutton", "string", "Obtener todas las caracteristicas", "position",[55 0 200 40],'callback',{@mycallback,"1"});
btnObtenerFuncionTransferencia = uicontrol (f, "style", "pushbutton", "string", "Obtener funcion G(S)", "position",[55 -40 200 40], 'callback', {@obtenerFTranf, txtPolos, txtCeros, txtEntrada, txtSalida, txtValorK});
btnIndicarPolos = uicontrol (f, "style", "pushbutton", "string", "Polos", "position",[55 -120 200 40],'callback',{@funcionPolosCeros,txtEntrada,txtPolos});
btnIndicarCeros = uicontrol (f, "style", "pushbutton", "string", "Ceros", "position",[55 -80 200 40],'callback',{@funcionPolosCeros,txtSalida,txtCeros});
btnGanancia = uicontrol (f, "style", "pushbutton", "string", "Ganancia", "position",[55 -160 200 40],'callback',{@calcularGanancia,txtPolos,txtCeros,txtSalida,txtEntrada,lblGanancia});
bntEstabilidad = uicontrol (f, "style", "pushbutton", "string", "Estabilidad", "position",[55 -200 200 40]);
btnBorrarTodo = uicontrol (f, "style", "pushbutton", "string", "Borrar todo", "position",[410 0 200 40],'callback',{@mycallback2,txtPolos,txtCeros});
btnFinalizar = uicontrol (f, "style", "pushbutton", "string", "Finalizar", "position",[410 -40 200 40]);

%Creo salida para la ganancia
lblGanancia = uicontrol (f, "style", "text", "string", "", "position",[270 -160 200 40]);

function calcularGanancia (hsrc, evt,polos,ceros,salida,entrada,ganancia)
  vecC = str2num(get(ceros,'string'));
  vecP = str2num(get(polos,'string'));
  
  %Si no vinieron o los polos o los ceros, la calculo por entrada y salida
  if (isnull(vecC) | isnull(vecP))
      polinomioEntrada = leerPoly(entrada);
      polinomioSalida = leerPoly(salida);
      funcTrans = tf(polinomioSalida,polinomioEntrada);
  else
      funcTrans = zpk(vecC,vecP,1);     
  endif
  
  [ceros,polos,ganancia] = zpkdata(funcTrans);
  set(ganancia, 'string',strcat("La ganancia es de ",num2str(ganancia)));

endfunction

function funcionPolosCeros (hsrc, evt,S_E,P_C)
  polinomio = leerPoly(S_E);
  raices = roots(polinomio);
  set(P_C, 'string',num2str(raices));
endfunction

function coefs = leerPoly (entrada)
  textoPoly = strsplit(get(entrada,'string'));
  elementos = numel(textoPoly);
  i = 1;
  coefs = [];
  negativo = false;
  
  while (i <= elementos)
    coef = strtok(textoPoly{i}, "*");
    
    if (strcmp(coef,"-"))
      negativo = true;
    elseif(strcmp(coef,"+"))
      negativo = false;
    else
      if (negativo)
        coefs(end+1) = -str2num(coef);
      else
        coefs(end+1) = str2num(coef);
      endif
    endif
    
    i++;
  endwhile
  return
endfunction

function obtenerFTranf (hsrc, evt,polos,ceros,entrada,salida,k)
  vecC = str2num(get(ceros,'string'));
  vecP = str2num(get(polos,'string'));
  g = zpk(vecC,vecP,1);
  set(salida,'string',(polyout(cell2mat(g.num))));
  set(entrada,'string',(polyout(cell2mat(g.den))));
  set(k,'string',"1");
endfunction

function mycallback2 (hsrc, evt,polos,ceros)
  texto = get(polos,'string');
  set(ceros, 'string',texto)
  disp (texto); 
endfunction

function mycallback (hsrc, evt,number)
  disp (number); 
endfunction
