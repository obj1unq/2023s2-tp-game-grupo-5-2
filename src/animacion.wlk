import personajes.*
import wollok.game.*
import inicioDelJuego.*

class Animacion {
	
	var property objeto 
	
	
	//const animaciones = self.gestionarDirDeSprite()
	
	var indiceSpriteActual = 0
	                      
	method intervaloEntreAnimacion(animaciones) = game.schedule(130, { self.siguienteFrame(animaciones) }) //se creo el parametro animaciones porque el metodo siguienteFrame lo requeria 
	
	method animacionActual(indice,animaciones) = animaciones.get(indice)
	
	method movimientoFinal()  {
    	return if (objeto.direccionMirando() == "Izquierda") "quietoIzq.png" else "quieto.png"
    }
		
	
//	method reiniciarControlador() {
//		self.hayAnimacionEnCurso(false)
//		self.permitirAnimacion(true)
//	}
	
	method spritesIzquierda() 
	 
	method spritesDerecha() 
	
	method aumentarIndice() {
		indiceSpriteActual = indiceSpriteActual + 1 
	}
	method realizarAnimacion() {
	  if(objeto.puedeRealizarAnimacion()) {
		  objeto.hayAnimacionEnCurso(true)
		  objeto.permitirAnimacion(true) 
		  self.animacion()
		}
	}
	method animacion() {
		const animaciones = self.gestionarDirDeSprite()  //se tiene que crear localmente ya que si no no se actualiza 
//		if(not animaciones.isEmpty()) { 
		objeto.image(self.animacionActual(indiceSpriteActual,animaciones))    //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		self.siguienteFrame(animaciones)                                         //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const     
	}
		
	method siguienteFrame(animaciones) {                                         //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		if(objeto.permitirAnimacion()) {
			self.controlarFrame(animaciones)                                     //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		}
		else {
			indiceSpriteActual = 0
			objeto.permitirAnimacion(true)
		}
	}
	method controlarFrame(animaciones) {                                          //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		if(indiceSpriteActual < animaciones.size() - 1) {
			self.aumentarIndice() 
			objeto.image(self.animacionActual(indiceSpriteActual,animaciones)) 
			self.intervaloEntreAnimacion(animaciones)                             //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		} 
		else {
			indiceSpriteActual = 0
			self.finalizarAnimacion()
		}
	}
	
	method gestionarDirDeSprite() {                 // decide que sprites usar dependiendo de donde este mirando el personaje
    	return if ( objeto.direccionMirando() == "Izquierda") {self.spritesIzquierda()}
    	       else                                              {self.spritesDerecha()}
  }
  
	method interrumpirAnimacion(nuevaAnim) {       //metodo para interrumpir todas las demas animaciones si estan en progreso
     objeto.permitirAnimacion(false)
     objeto.hayAnimacionEnCurso(true)
     game.schedule(1,  {objeto.hayAnimacionEnCurso(false)} )
     game.schedule(100,  nuevaAnim )
  }
    
	
	method finalizarAnimacion() {
		objeto.image(self.movimientoFinal())
		objeto.hayAnimacionEnCurso(false)	
	}													
}


object animacionGolpe inherits Animacion(objeto = bill ) { 
	const siguienteGolpe = animacionGolpe2
	
	 override method spritesDerecha() {
		return ["golpefr1.png", "golpefr1.png", "golpefr2.png", "golpefr3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq1.png", "golpeIzq1.png", "golpeIzq2.png", "golpeIzq3.png"]
	}
	
	method gestionarAnimacionDeGolpe() {
		
		if (objeto.golpesDados() == 1 ) self.realizarAnimacion() else objeto.golpesDados(0) siguienteGolpe.realizarAnimacion() 
	}
}

object animacionGolpe2 inherits Animacion(objeto = bill ) {
	
	 override method spritesDerecha() {
		return ["golpe2-1.png", "golpe2-1.png", "golpe2-2.png", "golpe2-3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq2-1.png", "golpeIzq2-1.png", "golpeIzq2-2.png", "golpeIzq2-3.png"]
	}	
	
	
}

object animacionPatada inherits Animacion(objeto = bill ) {
	const siguientePatada = animacionPatada2
	
	 override method spritesDerecha() {
		return ["patada1.png", "patada1.png", "patada2.png", "patada2.png"]
	}
    
	override method spritesIzquierda() {
		return ["patadaIzq1.png", "patadaIzq2.png", "patadaIzq3.png", "patadaIzq4.png", "patadaIzq4.png"]
	}
	
