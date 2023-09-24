import wollok.game.*
import movimientos.*

object jake {

	var property monedas = 0
	
	var property position = game.center()

	method image() = "jakeMirandoAlFrente.png"

	method sumarMoneda() {
		monedas = monedas + 1
	}
	
	method sumarMonedas() {
		monedas = monedas + 3
	}
	method altura() = 1
	
	method text() = monedas.toString()
	
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

object finnElHumano {
	
	var property monedas = 0
	
	var property position = game.at(0,0)
	
	method image() = "finnMirandoAlFrente.png"
	
	method sumarMoneda() {
		monedas = monedas + 1 
	}

	method sumarMonedas() {
		monedas = monedas + 3
	}
	method text() = monedas.toString()
	
	method altura() = 2
	
	
	
	
	
	
	
	
	
	
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

