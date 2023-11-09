import wollok.game.*
import personajes.*

object derecha {
	
	method esIgualA(direccion) {
		return self == direccion
	}
	
	method siguiente(position) {
		return position.right(1)
	}
	
	method IzqODer() {return "Derecha"}
	
}

object izquierda {
	
	method esIgualA(direccion) {
		return self == direccion
	}
	
	method siguiente(position) {
		return position.left(1)
	}
	method IzqODer() {return "Izquierda"}
}

object arriba {
	
	method esIgualA(direccion) {
		return self == direccion
	}

	method siguiente(position) {
		return position.up(1)
	}
	method IzqODer() { return if (bill.directionMirando() == "Derecha") "Derecha" else "Izquierda" }
}

object abajo {
	
	method esIgualA(direccion) {
		return self == direccion
	}
	
	method siguiente(position) {
		return position.down(1)
	}
	method IzqODer() {return if (bill.directionMirando() == "Izquierda") "Izquierda" else "Derecha" }

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

