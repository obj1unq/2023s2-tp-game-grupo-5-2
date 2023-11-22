import wollok.game.*
import movimientos.*
import movimientos.*
import animacion.*
import barraHP.*


class IndividuoBase {
	
	var property position = game.at(1,2)
	
	var property image = "quieto.png"
	
	var property golpesRecibidos = 0
	
	var property invulnerable = false   
	
    var property direccionMirando = "Derecha"
    
	var property hayAnimacionEnCurso = false

	var property permitirAnimacion = true
	
	///const controlDeAnimaciones = controlDeAnimacion
	
	method duracionInvulnerabilidad() 
	
	method derrotadoSiSeAgotaSalud()
	
	method aumentarGolpesRecibidos() {
		golpesRecibidos = golpesRecibidos + 1
	}
	
	method volverInvulnerable() {
		invulnerable = true
	}
	
	method quitarInvulnerabilidad() {
		invulnerable = false
	}
	
    method recibirDanio() 
    
    method golpear()
    
    method sePuedeMover(direccion) {
		const proxima = direccion.siguiente(self.position())
		return self.puedeOcupar(proxima)
	}
	method puedeOcupar(_posicion) {
		return _posicion.y().between(0, 1) && // Últimas tres filas después de invertir, lo mejor seria crear objetos invisibles en donde no queremos que se mueva y hacerlos solidos 
               _posicion.x().between(0, game.width() - 1)                               //return tablero.pertenece(_posicion)
	}
}

object bill inherits IndividuoBase {

	const enemigo1 = enemigoA
	
//	const enemigo2 = enemigoB
	
	const property barraDeVida = barraDeHP											
	
	const property animacionAlGolpear = animacionGolpe
	
	const property animacionAlRecibirDanio = animacionDanio
	
	const property animacionDerrotado = animacionDerrota
	
	const property animacionAlRevivir = animacionRevivir
	
	const property animacionAlPatear = animacionPatada
	
//	const property controlDeAnimaciones = controlDeAnimacion
//	
//	var property golpesRecibidos = 0
	
	var property golpesDados = 0
	
	var property patadasDadas = 0
	
//	var property invulnerable = false    
//	
	override method duracionInvulnerabilidad() = 1500 
//	
//	method volverInvulnerable() {
//		invulnerable = true
//	}
//	
//	method quitarInvulnerabilidad() {
//		invulnerable = false
//	}
//	
//	method aumentarGolpesRecibidos() {
//		golpesRecibidos = golpesRecibidos + 1
//	}
	
	method aumentarGolpesDados() {
		golpesDados = golpesDados + 1
	}
	
	method aumentarPatadasDadas() {
		patadasDadas = patadasDadas + 1
	}
	
	method resusitarOTerminar() {
    	if (barraDeVida.quedanVidasSuficientes()) self.resusitar() else  game.schedule(4000, {game.stop()}) //el game stop se puede reemplazar con un pantallazo de game over y dsp el stop 
    }
	
	method puedeRealizarAnimacion() {
		return not self.hayAnimacionEnCurso()
	}
	
	method resusitar() {
		self.position(game.at(1,1)) 
		animacionAlRevivir.respawn()
		barraDeVida.reiniciarSaludYEstados()	
	}
	override method derrotadoSiSeAgotaSalud() {
		if (barraDeVida.estaVacia()) {
    		animacionDerrotado.realizarAnimacion()
    	}
    	else {
    		self.quitarInvulnerabilidad()
        	self.hayAnimacionEnCurso(false)
 		}						
	}
	override method golpear(){ //nuevo
		//if(self.position() == algo.position()) {
		self.aumentarGolpesDados()
		animacionAlGolpear.gestionarAnimacionDeGolpe()
	//		algo.recibirDanio()
		//}
	//	else {
	//		animacionAlGolpear.gestionarAnimacionDeGolpe()
	//	}
		
	}
	
	method patear() {
		self.aumentarPatadasDadas()
		animacionAlPatear.gestionarAnimacionDePatada()		//agregar que le pegue al enemigo
    }
	
	override method recibirDanio() {
	 if (not invulnerable) {  
        self.volverInvulnerable()   
		animacionAlRecibirDanio.gestionarAnimacionDeDanio()
		barraDeVida.descontar()
	  }
	}
	method validarMover(direccion) {
		if(not self.sePuedeMover(direccion)) {
			self.error("No puedo moverme ahi")
		} 
	}
	
