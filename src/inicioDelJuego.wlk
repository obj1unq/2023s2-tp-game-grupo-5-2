import wollok.game.*
import animacion.*

import movimientos.*
import personajes.*
import barraHP.*


//-----------------------------------------------------------------------------------

object escenario{
  //  var cont = 1
	var property nivel
	
	method iniciarNivel(nuevoNivel){
		
		nuevoNivel.configuracionFondo()
	    nuevoNivel.configuracionSonido()
		nuevoNivel.configuracionInicial()
		nuevoNivel.configuracionTeclado()
		nuevoNivel.instanciarObjetos()
		nuevoNivel.bloqueados()
		nuevoNivel.configuracionVisual()
		nuevoNivel.configuracionEscenario()

		self.nivel(nuevoNivel)
	}
	
//	method passNivel(){
//		if(cont == 4){
//			self.removerNivel()
//			const nivel2 = new Nivel2()
//			self.iniciarNivel(nivel2)
//			cont +=1
//		}else{
//			self.ganarBill()
//		}
//	}

	method removerNivel(){
		nivel.removerVisualEscenario()
	}
	
	method perderVida(){
		self.removerNivel()
		self.iniciarNivel(nivel)
	}
	
//	method morir(){
//		self.removerNivel()
//		const gameOver = new GameOver() 
//		self.iniciarNivel(gameOver)
//	}
//	
//	method ganar(){
//		self.removerNivel()
//		const endGame = new EndGame() 
//		self.iniciarNivel(endGame)
//	}
		
}

class Nivel{
//	var property objetos = []
//	var property objetosExtra = []	
//	var property noPasar = []
	var property sonido 
			
	method configuracionInicial(){}
	
	method configuracionSonido(){
   	 	sonido.shouldLoop(true) 
    	game.schedule(500, {sonido.play()} )
	}
	
	method configuracionTeclado(){
		const arriba = new Arriba(personaje = bill)
		const abajo  = new Abajo(personaje = bill)
		const izquierda = new Izquierda(personaje = bill)
		const derecha   = new Derecha(personaje = bill)
		

		//musica
   		keyboard.up().onPressDo({sonido.volume(1)})
		keyboard.down().onPressDo({sonido.volume(0.2)})
		keyboard.m().onPressDo({sonido.volume(0)})
		//movimiento
		keyboard.w().onPressDo({  bill.mover(arriba)    })
		keyboard.s().onPressDo({  bill.mover(abajo)     })
		keyboard.a().onPressDo({  bill.mover(izquierda) }) 
		keyboard.d().onPressDo({  bill.mover(derecha)   })
	
	    //colisiones
		keyboard.e().onPressDo({  bill.golpear()   })
 		keyboard.q().onPressDo({  bill.patear()  })
 		keyboard.p().onPressDo({  bill.recibirDanio()   })//prueba
	}
		
	method bloqueados(){
	}
	method removerVisualEscenario(){
		//remover todos los visuales del escenario
		game.clear()
	}	
	
	method configuracionFondo(){}
	
	method instanciarObjetos(){}
	
	method configuracionVisual(){}
	
	method moverObjetosVisual(){}	

	method configuracionEscenario(){}	
	
	method pressEnter(){}
}

class Portada inherits Nivel{
	var contador = 0
	
	override method configuracionTeclado(){
		keyboard.enter().onPressDo {self.pressEnter()}
   		keyboard.up().onPressDo({sonido.volume(1)})
		keyboard.down().onPressDo({sonido.volume(0.2)})
		keyboard.m().onPressDo({sonido.volume(0)}) 
	}
	
	override method configuracionFondo(){
		game.addVisual(mainMenu)
		mainMenu.animacion()
		self.time()
		game.schedule(3500, { start.actualizar() }) //si se quiere retrasar la aparicion del boton hay que retrasar el metodo pressEnter tambien 
	    
	}
	
	override method pressEnter(){
		if (contador == 3500) { //3500 porque es lo que tarda el boton start en aparecer, es para que no se pueda apretar enter antes de ese tiempo y explote
			sonido.stop()
			const puertaInicial = new PuertaInicial (sonido = game.sound("perciana.wav"))
		    start.iniciarJuego()
		    escenario.removerNivel() 
		    escenario.iniciarNivel(puertaInicial)
		}
	}
	
	method time() {
		if (contador < 3500) {
			contador = contador + 100 //suma cada 100ms, si se intenta hacer cada 10ms o cada 1ms wollok falla y no detecta el cambio, no se porque se debe pero de esta manera funciona
			game.schedule(100, {self.time()})
		}
	}
}

class GameOver inherits Nivel{
		
	override method configuracionFondo(){
		mainMenu.image()
		game.addVisual(mainMenu)		
	}
		
}

class EndGame inherits Nivel{
		
	override method configuracionFondo(){
		mainMenu.image()
		game.addVisual(mainMenu)		
	}
		
}

class Nivel1 inherits Nivel{
	
	override method configuracionInicial(){
		//visual algunos	
		enemigoManager.generar()
		game.schedule(8000,  { enemigoManager.generar() } )
		game.schedule(16000, { enemigoManager.generar() } )
		game.schedule(24000, { enemigoManager.generar() } )
			
		game.addVisual(bill)
	
	}
	
	override method configuracionFondo(){
		game.addVisual(fondoLvl1)	
	}
	
	override method instanciarObjetos(){}

	override method configuracionVisual(){		

		game.addVisual(barraDeHP)
		contadorDeVidas.inicializar()	
		game.addVisual(contador)
		game.addVisual(numerico)	
	}	
	
