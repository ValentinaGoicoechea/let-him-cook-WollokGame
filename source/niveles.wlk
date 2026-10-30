import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*

class Nivel{
    var property puntosParaGanar 
    var property siguienteNivel 
}
object nivel1 {
    var property puntosParaGanar = 100
    var property siguienteNivel = nivel2
    method nuevoPedido() {
        //segun el nivel se crean distinto pedidos
    }

    method iniciar() {
        game.addVisual(cajonDeHuevo)
        game.addVisual(cajonDeBife)
        cajonDeHuevo.reponerStock()
        cajonDeBife.reponerStock()
        controladorDePartida.puntosSegunNivel()
        generadorDePedidos.empezar(self) 

    }
}
object nivel2 {
    var property puntosParaGanar = 100
    var property siguienteNivel = null
    method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(1).round()) //Puede salir ojo de bife y pollo con papas
    }
    method iniciar() {
        game.addVisual(cajonDePapas)
        game.addVisual(cajonDePollo)
        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()     
    }
}
