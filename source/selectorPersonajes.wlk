import teclado.*
import personajeprincipal.*

//SELECCION DE PERSONAJES (?)

object selectorPersonajes { //highlight alrededor de personaje
 /*
    var property position = game.at(15, 8)
    var personajeActual = null
    var personajeElegido = null
    method image() = "imagenesFondos/selectorPersonajes.png"

    method moverseA(unaDireccion) {
        if (self.direccionHabilitada(unaDireccion)) {
            position = unaDireccion.siguiente(position)
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
            personajePrincipal.asignarTipoPersonaje(parrillero)   
        }
    }
    */
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