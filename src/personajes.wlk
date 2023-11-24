import wollok.game.*
import movimientos.*
import movimientos.*
import animacion.*
import barraHP.*
import inicioDelJuego.*


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
    
    method esEnemigo()
    
    method sePuedeMover(direccion) {
		const proxima = direccion.siguiente(self.position())
		return self.puedeOcupar(proxima)
	}
	method puedeOcupar(_posicion) {
		return _posicion.y().between(0, 1) && // Últimas tres filas después de invertir, lo mejor seria crear objetos invisibles en donde no queremos que se mueva y hacerlos solidos 
               _posicion.x().between(0, game.width() - 1)                               //return tablero.pertenece(_posicion)
	}
	
	method puedeRealizarAnimacion() {
		return not self.hayAnimacionEnCurso()
	}
	
	
}

object bill inherits IndividuoBase { //probar borrar el immage y setearle en la clase madre a ver si aun sin ser abstracto el enemigo hace animaciones
	
//	const enemigo2 = enemigoB
	
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
    	if (barraDeVida.quedanVidasSuficientes()) self.resusitar() else  gameOver.mostrarPantalla() //el game stop se puede reemplazar con un pantallazo de game over y dsp el stop 
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
		self.daniarEnemigosSiExisten()
		//}
	//	else {
	//		animacionAlGolpear.gestionarAnimacionDeGolpe()
	//	}
	
	}
	
	method daniarEnemigosSiExisten() {
		if(not self.enemigosEnMiPosicion().isEmpty() ) {
			self.enemigosEnMiPosicion().forEach({enemigo => enemigo.recibirDanio()})
		}
	}
	
	method enemigosEnMiPosicion() = game.getObjectsIn(self.position()).filter({objetos => objetos.esEnemigo()})
	
	override method esEnemigo() = false //ponerlo en la superclase como abstracto 
	
	method patear() {
		self.aumentarPatadasDadas()
		animacionAlPatear.gestionarAnimacionDePatada()		 
		self.daniarEnemigosSiExisten()
    }
	
	override method recibirDanio() {
	 if (not invulnerable) {  
        //self.volverInvulnerable()   
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

object enemigoFactoryB inherits EnemigoFactory {
	override method nuevo() {
		return new Enemigo(image = "enemigoAquietoIzq.png", position= game.at(6,1), direccionMirando="Izquierda", tiempoPerseguir = 700)
	}
}
 
object enemigoFactory inherits EnemigoFactory{
	
	override method nuevo() {
		return new Enemigo(image = "enemigoAquietoIzq.png", position= game.at(5,1), direccionMirando="Izquierda", tiempoPerseguir = 500)
	}
}

object enemigoManager {
	
	var generados = #{}
	const limite = 4
	
	const factories = [enemigoFactory,enemigoFactoryB]
	
	
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
}



class Enemigo inherits IndividuoBase{			//nuevo
	
	var property tiempoPerseguir
	
	const personajePrincipal = bill
	 
	const numeroDeDerrotas = contador 
	 
	var property cantidadDeVida = 80
	
	const animacionEnemigoRecibeDanio = new AnimacionDanioEnemigo(objeto=self)
	
	const animacionEnemigoDerrotado = new AnimacionDerrotaEnemigo(objeto=self)
	
	const animacionEnemigoGolear = new AnimacionGolpeEnemigo(objeto=self)
	
	const animacionMover = new AnimadorMovimientoEnemigo(objeto= self)
	
	const animacionSubir = new AnimadorMovimientoSubirEnemigo(objeto= self)
	
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
		if (self.estoyJuntoABill()) {
			animacionEnemigoGolear.realizarAnimacion() 
			personajePrincipal.recibirDanio()
		}	  
	}
	
	method reducirSalud() {  // al sacar 10 de vida y tiene 80 como maximo, aguanta 7 golpes y muere en el 8
		cantidadDeVida = cantidadDeVida - 10
	}
	
	override method recibirDanio() {
        if (not invulnerable) {  
          self.volverInvulnerable()   
		  animacionEnemigoRecibeDanio.realizarAnimacion()
		  self.reducirSalud()
		  self.derrotadoSiSeAgotaSalud()
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
			game.schedule(500, {self.golpear()}) // schedule para que no te cague a palazos 
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
	
	
	
}

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

object gameOver {
	var property position = game.origin()
	const property image = "gameOver.jpg"
	
	method mostrarPantalla(){
		game.schedule(2000, {game.addVisual(self)})
		game.schedule(4000, {game.stop()})
	}
	
	
}




