import wollok.game.*
import movimientos.*

object fueguito {

	method position() = game.center()

	method image() = "fireboy.png"

}

object aguita {
	
	var property hidratacion = 100
	
	var property position = game.at(0,0)
	
	method image() = "watergirl.png"
	
	method hidratacion() = hidratacion 
	
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