import wollok.game.*
import movimientos.*
import movimientos.*
import animacion.*
import barraHP.*

object bill {
    
	var property position 
	var property image = "quieto.png"
	var property estaEnAnimacion = false
	var property directionMirando = "Derecha"
	var property permitirAnimacion = true        // Nueva flag para controlar la animación
	
	
	var property barraVida = 100  // La barra de HP llena sería 100
	var property vidas = 3    // Inicializa bill con 3 vidas
	var property invulnerable = false
	
    const duracionInvulnerabilidad = 1500 // La duración de la invulnerabilidad en milisegundos
    const intervaloParpadeo = 25 // Intervalo de parpadeo en milisegundos
    var tiempoParpadeando = 0 // Un contador para saber cuánto tiempo ha estado parpadeando	
    
    var property golpesRecibidos = 0
    var property tiempoParaDanioRapido = 2000 // Tiempo en milisegundos 

	
	method cambiarImage(_image) {
		self.image(_image)
	}
	//---------codigo cuando resive daño o muere o respawnea
	method recibirDanio(cantidad) {  
        if (not invulnerable) {      
        	barraVida -= cantidad  
        	invulnerable = true   //        
            barraDeHp.actualizarVida(barraVida)
            self.gestionarAnimacionDeDanio()      //self.interrumpirAnimacion( { self.iniciarAnimacionDeDanio() } )        
        } 
    }
 	method gestionarAnimacionDeDanio() {
 		golpesRecibidos++	
        if (golpesRecibidos == 1) {
            self.interrumpirAnimacion( { self.iniciarAnimacionDeDanio(self.spritesDanio(["danioIzq1.png", "danioIzq1.png", "danioIzq1.png"], 
            	                                                                        ["danio1.png", "danio1.png", "danio1.png"])) } )     //animacion de daño normal 
                                                                                          
        } else if (golpesRecibidos == 2) {
            self.interrumpirAnimacion( { self.iniciarAnimacionDeDanio(self.spritesDanio(["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"], 
            	                                                                        ["danio2.png", "danio2.png", "danio2.png"])) } )     //animacion de daño medio
                                                                                     
        } else {
            golpesRecibidos = 0	                                                                            	       	
            self.interrumpirAnimacion( { self.iniciarAnimacionDeDanio(self.spritesDanio(["danioIzq3.png", "danioIzq3.png", "danioIzq4.png", 
            	                                                                         "danioIzq4.png", "danioIzq5.png", "danioIzq5.png",
            	                                                                         "danioIzq6.png", "danioIzq6.png"],                  //animacion de daño critico
            	                                                                         
            	                                                                        ["danio3.png", "danio3.png", "danio4.png",
            	                                                                         "danio4.png", "danio5.png", "danio5.png", 
            	                                                                         "danio6.png", "danio6.png"])) } )    
        }
            game.schedule(tiempoParaDanioRapido, { golpesRecibidos = 0 })  //reinicia la flag para la animacion despues de un determinado tiempo sin recibir daño 
       		
 	}     
     
// 	method gestionarAnimacionDeDanio() {
//      if (enAnimacionDanioRapido) {
//        // Si Bill recibe daño nuevamente dentro de un corto período de tiempo, muestra una animación de daño diferente
//          self.interrumpirAnimacion( { self.iniciarAnimacionDeDanio(self.spritesDanio(["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"],
//          	                                                                          ["danio2.png", "danio2.png", "danio2.png"])) } ) //agregar sprites de daño alterno
//      } else {
//          self.interrumpirAnimacion( { self.iniciarAnimacionDeDanio(self.spritesDanio(["danioIzq1.png", "danioIzq1.png", "danioIzq1.png"], 
//          	                                                                          ["danio1.png", "danio1.png", "danio1.png"])) } ) //animacion de daño normal 
//          enAnimacionDanioRapido = true
//        // Resetea la flag después de un tiempo definido
//          game.schedule(tiempoParaDanioRapido, { enAnimacionDanioRapido = false })  //reinicia la flag para la animacion 
//      } 		
// 	} 
//	 
    
    method iniciarAnimacionDeDanio(tipoDeSprite) {
    	estaEnAnimacion = true
    	permitirAnimacion = true // Restablece la flag para permitir la animación 
    	animadorDanio.iniciarAnimacion( tipoDeSprite ) 
    }
    
    method derrotadoSiSeAgotaSalud(spriteDeAnimacion) {
    	if (barraVida <= 0) {
    		self.iniciarAnimacionDeDerrota()
    	} else {
    		invulnerable = false
    		estaEnAnimacion = false
    		self.cambiarImage(self.spriteBaseSegurDir())
    	}
    }
    method spritesDanio(primerCadena, segundaCadena) {
    	return if (directionMirando == "Izquierda") {primerCadena}
    	       else                                 {segundaCadena}
    }
    method spritesDerrota() {

    	return
    	if (directionMirando =="Izquierda") {
    		 (["derrotadoIzq1.png", "derrotadoIzq1.png", "derrotadoIzq1.png", "derrotadoIzq1.png",
    	       "derrotadoIzq2.png", "derrotadoIzq2.png", "derrotadoIzq2.png", "derrotadoIzq2.png",
    	       "derrotadoIzq3.png", "derrotadoIzq3.png", "derrotadoIzq3.png", "derrotadoIzq3.png"])
    	} else {
    		(["derrotado1.png", "derrotado1.png", "derrotado1.png", "derrotado1.png",
    	      "derrotado2.png", "derrotado2.png", "derrotado2.png", "derrotado2.png",
    	      "derrotado3.png", "derrotado3.png", "derrotado3.png", "derrotado3.png"])
    	}    	
    }
    

