import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*


object nivel1 {
    var property puntosParaGanar = 100
    var property siguienteNivel = nivel2
    method nuevoPedido() {
        generadorDePedidos.pedir(1)  //Solo ojo de bife con huevo
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
        controladorDePartida.puntosSegunNivel()
        generadorDePedidos.empezar(self)         
    }
}
object nivel3 {
    var property puntosParaGanar = 1000
    var property siguienteNivel = null
    method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(2).round()) //Se agrega el fernet u otra cosa
    }
    method iniciar() {
        nivel2.iniciar()
        controladorDePartida.puntosSegunNivel()
        generadorDePedidos.empezar(self)   
    }
}