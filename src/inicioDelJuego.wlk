import wollok.game.*
import animacion.*

import movimientos.*
import personajes.*
import barraHP.*

object start {

    var property position = game.origin()

    method image() = "startButton.png"

    method actualizarStart() {
        game.onTick(500, "actualizar Start", { self.visual()})
    }

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


//-----------------------------------------------------------------------------------

object escenario{
//	var cont = 1
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
//		if(cont == 1){
//			self.removerNivel()
//			const nivel2 = new Nivel2()
//			self.iniciarNivel(nivel2)
//			cont +=1
//		}else{
//			self.ganarTony()
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
		//musica
   		keyboard.up().onPressDo({sonido.volume(1)})
		keyboard.down().onPressDo({sonido.volume(0.3)})
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
	
	override method configuracionTeclado(){
		keyboard.enter().onPressDo {self.pressEnter()}
	}
	
//	override method configuracionSonido() {
//		game.schedule(100, {sonido.play()} )
//	}
	override method configuracionFondo(){
		game.addVisual(mainMenu)
		mainMenu.animacion()
		start.actualizarStart()	
		
	}
	
	override method pressEnter(){
		sonido.stop()
		//mainMenu.detener()		
		const puertaInicial = new PuertaInicial (sonido = game.sound("perciana.wav"))
		start.iniciarJuego()
		escenario.removerNivel() 
		escenario.iniciarNivel(puertaInicial)
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
		game.addVisual(bill)
		game.addVisual(enemigoA)
		//game.onCollideDo(tony,{algo => algo.chocasteCon(tony)})
	}
	
	override method configuracionFondo(){
		game.addVisual(fondoLvl1)	
	}
	
	override method instanciarObjetos(){
		
	}
//	override method configuracionSonido() {
//		game.schedule(500, {sonido.play()} )
//	}
	override method configuracionVisual(){		

		game.addVisual(barraDeHP)
		contadorDeVidas.inicializar()		
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

object fondoLvl1 {

	var property position = game.at(0, 0)
    var property image = "background1.png"


}















