import personajes.*
import wollok.game.*

class Animacion {
	
	const property personaje = bill
	
	const controlDeAnimaciones = controlDeAnimacion
	
	//const animaciones = self.gestionarDirDeSprite()
	
	var indiceSpriteActual = 0
	                      
	method intervaloEntreAnimacion(animaciones) = game.schedule(130, { self.siguienteFrame(animaciones) }) //se creo el parametro animaciones porque el metodo siguienteFrame lo requeria 
	
	method animacionActual(indice,animaciones) = animaciones.get(indice)
	
	method movimientoFinal()  {
    	return if (personaje.direccionMirando() == "Izquierda") "quietoIzq.png" else "quieto.png"
    }
	
	//method secuenciaDeMovimientos() = self.gestionarDirDeSprite()
	
	method spritesIzquierda() 
	
	method spritesDerecha() 
	
	method aumentarIndice() {
		indiceSpriteActual = indiceSpriteActual + 1 
	}
	method realizarAnimacion() {
	  if(controlDeAnimaciones.puedeRealizarAnimacion()) {
		  controlDeAnimaciones.hayAnimacionEnCurso(true)
		  controlDeAnimaciones.permitirAnimacion(true) 
		  self.animacion()
		}
	}
	method animacion() {
		const animaciones = self.gestionarDirDeSprite()  //se tiene que crear localmente ya que si no no se actualiza 
//		if(not animaciones.isEmpty()) { 
		personaje.image(self.animacionActual(indiceSpriteActual,animaciones))    //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		self.siguienteFrame(animaciones)                                         //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const     
	}
		
	method siguienteFrame(animaciones) {                                         //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		if(controlDeAnimaciones.permitirAnimacion()) {
			self.controlarFrame(animaciones)                                     //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		}
		else {
			indiceSpriteActual = 0
			controlDeAnimaciones.permitirAnimacion(true)
		}
	}
	method controlarFrame(animaciones) {                                          //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		if(indiceSpriteActual < animaciones.size() - 1) {
			self.aumentarIndice() 
			personaje.image(self.animacionActual(indiceSpriteActual,animaciones)) 
			self.intervaloEntreAnimacion(animaciones)                             //se la tenemos que pasar por parammetro a los sub metodos para no perder el scope de la const
		} 
		else {
			indiceSpriteActual = 0
			self.finalizarAnimacion()
		}
	}
	
	method gestionarDirDeSprite() {                 // decide que sprites usar dependiendo de donde este mirando el personaje
    	return if ( personaje.direccionMirando() == "Izquierda") {self.spritesIzquierda()}
    	       else                                              {self.spritesDerecha()}
  }
  
	method interrumpirAnimacion(nuevaAnim) {       //metodo para interrumpir todas las demas animaciones si estan en progreso
     controlDeAnimaciones.permitirAnimacion(false)
     controlDeAnimaciones.hayAnimacionEnCurso(true)
     game.schedule(1,  {controlDeAnimaciones.hayAnimacionEnCurso(false)} )
     game.schedule(100,  nuevaAnim )
  }
    
	
	method finalizarAnimacion() {
		personaje.image(self.movimientoFinal())
		controlDeAnimaciones.hayAnimacionEnCurso(false)	
	}													
}

object controlDeAnimacion {
	
	var property hayAnimacionEnCurso = false
	
	var property permitirAnimacion = true
	
	method puedeRealizarAnimacion() {
		return not self.hayAnimacionEnCurso()
	}
	
}

object animacionGolpe inherits Animacion {
	const siguienteGolpe = animacionGolpe2
	
	 override method spritesDerecha() {
		return ["golpefr1.png", "golpefr1.png", "golpefr2.png", "golpefr3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq1.png", "golpeIzq1.png", "golpeIzq2.png", "golpeIzq3.png"]
	}
	
	method gestionarAnimacionDeGolpe() {
		personaje.aumentarGolpesDados()
		if (personaje.golpesDados() == 1 ) self.realizarAnimacion() else personaje.golpesDados(0) siguienteGolpe.realizarAnimacion() 
	}
}

object animacionGolpe2 inherits Animacion {
	
	 override method spritesDerecha() {
		return ["golpe2-1.png", "golpe2-1.png", "golpe2-2.png", "golpe2-3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq2-1.png", "golpeIzq2-1.png", "golpeIzq2-2.png", "golpeIzq2-3.png"]
	}	
	
	
}

object animacionPatada inherits Animacion {
	const siguientePatada = animacionPatada2
	
	 override method spritesDerecha() {
		return ["patada1.png", "patada1.png", "patada2.png", "patada2.png"]
	}
    
