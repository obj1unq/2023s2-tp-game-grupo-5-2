import wollok.game.*

object derecha {

	method siguiente(position) {
		return position.right(1)
	}

}

object izquierda {

	method siguiente(position) {
		return position.left(1)
	}

}

object arriba {

	method siguiente(position) {
		return position.up(1)
	}

}

object abajo {

	method siguiente(position) {
		return position.down(1)
	}

}

object tablero {

	method pertenece(position) {
		return position.x().between(0, game.width() - 1) and 
			position.y().between(0, game.height() - 1)
	}

}

