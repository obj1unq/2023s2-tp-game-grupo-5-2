import personajes.*
import wollok.game.*
import inicioDelJuego.*

class Animacion {
	
	var property objeto 
	
    const intervaloParpadeo = 25                   // Intervalo de parpadeo en milisegundos
    
    var tiempoParpadeando = 0
	
	
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
		  self.hacerAlgoEntreAnimacion()
		  self.animacion()
		}
	}
	
	method hacerAlgoEntreAnimacion() {}
	
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
	
	
//metodos que usa la animacion de derrota 	
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

//enemigo

class AnimacionEnemigo inherits Animacion {
	var property objetoAnimado
	
	override method spriteBaseIzq() = objetoAnimado+"quietoIzq.png"
	override method spriteBaseDer() = objetoAnimado+"quieto.png"
}
class AnimacionGolpeEnemigo inherits AnimacionEnemigo {  
	
	 override method spritesDerecha() {
		return [objetoAnimado+"golpe1.png", objetoAnimado+"golpe1.png", objetoAnimado+"golpe2.png", objetoAnimado+"golpe3.png"]
	}
	override method spritesIzquierda() {
		return [objetoAnimado+"golpe1Izq.png", objetoAnimado+"golpe1Izq.png", objetoAnimado+"golpe2Izq.png", objetoAnimado+"golpe3Izq.png"]
	}
	
	override method hacerAlgoEntreAnimacion() { bill.recibirDanio()} //lo ideal seria pasarlo por parametro por si se quiere añadir otro jugador, pero habria que modificar el realizarAnimacion
}
class AnimacionDanioEnemigo inherits AnimacionEnemigo{ 
	
	 override method spritesDerecha() {
		return [objetoAnimado+"danio1.png", objetoAnimado+"danio1.png", objetoAnimado+"danio1.png"]
	}
	override method spritesIzquierda() {
		return [objetoAnimado+"danio1Izq.png", objetoAnimado+"danio1Izq.png", objetoAnimado+"danio1Izq.png"]
	}
	
	method gestionarAnimacionDanioEnemigo() { self.interrumpirAnimacion( { self.realizarAnimacion() } ) }
	
	override method finalizarAnimacion() {
 		super()
 		objeto.derrotadoSiSeAgotaSalud()
 	}
	
}
class AnimacionDerrotaEnemigo inherits AnimacionEnemigo { //refactor
	
	override method spritesDerecha() {
		return [objetoAnimado+"derrota1.png", objetoAnimado+"derrota1.png", objetoAnimado+"derrota2.png",
                objetoAnimado+"derrota2.png", objetoAnimado+"derrota3.png", objetoAnimado+"derrota3.png"]
	}
	
	override method spritesIzquierda() {
		return [objetoAnimado+"derrota1Izq.png", objetoAnimado+"derrota1Izq.png", objetoAnimado+"derrota2Izq.png", 
                objetoAnimado+"derrota2Izq.png", objetoAnimado+"derrota3Izq.png", objetoAnimado+"derrota3Izq.png"]
	}
	
	override method movimientoFinal() = if (objeto.direccionMirando() == "Izquierda") objetoAnimado+"derrota3Izq.png" else objetoAnimado+"derrota3.png"
	
	override method finalizarAnimacion() {
		objeto.image(self.movimientoFinal())
		self.parpadearImagen()			
	}
	
	override method finalizarInvulnerabilidadYDejarVisual() {
	 	if (game.hasVisual(objeto)) {
             game.removeVisual(objeto)        
        }      //nos aseguramos que el enemigo sea removido del tablero
	}
}
class AnimadorMovimientoEnemigo inherits AnimacionEnemigo{ 
	
	override method spritesIzquierda() {
		return [objetoAnimado+"atras1.png", objetoAnimado+"atras2.png", objetoAnimado+"atras3.png"]
	}
	override method spritesDerecha() {
		return [objetoAnimado+"paso1.png", objetoAnimado+"paso2.png", objetoAnimado+"paso3.png"]
	}
	
		
}
class AnimadorMovimientoSubirEnemigo inherits AnimacionEnemigo {
	
