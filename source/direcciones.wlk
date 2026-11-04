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
    method siguiente(posicion) = posicion //no muevo
    method direccionImagen() = "Frente"
}

object escenario {
    method esTransitable(pos){ //en base al piso
        const x = pos.x()
        const y= pos.y()    

        if (x == 20 && y == 7) return false //la basura
        else return  (y == 11 && (x.between(9, 13) || x.between(17, 24))) || 
                (y.between(7, 10) && x.between(5, 24)) ||
                (y == 6 && x.between(5, 18)) || 
                (y.between(4, 5)  && x.between(5, 25))||
                (y == 3 && x.between(18, 25))
        
        
        
        x == 5 && y.between(7,11)||
                x.between(9,13) && y == 11||
                x.between(21,24) && y == 11||
                (x.between(5, 24) && y.between(7,10) || 
                x.between(5,18) && y == 6||
                x.between(5,25) && y.between(4, 5))||
                x.between(18,25) && y == 3
    }
}