	override method removerVisualEscenario() { //nuevo
	//    sonido.stop()
		game.removeVisual(fondoLvl1)
		game.removeVisual(primerDetectorNivel)
		game.removeVisual(segundoDetectorNivel)
		mano.iniciarJuego()
				
		game.removeVisual(bill)
		game.removeVisual(barraDeHP)
		game.removeVisual(contadorDeVidas)
		game.removeVisual(contador)
		game.removeVisual(numerico)
		
		contador.cantidad(0)
		numerico.actualizar(0)
		game.clear()
	}	
}

class Nivel2 inherits Nivel1 { 
    
	override method configuracionSonido(){}
    
    override method configuracionInicial(){
    	enemigoManager.reiniciarManager()
    	super()
    	bill.position(game.at(1,1))
    	destrabarPersonaje.habilitarMovimientos()
    }
    
	override method configuracionFondo(){
		game.addVisual(fondoLvl2)	 
	}	
	
}


class PuertaInicial inherits Nivel {
	const animacionDePerciana = animadorPuerta
	
	override method configuracionFondo(){	
		game.addVisual(puerta)
		animacionDePerciana.realizarAnimacion() 
	}	
	
	override method configuracionSonido(){
   	 	sonido.shouldLoop(false)
    	game.schedule(100, {sonido.play()} )
	}	
}   

//----extras----------------------------

class ObjetosParpadeantes {
    method actualizar() {
        game.onTick(self.tiempoDeActualizacion(), "actualizar Start", { self.visual()})
    }

    method tiempoDeActualizacion() = 500

    method visual() {
        if (game.hasVisual(self)) game.removeVisual(self) else game.addVisual(self)
    }
	method quitarBoton() {
		if(game.hasVisual(self)) {
			game.removeVisual(self)
		} else {}
	}
		
    method iniciarJuego() {
        game.removeTickEvent("actualizar Start")
        self.quitarBoton()
    }	
		
}

object start inherits ObjetosParpadeantes {

    var property position = game.origin()

    method image() = "startButton.png"
}

object contador {
	var property position = game.at(6,7)
	const property numeroDelContador = numerico
	var property image = "contador.png"
	var property cantidad = 0
	
	method agregarYActualizar() {
		cantidad = cantidad + 1
		self.actualizarDerrotados()
	}
	
	method actualizarDerrotados() {
		numeroDelContador.actualizar(cantidad)
		self.ganarSiAlncanzoObjetivo()
	}
	
	method ganarSiAlncanzoObjetivo() {
		
		if (cantidad == 4 && game.hasVisual(fondoLvl1)) { //por ahora solo añade los detectores en el primer nivel 
			mano.aparecer()  //win.mostrarPantalla() //el win es para ganar el juego, hay que utilizarlo luego en otro lado, esto era de prueba solamente para la entrega 
			primerDetectorNivel.aparecerColision()
			segundoDetectorNivel.aparecerColision()
		} else if(cantidad == 4 && game.hasVisual(fondoLvl2)) {
			game.addVisual(elevador)
			animadorElevador.realizarAnimacion() //esto esta para que no explote, despues hay que reemplazarlo con un elevador.realizarAnimacion() y que en el movimiento
			                                      //final de este haga spawnear a otro enemigo y que en la animacion de derrota de este ultimo aparezcan los detectores y la mano                                      
		}
	}
}

object numerico {
	var property position = game.at(9,7)
	var property image = "0vidas.png"
	
	method actualizar(numero) {
		image = numero.toString() + "vidas.png" 
	}
}

class Fondos {
    var property position = game.at(0, 0)
    var property image	=""
}

object fondoLvl1 inherits Fondos {
    override method image() = "background1.png"
}

object fondoLvl2 inherits Fondos {
	override method image() = "background2.png"
}

object mano inherits ObjetosParpadeantes  {
	
	var property position = game.at(0, 0)
    var property image = "mano.png"
	
	method aparecer() {
		game.addVisual(self)
		game.sound("mano.wav").play()
		self.actualizar()
	}
	
	override method visual() {
		if (game.hasVisual(self)) {
			game.removeVisual(self) 
		}else {
			game.addVisual(self) 
		    game.sound("mano.wav").play()
		}
	}
}

class Detectores {
	var property position = game.origin()
	
	method aparecerColision() {
		game.addVisual(self)
		self.habilitarColision()
	}
	
	method habilitarColision() {			
		game.onCollideDo(bill, { detector=> detector.hacerAlgo() }) //si bill esta reapareciendo justo cuando el ultimo enemigo es derrotado puede generar error
	}
	
	method hacerAlgo() {}
	
	method soundtrackDeNivel() { //si estas en el lvl 1 segui con la misma musica. si no pone la del lvl 3 porque estas en el lvl2
		return if(game.hasVisual(fondoLvl1)) game.sound("") else game.sound("cancion del tercer nivel ")
	}
	
	method siguienteDelNivelActual() {
		return if(game.hasVisual(fondoLvl1)) new Nivel2(sonido = self.soundtrackDeNivel()) else "crear el new nivel3"
		//si fueran mas de 3 niveles habria que hacer elseif preguntando en que nivel esta para generar el correcto
	}
	
	method esEnemigo() = false
}

object primerDetectorNivel inherits Detectores {
	
	override method position() = game.at(11,1)
	
	override method hacerAlgo() {
		const nivel = self.siguienteDelNivelActual()
		escenario.removerNivel()
		escenario.iniciarNivel(nivel)
	}
}
object segundoDetectorNivel inherits Detectores {
	
	override method position() = game.at(11,0)
	
	override method hacerAlgo() {
		const nivel = self.siguienteDelNivelActual()
		escenario.removerNivel()
		escenario.iniciarNivel(nivel)
	}
}





