import source.direcciones.*
import source.ambiente.*
import source.comida.*
import source.selectorPersonajes.*
import wollok.game.*


//ACCIONES DEL PERSONAJE (MOVERSE-MIRAR-AGARRAR-ACCIONAR)

object personajePrincipal{
    var property personajeSeleccionado = null //Dependiendo el elegido hay un buff diferente
    var property tipoPersonaje = null
    var property position = game.at(10, 10)
    var property direccion = ninguna
    var property ultimadireccion = ninguna
    var manoOcupada = false
    var objetoEnMano = null

    method asignarPersonaje(personaje) {
        personajeSeleccionado = personaje
        tipoPersonaje = personajeSeleccionado.tipo()
    }

    method image() = "imagenesPersonajes/" + personajeSeleccionado.tipo() + ultimadireccion.direccionImagen() + ".png"
    method proximaPosicion() = direccion.siguiente(position)

    method posicionDondeMiro() = ultimadireccion.siguiente(position)

    method darPaso(){
        const nuevaPosicion=self.proximaPosicion()

        if(escenario.esTransitable(nuevaPosicion)){
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
        game.getObjectsIn(self.posicionDondeMiro()).forEach({elem => elem.tareaDeEstacion(objetoEnMano)}) // el objeto ve si le mando algo o null, no el personaje
        
    }

    method reiniciar() {
        position = game.at(10, 10)
        direccion = ninguna
        ultimadireccion = ninguna
        manoOcupada = false
        objetoEnMano = null
    }
}
