import personajes.*
import nivel_llaves.*
import nivel_bloques.*
import utilidades.*
import wollok.game.*
import elementos.*
import indicadores.*
import sonidos.*

class ModificadoresPollo{
	var property position = utilidadesParaJuego.unaPositionNoRepetida()
	
	method desaparecerModificador() {utilidadesParaJuego.eliminar(self) prick.play()}
	method accion(){
		self.asignarModificador()
		self.desaparecerModificador()
	}
	
	method modificarEnergiaDelPollo(unPollo)
	
	method asignarModificador() {personajeSimple.modificador(self)}	
}

class Duplicador inherits ModificadoresPollo{
	var property image = "duplicador.png"
	override method modificarEnergiaDelPollo(unPollo) {unPollo.energia(unPollo.energia() *2) }
}

class Triplicador inherits ModificadoresPollo{
	var property image = "triplicador.png"
	
	override method modificarEnergiaDelPollo(unPollo){
		if (personajeSimple.energia().even()) {unPollo.energia(unPollo.energia() *3)}
			
		else {unPollo.energia(unPollo.energia() *0)}
	}
}	

class Reforzador inherits ModificadoresPollo{
	var property image = "reforzador.png"
	override method modificarEnergiaDelPollo(unPollo){
		unPollo.energia(unPollo.energia() *2)
		if (personajeSimple.energia() < 10) {personajeSimple.energia(personajeSimple.energia() +20)}	 
	}
}

class CeldaSorpersa{
	var property image = "celda_sorpresa.png"
	var property position = utilidadesParaJuego.unaPositionNoRepetida()
	var property estado = "activo"
	const property esEnemigo = false
	
	method puedeMoverHacia(unaPosition) = game.getObjectsIn(unaPosition) == []

	method accion(){					
		if(game.getObjectsIn(self.position()).size() > 1 && 
			!game.getObjectsIn(self.position()).first().esEnemigo()){
			if(personajeSimple.vieneDesdeArriba() || 
				personajeSimple.vieneDesdeAbajo() || 
				personajeSimple.vieneDesdeLaIzquierda() || 
				personajeSimple.vieneDesdeLaDerecha()){ 
      	 	if (estado == "activo"){
						personajeSimple.rebote()	
						bit_noise.play()
						estado = "desactivo"
						image = "celdaByN.png"
						personajeSimple.energia(personajeSimple.energia() + (20.randomUpTo(-9).roundUp()))
						indicadorDeEnergia.indicar()
						}
					else{
						teleport.play()
						personajeSimple.position(utilidadesParaJuego.unaPositionNoRepetida())
					}
				}
			}
		else if(game.getObjectsIn(self.position()).size() > 1 && estado == "desactivo" &&
						game.getObjectsIn(self.position()).first().esEnemigo()){
			game.getObjectsIn(self.position()).first().position(utilidadesParaJuego.unaPositionNoRepetida())
				}
		}
	}

class CeldaAdyasentesDelCofre{
	var property image = "celdaAzul.jpg"
	var property position
	var property cofre
	
	method accion(){
		keyboard.a().onPressDo( { cofre.convertirCofreEnLlave() personajeSimple.restaEnergiaPatada(2) })
		
	}
}

