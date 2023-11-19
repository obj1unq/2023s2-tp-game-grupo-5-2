import personajes.*
import animacion.*

class Sprites inherits AnimacionManager {
	
    override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesDerecha() , self.spritesIzquierda()  )
	
	method spritesIzquierda() {
		return ["atras1.png", "atras2.png", "atras3.png"]
	}
	method spritesDerecha() {
		return ["paso1.png", "paso2.png", "paso3.png"]
	}	
}
class SpritesDanio inherits Sprites {  // añadir una variable donde el personaje pueda no ser bill 
	
	override method iniciarAnimacion() {
		bill.estaEnAnimacion(true)
     	bill.permitirAnimacion(true) 
     	super() 
	}
	
	override method finalizarAnimacion() {
		bill.derrotadoSiSeAgotaSalud(bill.spriteBaseSegurDir())
	}	
}

object spritesDanioNormal inherits SpritesDanio {

	
	override method spritesDerecha() {
		return ["danio1.png", "danio1.png", "danio1.png"] 
	}
	
	override method spritesIzquierda() {
		return ["danioIzq1.png", "danioIzq1.png", "danioIzq1.png"]
	}
	
}
object spritesDanioMedio inherits SpritesDanio {
	
		
	override method spritesDerecha() {
		return ["danio2.png", "danio2.png", "danio2.png"] 
	}
	
	override method spritesIzquierda() {
		return ["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"]
	}
		
}

object spritesDanioCritico inherits SpritesDanio {

	
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

object spritesDeDerrota inherits Sprites  {
	
	
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
    
	override method finalizarAnimacion() { // tiene la diferencia de que cuando termina la animacion de derrota decide si se termina el juego o revive
		bill.resusitarOTerminar()
	}
    
}

object spritesDeGolpe inherits Sprites  {
	
	
    override method spritesDerecha() {
		return ["golpefr1.png", "golpefr1.png", "golpefr2.png", "golpefr3.png"]
	}
	override method spritesIzquierda() {
		return ["golpeIzq1.png", "golpeIzq1.png", "golpeIzq2.png", "golpeIzq3.png"]
	}
}

object spritesDePatada inherits Sprites  {
	
    override method spritesDerecha() {
		return ["patada1.png", "patada1.png", "patada2.png", "patada2.png"]
	}
    
	override method spritesIzquierda() {
		return ["patadaIzq1.png", "patadaIzq2.png", "patadaIzq3.png", "patadaIzq4.png", "patadaIzq4.png"]
	}
}

object spritesDePaso inherits Sprites  {
	
}

object spritesDeSubir inherits Sprites {
	
	
    override method spritesDerecha() {
		return ["subir1.png", "subir2.png", "subir3.png", "subir4.png"]
	}
	
	override method spritesIzquierda() {
		return ["subirIzq1.png", "subirIzq2.png", "subirIzq3.png", "subirIzq4.png"]
	}	
}
