	method gestionarAnimacionDePatada() {
		if (objeto.patadasDadas() == 1 ) self.realizarAnimacion() else objeto.patadasDadas(0) siguientePatada.realizarAnimacion() 
	}
}

object animacionPatada2 inherits Animacion(objeto = bill ) {

	 override method spritesDerecha() {
		return ["patada2-1.png", "patada2-1.png", "patada2-2.png", "patada2-2.png", "patada2-3.png", "patada2-4.png" ]  
	}
    
	override method spritesIzquierda() {
		return ["patadaIzq2-1.png", "patadaIzq2-1.png", "patadaIzq2-2.png", "patadaIzq2-2.png", "patadaIzq2-3.png", "patadaIzq2-4.png" ]
	}	
}

class AnimadorDeTiposDeDanio inherits Animacion {
	
	
	override method finalizarAnimacion() {
 		super()
 		objeto.derrotadoSiSeAgotaSalud()
 	}
}

object animacionDanio inherits AnimadorDeTiposDeDanio(objeto = bill ) {					
	
	const danioMedio = animacionDanioMedio
	
	const danioCritico = animacionDanioCritico
	
	override method spritesDerecha() {
		return ["danio1.png", "danio1.png", "danio1.png"] 
	}
	
	override method spritesIzquierda() {
		return ["danioIzq1.png", "danioIzq1.png", "danioIzq1.png"]
	}
	
	method gestionarAnimacionDeDanio() {
		
 		objeto.aumentarGolpesRecibidos()	
        if (objeto.golpesRecibidos() == 1) { 
            self.interrumpirAnimacion( { self.realizarAnimacion() } )     //animacion de daño normal 
                                                                                          
        } else if (objeto.golpesRecibidos() == 2) {
            danioMedio.interrumpirAnimacion( { danioMedio.realizarAnimacion() } )       //animacion de daño medio
                                                                                     
        } else {
            objeto.golpesRecibidos(0) 
            danioCritico.interrumpirAnimacion( { danioCritico.realizarAnimacion() } )   //animacion de daño critico
        }
            game.schedule(2000, { objeto.golpesRecibidos(0)  })  //reinicia la flag para la animacion despues de un determinado tiempo sin recibir daño 
       		
 	}
 	
}

object animacionDanioMedio inherits AnimadorDeTiposDeDanio(objeto = bill ) {
	
	override method spritesDerecha() {
		return ["danio2.png", "danio2.png", "danio2.png"] 
	}
	
	override method spritesIzquierda() {
		return ["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"]
	}
}

object animacionDanioCritico inherits AnimadorDeTiposDeDanio(objeto = bill ) {
	
	override method spritesDerecha() {
		return ["danio3.png", "danio3.png", "danio4.png",
                "danio4.png", "danio5.png", "danio5.png", 
                "danio6.png", "danio6.png"]
	}
	
	override method spritesIzquierda() {
		return ["danioIzq3.png", "danioIzq3.png", "danioIzq4.png", 
               "danioIzq4.png", "danioIzq5.png", "danioIzq5.png",
               "danioIzq6.png", "danioIzq6.png"]
	}
}

object animacionDerrota inherits Animacion(objeto = bill ) {
	
	override method spritesIzquierda() {
		return ["derrotadoIzq1.png", "derrotadoIzq1.png", "derrotadoIzq1.png", "derrotadoIzq1.png",
    	        "derrotadoIzq2.png", "derrotadoIzq2.png", "derrotadoIzq2.png", "derrotadoIzq2.png",
    	        "derrotadoIzq3.png", "derrotadoIzq3.png", "derrotadoIzq3.png", "derrotadoIzq3.png"]	        
    }
    
    override method spritesDerecha() {
    	return ["derrotado1.png", "derrotado1.png", "derrotado1.png", "derrotado1.png",
    	        "derrotado2.png", "derrotado2.png", "derrotado2.png", "derrotado2.png",
    	        "derrotado3.png", "derrotado3.png", "derrotado3.png", "derrotado3.png"]
    }
	
	override method movimientoFinal() = if (objeto.direccionMirando() == "Izquierda") "derrotadoIzq3.png" else "derrotado3.png"
	
	override method finalizarAnimacion() {
		objeto.image(self.movimientoFinal())
		objeto.resusitarOTerminar()
	}
}
object animacionRevivir inherits Animacion(objeto = bill ) {

    const intervaloParpadeo = 25                   // Intervalo de parpadeo en milisegundos
    
