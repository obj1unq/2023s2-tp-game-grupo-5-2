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

object mainMenu {

    var property position = game.origin()

    method image() = "mainMenu.png"

    method iniciarJuego() {
        game.removeVisual(self)
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
	
//	method morirTony(){
//		self.removerNivel()
//		const gameOver = new GameOver() 
//		self.iniciarNivel(gameOver)
//	}
//	
//	method ganarTony(){
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
		start.actualizarStart()	
	}
	
	override method pressEnter(){
		sonido.stop()
		const puerta = new Puerta (sonido = game.sound("perciana.wav"))
		start.iniciarJuego()
		escenario.removerNivel()
		escenario.iniciarNivel(puerta)
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
		//objetos.forEach({a => a.visual()})		
		//game.addVisual(cueva)	
		//objetosExtra.forEach({a => a.visual()})
		//game.addVisual(tablon)
		//game.addVisual(monedasTablon)
		game.addVisual(barraDeHP)
		contadorDeVidas.inicializar()		
	}		
}

class Puerta inherits Nivel {
	
	override method configuracionFondo(){	
		game.addVisual(puerta)
		puertaMovil.abrirPuerta() 
	}	
	
	override method configuracionSonido(){
   	 	sonido.shouldLoop(false)
    	game.schedule(100, {sonido.play()} )
	}	
}  

object puerta {
	var property image = "puerta1.png"
	var property position = game.origin()
}

object puertaMovil {
	var property indice = 0
	
	method sprites() {
		return [ "puerta1.png", "puerta2.png", "puerta3.png", "puerta4.png", "puerta5.png", "puerta6.png", "puerta7.png", "puerta8.png", "puerta9.png", "puerta10.png",
			     "puerta11.png", "puerta12.png", "puerta13.png", "puerta14.png", "puerta15.png", "puerta16.png", "puerta17.png", "puerta18.png", "puerta19.png", "puerta20.png"]
	}	
	
	method abrirPuerta() {
		puerta.image(self.sprites().get(indice)) 
		self.segundoSprite()
	}
	
	method segundoSprite() {
		if(indice < self.sprites().size() - 1) {
			indice++
			puerta.image(self.sprites().get(indice))
			 game.schedule(150, { self.segundoSprite() })      
		} 
		else {
			self.finalizarAnimacion()
		}		
	}
	
	method finalizarAnimacion() {  //crea el nivel 1 cuando se abre la puerta 
		const nivel1 = new Nivel1(sonido = game.sound("citySlumStage1.wav"))
		escenario.removerNivel()
		escenario.iniciarNivel(nivel1)
	}
}


//
//class Nivel2 inherits Nivel{
//	
//	override method configuracionInicial(){
//		//visual algunos			
//		game.addVisual(bill)		
//
//		//game.onCollideDo(tony,{algo => algo.chocasteCon(tony)})
//	}
//	
//	override method configuracionFondo(){
//		game.addVisual(fondoCueva)	
//	}
//	
//	override method instanciarObjetos(){
//
//	}
//	
//	override method configuracionVisual(){		
//		objetos.forEach({a => a.visual()})
//		cueva.position(game.at(8, 1))	
//		game.addVisual(cueva)
//		objetosExtra.forEach({a => a.visual()})
//		game.onTick(200, "actualiza imagen golem", { => golem.numeroImagen(21)})
//		game.onTick(500, "moverGolem", { => golem.sigueATony()  })
//		game.addVisual(tablon)
//		game.addVisual(monedasTablon)
//		game.addVisual(barraDeVida)
//		game.addVisual(golem)		
//		coleccionVidas.image()
//	}
//	
//	
//	override method configuracionEscenario(){
//		self.configuracionGolem()
//		self.configuracionZombis()
//	}
//}


object fondoLvl1 {

	var property position = game.at(0, 0)
    var property image = "background1.png"


}















