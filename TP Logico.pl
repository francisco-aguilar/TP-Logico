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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saleCon(Quien,Cual):-
	pareja(Quien,Cual),
	Quien\=Cual.
	
saleCon(Quien,Cual):-
	pareja(Cual,Quien),
	Quien\=Cual.
	
% No es recursiva.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trabajaPara(Quien,bernardo):-
	trabajaPara(marsellus,Quien),
	Quien\=jules.
	
trabajaPara(Quien,george):-
	saleCon(bernardo,Quien),
	Quien\=bernardo.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
esFiel(Personaje):-
	persona(Personaje),
	findall(Quien,saleCon(Personaje,Quien),Z),
	length(Z,1).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

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

esPeligroso(Personaje):-
	personaje(Personaje,ladron([_, licorerias])).
	
esPeligroso(Personaje):-
	personaje(Personaje,ladron([licorerias, _])).
	
esPeligroso(Personaje):-
	personaje(Personaje,mafioso(maton)).
	
esPeligroso(Personaje):-
	personaje(Personaje,_),
	trabajaPara(Jefe,Personaje),
	esPeligroso(Jefe).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

sanCayetano(UnPersonaje):-
	alguienCerca(UnPersonaje),
	forall(sonCercanos(UnPersonaje,Encargado),encargo(UnPersonaje,Encargado,_)).

sonCercanos(UnPersonaje,OtroPersonaje):-
	personaje(UnPersonaje,_),
	personaje(OtroPersonaje,_),
	amigo(UnPersonaje,OtroPersonaje).
	
sonCercanos(UnPersonaje,OtroPersonaje):-
	personaje(UnPersonaje,_),
	personaje(OtroPersonaje,_),
	amigo(OtroPersonaje,UnPersonaje).
	
sonCercanos(UnPersonaje,OtroPersonaje):-
	personaje(UnPersonaje,_),
	personaje(OtroPersonaje,_),
	trabajaPara(UnPersonaje,OtroPersonaje).
	
sonCercanos(UnPersonaje,OtroPersonaje):-
	personaje(UnPersonaje,_),
	personaje(OtroPersonaje,_),
	trabajaPara(OtroPersonaje,UnPersonaje).
	
alguienCerca(UnPersonaje):-
	personaje(UnPersonaje,_),
	findall(X,sonCercanos(UnPersonaje,X),Lista),
	length(Lista,Numero),
	Numero>0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

nivelDeRespeto(Personaje,NivelDeRespeto):-
	personaje(Personaje,actriz(Z)),
	length(Z,Numero),
	NivelDeRespeto is Numero/10.

nivelDeRespeto(Personaje,10):-
	personaje(Personaje,mafioso(resuelveProblemas)).

nivelDeRespeto(Personaje,20):-
	personaje(Personaje,mafioso(capo)).
	
nivelDeRespeto(vincent,15).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

respetabilidad(Respetables,NoRespetables):-
	findall(R,respetoMayorANueve(R),ListaR),
	length(ListaR,CantidadRespetables),
	findall(NR,respetoMenorOIgualANueve(NR),ListaNR),
	length(ListaNR,CantidadNoRespetables),
	Respetables is CantidadRespetables,
	NoRespetables is CantidadNoRespetables.
	
respetoMayorANueve(UnPersonaje):-
	personaje(UnPersonaje,_),
	nivelDeRespeto(UnPersonaje,NivelDeRespeto),
	NivelDeRespeto>9.

respetoMenorOIgualANueve(UnPersonaje):-
	personaje(UnPersonaje,_),
	not(respetoMayorANueve(UnPersonaje)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
cantidadEncargos(UnPersonaje,CantidadEncargos):-
	personaje(UnPersonaje,_),
	findall(X,encargo(_,UnPersonaje,_),Z),
	length(Z,CantidadEncargos).

masAtareado(UnPersonaje):-
	cantidadEncargos(UnPersonaje,Encargos),
	forall((personaje(OtroPersonaje,_),UnPersonaje\=OtroPersonaje),(cantidadEncargos(OtroPersonaje,Encargos2),Encargos2<Encargos)).