	override method spritesIzquierda() = [objetoAnimado+"subir1Izq.png", objetoAnimado+"subir2Izq.png", objetoAnimado+"subir3Izq.png", objetoAnimado+"subir4Izq.png"]

	override method spritesDerecha() = [objetoAnimado+"subir1.png", objetoAnimado+"subir2.png", objetoAnimado+"subir3.png", objetoAnimado+"subir4.png"]	
	
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
	
	override method hacerAlgoEntreAnimacion() { objeto.daniarEnemigosSiExisten() }
}

class AnimacionGolpe2 inherits Animacion {
	
	 override method spritesDerecha() {
		return ["golpe2-1.png", "golpe2-1.png", "golpe2-2.png", "golpe2-3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq2-1.png", "golpeIzq2-1.png", "golpeIzq2-2.png", "golpeIzq2-3.png"]
	}	
	
	override method hacerAlgoEntreAnimacion() { objeto.daniarEnemigosSiExisten() }	
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
	override method hacerAlgoEntreAnimacion() { objeto.daniarEnemigosSiExisten() }
}

class AnimacionPatada2 inherits Animacion {

	 override method spritesDerecha() {
		return ["patada2-1.png", "patada2-1.png", "patada2-2.png", "patada2-2.png", "patada2-3.png", "patada2-4.png" ]  
	}
    
	override method spritesIzquierda() {
		return ["patadaIzq2-1.png", "patadaIzq2-1.png", "patadaIzq2-2.png", "patadaIzq2-2.png", "patadaIzq2-3.png", "patadaIzq2-4.png" ]
	}	
	
	override method hacerAlgoEntreAnimacion() { objeto.daniarEnemigosSiExisten() }
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

	override method spritesIzquierda() = []
	override method spritesDerecha() = []
	
	method respawn() {
    	tiempoParpadeando = 0 // Reinicia el contador de tiempo parpadeando
    	objeto.volverInvulnerable()
    	objeto.hayAnimacionEnCurso(false)
    	objeto.image("quieto.png") //tendria que ser un mensaje a los sprites con posicionBaseDePJ(self)
        self.parpadearImagen()
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
		return ["logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", 
			    "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", 
			    "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png", "logo.png",
			    "logo1.png",  "logo2.png", "logo3.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png","spriteMainMenu0.png",
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
	
	override method movimientoFinal() ="spriteMainMenu66.png"
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
	    game.sound("motor.wav").play()
		const nivel1 = new Nivel1(sonido = game.sound("citySlumStage1.wav"))
		escenario.removerNivel()
		escenario.guardarNivel(nivel1)
		escenario.iniciarNivel(nivel1)
	}	
}

object animadorElevador inherits Animacion(objeto = elevador) {
	
	override method spritesIzquierda() {}
	
	override method spritesDerecha() {
		return ["elevador1.png", "elevador1.png", "elevador2.png", "elevador2.png", "elevador3.png", "elevador3.png"]
	}
	
	override method finalizarAnimacion() {  
	    enemigoManager.agregarJefe(enemigoC,9,2,140) 
	    game.removeVisual(elevador)
	}	
	
}

object animadorPared inherits Animacion(objeto = pared) { 
	
	override method spritesIzquierda() {}
	
	override method spritesDerecha() {
		return ["pared1.png", "pared2.png", "pared2.png","pared2.png", "pared3.png","pared3.png", "pared3.png", "pared4.png", "pared4.png", "pared4.png"]
	}
	
	override method finalizarAnimacion() {  
	    enemigoManager.agregarJefe(enemigoC,3,2,140) 
	    game.removeVisual(pared)
	}
}


object destrabarPersonaje inherits Animacion(objeto = bill ) {
	override method spritesDerecha() {
		return ["paso1.png", "paso2.png", "paso3.png"]
	}	
	override method spritesIzquierda() {}
	
	method habilitarMovimientos() {
		self.interrumpirAnimacion( { self.realizarAnimacion() } )
	}
}

