import wollok.game.*
import movimientos.*
import movimientos.*
import animacion.*
import barraHP.*
import inicioDelJuego.*


class IndividuoBase {
	
	var property position = game.at(1,1)
	
	var property image = "quieto.png"
	
	var property golpesRecibidos = 0
	
	var property invulnerable = false   
	
    var property direccionMirando = "Derecha"
    
	var property hayAnimacionEnCurso = false

	var property permitirAnimacion = true
	
	var property timerDeGolpe = 0
	
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
    
    method esEnemigo()
    
    method sePuedeMover(direccion) {
		const proxima = direccion.siguiente(self.position())
		return self.puedeOcupar(proxima)
	}
	method puedeOcupar(_posicion) {
		return _posicion.y().between(0, 1) &&  
               _posicion.x().between(0, game.width() - 1)                               //return tablero.pertenece(_posicion)
	}
	
	method puedeRealizarAnimacion() {
		return not self.hayAnimacionEnCurso()
	}
	
	method actualizarTimerDeGolpe() {
			timerDeGolpe = timerDeGolpe + 100
			game.schedule(100, {self.controlarTimer()})
    }
    
	method controlarTimer() {
		if (self.timerDeGolpe() < self.intervaloDeGolpe()) {
            self.actualizarTimerDeGolpe()		 
	    } else {
			timerDeGolpe = 0
		}
	}	
	method intervaloDeGolpe() = 2000
}

object bill inherits IndividuoBase { 
	
	const property barraDeVida = barraDeHP											
	
	const property animacionAlGolpear = new AnimacionGolpe(objeto =self)
	
	const property animacionAlGolpear2 = new AnimacionGolpe2(objeto =self)
	
	const property animacionAlRecibirDanio = new AnimacionDanio(objeto =self)
	
	const property animacionDerrotado = new AnimacionDerrota(objeto =self)
	
	const property animacionAlRevivir = new AnimacionRevivir(objeto =self)
	
	const property animacionAlPatear = new  AnimacionPatada(objeto =self)
	
	const property animacionAlPatear2 = new AnimacionPatada2(objeto =self)
	
	const property animacionDanioMedio = new AnimacionDanioMedio(objeto =self)
	
	const property animacionDanioCritico = new AnimacionDanioCritico(objeto = self)
	
	var property golpesDados = 0
	
	var property patadasDadas = 0
	
	override method duracionInvulnerabilidad() = 1500 

	
	method aumentarGolpesDados() {
		golpesDados = golpesDados + 1
	}
	
	method aumentarPatadasDadas() {
		patadasDadas = patadasDadas + 1
	}
	
