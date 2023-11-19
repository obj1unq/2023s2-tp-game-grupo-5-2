import wollok.game.*
import movimientos.*
import movimientos.*
import animacion.*
import barraHP.*
import sprites.*

object bill {
    
	var property position = game.at(1,1)
	var property image = "quieto.png"
	var property estaEnAnimacion = false
	var property directionMirando = "Derecha"
	var property permitirAnimacion = true          // Nueva flag para controlar la animación
	                                                     
	const property barraDeVida = barraDeHP         
                                                   
	//var property vidas = 3                         // Inicializa bill con 3 vidas
	var invulnerable = false                          
	                                               
    const duracionInvulnerabilidad = 1500          // La duración de la invulnerabilidad en milisegundos
    const intervaloParpadeo = 25                   // Intervalo de parpadeo en milisegundos
    var tiempoParpadeando = 0                      // Un contador para saber cuánto tiempo ha estado parpadeando	
                                                   
    var property golpesRecibidos = 0               
	
	method cambiarImage(_image) {
		self.image(_image)
	}
	

	method volverInvulnerable() {
		invulnerable = true
	}
	
	method quitarInvulnerabilidad() {
		invulnerable = false
	}
	
	
	method aumentarGolpesRecibidos() {
		golpesRecibidos++
	}
	
	//---------codigo cuando recibe daño o muere o respawnea
	method recibirDanio() {  
        if (not invulnerable) {      

        	self.volverInvulnerable()     
            barraDeVida.descontar()
            self.gestionarAnimacionDeDanio()   
        } 
    }
    
 	method gestionarAnimacionDeDanio() {
 		
 		
 		self.aumentarGolpesRecibidos()	
        if (golpesRecibidos == 1) { 
            spritesDanioNormal.interrumpirAnimacion( { spritesDanioNormal.iniciarAnimacion() } )     //animacion de daño normal 
                                                                                          
        } else if (golpesRecibidos == 2) {
            spritesDanioMedio.interrumpirAnimacion( { spritesDanioMedio.iniciarAnimacion() } )       //animacion de daño medio
                                                                                     
        } else {
            golpesRecibidos = 0	                                                                            	       	
            spritesDanioCritico.interrumpirAnimacion( { spritesDanioCritico.iniciarAnimacion() } )   //animacion de daño critico
        }
            game.schedule(2000, { golpesRecibidos = 0 })  //reinicia la flag para la animacion despues de un determinado tiempo sin recibir daño 
       		
 	} 
 	
    
    method derrotadoSiSeAgotaSalud(spriteDeAnimacion) {
    	if (barraDeVida.cantidadDeVida() <= 0 ) {
    		self.iniciarAnimacionDeDerrota()
    	} else {
    		self.quitarInvulnerabilidad()
    		self.estaEnAnimacion(false)
    		self.cambiarImage(self.spriteBaseSegurDir())
    	}
    }
    
    method iniciarAnimacionDeDerrota() {
    	self.estaEnAnimacion(true)
    	self.permitirAnimacion(true)// Restablece la flag para permitir la animación de derrota
    	spritesDeDerrota.iniciarAnimacion()
    }
    
    method resusitarOTerminar() {
    	if (barraDeVida.quedanVidasSuficientes()) self.resusitar() else game.schedule(4000, {game.stop()}) //el game stop se puede reemplazar con un pantallazo de game over y dsp el stop 
    }
    
    method resusitar() {
        barraDeVida.reiniciarSaludYEstados()
    	contadorDeVidas.actualizarVidas()   //cambiar esto esta solo para probar
        self.respawn()  
    }
    
    method respawn() {
    	tiempoParpadeando = 0 // Reinicia el contador de tiempo parpadeando
    	self.position(game.at(1,1)) 
    	self.volverInvulnerable()
    	self.estaEnAnimacion(false)
    	self.cambiarImage("quieto.png") //tendria que ser un mensaje a los sprites con posicionBaseDePJ(self)
        self.parpadearImagen()
    }
    
    method parpadearImagen() {
    // Alternar la visibilidad de bill para simular el parpadeo
        if (invulnerable) {
         self.sacarYAgregarVisualSiTiene()
         tiempoParpadeando += intervaloParpadeo
         self.realizarParpadeo()
       }
    }
    
    method realizarParpadeo() {
    	if (tiempoParpadeando < duracionInvulnerabilidad) {
            game.schedule(intervaloParpadeo, { self.parpadearImagen() })
      } else {
            self.finalizarInvulnerabilidadYDejarVisual()
      }
    }
    
    method sacarYAgregarVisualSiTiene() {
    	if (game.hasVisual(self)) {
            game.removeVisual(self)
      } else {
        game.addVisual(self)
      }
    }
    
    method finalizarInvulnerabilidadYDejarVisual() {
        if (not game.hasVisual(self)) {
             game.addVisual(self)       // Asegurarse de que bill sea visible
        }
        self.quitarInvulnerabilidad() 
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
          self.estaEnAnimacion(true)
          spritesDeGolpe.iniciarAnimacion()
        }
    }
    
    method iniciarPatada() {
        if (not estaEnAnimacion) { // Solo inicia el golpe si no está haciendo alguna animacion
          self.estaEnAnimacion(true)
          spritesDePatada.iniciarAnimacion()
        }
    }
    	
    method finalizarAnimacion(sprite) {
        self.cambiarImage(sprite)
        self.estaEnAnimacion(false) 
    }    
    
    method spriteBaseSegurDir() {
    	return if (directionMirando == "Izquierda") "quietoIzq.png" else "quieto.png"
    }
    
    method movimientoConAnimacionHacia(direccion) {
    	if (not self.estaEnAnimacion()) {
    	  self.mover(direccion)
    	  direccion.animar()
        }
    }
    

}









