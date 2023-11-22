import wollok.game.*
import animacion.*
import personajes.*

class DireccionBase {
	
	const animador = new AnimadorMovimiento(objeto = bill) 
	
	const personaje = bill
	
	method siguiente(position)
	
	method animar() 
	
}


object derecha inherits DireccionBase{

 	override method siguiente(position) {
		 return position.right(1)
	 }
	method IzqODer() {return "Derecha"}
	
	override method animar() {
		animador.realizarAnimacion()
	}
}

object izquierda inherits DireccionBase{
	
	override method siguiente(position) {
		return position.left(1)
	}
	
	method IzqODer() {return "Izquierda"}
	
	override method animar() { 
		animador.realizarAnimacion()
	}
}

object arriba inherits DireccionBase{
	
	const animadorSubir = new AnimadorMovimientoSubir(objeto = bill)
	
	override method siguiente(position) {
		return position.up(1)
	}
	
	override method animar() {
		animadorSubir.realizarAnimacion()	
	}
	
	method IzqODer() { return if (personaje.direccionMirando() == "Derecha") "Derecha" else "Izquierda" }
}

object abajo inherits DireccionBase{
	
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

