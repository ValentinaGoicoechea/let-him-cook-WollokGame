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
        
        if(objeto.sePuedeCocinar() && objeto.elemento() == "comida" && !hornoOcupado){
            prendido = true
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
    const property position = game.at(14,12) 
    method image() = "mesada.png"
}

object basura {
    const property position = game.at(20,7)
    method image() = "basura.png"
}

object bacha {
    const property position = game.at(4,6)
    method sePuedeAgarrar() = false
    method elemento() = "funcional"
    var bachaOcupada = false

    method funcion(objeto) {
        if(objeto.elemento() == "plato" && !bachaOcupada && objeto.limpio(false)){
            bachaOcupada = true
            personajePrincipal.agarrarOSoltar()
            game.schedule(3000, { /*espero 3 segundos!!*/ //BLOQUE
                objeto.limpio(true)
                bachaOcupada = false
            })}
        }
}

object mesadaArmado {
    const property position = game.at(24.5,7)
    method image() = "mesadaArmado.png"  
}

object tablaDeCortar {
    const property position = game.at(4,9)
    method image() = "tablaDeCortar.png" 
}