	method resusitarOTerminar() {
    	if (barraDeVida.quedanVidasSuficientes()) self.resusitar()  else  gameOver.mostrarPantalla() 
    }
	
	
	method resusitar() {
		self.position(game.at(1,1)) 
		animacionAlRevivir.respawn()
		barraDeVida.reiniciarSaludYEstados()	
	}
	override method derrotadoSiSeAgotaSalud() {
		if (barraDeVida.estaVacia()) {
			self.volverInvulnerable()
			game.sound("perderVida.wav").play()
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
		//}
	//	else {
	//		animacionAlGolpear.gestionarAnimacionDeGolpe()
	//	}
	
	}
	
	method daniarEnemigosSiExisten() {
		if(not self.enemigosEnMiPosicion().isEmpty() ) {
			self.enemigosEnMiPosicion().forEach({enemigo => enemigo.hayAnimacionEnCurso(false) enemigo.permitirAnimacion(true) enemigo.recibirDanio()})
		}
	}
	
	method enemigosEnMiPosicion() = game.getObjectsIn(self.position()).filter({objetos => objetos.esEnemigo()})
	
	override method esEnemigo() = false //ponerlo en la superclase como abstracto 
	
	method patear() {
		self.aumentarPatadasDadas()
		animacionAlPatear.gestionarAnimacionDePatada()		 
    }
	
	override method recibirDanio() {
	 if (not invulnerable) {  
        //self.volverInvulnerable()   
        self.actualizarTimerDeGolpe()
        self.aumentarGolpesRecibidos()
        game.sound("recibirDanio.wav").play()
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

class EnemigoFactory {
	
	method nuevo()
}

object enemigoA inherits EnemigoFactory {
	override method nuevo() {
		return new Enemigo(image = self.toString()+"quietoIzq.png", position= game.at(8,1), direccionMirando="Izquierda", tiempoPerseguir = 1000, enemigoAAnimar= self.toString() )
	}
}
 
object enemigoB inherits EnemigoFactory{
	
	override method nuevo() {
		return new Enemigo(image = self.toString()+"quietoIzq.png", position= game.at(7,0), direccionMirando="Izquierda", tiempoPerseguir = 500, enemigoAAnimar= self.toString() )
	}
}

object enemigoC inherits EnemigoFactory {
	override method nuevo() {
		return new Enemigo(image = self.toString()+"quietoIzq.png", position= game.at(9,2), direccionMirando="Izquierda", tiempoPerseguir = 450, enemigoAAnimar= self.toString() )
	}
	
}

object enemigoManager {
	
	var generados = #{}
	var limite = 4
	
	const factories = [enemigoA,enemigoB]
	
	
	method seleccionarFactory() {

//      Para una probabilidad de 10% alpiste 90% manzana		
//		const x = 0.randomUpTo(1)
//		return if (x < 0.10) alpisteFactory else manzanaFactory 
		
		return factories.anyOne() //igual de probabilidad
	}
	
	method generar() {
		if(generados.size() < limite ) {
			
			const tipoEnemigo = self.seleccionarFactory().nuevo() 		
			game.addVisual(tipoEnemigo)	
			generados.add(tipoEnemigo)
			tipoEnemigo.perseguirPersonaje()
		}
	}
	
	method quitar(tipoEnemigo) {
		generados.remove(tipoEnemigo)
		game.removeVisual(tipoEnemigo)
	}
	
	method reiniciarManager() {
		generados = #{}
	}
	
	method cambiarLimiteEnemigos(cantidad) {
		limite = cantidad
	}
	
	method agregarJefe(jefe) {
		const jefe1 = jefe.nuevo()
		
		game.addVisual(jefe1)
		jefe1.cantidadDeVida(120)
		jefe1.perseguirPersonaje()
	}
}



class Enemigo inherits IndividuoBase{			//nuevo
	
	var property tiempoPerseguir
	
	var property enemigoAAnimar
	
	var property sigoEnCombate = true
	
	const personajePrincipal = bill
	 
	const numeroDeDerrotas = contador 
	 
	var property cantidadDeVida = 80
	
	const animacionEnemigoRecibeDanio = new AnimacionDanioEnemigo(objeto=self, objetoAnimado=enemigoAAnimar) 
	
	const animacionEnemigoDerrotado = new AnimacionDerrotaEnemigo(objeto=self, objetoAnimado=enemigoAAnimar)
	
	const animacionEnemigoGolear = new AnimacionGolpeEnemigo(objeto=self, objetoAnimado=enemigoAAnimar)
	
	const animacionMover = new AnimadorMovimientoEnemigo(objeto= self, objetoAnimado=enemigoAAnimar)
	
	const animacionSubir = new AnimadorMovimientoSubirEnemigo(objeto= self, objetoAnimado=enemigoAAnimar)
	
//	var property golpesRecibidos = 0
//	
//	const controlDeAnimaciones = 
//	
//	method aumentarGolpesRecibidos() {
//		golpesRecibidos = golpesRecibidos + 1
//	}
//		
    override method esEnemigo() = true

	override method duracionInvulnerabilidad() = 1500

	override method derrotadoSiSeAgotaSalud() {
		if (self.noTieneMasSalud()) {
			self.sigoEnCombate(false)
			self.volverInvulnerable()
			game.removeTickEvent("acercarse")
    		animacionEnemigoDerrotado.animacion()
    		numeroDeDerrotas.agregarYActualizar()
    	}
    	else {
    		self.quitarInvulnerabilidad()
            self.hayAnimacionEnCurso(false)
    	}										
	}
	
	method noTieneMasSalud() {
		return self.cantidadDeVida() <= 0
	}
	
	override method golpear() {
		if (self.estoyJuntoABill() && personajePrincipal.timerDeGolpe() == 0 && self.sigoEnCombate() ) { //personajePrincipal.timerDeGolpe() == 0 podria ser un metodo con un mejor nombre
			animacionEnemigoGolear.realizarAnimacion()
		}	  
	}
	
	method reducirSalud() {  // al sacar 10 de vida y tiene 80 como maximo, aguanta 7 golpes y muere en el 8
		cantidadDeVida = cantidadDeVida - 10
	}
	
	override method recibirDanio() {
        if (not invulnerable) {  
          self.volverInvulnerable()   
          game.sound("recibirDanio.wav").play()
		  animacionEnemigoRecibeDanio.gestionarAnimacionDanioEnemigo()
		  self.reducirSalud()
		  game.schedule(100,{ self.quitarInvulnerabilidad()})
	  }
	}
	
	method desaparecer() {
		game.removeVisual(self)
	}
	
	
	method perseguirPersonaje() {
		game.onTick(tiempoPerseguir,"acercarse",{self.darUnPasoOGolpear()})
	}
	
	//de aca hacia abajo es codigo para que siga a bill 
	method estoyJuntoABill() {
		return self.position() == personajePrincipal.position()
	}
	
	method darUnPasoOGolpear() {
		
		if (not self.estoyJuntoABill()) {
			self.acercarseABill()
		}else {
			game.schedule(700,{self.golpear()}) // schedule para que no te cague a palazos, pensar en un motor de golpe distinto 
		}
	}
	
	method acercarseABill() {
		if (self.laDistanciaDelEjeYEsMayorQueElX(self)) { //si la distancia entre los ejes y de cada uno es mayor a la de los ejes x
			self.moversePorElEjeY(self)      //se mueve en el eje y
		}else {
			self.moversePorElEjeX(self)     // se mueve en el eje x
		}
	}

	method laDistanciaDelEjeYEsMayorQueElX(personaje) = (personaje.position().y() - personajePrincipal.position().y()).abs() > (personaje.position().x() -personaje.position().x()).abs()
	
	method moversePorElEjeY(personaje) {
		if(personaje.position().y() - personajePrincipal.position().y() > 0){
			
			animacionMover.realizarAnimacion()
			self.position(self.position().down(1))		
			
		}else if (personaje.position().y()  - personajePrincipal.position().y() < 0){
			
			animacionSubir.realizarAnimacion()
		    self.position(self.position().up(1))
		}
	}
	
	method moversePorElEjeX(personaje) {
		if(personaje.position().x() - personajePrincipal.position().x() > 0){
			
			self.direccionMirando("Izquierda")
			self.position(self.position().left(1))
			
		}else if (personaje.position().x()  - personajePrincipal.position().x() < 0){
			
			self.direccionMirando("Derecha")
		    self.position(self.position().right(1))  
		}
		animacionMover.realizarAnimacion()
	}
	
	
	method hacerAlgo() {} //solo por los detectores para que no salga mensaje de error, habria que buscar una forma mejor de hacerlo
}






class Finalizar {
	var property position = game.origin()
	var property image = "gameOver.jpg"
	
	method mostrarPantalla(){
		self.temporizadorVisual()
		self.juegoFinalizado()
	}
	
	method temporizadorVisual() {game.schedule(2000, {game.addVisual(self)}) }
	method juegoFinalizado() {game.schedule(4000, {game.stop()}) }  

}
object gameOver inherits Finalizar {
	
}

object win inherits Finalizar {
	
   	override method image() = "theEnd.png"
   	
   	override method temporizadorVisual() {game.schedule(5000, {game.addVisual(self)})  }
    override method juegoFinalizado() {game.schedule(8000, {game.stop()}) } 
}

object puerta inherits IndividuoBase{
	
    override method position() = game.origin()

	override method duracionInvulnerabilidad() {} 
	override method golpear()				   {}
	override method recibirDanio() 			   {}
	override method esEnemigo() 			   {}
	override method derrotadoSiSeAgotaSalud()  {}

}

object elevador inherits IndividuoBase{
	
    override method position() = game.origin()

	override method duracionInvulnerabilidad() {} 
	override method golpear()				   {}
	override method recibirDanio() 			   {}
	override method esEnemigo() 			   {}
	override method derrotadoSiSeAgotaSalud()  {}	
	method hacerAlgo() {}
}

object mainMenu inherits IndividuoBase{

    const property animacionInicio = animacionMainMenu


    method iniciarJuego() {
        game.removeVisual(self)
    }
    
    method animacion() {
    	animacionInicio.realizarAnimacion()
    }
    

    override method position() = game.origin()
    
	override method duracionInvulnerabilidad() {} 
	override method golpear() 			   	   {}
	override method recibirDanio()		  	   {}
	override method esEnemigo()			 	   {}
	override method derrotadoSiSeAgotaSalud()  {}
}




