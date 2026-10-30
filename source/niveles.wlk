import pedidos.*
import ambiente.*
import controladorPantallasYNiveles.*
import puntaje.*

class Nivel{
    var property puntosParaGanar 
    var property siguienteNivel = null
    const pantalla

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
        pantalla.mostrarInfoNivel()
        game.schedule(5200, {
            controladorDePartida.puntosSegunNivel()
            generadorDePedidos.empezar(self) })
    }
}

object nivel2 inherits Nivel(
    puntosParaGanar = 650,
    pantalla = pantallaNivel2
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
    puntosParaGanar = 450,
    siguienteNivel = nivel2,
    pantalla = pantallaNivel1
    ){
    override method nuevoPedido() {
        generadorDePedidos.pedir(1)  //Solo ojo de bife con huevo
    }
}
