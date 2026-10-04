import wollok.game.*
import personajeprincipal.*

class Estacion{
    const property position
    var prendido 
    var estaOcupado 
    const tiempoTarea
    const imagen1
    const imagen2
    const valorOtorgado
    const debeValidar
    method mesaArmado() = false //PRUEBA

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
        if(objeto.tareas().contains(debeValidar) && !estaOcupado){
            prendido = true
            estaOcupado = true
            personajePrincipal.agarrarOSoltar()
            objeto.sePuedeAgarrar(false)
            game.schedule(tiempoTarea, { 
                objeto.modificado(valorOtorgado)
                if(valorOtorgado == "tirado") game.removeVisual(objeto)
                prendido = false
                estaOcupado = false
                objeto.sePuedeAgarrar(true)
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

class PlatoArmado {
    var property position
    var property elementosPlato = []
    const property estaEnPlato = false
    method tareas() = ["tirar"]
    
    method sePuedeAgarrar(){
        return(elementosPlato.size() > 1)
    }


    method elemento(){
        if(self.sePuedeAgarrar()){
            return "plato armado"
        }else{
            return "plato no armado"
        }
    } 

    method nuevaposicion(nuevaPos) {
        position = nuevaPos
        elementosPlato.forEach({ elem => elem.position(nuevaPos) })
    }


}

const platoArmado1 = new PlatoArmado( //ASIGNANDO UN PLATO A CADA MESADA
    position = game.at(24.5,7)

)


object mesadaArmado { //Hay 3 mesas de armado, por eso un class
    const property position = game.at(24.5,7)
    method image() = "mesadaArmado.png"  
    method elemento() = "estacion"
    method mesaArmado() = true
    method sePuedeAgarrar() = false
    const property platoEnArmado = platoArmado1 //Cada mesa tiene un plato asignado? ver como hacemos cuando los entregamos


    method armarPlato(objeto){
        if(objeto.elemento() == "plato"){
            if(!platoEnArmado.elementosPlato().any({elem=> elem.elemento() == "plato"})){
                platoEnArmado.elementosPlato().add(objeto)
                objeto.estaEnPlato(true)  
                personajePrincipal.agarrarOSoltar()
                           
                
            } //Si hay alguno tendria qe decir que ya hay un plato!
        } else{
            if(platoEnArmado.elementosPlato().any({elem => elem.elemento() == "plato"})){
                platoEnArmado.elementosPlato().add(objeto)
                objeto.estaEnPlato(true)
                personajePrincipal.agarrarOSoltar()
            }
            //Si no hay plato tiene que decir que necesita un plato para poner la comida
        }        

    }

    method agarrarPlatoArmado() {
        if(platoEnArmado.sePuedeAgarrar()){
            return platoEnArmado
        }else{
            return null
        }
    }

}

object cajonDePapas {
    const property position = game.at(26,5)
    method image() = "cajonDePapas.png"
    method elemento() = "cajonDePapas"

    method reponerStock() {
        
    }
}

object cajonDePollo {
    const property position = game.at(26,6)
    method image() = "cajonDePollo.png"
    method elemento() = "cajonDePollo"

    method reponerStock() {
        
    }
}