    var tiempoParpadeando = 0
	
//	override method secuenciaDeMovimientos() = []
	
	override method spritesIzquierda() = []
	override method spritesDerecha() = []
	
	method respawn() {
    	tiempoParpadeando = 0 // Reinicia el contador de tiempo parpadeando
    	objeto.volverInvulnerable()
    	objeto.hayAnimacionEnCurso(false)
    	objeto.image("quieto.png") //tendria que ser un mensaje a los sprites con posicionBaseDePJ(self)
        self.parpadearImagen()
    }
    
    method parpadearImagen() {
    // Alternar la visibilidad de bill para simular el parpadeo
        if (objeto.invulnerable()) {
         self.sacarYAgregarVisualSiTiene()
         tiempoParpadeando += intervaloParpadeo
         self.realizarParpadeo()
       }
    }
    
    method realizarParpadeo() {
    	if (tiempoParpadeando < objeto.duracionInvulnerabilidad()) {
            game.schedule(intervaloParpadeo, { self.parpadearImagen() })
      } else {
            self.finalizarInvulnerabilidadYDejarVisual()
      }
    }
    
    method sacarYAgregarVisualSiTiene() {
    	if (game.hasVisual(objeto)) {
            game.removeVisual(objeto)
      } else {
        game.addVisual(objeto)
      }
    }
   method finalizarInvulnerabilidadYDejarVisual() {
        if (not game.hasVisual(objeto)) {
             game.addVisual(objeto)       // Asegurarse de que bill sea visible
        }
        objeto.quitarInvulnerabilidad()
    }
   
}

object animadorMovimientoSubir inherits Animacion(objeto = bill ) {
	
	override method spritesIzquierda() = ["subirIzq1.png","subirIzq2.png","subirIzq3.png"]

	override method spritesDerecha() = ["subir1.png","subir2.png","subir3.png"]	
	
}

object animadorMovimiento inherits Animacion(objeto = bill ) {
	
	override method spritesIzquierda() {
		return ["atras1.png", "atras2.png", "atras3.png"]
	}
	override method spritesDerecha() {
		return ["paso1.png", "paso2.png", "paso3.png"]
	}	
}
//enemigo
class AnimacionGolpeEnemigo inherits Animacion {  
	
	 override method spritesDerecha() {
		return [objeto.toString()+"golpe1.png", objeto.toString()+"golpe1.png", objeto.toString()+"golpe2.png", objeto.toString()+"golpe3.png"]
	}
	override method spritesIzquierda() {
		return [objeto.toString()+"golpe1Izq.png", objeto.toString()+"golpe1Izq.png", objeto.toString()+"golpe2Izq.png", objeto.toString()+"golpe3Izq.png"]
	}
}
class AnimacionDanioEnemigo inherits Animacion{ 
	
	 override method spritesDerecha() {
		return [objeto.toString()+"danio1.png", objeto.toString()+"danio1.png", objeto.toString()+"danio1.png"]
	}
	override method spritesIzquierda() {
		return [objeto.toString()+"danio1Izq.png", objeto.toString()+"danio1Izq.png", objeto.toString()+"danio1Izq.png"]
	}
}
class AnimacionDerrotaEnemigo inherits Animacion { //refactor
	
	override method spritesDerecha() {
		return [objeto.toString()+"derrota1.png", objeto.toString()+"derrota1.png", objeto.toString()+"derrota2.png",
                objeto.toString()+"derrota2.png", objeto.toString()+"derrota3.png", objeto.toString()+"derrota3.png"]
	}
	
	override method spritesIzquierda() {
		return [objeto.toString()+"derrota1Izq.png", objeto.toString()+"derrota1Izq.png", objeto.toString()+"derrota2Izq.png", 
                objeto.toString()+"derrota2Izq.png", objeto.toString()+"derrota3Izq.png", objeto.toString()+"derrota3Izq.png"]
	}
	
	override method movimientoFinal() = if (objeto.direccionMirando() == "Izquierda") objeto.toString()+"derrota3Izq.png" else objeto.toString()+"derrota3.png"
	
	override method finalizarAnimacion() {
		objeto.image(self.movimientoFinal())
		objeto.desaparecer()  //el enemigo muere 
	}
}
class AnimadorMovimientoEnemigo inherits Animacion{
	