	method mover(direccion) {
        if(self.puedeRealizarAnimacion()) {
			self.validarMover(direccion)
			const proxima = direccion.siguiente(self.position())
			self.direccionMirando(direccion.IzqODer())
			direccion.animar()
			self.position(proxima)
		}		
	}
	method moverConAnimacionHacia(direccion) {
//			if(controlDeAnimaciones.puedeRealizarAnimacion()) {
			self.mover(direccion)
			direccion.animar()
//			}
	}
}


class Enemigo inherits IndividuoBase{			//nuevo
	
	const personajePrincipal = bill
	
	var property cantidadDeVida = 20
	
	const animacionEnemigoRecibeDanio = new AnimacionDanioEnemigo(objeto=self)
	
	const animacionEnemigoDerrotado = new AnimacionDerrotaEnemigo(objeto=self)
	
	override method image() = "enemigoAQuietoIzq.png"
	
	override method position() = game.at(5,1) 
	
//	var property golpesRecibidos = 0
//	
//	const controlDeAnimaciones = 
//	
//	method aumentarGolpesRecibidos() {
//		golpesRecibidos = golpesRecibidos + 1
//	}
//	
	override method direccionMirando() = "Izquierda"
	
	override method duracionInvulnerabilidad() = 1500

	override method derrotadoSiSeAgotaSalud() {
		if (not self.tieneVida()) {
    		animacionEnemigoDerrotado.realizarAnimacion()
    		game.removeTickEvent("acercarse")
    	}
    	else {
    		self.quitarInvulnerabilidad()
            self.hayAnimacionEnCurso(false)
    	}										
	}
	
	method tieneVida() {
		return self.cantidadDeVida() >= 0
	}
	
	override method golpear() {
		//  algo.recibirDanio() 		  
	}
	
	override method recibirDanio() {
        if (not invulnerable) {  
          self.volverInvulnerable()   
		  animacionEnemigoRecibeDanio.realizarAnimacion()
		  self.derrotadoSiSeAgotaSalud()
	  }
	}
	
	method desaparecer() {
		game.removeVisual(self)
	}
	
	
	method perseguirPersonaje() {
		game.onTick(1000,"acercarse",{self.darUnPaso(personajePrincipal.position())})
	}
	
	method darUnPaso(destino) {
		if(self.sePuedeMover(destino)) {
		position = game.at(
			position.x() + (destino.x() - position.x()) / 2,
			position.y() + (destino.y() - position.y() / 2)
		)
		}
	}
	
	
	
}

object enemigoA inherits Enemigo {}

object puerta {
	const property direccionMirando = "Derecha"
	var property image = "puerta1.png"
	var property position = game.origin()
	var property hayAnimacionEnCurso = false
	var property permitirAnimacion = true
	
	method quitarInvulnerabilidad() {}
	method duracionInvulnerabilidad() {} 
	method invulnerable() {}
	method volverInvulnerable() {}
	method resusitarOTerminar() {}
	method golpesRecibidos(numero) {} 
	method aumentarGolpesRecibidos() {}
	method derrotadoSiSeAgotaSalud() {}
	method patadasDadas(numero) {}
	method aumentarPatadasDadas() {}
	method golpesDados(numero) {}
	method aumentarGolpesDados() {}
	
	method puedeRealizarAnimacion() {
		return not self.hayAnimacionEnCurso()
	}
}
object mainMenu {
	var property hayAnimacionEnCurso = false
	var property permitirAnimacion = true
    const property animacionInicio = animacionMainMenu
    const property direccionMirando = "Derecha"
    var property position = game.origin()
    var property image = "spriteMainMenu0.png"

    method iniciarJuego() {
        game.removeVisual(self)
    }
    
    method animacion() {
    	animacionInicio.realizarAnimacion()
    }
    
//    method detener() {
//    	animacionInicio.detenerAnimacion()
//    }
    
	method quitarInvulnerabilidad() {}
	method duracionInvulnerabilidad() {} 
	method invulnerable() {}
	method volverInvulnerable() {}
	method resusitarOTerminar() {}
	method golpesRecibidos(numero) {} 
	method aumentarGolpesRecibidos() {}
	method derrotadoSiSeAgotaSalud() {}
	method patadasDadas(numero) {}
	method aumentarPatadasDadas() {}
	method golpesDados(numero) {}
	method aumentarGolpesDados() {}
	
	method puedeRealizarAnimacion() {
		return not self.hayAnimacionEnCurso()
	}
}






