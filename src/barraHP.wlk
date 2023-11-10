import wollok.game.*

object barraDeHp {
  var property image = "barraLlena.png" // Inicia con la barra llena
  var property position = game.at(0,0)
  

  
  method inicializar() {
    game.addVisual(self)
  }
  
  // Método para actualizar la imagen de la barra de vida
  method actualizarVida(vida) {
    image = self.calcularSpriteSegunVida(vida)
  }
  
  // Método para calcular el sprite de la barra de vida según la vida actual
  method calcularSpriteSegunVida(vida) {
    return if (vida > 80) {
       "barraLlena.png"
    } else if (vida > 60) {
       "barraUnTick.png"
    } else if (vida > 40) {
       "barraDosTick.png"
    } else if (vida > 20) {
       "barraTresTick.png"
    } else if (vida > 0){
       "barraCuatroTick.png"
    } else {
       "barraVacia.png"
    }
  }
}

object contadorDeVidas {
	var property image = "3vidas.png"       //En los assets estan los sprites hasta 6 vidas por si se quiere modificar o hacer un main menu interactivo donde se seleccione la cantidad
	var property position = game.at(0,0)
	
	method inicializar() {
		game.addVisual(self)
	}
	
	method actualizarVidas(vidas) {
		image = self.calcularSpriteSegunVidas(vidas)
	}
	
	method calcularSpriteSegunVidas(numeroDeVidas) {
		return numeroDeVidas.toString() + "vidas.png"
	}
}

