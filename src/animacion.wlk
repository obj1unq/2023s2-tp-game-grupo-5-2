import personajes.*
import wollok.game.*
import sprites.*

class AnimacionManager {

  var indiceSpriteActual = 0
  var spriteQuieto = "quieto.png"
  	
  
  method iniciarAnimacion(listaDeSprites) {

    bill.cambiarImage(listaDeSprites.get(indiceSpriteActual))  //cambia al primer sprite de la lista
    self.siguienteFrame(listaDeSprites)
  }

  method siguienteFrame(listaDeSprites) {
   if (bill.permitirAnimacion()) {   //esto permite que la animacion corte en caso de ser derrotado y asi evita la superposicion del siguiente frame 
    		self.controlarFrame(listaDeSprites)
    	} else {
    		indiceSpriteActual = 0
    		bill.permitirAnimacion(true)
    	} 
  }
  
  method controlarFrame(listaDeSprites) {    //se encarga de iterar sobre la lista de sprites devolviendo el frame siguiente 
	    if (indiceSpriteActual < listaDeSprites.size() - 1) {
	      indiceSpriteActual++
	      bill.cambiarImage(listaDeSprites.get(indiceSpriteActual))
	      self.intervaloDeAnimacion(listaDeSprites)          
	                  
	    } else {
	      // Termina la animación y resetea los valores
	      indiceSpriteActual = 0
	      self.finalizarAnimacion()
        }
  }
  
  method seteaarSpriteBaseALaIzquierda() {
  	spriteQuieto = "quietoIzq.png"
  }
  
  method reiniciarSpriteBase() {
  	spriteQuieto = "quieto.png"
  }
  
  method interrumpirAnimacion(nuevaAnim) {       //metodo para interrumpir todas las demas animaciones si estan en progreso
    bill.permitirAnimacion(false)
    game.schedule(100,  nuevaAnim )
  }
    
  method intervaloDeAnimacion(listaDeSprites) {
  	game.schedule(130, { self.siguienteFrame(listaDeSprites) }) // programar el próximo frame, por ejemplo en 200ms
  }
  
  method finalizarAnimacion() {
  	bill.finalizarAnimacion(spriteQuieto) // vuelve a habilitar las animaciones y regresar al sprite base
  }   
}


object animadorDeMovimiento inherits AnimacionManager {
	
	
	
	override method iniciarAnimacion(_listaDeSprites) { //se encarga de decidir que sprites usar dependiendo de la ultima direccion donde miro el personaje y la accion a realizar 
		var sprites     = _listaDeSprites
		const accion    = sprites.get(0) 
		const direccion = bill.directionMirando()
		
		bill.estaEnAnimacion(true)
		
	  if (accion.startsWith("golpe") && direccion == "Izquierda") { // Cambia los sprites por los de golpe hacia la izquierda
        self.seteaarSpriteBaseALaIzquierda() 
        sprites = spritesDeGolpe.spritesGolpeIzquierda()
        
      } else if (accion.startsWith("atras")) {  // Si los sprites comienzan con "atras", entonces bill se movió a la izquierda
        self.seteaarSpriteBaseALaIzquierda() 
        
      } else if (accion.startsWith("subir") && direccion  == "Izquierda") {   // Si quiere subir y la ultima dir es izquierda
        self.seteaarSpriteBaseALaIzquierda() 
        sprites = spritesDeMovimiento.spritesSubirIzquierda()  
        
      } else if (accion.startsWith("patada") && direccion  == "Izquierda") {   // Si es patada y la ultima dir es izquierda
        self.seteaarSpriteBaseALaIzquierda() 
        sprites = spritesDePatada.spritesPatadaIzquirda()  

      } else if (accion.startsWith("bajar") && direccion  == "Izquierda") {   // Si quiere bajar y la ultima dir es izquierda
        self.seteaarSpriteBaseALaIzquierda() 
        sprites = spritesDeMovimiento.spritesAtrasIzquierda()
            
      } else  {
        self.reiniciarSpriteBase()
      }
      super(sprites)
    }
	

} 

object animadorDeDerrota inherits AnimacionManager {

	override method finalizarAnimacion() { // tiene la diferencia de que cuando termina la animacion de derrota decide si se termina el juego o revive
		bill.resusitarOTerminar()
	} 
	
}

object animadorDanio inherits AnimacionManager {
	
    method iniciarAnimacionDeDanio(tipoDeSprite) { // inicia una animacion con los sprites dados
    	bill.estaEnAnimacion(true)
    	bill.permitirAnimacion(true) 
    	self.iniciarAnimacion( tipoDeSprite ) 
    }
	
	override method finalizarAnimacion() {
		bill.derrotadoSiSeAgotaSalud(spriteQuieto)
	}
}

