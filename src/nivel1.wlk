import personajes.*
import wollok.game.*
import sonidos.*
import barraHP.*


object _ {
	
	method generar(position) {
		//El vacio no agrega nada
	}	
}

object b {
	method generar(position) {
		bill.position(position)
		
		//No agrega el visual para hacerlo al final
	}		
}


object nivel1 {
	
	var celdas = [
		[_,_,_,_,_,_,_,_,_,_],   //una opcion es reemplazar los _ de algunas zonas por objetos solidos y agregar una condicion al mover, esto elimina el mensaje de
		[_,_,_,_,_,_,_,_,_,_],   //error al subir en el mapa pero lo mantiene si intenta salir por los bordes
		[_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],		
		[_,b,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_]		
	].reverse() //reverse porque el y crece en el orden inverso
	
	
	
	method generar() {
		
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		game.boardGround("background1.png")
		//gameSoundManager.playSoundtrackForLevel1()
	    game.addVisual(barraDeHP)
	    contadorDeVidas.inicializar()
		
		
		(0..game.width() -1).forEach({x =>
			(0..game.height() -1).forEach( {y =>
				self.generarCelda(x,y)
			})
		})
		game.addVisual(bill) //agrego al final por un tema del z index
		
	}
	
	method generarCelda(x,y) {
		const celda = celdas.get(y).get(x)
		celda.generar(game.at(x,y))
	}
	
	
}