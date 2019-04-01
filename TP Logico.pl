%pareja(Persona, Persona)
pareja(marsellus,mia).
pareja(pumkin,honeyBunny).
pareja(bernardo,charo).
pareja(bernardo,bianca).

persona(marsellus).
persona(pumkin).
persona(bernardo).
persona(charo).
persona(bianca).
persona(vincent).
persona(jules).
persona(winston).
persona(george).
persona(honeyBunny).
persona(mia).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%whaaaaaat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto1
saleCon(Quien,Cual):-
	pareja(Quien,Cual),
	Quien\=Cual.
	
saleCon(Quien,Cual):-
	pareja(Cual,Quien),
	Quien\=Cual.
	
% No es recursiva.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto3
trabajaPara(Quien,bernardo):-
	trabajaPara(marsellus,Quien),
	Quien\=jules.
	
trabajaPara(Quien,george):-
	saleCon(bernardo,Quien),
	Quien\=bernardo.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto4
esFiel(Personaje):-
	persona(Personaje),
	findall(Quien,saleCon(Personaje,Quien),ListaParejas),
	length(ListaParejas,1).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

%Punto5
% Caso base
acataOrden(Jefe,Empleado):-
	trabajaPara(Jefe,Empleado).
	
	
% Caso recursivo
acataOrden(Jefe,Trabajador):-
	trabajaPara(Empleador,Trabajador),
	acataOrden(Jefe,Empleador).

% Es recursiva.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
% Información base
% personaje(Nombre, Ocupacion)
personaje(pumkin,     ladron([estacionesDeServicio, licorerias])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).
personaje(bernardo,   mafioso(cerebro)).
personaje(bianca,     actriz([elPadrino1])).
personaje(elVendedor, vender([humo, iphone])).
personaje(jimmie,     vender([auto])).


% encargo(Solicitante, Encargado, Tarea). 
% las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(bernardo, vincent, buscar(jules, fuerteApache)).
encargo(bernardo, winston, buscar(jules, sanMartin)).
encargo(bernardo, winston, buscar(jules, lugano)).


amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto1
esPeligroso(Personaje):-	realizaActividadPeligrosa(Personaje).
esPeligroso(Personaje):-	tieneJefePeligroso(Personaje).

realizaActividadPeligrosa(Personaje):-
	personaje(Personaje,mafioso(maton)).

realizaActividadPeligrosa(Personaje):-
	personaje(Personaje,ladron(Robos)),
	member(licorerias,Robos).

tieneJefePeligroso(Personaje):-
	personaje(Personaje,_),
	trabajaPara(Jefe,Personaje),
	esPeligroso(Jefe).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

%Punto2
sanCayetano(UnPersonaje):-
	alguienCerca(UnPersonaje),
	forall(sonCercanos(UnPersonaje,Encargado),encargo(UnPersonaje,Encargado,_)).

sonCercanos(UnPersonaje,OtroPersonaje):-	sonAmigos(UnPersonaje,OtroPersonaje).
sonCercanos(UnPersonaje,OtroPersonaje):-	trabajaPara(UnPersonaje,OtroPersonaje).
sonCercanos(UnPersonaje,OtroPersonaje):-	trabajaPara(OtroPersonaje,UnPersonaje).

sonAmigos(UnPersonaje,OtroPersonaje):-	amigo(UnPersonaje,OtroPersonaje).
sonAmigos(UnPersonaje,OtroPersonaje):-	amigo(OtroPersonaje,UnPersonaje).
	
alguienCerca(Personaje):-
	personaje(Personaje,_),
	sonCercanos(Personaje,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

%Punto3
nivelDeRespeto(Personaje,NivelDeRespeto):-
	personaje(Personaje,actriz(Peliculas)),
	length(Peliculas,Cantidad),
	NivelDeRespeto is Cantidad/10.

nivelDeRespeto(Personaje,10):-
	personaje(Personaje,mafioso(resuelveProblemas)).

nivelDeRespeto(Personaje,20):-
	personaje(Personaje,mafioso(capo)).
	
nivelDeRespeto(vincent,15).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto4
respetabilidad(CantidadRespetables,CantidadNoRespetables):-
	findall(Personaje,respetoMayorANueve(Personaje),ListaRespetables),
	length(ListaRespetables,CantidadRespetables),
	findall(Personaje,respetoMenorOIgualANueve(Personaje),ListaNoRespetables),
	length(ListaNoRespetables,CantidadNoRespetables).
	
respetoMayorANueve(Personaje):-
	nivelDeRespeto(Personaje,Respeto),
	Respeto>9.

respetoMenorOIgualANueve(Personaje):-
	personaje(Personaje,_),
	not(respetoMayorANueve(Personaje)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto5	
masAtareado(Personaje):-
	cantidadEncargos(Personaje,Cantidad),
	forall(personaje(OtroPersonaje,_),(cantidadEncargos(OtroPersonaje,OtraCantidad),Cantidad>=OtraCantidad)).

cantidadEncargos(Personaje,Cantidad):-
	personaje(Personaje,_),
	findall(Encargo,encargo(_,Personaje,_),ListaEncargos),
	length(ListaEncargos,Cantidad).
