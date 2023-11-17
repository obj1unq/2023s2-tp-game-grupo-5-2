import personajes.*
import wollok.game.*
import sprites.*

class AnimacionManager {

  var indiceSpriteActual = 0
  const animaciones = self.secuenciaDeMovimientos()
  	
  method secuenciaDeMovimientos()
  
  
  method iniciarAnimacion() {

    bill.cambiarImage(animaciones.get(indiceSpriteActual))  //cambia al primer sprite de la lista
    self.siguienteFrame( )
  }

  method siguienteFrame( ) {
   if (bill.permitirAnimacion()) {   //esto permite que la animacion corte en caso de ser derrotado y asi evita la superposicion del siguiente frame 
    		self.controlarFrame( )
    	} else {
    		indiceSpriteActual = 0
    		bill.permitirAnimacion(true)
    	} 
  }
  
  method controlarFrame( ) {    //se encarga de iterar sobre la lista de sprites devolviendo el frame siguiente 
	    if (indiceSpriteActual < animaciones.size() - 1) {
	      indiceSpriteActual++
	      bill.cambiarImage(animaciones.get(indiceSpriteActual))
	      self.intervaloDeAnimacion( )          
	                  
	    } else {
	      // Termina la animación y resetea los valores
	      indiceSpriteActual = 0
	      self.finalizarAnimacion()
        }
  }
  
//  method seteaarSpriteBaseALaIzquierda() = "quietoIzq.png"
//
//  
//  method reiniciarSpriteBase() = "quieto.png"
  
  
  method gestionarDirDeSprite(primerCadena, segundaCadena) {                 // decide que sprites usar dependiendo de donde este mirando el personaje
    	return if (bill.directionMirando() == "Izquierda") {segundaCadena}
    	       else                                        {primerCadena}
  }
  
  method interrumpirAnimacion(nuevaAnim) {       //metodo para interrumpir todas las demas animaciones si estan en progreso
    bill.permitirAnimacion(false)
    game.schedule(100,  nuevaAnim )
  }
    
  method intervaloDeAnimacion( ) { 
  	game.schedule(130, { self.siguienteFrame( ) }) // programar el próximo frame, por ejemplo en 200ms
  }
  
  method finalizarAnimacion() {
  	bill.finalizarAnimacion(bill.spriteBaseSegurDir()) // vuelve a habilitar las animaciones y regresar al sprite base
  }   
}


//object animadorDeMovimiento inherits AnimacionManager {
//	
//	
//	
//	override method iniciarAnimacion(cadenaDeSprites1, cadenaDeSprites2) { //se encarga de decidir que sprites usar dependiendo de la ultima direccion donde miro el personaje y la accion a realizar 
//		var sprites     = _listaDeSprites
//		const accion    = sprites.get(0) 
//		const direccion = bill.directionMirando()
//		
//		bill.estaEnAnimacion(true)
//		self.gestionarDirDeSprite(    )
//		
////	  if (accion.startsWith("golpe") && direccion == "Izquierda") { // Cambia los sprites por los de golpe hacia la izquierda
////        self.seteaarSpriteBaseALaIzquierda() 
////        sprites = spritesDeGolpe.spritesGolpeIzquierda()
////        
////      } else if (accion.startsWith("atras")) {  // Si los sprites comienzan con "atras", entonces bill se movió a la izquierda
////        self.seteaarSpriteBaseALaIzquierda() 
////        
////      } else if (accion.startsWith("subir") && direccion  == "Izquierda") {   // Si quiere subir y la ultima dir es izquierda
////        self.seteaarSpriteBaseALaIzquierda() 
////        sprites = spritesDeMovimiento.spritesSubirIzquierda()  
////        
////      } else if (accion.startsWith("patada") && direccion  == "Izquierda") {   // Si es patada y la ultima dir es izquierda
////        self.seteaarSpriteBaseALaIzquierda() 
////        sprites = spritesDePatada.spritesPatadaIzquirda()  
////
////      } else if (accion.startsWith("bajar") && direccion  == "Izquierda") {   // Si quiere bajar y la ultima dir es izquierda
////        self.seteaarSpriteBaseALaIzquierda() 
////        sprites = spritesDeMovimiento.spritesAtrasIzquierda()  // hacer que bill decida si da el sprite de derecha o izquierda en vez de hacer tantos if aca
////            
////      } else  {
////        self.reiniciarSpriteBase()
////      }
//      super(sprites)
//    }
//	
//
//} 

//object animadorDeDerrota inherits AnimacionManager {
//
//	override method finalizarAnimacion() { // tiene la diferencia de que cuando termina la animacion de derrota decide si se termina el juego o revive
//		bill.resusitarOTerminar()
//	} 
//	
//}
//
//object animadorDanio inherits AnimacionManager {
//	
//    method iniciarAnimacionDeDanio(tipoDeSprite) { // inicia una animacion con los sprites dados
//    	bill.estaEnAnimacion(true)
//    	bill.permitirAnimacion(true) 
//    	self.iniciarAnimacion( tipoDeSprite ) 
//    }
//	
//	override method finalizarAnimacion() {
//		bill.derrotadoSiSeAgotaSalud(spriteQuieto)
//	}
//}

