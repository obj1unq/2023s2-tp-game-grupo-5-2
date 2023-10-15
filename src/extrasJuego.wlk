import wollok.game.*
import personajes.*
import objetosInteractivos.*

/*
 * Crear una class que tenga los mensajes que finn le manda a cada objeto cuando ocurre una colision
   como metodos abstractos, asi no se repite codigo y cada objeto lo sobreescribe en su interior de
   manera que haga el efecto que tendria que suceder
 
 */


object cofre {

	var property position = game.at(8,6)
	
	var property estado = cerrado
	
	const property contenidoDelCofre = [llavePuerta]
	
	var property image = "cofre_cerrado.png"
	
	
	method validarAgarrado(personaje) {
		if(not estado.puedeAgararseLoQueHayDentro()) {
			self.error("estoy " + self.estado().toString() + ", no hay nada que agarrar")
		}
	}

	method agarrado(personaje) {
		self.validarAgarrado(personaje)
		estado.serVaciado(self,personaje)
		estado = vacio
	}
	
	method abrir() {
		estado.abrir(self)
		estado = abierto
	}
	
	method serAbiertoCon(tipoLlave) {
		self.validarSerAbiertoCon(tipoLlave)
		self.abrir()
	}
	method validarSerAbiertoCon(tipoLlave) {
		if(not tipoLlave.esLlaveParaCofre()) {
			self.error("No se puede abrir")
		}
	}
}

object cerrado {
	
	method abrir(cofre) {
		cofre.image("cofre_abierto.png")
	}
	
	method puedeAgararseLoQueHayDentro() {
		return false
	}
	
	method serVaciado(cofre,personaje) {}
}

object abierto {

	method serVaciado(cofre,personaje) {
		personaje.llaveObtenida(cofre.contenidoCofre().uniqueElement())
		cofre.remove(cofre.contenidoCofre())
		cofre.image("cofre_vacio.png")
	}
	method puedeAgararseLoQueHayDentro() {
		return true
	}
	method abrir(cofre){}
}

object vacio {
	
	method puedeAgararseLoQueHayDentro() {
		return false
	}
	
	method abrir(cofre){}
	
	method serVaciado(cofre,personaje) {}
}

object puerta {
	
	var property position = null
	
	method image() = "jakeDeEspalda.png"
	
	method validarSerAbridaCon(tipoLlave) {
		if(not tipoLlave.esLlaveParaPuerta()) {
			self.error("No se puede abrir")
		}
	}
	
	method abrir() {
		game.stop()
	}
	
	method serAbridaCon(tipoLlave){
		self.validarSerAbridaCon(tipoLlave)
		self.abrir()
	}
	method agarrado(personaje) {
	}
}
object bemoo {
	
	var property position = game.at(7,8)
	
	const property image = "bemoo.png"
	
	method agarrado(personaje) {
		if(personaje.poseeLlavePuerta()) {
			game.say(self, "Hola finn, Enhorabuena, tenes la llave para pasar al siguiente nivel.. suerte!")	
		}
		else {
			game.say(self, "Hola finn, necesitas una llave para abrir esa puerta. Espero la encuentres")
		}
	}
}