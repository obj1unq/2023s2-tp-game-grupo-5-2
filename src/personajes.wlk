import wollok.game.*
import movimientos.*

object fueguito {

	var property position = game.center()

	method image() = "fueguito.png"

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

object aguita {
	
	var property hidratacion = 100
	
	var property position = game.at(0,0)
	
	method image() = "aguita.png"
	
	method text() = hidratacion.toString()
	method hidratacion() = hidratacion 
	method textColor() = "#4294D9"
	
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