	override method spritesIzquierda() {
		return [objeto.toString()+"atras1.png", objeto.toString()+"atras2.png", objeto.toString()+"atras3.png"]
	}
	override method spritesDerecha() {
		return [objeto.toString()+"paso1.png", objeto.toString()+"paso2.png", objeto.toString()+"paso3.png"]
	}	
}
//--enemigoB
//object animacionGolpeEnemigoB inherits Animacion(objeto = enemigoB ) { 
//	
//	 override method spritesDerecha() {
//		return ["enemigoBgolpe1.png", "enemigoBgolpe1.png", "enemigoBgolpe2.png", "enemigoBgolpe3.png"]
//	}
//	override method spritesIzquierda() {
//		return ["enemigoBgolpe1Izq.png", "enemigoBgolpe1Izq.png", "enemigoBgolpe2Izq.png", "enemigoBgolpe3Izq.png"]
//	}
//}
//object animacionDanioEnemigoB inherits Animacion(objeto = enemigoB ) { 
//	
//	 override method spritesDerecha() {
//		return ["enemigoBdanio1.png", "enemigoBdanio1.png", "enemigoBdanio1.png"]
//	}
//	override method spritesIzquierda() {
//		return ["enemigoBdanio1Izq.png", "enemigoBdanio1Izq.png", "enemigoBdanio1Izq.png"]
//	}
//}
//object animacionDerrotaEnemigoB inherits Animacion(objeto = enemigoB ) {
//	
//	override method spritesDerecha() {
//		return ["enemigoBderrota1.png", "enemigoBderrota1.png", "enemigoBderrota2.png",
//                "enemigoBderrota2.png", "enemigoBderrota3.png", "enemigoBderrota3.png"]
//	}
//	
//	override method spritesIzquierda() {
//		return ["enemigoBderrota1Izq.png", "enemigoBderrota1Izq.png", "enemigoBderrota2Izq.png", 
//               "enemigoBderrota2Izq.png", "enemigoBderrota3Izq.png", "enemigoBderrota3Izq.png"]
//	}
//	
//	override method movimientoFinal() = if (objeto.direccionMirando() == "Izquierda") "enemigoBderrota3Izq.png" else "enemigoBderrota3.png"
//	
//	override method finalizarAnimacion() {
//		objeto.image(self.movimientoFinal())
//		objeto.resusitarOTerminar()  //el enemigo muere 
//	}
//}
//object animadorMovimientoEnemigoB inherits Animacion(objeto = enemigoB ) {
//	
//	override method spritesIzquierda() {
//		return ["enemigoBatras1.png", "enemigoBatras2.png", "enemigoBatras3.png"]
//	}
//	override method spritesDerecha() {
//		return ["enemigoBpaso1.png", "enemigoBpaso2.png", "enemigoBpaso3.png"]
//	}	
//}

object animacionMainMenu inherits Animacion(objeto = mainMenu) {

	override method spritesIzquierda() {}
	
	override method spritesDerecha() { 
		return ["spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png",
		       "spriteMainMenu0.png", "spriteMainMenu1.png", "spriteMainMenu2.png",  "spriteMainMenu3.png", "spriteMainMenu4.png", "spriteMainMenu5.png",
			    "spriteMainMenu6.png", "spriteMainMenu7.png", "spriteMainMenu8.png", "spriteMainMenu10.png", "spriteMainMenu11.png", "spriteMainMenu12.png",
			    "spriteMainMenu13.png", "spriteMainMenu14.png", "spriteMainMenu0.png", "spriteMainMenu0.png", "spriteMainMenu0.png", "spriteMainMenu0.png",
			    "spriteMainMenu0.png", "spriteMainMenu0.png", "spriteMainMenu0.png", "spriteMainMenu0.png", "spriteMainMenu0.png", "spriteMainMenu0.png",
			    "spriteMainMenu0.png", "spriteMainMenu0.png", "spriteMainMenu27.png", "spriteMainMenu28.png", "spriteMainMenu29.png", "spriteMainMenu30.png",
			    "spriteMainMenu31.png", "spriteMainMenu32.png", "spriteMainMenu33.png", "spriteMainMenu34.png", "spriteMainMenu35.png", "spriteMainMenu36.png",
			    "spriteMainMenu37.png", "spriteMainMenu38.png", "spriteMainMenu39.png", "spriteMainMenu40.png", "spriteMainMenu41.png", "spriteMainMenu42.png",
			    "spriteMainMenu43.png", "spriteMainMenu44.png", "spriteMainMenu45.png", "spriteMainMenu46.png", "spriteMainMenu47.png", "spriteMainMenu48.png",
			    "spriteMainMenu49.png", "spriteMainMenu50.png", "spriteMainMenu51.png", "spriteMainMenu52.png", "spriteMainMenu53.png", "spriteMainMenu54.png",
			    "spriteMainMenu55.png", "spriteMainMenu56.png", "spriteMainMenu57.png", "spriteMainMenu58.png", "spriteMainMenu59.png", "spriteMainMenu60.png",
			    "spriteMainMenu61.png", "spriteMainMenu62.png", "spriteMainMenu63.png", "spriteMainMenu64.png", "spriteMainMenu65.png", "spriteMainMenu66.png"
		]
	}	
	override method intervaloEntreAnimacion(animaciones) = game.schedule(80, { self.siguienteFrame(animaciones) })
	
//	override method finalizarAnimacion() {  //crea el nivel 1 cuando se abre la puerta 
//	    self.reiniciarControlador()
//	}
	
