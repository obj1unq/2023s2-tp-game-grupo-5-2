import wollok.game.*
import randomizerVJuego.*
/* 
object monedaFactory{
	
	method nuevo() {
		return new Moneda(position = randomizerVJuego.emptyPosition())
	}
}

object monedasManager {
	
	var generados = #{}
	const limite = 3
	
	const factories = [monedaFactory]
	
	
	method seleccionarFactory() {

//      Para una probabilidad de 10% alpiste 90% manzana		
//		const x = 0.randomUpTo(1)
//		return if (x < 0.10) alpisteFactory else manzanaFactory 
		
		return factories.anyOne() //igual de probabilidad
	}
	
	method generar() {
		if(generados.size() < limite ) {
			
			const tipoMoneda = self.seleccionarFactory().nuevo() 		
			game.addVisual(tipoMoneda)	
			generados.add(tipoMoneda)
		}
	}
	
	method quitar(tipoMoneda) {
		generados.remove(tipoMoneda)
		game.removeVisual(tipoMoneda)
	}
}
*/

class Moneda {

	var property position 
	
	const property tipoDeMonedaPosible = [monedaSola,variasMonedas]
	
	var property estadoMoneda = self.seleccionarEstadoDeMoneda()
	
	method seleccionarEstadoDeMoneda() {
		return tipoDeMonedaPosible.anyOne()
	}
	
	method agarrado(personaje) {
		game.removeVisual(self)
		personaje.sumarMonedas(estadoMoneda.monedasABrindar())
	}

	method image() = estadoMoneda.image()
	
}

object monedaSola {
	
	method monedasABrindar() = 1
	
	method image() = "unaMoneda.png"
}

object variasMonedas {
	
	method monedasABrindar() = 3
	
	method image() = "variasMonedas.png"
}

object llave {
	
	var property position = null
	
	var property tipoDeLlave = llaveCofre
	
	method image() = "llaveInicial.png" 
	
	method agarrado(personaje) {
		personaje.llaveObtenida(tipoDeLlave)
	}
	
	method esLlaveParaCofre() {
		return tipoDeLlave.abreCofre()
	}
	method esLlaveParaPuerta() {
		return tipoDeLlave.abrePuerta()
	}
}
object llaveCofre {
	
	method abreCofre() {
		return true
	}
	
	method abrePuerta() {
		return false
	}
}

object llavePuerta {
	
	method abreCofre() {
		return false
	}
	
	method abrePuerta() {
		return true
	}
	
}





/* 
class Enemigo {
	
	var property position = game.at(8,8)
	
	method image() {}

	method dispara() {
		game.onTick(2000,"disparar",{
			const bola = new BolaDeNieve(position = position.left(1))
			game.addVisual(bola)
			bola.desplazarse()}) 
		}
}

class BolaDeNieve {
	
	var property position 
	
	method image() {}
	
	method desplazarse() {
		game.onCollideDo(self,{algo => algo.tePegue()})
		game.onTick(250,"bola",{self.moverseIzquierda()})	
	}
	
	method moverseIzquierda() {
		position = position.left(1)
		if(position.x() > game.width()) {
			game.removeTickEvent("bola")
			game.removeVisual(self)
		}
		
	}
	
}

*/