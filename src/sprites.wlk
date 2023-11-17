import personajes.*
import animacion.*

class Sprites inherits AnimacionManager {
	
	method spritesAtras() {
		return ["atras1.png", "atras2.png", "atras3.png"]
	}
	method spritesPaso() {
		return ["paso1.png", "paso2.png", "paso3.png"]
	}	
}
class SpritesDanio inherits AnimacionManager {
	
	override method iniciarAnimacion() {
		bill.estaEnAnimacion(true)
     	bill.permitirAnimacion(true) 
     	super() 
	}
}

object spritesDanioNormal inherits SpritesDanio {

	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesDanioNormal() , self.spritesDanioNormalIzquierda()  )
	
	method spritesDanioNormal() {
		return ["danio1.png", "danio1.png", "danio1.png"] 
	}
	
	method spritesDanioNormalIzquierda() {
		return ["danioIzq1.png", "danioIzq1.png", "danioIzq1.png"]
	}
	
	override method finalizarAnimacion() {
		bill.derrotadoSiSeAgotaSalud(bill.spriteBaseSegurDir())
	}	
}
object spritesDanioMedio inherits SpritesDanio {
	
	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesDanioMedio() , self.spritesDanioMedioIzquierda()  )
		
	method spritesDanioMedio() {
		return ["danio2.png", "danio2.png", "danio2.png"] 
	}
	
	method spritesDanioMedioIzquierda() {
		return ["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"]
	}
	
	override method finalizarAnimacion() {
		bill.derrotadoSiSeAgotaSalud(bill.spriteBaseSegurDir())
	}	
}

object spritesDanioCritico inherits SpritesDanio {

	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesDanioCritico() , self.spritesDanioCriticoIzquierda()  )
	
	method spritesDanioCritico() {
		return ["danio3.png", "danio3.png", "danio4.png",
                "danio4.png", "danio5.png", "danio5.png", 
                "danio6.png", "danio6.png"]
	}
	
	method spritesDanioCriticoIzquierda() {
		return ["danioIzq3.png", "danioIzq3.png", "danioIzq4.png", 
               "danioIzq4.png", "danioIzq5.png", "danioIzq5.png",
               "danioIzq6.png", "danioIzq6.png"]
	}	
	
	override method finalizarAnimacion() {
		bill.derrotadoSiSeAgotaSalud(bill.spriteBaseSegurDir())
	}	
		
}

object spritesDeDerrota inherits Sprites  {
	
	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesDerecha(), self.spritesIzquierda() )
	
	method spritesIzquierda() {
		return ["derrotadoIzq1.png", "derrotadoIzq1.png", "derrotadoIzq1.png", "derrotadoIzq1.png",
    	        "derrotadoIzq2.png", "derrotadoIzq2.png", "derrotadoIzq2.png", "derrotadoIzq2.png",
    	        "derrotadoIzq3.png", "derrotadoIzq3.png", "derrotadoIzq3.png", "derrotadoIzq3.png"]	        
    }
    
    method spritesDerecha() {
    	return ["derrotado1.png", "derrotado1.png", "derrotado1.png", "derrotado1.png",
    	        "derrotado2.png", "derrotado2.png", "derrotado2.png", "derrotado2.png",
    	        "derrotado3.png", "derrotado3.png", "derrotado3.png", "derrotado3.png"]
    }
    
	override method finalizarAnimacion() { // tiene la diferencia de que cuando termina la animacion de derrota decide si se termina el juego o revive
		bill.resusitarOTerminar()
	}
    
}

object spritesDeGolpe inherits Sprites  {
	
	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesGolpe(), self.spritesGolpeIzquierda() )
	
	method spritesGolpe() {
		return ["golpefr1.png", "golpefr1.png", "golpefr2.png", "golpefr3.png"]
	}
	method spritesGolpeIzquierda() {
		return ["golpeIzq1.png", "golpeIzq1.png", "golpeIzq2.png", "golpeIzq3.png"]
	}
}

object spritesDePatada inherits Sprites  {
	 
	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesPatada(), self.spritesPatadaIzquierda() )
	
	method spritesPatada() {
		return ["patada1.png", "patada1.png", "patada2.png", "patada2.png"]
	}
    
	method spritesPatadaIzquierda() {
		return ["patadaIzq1.png", "patadaIzq2.png", "patadaIzq3.png", "patadaIzq4.png", "patadaIzq4.png"]
	}
}

object spritesDePaso inherits Sprites  {
	
	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesPaso(), self.spritesAtras() )
}

object spritesDeSubir inherits Sprites {
	
	override method secuenciaDeMovimientos() = self.gestionarDirDeSprite( self.spritesSubir(), self.spritesSubirIzquierda() )
	
	method spritesSubir() {
		return ["subir1.png", "subir2.png", "subir3.png", "subir4.png"]
	}
	
	method spritesSubirIzquierda() {
		return ["subirIzq1.png", "subirIzq2.png", "subirIzq3.png", "subirIzq4.png"]
	}	
}
































