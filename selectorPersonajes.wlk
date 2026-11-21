import teclado.*
import personajeprincipal.*
import controladorPantallasYNiveles.*

//SELECCION DE PERSONAJES (?)

object selectorPersonajes { //highlight alrededor de personaje
    var property position = game.at(8, 5)
    const personajesDisponibles = [ropaCocinero, ropaOtro] //cambiar nombres a futuro
    var property personajeActual = null //el personaje actualmente seleccionado
    var personajeElegido = null // el personaje confirmado tras seleccion
    var numJugador = 0

    method numJugador() = numJugador
    
    method image() {
        if(personajeActual == null ) {
            return "imagenesEstaciones/vacio.png"
        } else { 
            return "imagenesFondos/selectorPersonajes.png"
        }
    }

    method seleccionarPersonaje(numero){
        personajeActual = personajesDisponibles.find({personaje => personaje.numero() == numero})
        if(personajeActual != null){
            position = personajeActual.posicionSelector()
        }
        
    
    }

    method confirmarSeleccion(){ 
        if (personajeActual != null) {
            personajeElegido = personajeActual
            self.jugadorQueElige().asignarPersonaje(personajeElegido)

            if(self.esElUltimoJugador()) {
                controladorPantallas.entrarAlJuego()
                game.schedule(1, {
                    juegoCocinero.iniciarJuego() 
                })
            } else{
                numJugador = numJugador + 1
                personajeActual = null  
            }
        }
    }


    method reiniciar() {
        personajeActual = null
        numJugador = 0
    }

    method jugadorQueElige() = configuracionPartida.jugadoresActivos().get(numJugador)

    method esElUltimoJugador() = numJugador == configuracionPartida.jugadoresActivos().size() - 1


}

class Personajes{
    var property tipo
    var property numero
    const property posicionSelector
}

const ropaCocinero = new Personajes(
    tipo = "cocinero",
    numero = 1,
    posicionSelector = game.at(8, 5) 
)
const ropaOtro = new Personajes(    //PRUEBA, después hacemos otro tipo de personaje
    tipo = "parrillero",
    numero =2,
    posicionSelector = game.at(16, 5) 
)

object configuracionPartida {
    var property cantidadJugadores = 0

    method actualizarJugadores(numero) {
        cantidadJugadores = numero
    } 

    method jugadoresActivos(){
        if(cantidadJugadores == 2) return [jugador1, jugador2] 
        else return [jugador1]

    }

    method esMultijugador()= (cantidadJugadores == 2)
}