    method interrumpirAnimacion(nuevaAnim) {
    	permitirAnimacion = false
    	game.schedule(100,  nuevaAnim )
    }
    
    method iniciarAnimacionDeDerrota() {
    	estaEnAnimacion = true
    	permitirAnimacion = true // Restablece la flag para permitir la animación de derrota
    	animadorDeDerrota.iniciarAnimacion(self.spritesDerrota())
    }
    
    method resusitarOTerminar() {
    	if (vidas > 0) self.resusitar() else game.schedule(4000, {game.stop()}) //el game stop se puede reemplazar con un pantallazo de game over y dsp el stop 
    }
    
    method resusitar() {
    	barraVida = 100
    	vidas = vidas - 1  
    	contadorDeVidas.actualizarVidas(vidas)
        barraDeHp.actualizarVida(barraVida)
        self.respawn()
    }
    
    method respawn() {
    	self.position(game.at(1,1)) 
    	invulnerable = true
    	estaEnAnimacion = false
    	tiempoParpadeando = 0 // Reinicia el contador de tiempo parpadeando
    	self.cambiarImage("quieto.png")
        self.toggleInvulnerability()
//    	game.schedule(200, { self.toggleInvulnerability() }) // Alternar la invulnerabilidad cada 200 ms
//    	game.schedule(3000, { self.finalizarInvulnerabilidad() }) // Terminar invulnerabilidad después de 3 segundos
    }
    
    method toggleInvulnerability() {
    // Alternar la visibilidad de bill para simular el parpadeo
        if (invulnerable) {
         self.sacarYAgregarVisualSiTiene()
         tiempoParpadeando += intervaloParpadeo
         self.realizarParpadeo()
         
//         game.removeVisual(self)
//         game.schedule(200, { game.addVisual(self) })
       }
    }
    method realizarParpadeo() {
    	if (tiempoParpadeando < duracionInvulnerabilidad) {
            game.schedule(intervaloParpadeo, { self.toggleInvulnerability() })
      } else {
            self.finalizarInvulnerabilidad()
      }
    }
    method sacarYAgregarVisualSiTiene() {
    	if (game.hasVisual(self)) {
            game.removeVisual(self)
      } else {
        game.addVisual(self)
      }
    }
    
    method finalizarInvulnerabilidad() {
        invulnerable = false
        if (not game.hasVisual(self)) {
             game.addVisual(self) // Asegurarse de que bill sea visible
        }
//        game.addVisual(self) // Asegurarse de que bill sea visible si el último estado era invisible
    
    }

//movimiento y error personalizado 
	method validarMover(direccion) {
		if(not self.sePuedeMover(direccion)) {
			self.error("No puedo moverme ahi")
		} 
	}
	
	method mover(direccion) {
		     //para que no se mueva mientras esta en animacion
			self.validarMover(direccion)
			estaEnAnimacion = true
			const proxima = direccion.siguiente(self.position())
			self.position(proxima)
			directionMirando = direccion.IzqODer()	
			
	}
	
	method sePuedeMover(direccion) {
		const proxima = direccion.siguiente(self.position())
		return self.puedeOcupar(proxima)
	}
	
	
	method puedeOcupar(_posicion) {
		return _posicion.y().between(0, 1) && // Últimas tres filas después de invertir, lo mejor seria crear objetos invisibles en donde no queremos que se mueva y hacerlos solidos 
               _posicion.x().between(0, game.width() - 1)                               //return tablero.pertenece(_posicion)
	}

    method iniciarGolpe() {
        if (not estaEnAnimacion) { // Solo inicia el golpe si no está haciendo alguna animacion
          estaEnAnimacion = true
          animadorDeMovimiento.iniciarAnimacion(["golpefr1.png", "golpefr1.png", "golpefr2.png", "golpefr3.png"])
        }
    }
    
    method iniciarPatada() {
        if (not estaEnAnimacion) { // Solo inicia el golpe si no está haciendo alguna animacion
          estaEnAnimacion = true
          animadorDeMovimiento.iniciarAnimacion(["patada1.png", "patada1.png", "patada2.png", "patada2.png"])
        }
    }
//    method iniciarCodazo() {
//        if (not estaEnAnimacion) { // Solo inicia el golpe si no está haciendo alguna animacion (viejo)
//          estaEnAnimacion = true
//          animadorDeMovimiento.iniciarAnimacion(["codazo1.png", "codazo1.png", "codazo2.png"])
//        }
//    }
    	
    method finalizarAnimacion(sprite) {
        self.cambiarImage(sprite)
        estaEnAnimacion = false     
    }    
    
    method spriteBaseSegurDir() {
    	return if (directionMirando == "Izquierda") "quietoIzq.png" else "quieto.png"
    }
    
    method movimientoConAnimacionHacia(direccion) {
    	if (not self.estaEnAnimacion()) {
    	  self.mover(direccion)
    	  self.decidirSpriteMovimientoAl(direccion)
        }
    }
    
    method decidirSpriteMovimientoAl(direccion) {
    	if (direccion.esIgualA(arriba)) {
    		animadorDeMovimiento.iniciarAnimacion(["subir1.png", "subir2.png", "subir3.png", "subir4.png"])
    	} else if (direccion.esIgualA(abajo)) {
    		animadorDeMovimiento.iniciarAnimacion(["bajar1.png", "bajar2.png", "bajar3.png"])
    	} else if (direccion.esIgualA(izquierda)) {
    		animadorDeMovimiento.iniciarAnimacion(["atras1.png", "atras2.png", "atras3.png"])
    	} else {
    		animadorDeMovimiento.iniciarAnimacion(["paso1.png", "paso2.png", "paso3.png"])
    	}
    }
}









