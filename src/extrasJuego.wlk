import wollok.game.*
import personajes.*
import objetosInteractivos.*


object cofre {

	var property position = game.at(8,6)
	
	var property estado = cerrado
	
	method image() = "cofre_cerrado.png"


	method agarrado(personaje) {
		
	}
	method usarLlave(){
		
	}
	
}

object cerrado {
	
	
}

object abierto {

	
}

object vacio {
	
}

object puerta {
	
	var property position = null
	
	method image() = "jakeDeEspalda.png"
	
	method agarrado(personaje) {
	}
	method usarLlave(){
		
	}
	
}
object bemoo {
	
	var property position = game.at(7,8)
	
	const property image = "bemoo.png"
	
	method agarrado(personaje) {
		
	}
}