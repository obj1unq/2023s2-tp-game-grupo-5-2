import personajes.*
class Sprites {
    method gestionarDirDeSprite(primerCadena, segundaCadena) {                 // decide que sprites usar dependiendo de donde este mirando el personaje
    	return if (bill.directionMirando() == "Izquierda") {segundaCadena}
    	       else                                        {primerCadena}
    }
}

object spritesDanio inherits Sprites{

	
	method spritesDanio1() {
		return ["danio1.png", "danio1.png", "danio1.png"] 
	}
	
	method spritesDanio1Izquierda() {
		return ["danioIzq1.png", "danioIzq1.png", "danioIzq1.png"]
	}
	
	method spritesDanio2() {
		return ["danio2.png", "danio2.png", "danio2.png"] 
	}
	
	method spritesDanio2Izquierda() {
		return ["danioIzq2.png", "danioIzq2.png", "danioIzq2.png"]
	}
	
	method spritesDanio3() {
		return ["danio3.png", "danio3.png", "danio4.png",
                "danio4.png", "danio5.png", "danio5.png", 
                "danio6.png", "danio6.png"]
	}
	
	method spritesDanio3Izquierda() {
		return ["danioIzq3.png", "danioIzq3.png", "danioIzq4.png", 
               "danioIzq4.png", "danioIzq5.png", "danioIzq5.png",
               "danioIzq6.png", "danioIzq6.png"]
	}
	
}

object spritesDeDerrota inherits Sprites {
	
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
}

object spritesDeGolpe inherits Sprites {
	
	method spritesGolpe() {
		return ["golpefr1.png", "golpefr1.png", "golpefr2.png", "golpefr3.png"]
	}
	method spritesGolpeIzquierda() {
		return ["golpeIzq1.png", "golpeIzq1.png", "golpeIzq2.png", "golpeIzq3.png"]
	}
}

object spritesDePatada inherits Sprites {
	
	method spritesPatada() {
		return ["patada1.png", "patada1.png", "patada2.png", "patada2.png"]
	}
    
	method spritesPatadaIzquirda() {
		return ["patadaIzq1.png", "patadaIzq2.png", "patadaIzq3.png", "patadaIzq4.png", "patadaIzq4.png"]
	}
}

object spritesDeMovimiento inherits Sprites {
	
	method spritesSubir() {
		return ["subir1.png", "subir2.png", "subir3.png", "subir4.png"]
	}
	
	method spritesSubirIzquierda() {
		return ["subirIzq1.png", "subirIzq2.png", "subirIzq3.png", "subirIzq4.png"]
	}
	
	method spritesAtras() {
		return ["atras1.png", "atras2.png", "atras3.png"]
	}
	
	method spritesAtrasIzquierda() {
		return ["atras1.png", "atras2.png", "atras3.png"]
	}
	
	method spritesBajar() {
		return ["bajar1.png", "bajar2.png", "bajar3.png"]
	}
	
	method spritesPaso() {
		return ["paso1.png", "paso2.png", "paso3.png"]
	}
}
































