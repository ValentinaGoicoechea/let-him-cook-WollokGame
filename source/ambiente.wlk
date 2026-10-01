import wollok.game.*
import personajeprincipal.*

object horno{
    const property position = game.at(6,12)
    var prendido = false
    var hornoOcupado = false
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
        if(objeto.sePuedeCocinar() && objeto.elemento() == "comida" && !hornoOcupado){
            hornoOcupado = true
            personajePrincipal.agarrarOSoltar()
            game.schedule(5000, { /*espero 5 segundos!!*/
                objeto.cocinada(true)
                prendido = false
                hornoOcupado = false
            })}
        
        return
    }

}

object mesadaEntrega {
    const property position = game.at(14,11) 
    method image() = "mesada.png"
}

object basura {
    const property position = game.at(20,7)
    method image() = "basura.png"
}

object bacha {
    const property position = game.at(4,6)
    
}

object mesadaArmado {
    const property position = game.at(25,7)
    method image() = "mesadaArmado.png"  
}