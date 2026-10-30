import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*

class Nivel{
    var property puntosParaGanar 
    var property siguienteNivel = null

    method nuevoPedido() {
        //segun el nivel se crean distinto pedidos
    }

    method iniciar() {
        if (!game.allVisuals().contains(cajonDeHuevo)) {
            game.addVisual(cajonDeHuevo)
        }
        if (!game.allVisuals().contains(cajonDeBife)) { //ver como cambiar esta logica
            game.addVisual(cajonDeBife)
        }
        cajonDeHuevo.reponerStock()
        cajonDeBife.reponerStock()
        controladorDePartida.puntosSegunNivel()
        generadorDePedidos.empezar(self) 

    }
}
object nivel2 inherits Nivel(
    puntosParaGanar = 100
    ){
    override method nuevoPedido() {
        generadorDePedidos.pedir(0.randomUpTo(1).round()) //Puede salir ojo de bife y pollo con papas
    }
    override method iniciar() {
        if (!game.allVisuals().contains(cajonDePapas)) {
            game.addVisual(cajonDePapas)
        }
        if (!game.allVisuals().contains(cajonDePollo)) {
            game.addVisual(cajonDePollo)
        }
        cajonDePollo.reponerStock()
        cajonDePapas.reponerStock()
        super()      
    }

}
object nivel1 inherits Nivel(
    puntosParaGanar = 150,
    siguienteNivel = nivel2
    ){
    override method nuevoPedido() {
        generadorDePedidos.pedir(1)  //Solo ojo de bife con huevo
    }
}

