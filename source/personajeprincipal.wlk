import source.ambiente.*
import source.comida.*
import wollok.game.*

object personajePrincipal{
    var property position = game.at(10,10)
    
    
    var property direccion = "ninguna"
    var property ultimadireccion = "ninguna"
    var manoOcupada = false
    var objetoEnMano = null

    method image() {
        //if (ultimadireccion == "abajo") return "cocineroFrente.png"
        if (ultimadireccion == "derecha") return "cocineroDerecha.png"
        if (ultimadireccion == "arriba") return "cocineroEspalda.png"
        if (ultimadireccion == "izquierda") return "cocineroIzquierda.png"
        return "cocineroFrente.png" //o aparece o esta de frente
    } 

    method esSuelo(pos){ //en base al piso
        const x = pos.x()
        const y= pos.y()

        return(x.between(5, 24) && y.between(7,11) || 
                x.between(5,18) && y == 6||
                x.between(5,25) && y.between(4, 5))||
                x.between(18,25) && y == 3
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
            if(objetoEnMano != null){
                self.otorgarPosicionAlElemento(nuevaPosicion)
            }
        }
    }

    method agarrableEn(posicion){ //para objetos que necesito agarrar
        return game.getObjectsIn(posicion).findOrDefault({ objeto => objeto.sePuedeAgarrar() && not(objeto.estaEnPlato()) }, null)
    }

    method elementoEn(posicion, tipo) { 
        return game.getObjectsIn(posicion).findOrDefault({objeto => objeto.elemento() == tipo }, null)
    }

    method posicionDondeMiro(){
            if (ultimadireccion == "derecha") return position.right(1)
            if (ultimadireccion == "izquierda") return position.left(1)
            if (ultimadireccion == "arriba") return position.up(1)
            if (ultimadireccion == "abajo") return position.down(1)
            return position //error?
    }

    method otorgarPosicionAlElemento(posicion) {
        if(objetoEnMano.elemento() != "plato armado") {
                objetoEnMano.position(posicion)
            } else { 
                objetoEnMano.nuevaPosicion(posicion)
            }
    }

    method agarrarOSoltar() {
        if (!manoOcupada) {
            var objetoAAgarrar = null
            objetoAAgarrar = self.agarrableEn(self.posicionDondeMiro())
            if (objetoAAgarrar != null){
                objetoEnMano = objetoAAgarrar
                self.otorgarPosicionAlElemento(position)
                manoOcupada = true
            } 
        } else {
            self.otorgarPosicionAlElemento(self.posicionDondeMiro())
            objetoEnMano = null
            manoOcupada = false
        }
    }


    method accionar(){
        const elementoQueMiro = self.elementoEn(self.posicionDondeMiro(), "estacion")
            if(elementoQueMiro != null)
                if(manoOcupada){
                    elementoQueMiro.tareaDeEstacion(objetoEnMano)
                }else{
                    elementoQueMiro.agarrarPlatoArmado() //Es un metodo que va a activar mesa de armado, por ahora lo creo en todos y los demás no hacen nada, buscar mejor solucion
            }
    }

    method accionarCajon() {
        const cajon = self.elementoEn(self.posicionDondeMiro(), "stock")
        if (cajon != null) cajon.reponerStock()
    }
}