	override method movimientoFinal() ="spriteMainMenu66.png"
    
//    method detenerAnimacion() {
//    	personaje.permitirAnimacion(false)
//        personaje.hayAnimacionEnCurso(true)
////    	self.reiniciarControlador()
//    }
}

object animadorPuerta inherits Animacion(objeto = puerta ) {
	
	override method spritesIzquierda() {}
	
	override method spritesDerecha() {
		return [ "puerta1.png", "puerta2.png", "puerta3.png", "puerta4.png", "puerta5.png", 
		         "puerta6.png", "puerta7.png", "puerta8.png", "puerta9.png", "puerta10.png",
			     "puerta11.png", "puerta12.png", "puerta13.png", "puerta14.png", "puerta15.png", 
			     "puerta16.png", "puerta17.png", "puerta18.png", "puerta19.png", "puerta20.png"
			   ]
	}
	
	override method intervaloEntreAnimacion(animaciones) = game.schedule(150, { self.siguienteFrame(animaciones) }) 
	
	override method finalizarAnimacion() {  //crea el nivel 1 cuando se abre la puerta 
//	    self.reiniciarControlador()
	    game.sound("motor.wav").play()
		const nivel1 = new Nivel1(sonido = game.sound("citySlumStage1.wav"))
		escenario.removerNivel()
		escenario.iniciarNivel(nivel1)
	}	
}
	
//import personajes.*
//import wollok.game.*
//import sprites.*
//
//class AnimacionManager {
//  
//  var indiceSpriteActual = 0
//	
//  method secuenciaDeMovimientos()
//  
//  
//  method iniciarAnimacion() {
//  	const animaciones = self.secuenciaDeMovimientos()
//
//    bill.cambiarImage(animaciones.get(indiceSpriteActual))  //cambia al primer sprite de la lista
//    self.siguienteFrame(animaciones)
//  }
//
//  method siguienteFrame(animaciones) {
//   if (bill.permitirAnimacion()) {   //esto permite que la animacion corte en caso de ser derrotado y asi evita la superposicion del siguiente frame 
//    		self.controlarFrame(animaciones)
//    	} else {
//    		indiceSpriteActual = 0
//    		bill.permitirAnimacion(true)
//    	} 
//  }
//  
//  method controlarFrame(animaciones) {    //se encarga de iterar sobre la lista de sprites devolviendo el frame siguiente 
//	    if (indiceSpriteActual < animaciones.size() - 1) {
//	      indiceSpriteActual++
//	      bill.cambiarImage(animaciones.get(indiceSpriteActual))
//	      self.intervaloDeAnimacion(animaciones)          
//	                  
//	    } else {
//	      // Termina la animación y resetea los valores
//	      indiceSpriteActual = 0
//	      self.finalizarAnimacion()
//        }
//  }
// 
//  
//  method gestionarDirDeSprite(primerCadena, segundaCadena) {                 // decide que sprites usar dependiendo de donde este mirando el personaje
//    	return if (bill.directionMirando() == "Izquierda") {segundaCadena}
//    	       else                                        {primerCadena}
//  }
//  
//  method interrumpirAnimacion(nuevaAnim) {       //metodo para interrumpir todas las demas animaciones si estan en progreso
//    bill.permitirAnimacion(false)
//    game.schedule(100,  nuevaAnim )
//  }
//    
//  method intervaloDeAnimacion(animaciones) { 
//  	game.schedule(130, { self.siguienteFrame(animaciones) }) // programar el próximo frame, por ejemplo en 200ms
//  }
//  
//  method finalizarAnimacion() {
//  	bill.finalizarAnimacion(bill.spriteBaseSegurDir()) // vuelve a habilitar las animaciones y regresar al sprite base
//  }   
//}
//
