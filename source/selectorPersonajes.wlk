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
            position = personajeActual.position()
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
    var property position
    var property image
}

const ropaCocinero = new Personajes(
    tipo = "cocinero",
    numero = 1,
    position = game.at(15, 8),
    image = "ropaCocinero.png"
)
const ropaOtro = new Personajes(    //PRUEBA, después hacemos otro tipo de personaje
    tipo = "parrillero",
    numero =2 ,
    position = game.at(17, 8),
    image= "ropaOtro.png"
)