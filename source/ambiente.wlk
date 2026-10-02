import wollok.game.*
import personajeprincipal.*

class Estacion{
    const property position
    var prendido 
    var estaOcupado 
    const tiempoTarea
    var imagen1
    var imagen2
    var valorOtorgado
    var property debeValidar

    method sePuedeAgarrar() = false
    method elemento() = "estacion"

    method image(){
        if(prendido){
            return imagen1
        } else{
            return imagen2
        }
    }

    method tareaDeEstacion(objeto) {
        if((objeto.puede()).contains(debeValidar) && !estaOcupado){
            prendido = true
            estaOcupado = true
            personajePrincipal.agarrarOSoltar()
            game.schedule(tiempoTarea, { 
                objeto.modificado(valorOtorgado)
                prendido = false
                estaOcupado = false
            })}
        
        return
    }
}

const horno = new Estacion(
    position = game.at(6,11),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 7000,
    imagen1 = "hornoprendido.png",
    imagen2 = "hornoapagado.png",
    valorOtorgado = "cocinado",
    debeValidar = "cocinar"
)

const basura = new Estacion(
    position = game.at(20,7),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 500,
    imagen1 = "basuraAbierta.png",
    imagen2 = "basura.png",
    valorOtorgado = "tirado",
    debeValidar = "tirar"
)

const bacha = new Estacion(
    position = game.at(4,6),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 3000,
    imagen1 = "vacio.png", //ESPUMA O AGUA
    imagen2 = "vacio.png",
    valorOtorgado = "limpio",
    debeValidar = "limpiar"
)

const tablaDeCortar = new Estacion(
    position = game.at(4,9),
    prendido = false,
    estaOcupado = false,
    tiempoTarea = 4500,
    imagen1 = "tablaDeCortar.png", 
    imagen2 = "tablaDeCortar.png", // hacer cambio (para notar que esta en uso)
    valorOtorgado = "cortada",
    debeValidar = "cortar"
)

object mesadaEntrega {
    const property position = game.at(14,11) 
    method image() = "mesada.png"
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

