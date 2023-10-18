import wollok.game.*
import movimientos.*
import extrasJuego.*
object finnElHumano {
	
	var property monedas = 0
	
	const property puertaJuego = puerta
	
	const property cofreJuego = cofre
	
	var property position = game.at(0,0)

	var property estado = inofensivo
	
	var property image = "finnMirandoAlFrente.png"
	
	var llaveObtenida 
	
	method llaveObtenida(tipoLlave) {
		 llaveObtenida = tipoLlave
	}
	
	method sumarMonedas(_monedas) {
		monedas = monedas + _monedas
	}

	method text() = monedas.toString()
	
	method hayAlgoParaAgarar() {
		const objetosMiPosicion = game.getObjectsIn(position)
		
		return objetosMiPosicion.size() > 1
	}
	
	method validarAgarrar(algo) {
		if( not self.hayAlgoParaAgarar()) {
			self.error("No hay nada que agarrar")
		}
	}
	
	method agarrar(algo) {
		self.validarAgarrar(algo)
		algo.agarrado(self)
	}
	
	method hayPuertaOHayCofre() {
		return cofreJuego.position() == self.position() || self.position() == puertaJuego.position()
	}
	

	method puedeUsarLlave() {
		return self.hayPuertaOHayCofre() 
	}
	
	method validarUsarLlave() {
		if(not self.puedeUsarLlave()){
			self.error("Aca no hay ni una puerta ni un cofre capo")
		}
	}
	
	method usarLlave() {
		self.validarUsarLlave()
		cofreJuego.serAbiertoCon(llaveObtenida)
		puertaJuego.serAbridaCon(llaveObtenida)
	}
	
	method validarMover(direccion) {
		if(not self.sePuedeMover(direccion)) {
			self.error("Estoy en el borde, no puedo moverme")
		} 
	}
	
	method mover(direccion) {
		self.validarMover(direccion)
		const proxima = direccion.siguiente(self.position())
		self.position(proxima)		
	}
	
	method sePuedeMover(direccion) {
		const proxima = direccion.siguiente(self.position())
		return self.puedeOcupar(proxima)
	}
	
	
	method puedeOcupar(_posicion) {
		return tablero.pertenece(_posicion)
	}
	
}

object inofensivo {
	
	
}

object combativo {
	
}