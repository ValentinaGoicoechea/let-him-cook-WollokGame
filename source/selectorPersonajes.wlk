import teclado.*
import personajeprincipal.*

object selectorPersonajes { //highlight alrededor de personaje

    var property position = game.at(15, 8)
    var personajeActual = null
    var personajeElegido = null
    method image() = "selectorPersonajes.png"

    method moverseA(direccion) {
        if (self.direccionHabilitada(direccion)) {
            if (direccion == "derecha") { 
                position = position.right(1) 
            }
            if (direccion == "izquierda") { 
                position = position.left(1)
            }
            if (direccion == "arriba") { 
                position = position.up(1) 
            }
            if (direccion == "abajo") {  
                position = position.down(1)
            } 
        }
    }

    method direccionHabilitada(direccion) {
        return true //Por ahora lo dejo así
    }

    method personajeEnPosicion() {
        personajeActual = game.getObjectsIn(position)
    }

    method elegirPersonaje() {
        if (position == ropaCocinero.position()) {
            personajePrincipal.asignarTipoPersonaje(cocinero)
        } else {
            personajePrincipal.asignarTipoPersonaje(otro)   
        }
    }
}

object ropaCocinero {
    var property id = "cocinero"
    var property position = game.at(15, 8)
    method image() = "ropaCocinero.png"
}
object ropaOtro {    //PRUEBA, después hacemos otro tipo de personaje
    var property id = "otro"
    var property position = game.at(17, 8)
    method image() = "ropaOtro.png"
}