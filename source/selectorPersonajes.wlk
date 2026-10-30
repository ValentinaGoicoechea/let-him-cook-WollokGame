import teclado.*
import personajeprincipal.*
import controladorPantallasYNiveles.*

//SELECCION DE PERSONAJES (?)

object selectorPersonajes { //highlight alrededor de personaje
    var property position = game.at(15, 8)
    const personajesDisponibles = [ropaCocinero, ropaOtro] //cambiar nombres a futuro
    var personajeActual = null //el personaje actualmente seleccionado
    var personajeElegido = null // el personaje confirmado tras seleccion
    method image() {if(personajeActual == null ) return "imagenesEstaciones/vacio.png"
                    else return "imagenesFondos/selectorPersonajes.png"}


    method seleccionarPersonaje(numero){
        personajeActual = personajesDisponibles.find({personaje => personaje.numero() == numero})
        if(personajeActual != null){
            position = personajeActual.posicionSelector()
            teclado.confirmarPersonaje()
        }
        
    
    }

    method confirmarSeleccion(){ //solo se va a activar cuando ya tenga un personaje actual
        personajeElegido = personajeActual
        self.elegirPersonaje() //le asigno el tipo al personaje principal para ver el buff
        juegoCocinero.iniciarJuego()
        
    }

    method elegirPersonaje() {
        personajePrincipal.asignarPersonaje(personajeElegido) 

    }
}

class Personajes{
    var property tipo
    var property numero
    const property posicionSelector
}

const ropaCocinero = new Personajes(
    tipo = "cocinero",
    numero = 1,
    posicionSelector = game.at(4, 8) 
)
const ropaOtro = new Personajes(    //PRUEBA, después hacemos otro tipo de personaje
    tipo = "parrillero",
    numero =2,
    posicionSelector = game.at(7, 8) 
)