import wollok.game.*

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
    method siguiente(posicion) = posicion
    method direccionImagen() = "Frente"
}