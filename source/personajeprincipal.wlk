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
                objetoEnMano.position(nuevaPosicion)
            }
        }
    }

    method agarrableEn(posicion){ //para objetos que necesito agarrar
        return game.getObjectsIn(posicion).findOrDefault({ objeto => objeto.sePuedeAgarrar() && not(objeto.estaEnPlato()) }, null)
    }

    method elementoEn(posicion, tipo) { 
        return game.getObjectsIn(posicion).findOrDefault({objeto => objeto.elemento() == tipo }, null)
    }

    method posicionDondeMiro() = ultimadireccion.siguiente(position)

    method agarrarOSoltar() {
        const elementoQueMiro = self.elementoEn(self.posicionDondeMiro(), "estacion")
        if (!manoOcupada) {
            var objetoAAgarrar = null
            objetoAAgarrar = self.agarrableEn(self.posicionDondeMiro())

            if (objetoAAgarrar != null){
                if(objetoAAgarrar.elemento() == "plato armado" && elementoQueMiro != null && elementoQueMiro.esMesadaArmado()){ //si es plato armado y está en la mesada
                    elementoQueMiro.agarrarPlatoArmado() //Avisa que ya no tiene un plato en armado a la mesada
                }
                objetoEnMano = objetoAAgarrar
                objetoEnMano.position(position)
                manoOcupada = true
                
            } 
        } else {
            objetoEnMano.position(self.posicionDondeMiro())
            objetoEnMano = null
            manoOcupada = false
        }
    }


    method accionar(){
        const elementoQueMiro = self.elementoEn(self.posicionDondeMiro(), "estacion")
            if(elementoQueMiro != null && manoOcupada)
                elementoQueMiro.tareaDeEstacion(objetoEnMano)
    }

    method accionarCajon() {
        const cajon = self.elementoEn(self.posicionDondeMiro(), "stock")
        if (cajon != null) cajon.reponerStock()
    }
}

object cocinero {
    method idImagen() = "imagenesPersonajes/cocinero" 
}

object parrillero { //Después vemos el nombre
    method idImagen() = "imagenesPersonajes/parrillero" 
}