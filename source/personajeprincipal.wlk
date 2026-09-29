import wollok.game.*

object personajePrincipal{
    var property position = game.at(0,0)
    
    var property direccion = "ninguna"

    method image() = "cocinero.png"
/*
    method enSuelo(){
        if (self.position().x().between(229, 890) && self.position().y().between(589){
            return true
        }
        else if(self.position().x().between(min, max))
    }
*/
    method darPaso() {
        if (direccion == "derecha") position = position.right(1)
        if (direccion == "izquierda") position = position.left(1)
        if (direccion == "arriba") position = position.up(1)
        if (direccion == "abajo") position = position.down(1)
    }
    
}

//LO DE LA DIRECCION ES ÚTIL PARA DESPUES CAMBIAR LAS IMAGENES!!
//habría que tener algun if dependiendo el personaje que se eligió al inicio