import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*

class Nivel{
    var property puntosParaGanar 
    var property siguienteNivel 

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
object nivel1 inherits Nivel(
    puntosParaGanar = 750,
    siguienteNivel = nivel2
    ){
    override method nuevoPedido() {
        generadorDePedidos.pedir(1)  //Solo ojo de bife con huevo
    }
}
object nivel2 inherits Nivel(
    puntosParaGanar = 850,
    siguienteNivel = null
    ){
    override method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(1).round()) //Puede salir ojo de bife y pollo con papas
    }
    override method iniciar() {
        game.addVisual(cajonDePapas)
        game.addVisual(cajonDePollo)
        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()
        super()      
    }
}
