import wollok.game.*

object personajePrincipal{
    var property position = game.at(10,10)
    
    var property direccion = "ninguna"

    method image() = "cocinero.png"

    method esSuelo(pos){ //en base al piso
        const x = pos.x()
        const y= pos.y()

        return(x.between(4, 23) && y.between(10,11) || 
                x.between(4,24) && y.between(8,9)||
                x.between(5,24) && y == 7||
                x.between(5,18) && y.between(4, 6))
    }

    method proximaPosicion() {
            if (direccion == "derecha") return position.right(1)
            if (direccion == "izquierda") return position.left(1)
            if (direccion == "arriba") return position.up(1)
            if (direccion == "abajo") return position.down(1)
            return position //error
    }

    method darPaso(){
        const nuevaPosicion=self.proximaPosicion()

        if(self.esSuelo(nuevaPosicion)){
            position = nuevaPosicion
        }
    }
    
}

//LO DE LA DIRECCION ES ÚTIL PARA DESPUES CAMBIAR LAS IMAGENES!!
//habría que tener algun if dependiendo el personaje que se eligió al inicio