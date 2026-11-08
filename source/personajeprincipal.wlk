import source.direcciones.*
import source.ambiente.*
import source.comida.*
import source.selectorPersonajes.*
import wollok.game.*


//ACCIONES DEL PERSONAJE (MOVERSE-MIRAR-AGARRAR-ACCIONAR)

class Jugador {
    const numeroPersonaje
    var property personajeSeleccionado = null
    var property tipoPersonaje = null
    var property position
    var property direccion = ninguna
    var property ultimadireccion = ninguna
    var manoOcupada = false
    var objetoEnMano = null
    const posicionInicial

    method numeroPersonaje() = numeroPersonaje

    method asignarPersonaje(personaje) {
        personajeSeleccionado = personaje
        tipoPersonaje = personajeSeleccionado.tipo()
    }

    method image() = "imagenesPersonajes/" + personajeSeleccionado.tipo() + ultimadireccion.direccionImagen() + ".png"
    method proximaPosicion() = direccion.siguiente(position)

    method posicionDondeMiro() = ultimadireccion.siguiente(position)
    
    method puedeAvanzar(posicion) { //mira que no haya nada en la proxima casilla a avanzar
        return game.getObjectsIn(posicion).all({obj => obj == self || obj == objetoEnMano}) //all para que no se trabe cuando direccion = ninguna
    }

    method darPaso(){
        const nuevaPosicion=self.proximaPosicion()

        if(escenario.esTransitable(nuevaPosicion) && self.puedeAvanzar(nuevaPosicion)){
            position = nuevaPosicion
            if(objetoEnMano != null){
                objetoEnMano.nuevaPosicion(nuevaPosicion)
            }
        }
    }

    method agarroObjeto(objeto){
        objetoEnMano = objeto
        objetoEnMano.nuevaPosicion(position)
        manoOcupada = true
    }

    method sueltoObjeto(objeto){
        if (objetoEnMano != null) {
            objetoEnMano.nuevaPosicion(self.posicionDondeMiro())
            objetoEnMano = null
            manoOcupada = false
        }
    }

    method agarrarOSoltar() {
        const elementosDondeMiro = game.getObjectsIn(self.posicionDondeMiro())
        if (!manoOcupada) {
            elementosDondeMiro.forEach({elem => if (!manoOcupada) elem.agarrar(self)}) 
        } else {
            self.sueltoObjeto(objetoEnMano)
        }
    }

    method accionar(){
        game.getObjectsIn(self.posicionDondeMiro()).forEach({
            elem => elem.tareaDeEstacion(self, objetoEnMano)}) 
    }

    method reiniciar() {
        position = posicionInicial
        direccion = ninguna
        ultimadireccion = ninguna
        manoOcupada = false
        objetoEnMano = null
    }
}

const jugador1 = new Jugador(numeroPersonaje = 1, position = game.at(10, 10), posicionInicial = game.at(10, 10))
const jugador2 = new Jugador(numeroPersonaje = 2, position = game.at(20, 10), posicionInicial = game.at(15, 10))