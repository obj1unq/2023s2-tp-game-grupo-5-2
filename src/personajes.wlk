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
	
	const property llaveObtenida = []
	
	method llaveObtenida(tipoLlave) {
		llaveObtenida.add(tipoLlave)
	}
	
	method sumarMonedas(_monedas) {
		monedas = monedas + _monedas
	}

	method text() = monedas.toString()
	
	
	method agarrar(algo) {
		algo.agarrado(self)
	}
	
	method validarUsarLlave() {
		if(self.position() != cofre.position() || self.position() != puerta.position()){
			self.error("Aca no hay ni una puerta ni un cofre capo")
		}
	}
	
	method usarLlave() {
		self.validarUsarLlave()
		
	}
	
	method validarMover(direccion) {
		if(not self.sePuedeMover(direccion)) {
			self.error("No es posible moverse")
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

