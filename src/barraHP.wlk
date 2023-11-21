import wollok.game.*
import personajes.*

object barraDeHP {
	
	var property position = game.origin()
	
	var property estado = completa
	
	var property vidas = 4	
	
	var property cantidadDeVida = 100
	
	const property vidaADisminuir = 20
	
	const contadorVidas = contadorDeVidas
	
	method reiniciarSaludYEstados() {
		self.quitarVida()
		self.cantidadDeVida(100)
		estado.reiniciar(self)
		contadorVidas.actualizarVidas()
	}
	method estaVacia() {
		return self.cantidadDeVida() <= 0
	}
	method quitarVida() {
		vidas = vidas - 1
	}
		
//	method reiniciarVidaSi(personaje) {
//		if(self.cantidadDeVida() == 0) {		
//			estado.reiniciar(self)
//			personaje.descontarVida()
//			self.cantidadDeVida(100)	
//		}
//		else {}
//		
//	}
	
	method descontarVida() {							
		self.degradarVida()
	}
	
	method degradarVida() {
		cantidadDeVida = cantidadDeVida - vidaADisminuir
	}
	method image() {
		return estado.image()
	}
	
	method degradarEstado() {
		estado.degradar(self)
	}
	
	method aumentar() {}						//Consume algo que le da 1 vida mas
	
	method quedanVidasSuficientes() {
		return vidas > 1
	}
	method validarDescontar() {								
		if(self.vidas() == 0) {		//cambio
			self.error("No tengo mas salud, no es posible recibir daño")
		}
	}
			
	method descontar() {									
		self.validarDescontar()
		self.degradarEstado()
		self.degradarVida()
	}
}
	


class EstadoBaseBarraHP {

	method image()
	
	method degradar(barraHP)
	
	method reiniciar(barraHP) {}		
	
}


object completa inherits EstadoBaseBarraHP {
	
	override method image() = "barraLlena.png"
	
	override method degradar(barraHP) {			
		barraHP.estado(degradada)
	}
}

object degradada inherits EstadoBaseBarraHP {					//Hay que hacerlo animacion
	
	const property degradaciones = self.degradacionesIniciales()								
	
	override method image() = self.degradamientoActual()
	
	method degradamientoActual() {
		return degradaciones.first()
	}
	
	override method degradar(barraHP) {
		if(degradaciones.size() == 1) {								
			degradaciones.remove(self.degradamientoActual())
			barraHP.estado(vacia)
			self.reiniciarDegradaciones()
		}
		else { degradaciones.remove(self.degradamientoActual()) }
	}
	
	method degradacionesIniciales() {
		return ["barraUnTick.png","barraDosTick.png","barraTresTick.png","barraCuatroTick.png"]
	}
	
	 method reiniciarDegradaciones() {
		degradaciones.addAll(self.degradacionesIniciales())										
	}
	
}

object vacia inherits EstadoBaseBarraHP {
	
	override method image() = "barraVacia.png"
	
	override method degradar(barraHP) {}
	
	override method reiniciar(barraHP) {              
		  barraHP.estado(completa)
	}
}

object contadorDeVidas {
	var property image = "3vidas.png"       //En los assets estan los sprites hasta 6 vidas por si se quiere modificar o hacer un main menu interactivo donde se seleccione la cantidad
	var property position = game.origin()
	
	const barraVida = barraDeHP
	
	method inicializar() {
		game.addVisual(self)
	}
	
	method actualizarVidas() {
		image = self.calcularSpriteSegunVidas(barraVida.vidas())
	}
	
	method calcularSpriteSegunVidas(numeroDeVidas) {
		return (numeroDeVidas - 1).toString() + "vidas.png"
	}
}
//import wollok.game.*
//import personajes.*
//
//object barraDeHP {
//	
//	var property position = game.origin()
//	
//	var property estado = completa
//	
//	var property vidas = 4											
//	
//	var property cantidadDeVida = 100 
//	
//	const property vidaADisminuir = 20
//	
//	method reiniciarSaludYEstados() {
//		self.quitarVida()
//		self.cantidadDeVida(100)
//		self.estado(completa)
//	}
//	method esBarraDeHPVacia() {
//		return self.cantidadDeVida() == 0
//	}
//	method quitarVida() {
//		vidas = vidas - 1
//	}
//	
//	method quedanVidasSuficientes() {
//		return vidas > 1
//	}
//	
//	method degradarVida() {
//		cantidadDeVida = cantidadDeVida - self.vidaADisminuir()
//	}
//	
//	method descontarVida() {							
//		self.degradarVida()
//	}
//	
//	method image() {
//		return estado.image()
//	}
//	
//	method degradarEstado() {
//		estado.degradar(self)
//	}
//	
//	method aumentar() {}						//Consume algo que le da 1 vida mas
//	
//	method validarDescontar() {								
//		if(self.vidas() == 0) {		//cambio
//			self.error("No tengo mas salud, no es posible recibir daño")
//		}
//	}
//			
//	method descontar() {									
//		self.validarDescontar()
//		self.degradarEstado()
//		self.descontarVida()
//	}
//}
//	
//
//
//class EstadoBaseBarraHP {
//
//	method image()
//	
//	method degradar(barraHP)
//	
//	method reiniciar(barraHP) {}		
//	
//}
//
//
//object completa inherits EstadoBaseBarraHP {
//	
//	override method image() = "barraLlena.png"
//	
//	override method degradar(barraHP) {			
//		barraHP.estado(degradada)
//	}
//}
//
//object degradada inherits EstadoBaseBarraHP {
//	
//	const property degradaciones = self.degradacionesIniciales()								
//	
//	override method image() = self.degradamientoActual()
//	
//	method degradamientoActual() {
//		return degradaciones.first()
//	}
//	
//	
//	override method degradar(barraHP) {
//		if(degradaciones.size() == 1) {								
//			degradaciones.remove(self.degradamientoActual())
//			barraHP.estado(vacia)
//			self.reiniciarDegradaciones()
//		}
//		else { degradaciones.remove(self.degradamientoActual()) }
//	}
//	
//	method degradacionesIniciales() {
//		return ["barraUnTick.png","barraDosTick.png","barraTresTick.png","barraCuatroTick.png"]
//	}
//	
//	 method reiniciarDegradaciones() {
//		degradaciones.addAll(self.degradacionesIniciales())										
//	}
//}
//
//object vacia inherits EstadoBaseBarraHP {
//	
//	override method image() = "barraVacia.png"
//	
//	override method degradar(barraHP) {}
//	
//	override method reiniciar(barraHP) {}
//}
//
//object contadorDeVidas {
//	var property image = "3vidas.png"       //En los assets estan los sprites hasta 6 vidas por si se quiere modificar o hacer un main menu interactivo donde se seleccione la cantidad
//	var property position = game.origin()
//	
//	method inicializar() {
//		game.addVisual(self)
//	}
//	
//	method actualizarVidas() {
//		image = self.calcularSpriteSegunVidas(barraDeHP.vidas())
//	}
//	
//	method calcularSpriteSegunVidas(numeroDeVidas) {
//		return (numeroDeVidas - 1).toString() + "vidas.png"
//	}
//}

