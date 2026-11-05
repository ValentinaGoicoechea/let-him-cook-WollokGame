import wollok.game.*
import niveles.*

//DIRECCIONES(OBJETOS) POSIBLES DE MOVIMIENTO
object arriba {
    method siguiente(posicion) = posicion.up(1) 
    method direccionImagen() = "Espalda"
}
object abajo {
    method siguiente(posicion) = posicion.down(1)
    method direccionImagen() = "Frente"
}
object izquierda {
    method siguiente(posicion) = posicion.left(1)
    method direccionImagen() = "Izquierda"
}
object derecha {
    method siguiente(posicion) = posicion.right(1)
    method direccionImagen() = "Derecha"
}
object ninguna {  
    method siguiente(posicion) = posicion //no muevo
    method direccionImagen() = "Frente"
}

object escenario { //Para el nivel 1 y 2 
    var property nivelActual = nivel1 //asi inicializa
    method esTransitable(pos){ //en base al piso
        return nivelActual.esTransitable(pos)
    }
}