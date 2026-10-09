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
            if(objetoEnMano != null && (objetoEnMano.elemento() == "comida" or objetoEnMano.elemento() == "plato")){
                objetoEnMano.position(nuevaPosicion)
            }else if(objetoEnMano != null && objetoEnMano.elemento() == "plato armado"){
                objetoEnMano.elementosPlato().forEach({elemento => elemento.position(nuevaPosicion)})
            }
        }
    }

    method agarrableEn(posicion){ //para objetos que necesito agarrar
        return game.getObjectsIn(posicion).findOrDefault({ objeto => objeto.sePuedeAgarrar() && not(objeto.estaEnPlato()) }, null)
    }

    method estacionEn(posicion) { //para objetos que tenco que interactuar con funcion
        return game.getObjectsIn(posicion).findOrDefault({ objeto => objeto.elemento() == "estacion" }, null)
    }

    method cajonEn(posicion) {
        return game.getObjectsIn(posicion).findOrDefault({objeto => objeto.elemento() == "stock"}, null)
    }

    method posicionDondeMiro(){
            if (ultimadireccion == "derecha") return position.right(1)
            if (ultimadireccion == "izquierda") return position.left(1)
            if (ultimadireccion == "arriba") return position.up(1)
            if (ultimadireccion == "abajo") return position.down(1)
            return position //error?
    }

    method agarrarOSoltar() {  //Se podrá simplificar más? No lo sé
        if (!(manoOcupada)) {
            var objetoAAgarrar = null
            objetoAAgarrar = self.agarrableEn(self.posicionDondeMiro())
            if (objetoAAgarrar != null && (objetoAAgarrar.elemento() == "comida" || objetoAAgarrar.elemento() == "plato")) { // Si es comida o plato se pueden agarrar por default
                objetoAAgarrar.position(position)
            } else if (objetoAAgarrar != null && (objetoAAgarrar.elemento() == "plato armado")){ //Si es plato armado
                objetoEnMano.nuevaPosicion(position)
            }
            objetoEnMano = objetoAAgarrar
            manoOcupada = true
        } else {
            if (objetoEnMano.elemento() == "comida" || objetoEnMano.elemento() == "plato") {
                objetoEnMano.position(self.posicionDondeMiro())
            } else if (objetoEnMano.elemento() == "plato armado"){
                objetoEnMano.nuevaPosicion(self.posicionDondeMiro())
            }
            objetoEnMano = null
            manoOcupada = false
        }
    }

    method accionar(){
    const elementoQueMiro = self.estacionEn(self.posicionDondeMiro())

        if(elementoQueMiro != null && manoOcupada && (elementoQueMiro).elemento() == "estacion"){
            if(elementoQueMiro.mesaArmado()){
                elementoQueMiro.armarPlato(objetoEnMano)
            }else if(elementoQueMiro.mesadaEntrega() && objetoEnMano.elemento() =="plato armado"){
                elementoQueMiro.entregarPlato(objetoEnMano)
            }else{
                (elementoQueMiro).tareaDeEstacion(objetoEnMano)
            }
        }
    }

    method accionarCajon() {
        const cajon = self.cajonEn(self.posicionDondeMiro())
        if (cajon != null) cajon.reponerStock()
    }
}

//LO DE LA DIRECCION ES ÚTIL PARA DESPUES CAMBIAR LAS IMAGENES!!
//habría que tener algun if dependiendo el personaje que se eligió al inicio