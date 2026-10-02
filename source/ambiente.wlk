import wollok.game.*
import personajeprincipal.*

object horno{
    const property position = game.at(6,11)
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
            game.schedule(5000, { /*espero 7 segundos!!*/
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
    method sePuedeAgarrar() = false
    method elemento() = "funcional"

    method funcion(objeto) {
        if(objeto.elemento() == "comida"){
            game.removeVisual(objeto)
        }
    } 
}

object bacha {
    const property position = game.at(4,6)
    method sePuedeAgarrar() = false
    method elemento() = "funcional"
    var bachaOcupada = false

    method funcion(objeto) {
        if(objeto.elemento() == "plato" && !bachaOcupada && !objeto.limpio()){
            bachaOcupada = true
            personajePrincipal.agarrarOSoltar()
            game.schedule(3000, { /*espero 3 segundos!!*/ //BLOQUE
                objeto.limpio(true)
                bachaOcupada = false
            })}
        }
}

object mesadaArmado { //Hay 3 mesas de armado, por eso un class
    const property position = game.at(24.5,7)
    method image() = "mesadaArmado.png"  
    method elemento() = "funcional"
    method sePuedeAgarrar() = false
    var platoEnArmado = []

    method funcion(objeto){
        if (objeto == null) {
        game.say(personajePrincipal, "No tengo nada en la mano")
        }
        if(objeto.elemento() == "plato"){
            if(!platoEnArmado.any({elem=> elem.elemento() == "plato"})){
                platoEnArmado.add(objeto)
                personajePrincipal.agarrarOSoltar()
                           
                
            } //Si hay alguno tendria qe decir que ya hay un plato!
        } else{
            if(platoEnArmado.any({elem => elem.elemento() == "plato"})){
                platoEnArmado.add(objeto)
                personajePrincipal.agarrarOSoltar()
            }
            //Si no hay plato tiene que decir que necesita un plato para poner la comida
        }        

    }
}

object tablaDeCortar {
    const property position = game.at(4,9)
    method image() = "tablaDeCortar.png" 
    method sePuedeAgarrar() = false
    method elemento() = "funcional"
    var tablaOcupada = false

    method funcion(objeto) {
        if(objeto.elemento() == "comida" && !tablaOcupada && !objeto.cortado()){
            tablaOcupada = true
            personajePrincipal.agarrarOSoltar()
            game.schedule(5000, { /*espero 5 segundos!!*/ //BLOQUE
                objeto.cortado(true)
                tablaOcupada = false
            })}
        }
}