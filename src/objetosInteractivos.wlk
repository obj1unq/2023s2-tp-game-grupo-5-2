import wollok.game.*
object pared {
	
	const property position = game.at(1,3)
	
	method image() {
		
	}
	
}

object agua {
	
	method image() {
		
	}
	
	method colision(personaje) {
		
	}
	
	
}

object fuego {
	
	method image() {
		
	}
	
	method colision(personaje) {
		
	}
	
}

object moneda {

	var property position = game.at(2,4)

	method tomado(personaje) {
		game.removeVisual(self)
		personaje.sumarMoneda()
	}
	
	method image() = "unaMoneda.png"
		
}

object monedas {
	
	var property position = game.at(1,9)

	method tomado(personaje) {
		game.removeVisual(self)
		personaje.sumarMonedas()
	}
	
	method image() = "Monedas.png"
	
}
object bemoo {
	
	var property position = game.at(7,8)
	
	method image() = "bemoo.png"
	
	method tomado(personaje) {
		if(personaje.altura() == 2) game.say(self,"Hola finn") else game.say(self,"Hola jake")
	}
}