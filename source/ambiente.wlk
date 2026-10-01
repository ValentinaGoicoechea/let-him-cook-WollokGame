import wollok.game.*
import personajeprincipal.*

object horno{
    const property position = game.at(6,12)
    var prendido = false
    method image(){
        if(prendido){
            return "hornoprendido.png"
        } else{
            return "hornoapagado.png"
        }
    }

    method sePuedeAgarrar() = false
    method elemento() = "funcional"

    method funcion(objeto) {
        prendido = true
        if(objeto.sePuedeCocinar() && objeto.elemento() == "comida") {objeto.cocinada(true)}

        return
    }

}

object mesada {
    const property position = game.at(14,11) 
    method image() = "mesada.png"
}

object basura {
    const property position = game.at(21,7)
    method image() = "basura.png"
}

object bacha {
    const property position = game.at(4,6)
    
}