	override method spritesIzquierda() {
		return ["patadaIzq1.png", "patadaIzq2.png", "patadaIzq3.png", "patadaIzq4.png", "patadaIzq4.png"]
	}
	
	method gestionarAnimacionDePatada() {
		personaje.aumentarPatadasDadas()
		if (personaje.patadasDadas() == 1 ) self.realizarAnimacion() else personaje.patadasDadas(0) siguientePatada.realizarAnimacion() 
	}
}

object animacionPatada2 inherits Animacion {

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
 		personaje.derrotadoSiSeAgotaSalud()
 	}
}

object animacionDanio inherits AnimadorDeTiposDeDanio {					
	
	const danioMedio = animacionDanioMedio
	
	const danioCritico = animacionDanioCritico
	
	override method spritesDerecha() {
		return ["danio1.png", "danio1.png", "danio1.png"] 
	}
	
	override method spritesIzquierda() {
		return ["danioIzq1.png", "danioIzq1.png", "danioIzq1.png"]
	}
	
	method gestionarAnimacionDeDanio() {
		
 		personaje.aumentarGolpesRecibidos()	
        if (personaje.golpesRecibidos() == 1) { 
            self.interrumpirAnimacion( { self.realizarAnimacion() } )     //animacion de daño normal 
                                                                                          
        } else if (personaje.golpesRecibidos() == 2) {
            danioMedio.interrumpirAnimacion( { danioMedio.realizarAnimacion() } )       //animacion de daño medio
                                                                                     
        } else {
            personaje.golpesRecibidos(0) 
            danioCritico.interrumpirAnimacion( { danioCritico.realizarAnimacion() } )   //animacion de daño critico
        }
            game.schedule(2000, { personaje.golpesRecibidos(0)  })  //reinicia la flag para la animacion despues de un determinado tiempo sin recibir daño 
       		
 	}
 	
}

object animacionDanioMedio inherits AnimadorDeTiposDeDanio {
	
	override method spritesDerecha() {
		return ["danio2.png", "danio2.png", "danio2.png"] 
	}
	
	override method spritesIzquierda() {
		return ["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"]
	}
}

object animacionDanioCritico inherits AnimadorDeTiposDeDanio {
	
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

object animacionDerrota inherits Animacion {
	
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
	
	override method movimientoFinal() = "derrotado3.png"
	
	override method finalizarAnimacion() {
		personaje.image(self.movimientoFinal())
		personaje.resusitarOTerminar()
	}
}
object animacionRevivir inherits Animacion {

    const intervaloParpadeo = 25                   // Intervalo de parpadeo en milisegundos
    
    var tiempoParpadeando = 0
	
//	override method secuenciaDeMovimientos() = []
	
	override method spritesIzquierda() = []
	override method spritesDerecha() = []
	
	method respawn() {
    	tiempoParpadeando = 0 // Reinicia el contador de tiempo parpadeando
    	personaje.volverInvulnerable()
    	controlDeAnimaciones.hayAnimacionEnCurso(false)
    	personaje.image("quieto.png") //tendria que ser un mensaje a los sprites con posicionBaseDePJ(self)
        self.parpadearImagen()
    }
    
    method parpadearImagen() {
    // Alternar la visibilidad de bill para simular el parpadeo
        if (personaje.invulnerable()) {
         self.sacarYAgregarVisualSiTiene()
         tiempoParpadeando += intervaloParpadeo
         self.realizarParpadeo()
       }
    }
    
    method realizarParpadeo() {
    	if (tiempoParpadeando < personaje.duracionInvulnerabilidad()) {
            game.schedule(intervaloParpadeo, { self.parpadearImagen() })
      } else {
            self.finalizarInvulnerabilidadYDejarVisual()
      }
    }
    
    method sacarYAgregarVisualSiTiene() {
    	if (game.hasVisual(personaje)) {
            game.removeVisual(personaje)
      } else {
        game.addVisual(personaje)
      }
    }
   method finalizarInvulnerabilidadYDejarVisual() {
        if (not game.hasVisual(personaje)) {
             game.addVisual(personaje)       // Asegurarse de que bill sea visible
        }
        personaje.quitarInvulnerabilidad() 
    }
   
}

object animadorMovimientoSubir inherits Animacion {
	
	override method spritesIzquierda() = ["subirIzq1.png","subirIzq2.png","subirIzq3.png"]

	override method spritesDerecha() = ["subir1.png","subir2.png","subir3.png"]	
	
}

object animadorMovimiento inherits Animacion {
	
	override method spritesIzquierda() {
		return ["atras1.png", "atras2.png", "atras3.png"]
	}
	override method spritesDerecha() {
		return ["paso1.png", "paso2.png", "paso3.png"]
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
