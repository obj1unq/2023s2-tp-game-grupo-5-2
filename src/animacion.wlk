import personajes.*
import wollok.game.*


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
  
  method intervaloDeAnimacion(listaDeSprites) {
  	game.schedule(130, { self.siguienteFrame(listaDeSprites) }) // programar el próximo frame, por ejemplo en 200ms
  }
  
  method finalizarAnimacion() {
  	bill.finalizarAnimacion(spriteQuieto) // vuelve a habilitar las animaciones y regresar al sprite base
  }   
}


object animadorDeMovimiento inherits AnimacionManager {
	
	
	
	override method iniciarAnimacion(_listaDeSprites) { //se encarga de decidir que sprites usar dependiendo de la ultima direccion donde miro el personaje y la accion a realizar 
		var spritesDelMovimiento = _listaDeSprites
		bill.estaEnAnimacion(true)
		
	  if (spritesDelMovimiento.get(0).startsWith("golpe") && bill.directionMirando() == "Izquierda") { // Cambia los sprites por los de golpe hacia la izquierda
        spriteQuieto = "quietoIzq.png" 
        spritesDelMovimiento =(["golpeIzq1.png", "golpeIzq1.png", "golpeIzq2.png", "golpeIzq3.png"])
        
      } else if (_listaDeSprites.get(0).startsWith("atras")) {  // Si los sprites comienzan con "atras", entonces bill se movió a la izquierda
        //direccionUltimoMovimiento = "Izquierda"
        spriteQuieto = "quietoIzq.png"
        
      } else if (spritesDelMovimiento.get(0).startsWith("subir") && bill.directionMirando()  == "Izquierda") {   // Si quiere subir y la ultima dir es izquierda
        spriteQuieto = "quietoIzq.png"
        spritesDelMovimiento =(["subirIzq1.png", "subirIzq2.png", "subirIzq3.png", "subirIzq4.png"])  
        
      } else if (spritesDelMovimiento.get(0).startsWith("patada") && bill.directionMirando()  == "Izquierda") {   // Sies patada y la ultima dir es izquierda
        spriteQuieto = "quietoIzq.png"
        spritesDelMovimiento =(["patadaIzq1.png", "patadaIzq2.png", "patadaIzq3.png", "patadaIzq4.png", "patadaIzq4.png"])  

      } else if (spritesDelMovimiento.get(0).startsWith("bajar") && bill.directionMirando()  == "Izquierda") {   // Si quiere bajar y la ultima dir es izquierda
        spriteQuieto = "quietoIzq.png"
        spritesDelMovimiento =(["atras1.png", "atras2.png", "atras3.png"])  
            
      } else  { // De lo contrario, la dirección es derecha
        //direccionUltimoMovimiento = "Derecha"
        spriteQuieto = "quieto.png"
      }
      super(spritesDelMovimiento)
    }
	

} 

object animadorDeDerrota inherits AnimacionManager {

	override method finalizarAnimacion() { // tiene la diferencia de que cuando termina la animacion de derrota decide si se termina el juego o revive
		bill.resusitarOTerminar()
	}
	
}

object animadorDanio inherits AnimacionManager {
	
	override method finalizarAnimacion() {
		bill.derrotadoSiSeAgotaSalud(spriteQuieto)
	}
}

