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
    	return if (objeto.direccionMirando() == "Izquierda") self.spriteBaseIzq() else self.spriteBaseDer()
    }
		
	
//	method reiniciarControlador() {
//		self.hayAnimacionEnCurso(false)
//		self.permitirAnimacion(true)
//	}
	method spriteBaseIzq() = "quietoIzq.png"
	method spriteBaseDer() = "quieto.png"
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

//enemigo

class AnimacionEnemigo inherits Animacion {
	override method spriteBaseIzq() = "enemigoAquietoIzq.png"
	override method spriteBaseDer() ="enemigoAquieto.png"
}
class AnimacionGolpeEnemigo inherits AnimacionEnemigo {  
	
	 override method spritesDerecha() {
		return ["enemigoAgolpe1.png", "enemigoAgolpe1.png", "enemigoAgolpe2.png", "enemigoAgolpe3.png"]
	}
	override method spritesIzquierda() {
		return ["enemigoAgolpe1Izq.png", "enemigoAgolpe1Izq.png", "enemigoAgolpe2Izq.png", "enemigoAgolpe3Izq.png"]
	}
}
class AnimacionDanioEnemigo inherits AnimacionEnemigo{ 
	
	 override method spritesDerecha() {
		return ["enemigoAdanio1.png", "enemigoAdanio1.png", "enemigoAdanio1.png"]
	}
	override method spritesIzquierda() {
		return ["enemigoAdanio1Izq.png", "enemigoAdanio1Izq.png", "enemigoAdanio1Izq.png"]
	}
}
class AnimacionDerrotaEnemigo inherits AnimacionEnemigo { //refactor
	
	override method spritesDerecha() {
		return ["enemigoAderrota1.png", "enemigoAderrota1.png", "enemigoAderrota2.png",
                "enemigoAderrota2.png", "enemigoAderrota3.png", "enemigoAderrota3.png"]
	}
	
	override method spritesIzquierda() {
		return ["enemigoAderrota1Izq.png", "enemigoAderrota1Izq.png", "enemigoAderrota2Izq.png", 
                "enemigoAderrota2Izq.png", "enemigoAderrota3Izq.png", "enemigoAderrota3Izq.png"]
	}
	
	override method movimientoFinal() = if (objeto.direccionMirando() == "Izquierda") "enemigoAderrota3Izq.png" else "enemigoAderrota3.png"
	
	override method finalizarAnimacion() {
		objeto.image(self.movimientoFinal())
		objeto.desaparecer()  //el enemigo muere  
	}
}
class AnimadorMovimientoEnemigo inherits AnimacionEnemigo{ 
	
	override method spritesIzquierda() {
		return ["enemigoAatras1.png", "enemigoAatras2.png", "enemigoAatras3.png"]
	}
	override method spritesDerecha() {
		return ["enemigoApaso1.png", "enemigoApaso2.png", "enemigoApaso3.png"]
	}
	
		
}
class AnimadorMovimientoSubirEnemigo inherits AnimacionEnemigo {
	
	override method spritesIzquierda() = ["enemigoAsubir1Izq.png","enemigoAsubir2Izq.png","enemigoAsubir3Izq.png","enemigoAsubir4Izq.png"]

	override method spritesDerecha() = ["enemigoAsubir1.png","enemigoAsubir2.png","enemigoAsubir3.png", "enemigoAsubir4.png"]	
	
}




class AnimacionGolpe inherits Animacion { 
	
	 override method spritesDerecha() {
		return ["golpefr1.png", "golpefr1.png", "golpefr2.png", "golpefr3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq1.png", "golpeIzq1.png", "golpeIzq2.png", "golpeIzq3.png"]
	}
	
	method gestionarAnimacionDeGolpe() {
		
		if (objeto.golpesDados() == 1 ) self.realizarAnimacion() else objeto.golpesDados(0) objeto.animacionAlGolpear2().realizarAnimacion() 
	}
}

class AnimacionGolpe2 inherits Animacion {
	
	 override method spritesDerecha() {
		return ["golpe2-1.png", "golpe2-1.png", "golpe2-2.png", "golpe2-3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq2-1.png", "golpeIzq2-1.png", "golpeIzq2-2.png", "golpeIzq2-3.png"]
	}	
	
	
}

class AnimacionPatada inherits Animacion {
	
	 override method spritesDerecha() {
		return ["patada1.png", "patada1.png", "patada2.png", "patada2.png"]
	}
    
	override method spritesIzquierda() {
		return ["patadaIzq1.png", "patadaIzq2.png", "patadaIzq3.png", "patadaIzq4.png", "patadaIzq4.png"]
	}
	
	method gestionarAnimacionDePatada() {
		if (objeto.patadasDadas() == 1 ) self.realizarAnimacion() else objeto.patadasDadas(0) objeto.animacionAlPatear2().realizarAnimacion() 
	}
}

class AnimacionPatada2 inherits Animacion {

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

class AnimacionDanio inherits AnimadorDeTiposDeDanio {					
	
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
            objeto.animacionDanioMedio().interrumpirAnimacion( { objeto.animacionDanioMedio().realizarAnimacion() } )       //animacion de daño medio
                                                                                     
        } else {
            objeto.golpesRecibidos(0) 
            objeto.animacionDanioCritico().interrumpirAnimacion( { objeto.animacionDanioCritico().realizarAnimacion() } )   //animacion de daño critico
        }
            game.schedule(4000, { objeto.golpesRecibidos(0)  })  //reinicia la flag para la animacion despues de un determinado tiempo sin recibir daño 
       		
 	}
 	 
}

class AnimacionDanioMedio inherits AnimadorDeTiposDeDanio {
	
	override method spritesDerecha() {
		return ["danio2.png", "danio2.png", "danio2.png"] 
	}
	
	override method spritesIzquierda() {
		return ["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"]
	}
}

class AnimacionDanioCritico inherits AnimadorDeTiposDeDanio {
	
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

class AnimacionDerrota inherits Animacion {
	
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
class AnimacionRevivir inherits Animacion {

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

class AnimadorMovimientoSubir inherits Animacion {
	
	override method spritesIzquierda() = ["subirIzq1.png","subirIzq2.png","subirIzq3.png"]

	override method spritesDerecha() = ["subir1.png","subir2.png","subir3.png"]	
	
}

class AnimadorMovimiento inherits Animacion {
	
	override method spritesIzquierda() {
		return ["atras1.png", "atras2.png", "atras3.png"]
	}
	override method spritesDerecha() {
		return ["paso1.png", "paso2.png", "paso3.png"]
	}	
}












object animacionMainMenu inherits Animacion(objeto = mainMenu) {

	override method spritesIzquierda() {}
	
	override method spritesDerecha() { 
		return ["spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png",
			    "spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png",
			    "spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png",
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
