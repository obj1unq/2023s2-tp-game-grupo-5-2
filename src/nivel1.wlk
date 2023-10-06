import personajes.*
import wollok.game.*
import objetosInteractivos.*
import extrasJuego.*

object _ {
	
	method generar(position) {
		//El vacio no agrega nada
	}	
}

object f {
	method generar(position) {
		finnElHumano.position(position)
		//game.addVisual(finnElHumano)
		//No agrega el visual para hacerlo al final
	}		
}

object c {
	method generar(position) {
		cofre.position(position)
		game.addVisual(cofre)
	}			
}
object b {
	method generar(position) {
		bemoo.position(position)
		game.addVisual(bemoo)
	}	
}
object l {
	method generar(position) {
		llave.position(position)
		
	}
}
object p {
	method generar(position) {
		puerta.position(position)
	}
}
object nivel1 {
	
	var celdas = [
		[_,_,_,_,_,b,_,_,_,p],
		[c,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],		
		[f,_,_,_,_,l,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_]		
	].reverse() //reverse porque el y crece en el orden inverso
	
	
	
	method generar() {
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		(0..game.width() -1).forEach({x =>
			(0..game.height() -1).forEach( {y =>
				self.generarCelda(x,y)
			})
		})
		game.addVisual(finnElHumano) //agrego al final por un tema del z index
	}
	
	method generarCelda(x,y) {
		const celda = celdas.get(y).get(x)
		celda.generar(game.at(x,y))
	}
	
}