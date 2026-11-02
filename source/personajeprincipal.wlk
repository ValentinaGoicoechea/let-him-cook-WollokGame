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
        objetoEnMano.position(self.proximaPosicion())
        objetoEnMano = null
        manoOcupada = false

    }

    method agarrarOSoltar() {
        const elementosDondeMiro = game.getObjectsIn(self.proximaPosicion())
        if (!manoOcupada) {
            elementosDondeMiro.forEach({elem => elem.agarrar(self)}) 
        } else {
            elementosDondeMiro.forEach({elem=> elem.soltar(self)})
        }
    }


    method accionar(){
        if(manoOcupada){
            game.getObjectsIn(self.proximaPosicion()).forEach({elem => elem.tareaDeEstacion(objetoEnMano)})
        }
    }

    /* VER DE ACCIONARLO CON LA Q
    method accionarCajon() {
        const cajon = self.elementoEn(self.posicionDondeMiro(), "stock")
        if (cajon != null) {
        cajon.reponerStock()
        }
    }
    */
}
