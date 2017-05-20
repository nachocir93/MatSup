%Test = @(hObj,event) disp ('I am in the callback function'); 

% create figure and panel on it
f = figure;
p = uipanel ("title", "Datos de la funcion de Transferencia","position",[.09,.15,1,.75]);

%Create labels
e1 = uicontrol (p, "style", "text", "string", "Ingrese valores de la funcion trasnferencia como polinomios o por ceros y raices","position",[20 250 480 40],"enable","inactive");
e1 = uicontrol (p, "style", "text", "string", "G(S) =","position",[80 165 80 40],"enable","inactive");
e1 = uicontrol (p, "style", "text", "string", "Ceros =","position",[80 80 80 40],"enable","inactive");
e1 = uicontrol (p, "style", "text", "string", "Polos =","position",[80 40 80 40],"enable","inactive");

% Creo los textbox para ingresar Numerador, Denominador y K
txtSalida = uicontrol (p, "style", "edit", "string", "S(S)","position",[220 185 200 40]);
txtEntrada = uicontrol (p, "style", "edit", "string", "E(S)", "position",[220 145 200 40]);
txtValorK = uicontrol (p, "style", "edit", "string", "K", "position",[170 165 50 40]);

%Creo los textbox para ingresar Polos y Ceros
txtPolos = uicontrol (p, "style", "edit", "string", "Polos","position",[170 40 200 40]);
txtCeros = uicontrol (p, "style", "edit", "string", "Ceros", "position",[170 80 200 40]);

% create a button (default style)
btnTodasLasCaracteristicas = uicontrol (f, "style", "pushbutton", "string", "Obtener todas las caracteristicas", "position",[55 0 200 40],'callback',{@mycallback,"1"});
btnObtenerFuncionTransferencia = uicontrol (f, "style", "pushbutton", "string", "Obtener funcion G(S)", "position",[55 -40 200 40], 'callback', {@obtenerFTranf, txtPolos, txtCeros, txtEntrada, txtSalida, txtValorK});
btnIndicarPolos = uicontrol (f, "style", "pushbutton", "string", "Polos", "position",[55 -120 200 40]);
btnIndicarCeros = uicontrol (f, "style", "pushbutton", "string", "Ceros", "position",[55 -80 200 40]);
btnGanancia = uicontrol (f, "style", "pushbutton", "string", "Ganancia", "position",[55 -160 200 40]);
bntEstabilidad = uicontrol (f, "style", "pushbutton", "string", "Estabilidad", "position",[55 -200 200 40]);
btnBorrarTodo = uicontrol (f, "style", "pushbutton", "string", "Borrar todo", "position",[410 0 200 40],'callback',{@mycallback2,txtPolos,txtCeros});
btnFinalizar = uicontrol (f, "style", "pushbutton", "string", "Finalizar", "position",[410 -40 200 40]);

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
