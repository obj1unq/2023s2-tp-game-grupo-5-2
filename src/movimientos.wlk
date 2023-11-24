import wollok.game.*
import animacion.*
import personajes.*

class DireccionBase {
	
	var property personaje
	
	const animador = new AnimadorMovimiento(objeto = personaje) 
	
	method siguiente(position)
	
	method animar() 
	
}


class Derecha inherits DireccionBase{

 	override method siguiente(position) {
		 return position.right(1)
	 }
	method IzqODer() {return "Derecha"}
	
	override method animar() {
		animador.realizarAnimacion()
	}
}

class Izquierda inherits DireccionBase{
	
	override method siguiente(position) {
		return position.left(1)
	}
	
	method IzqODer() {return "Izquierda"}
	
	override method animar() { 
		animador.realizarAnimacion()
	}
}

class Arriba inherits DireccionBase{
	
	const animadorSubir = new AnimadorMovimientoSubir( objeto = personaje)
	
	override method siguiente(position) {
		return position.up(1)
	}
	
	override method animar() {
		animadorSubir.realizarAnimacion()	
	}
	
	method IzqODer() { return if (personaje.direccionMirando() == "Derecha") "Derecha" else "Izquierda" }
}

class Abajo inherits DireccionBase{
	
	override method siguiente(position) {
		return position.down(1)
	}
	
	method IzqODer() {return if (personaje.direccionMirando() == "Izquierda") "Izquierda" else "Derecha" }
	
	override method animar() {
		animador.realizarAnimacion()
	} 
}

object tablero {

	method pertenece(position) {
		return position.x().between(0, game.width() - 1) and 
			position.y().between(0, game.height() - 1)
	}
	
	method puedeOcupar(position) {
		return self.pertenece(position) 
	}
	
	
}



//import wollok.game.*
//import personajes.*
//import sprites.*
//
//class Direccion {
//	method animar() {
//		spritesDePaso.iniciarAnimacion()
//	}
//}
//
//object derecha inherits Direccion {
//	
//
//	
//	method siguiente(position) {
//		return position.right(1)
//	}
//	
//	method IzqODer() {return "Derecha"}
//	
//}
//
//object izquierda inherits Direccion {
//	
//
//	method siguiente(position) {
//		return position.left(1)
//	}
//	method IzqODer() {return "Izquierda"}
//}
//
//object arriba inherits Direccion {
//	
//	override method animar() {
//		spritesDeSubir.iniciarAnimacion()
//	}
//
//	method siguiente(position) {
//		return position.up(1)
//	}
//	method IzqODer() { return if (bill.directionMirando() == "Derecha") "Derecha" else "Izquierda" }
//}
//
//object abajo inherits Direccion {
//	
//
//	method siguiente(position) {
//		return position.down(1)
//	}
//	method IzqODer() {return if (bill.directionMirando() == "Izquierda") "Izquierda" else "Derecha" }
//
//}
//
//object tablero {
//
//	method pertenece(position) {
//		return position.x().between(0, game.width() - 1) and 
//			position.y().between(0, game.height() - 1)
//	}
//	
//	method puedeOcupar(position) {
//		return self.pertenece(position) 
//	}
//	
//	
//}

